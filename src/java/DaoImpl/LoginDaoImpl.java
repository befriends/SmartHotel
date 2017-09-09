package DaoImpl;

import Controller.LoginController;
import DBConnection.DBPool;
import Dao.LoginDao;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class LoginDaoImpl implements LoginDao {

    Connection conn = null;

    @Override
    public JSONObject validLogin(String username, String password) throws JSONException, IOException, SQLException {
        boolean result = false;
        JSONObject resultJSONObject = new JSONObject();
        try {
            conn = DBPool.getConnection();
            PreparedStatement pst = conn.prepareStatement("Select * from userlogin ul inner join user u on ul.userid=u.userid where ul.username=? and ul.password=? and u.isdeleted='0'");
            pst.setString(1, username);
            pst.setString(2, password);
            ResultSet rs = pst.executeQuery();
            if (rs != null && rs.next()) {
                resultJSONObject.put("userid", rs.getString("userid"));
                resultJSONObject.put("username", rs.getString("username"));
                resultJSONObject.put("password", rs.getString("password"));
                resultJSONObject.put("roleid", rs.getString("roleid"));
                resultJSONObject.put("summarymsgsentdate", rs.getString("summarymsgsentdate"));
                resultJSONObject.put("success", "true");
                resultJSONObject.put("conn", "true");
                result = true;
            } else {
                resultJSONObject.put("success", "false");
                resultJSONObject.put("conn", "true");
            }
        } catch (Exception e) {
//            resultJSONObject.put("success", "false");
            resultJSONObject.put("conn", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return resultJSONObject;
    }

    public JSONObject initialStock() throws JSONException, SQLException {
        JSONObject resultJSONObject = new JSONObject();
        JSONArray jarr = new JSONArray();
        ResultSet rs = null;
        String materialId = "", materialName = "", customId = "";
        double quantity = 0;
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);
            resultJSONObject.put("success", "false");
            PreparedStatement pst = null;

            Statement st = conn.createStatement();

            String query = "select * from materialstock order by materialname";

            rs = st.executeQuery(query);

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
                    jobj.put("materialid", rs.getLong(1));
                    jobj.put("materialname", null != rs.getString(2) ? rs.getString(2) : "");
                    jobj.put("quantity", rs.getDouble(3));
                    jobj.put("customid", null != rs.getString(4) ? rs.getString(4) : "");
                    jarr.put(jobj);
                }
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.DATE, 0);
                SimpleDateFormat format1 = new SimpleDateFormat("dd/MM/yyyy");
                String adDate = format1.format(cal.getTime());

                String year = adDate.substring(adDate.lastIndexOf("/") + 1);
                String month = adDate.substring(adDate.indexOf("/") + 1, adDate.lastIndexOf("/"));
                String day = adDate.substring(0, adDate.indexOf("/"));

                long DateInLong = new Date(year + "/" + month + "/" + day).getTime();
                long previesstockdate = 0;
                query = "select initialstockdate from initialstock where initialstockdate =" + DateInLong + "";

                rs = st.executeQuery(query);
                while (rs.next()) {
                    previesstockdate = rs.getLong(1);
                }
                if ((DateInLong != previesstockdate) || (previesstockdate == 0)) {

                    for (int cnt = 0; cnt < jarr.length(); cnt++) {
                        String initialstockId = UUID.randomUUID().toString();
                        JSONObject stockJobj = jarr.getJSONObject(cnt);
                        materialId = stockJobj.getString("materialid");
                        materialName = stockJobj.getString("materialname");
                        quantity = stockJobj.getDouble("quantity");
                        customId = stockJobj.getString("customid");

                        pst = conn.prepareStatement("insert into initialstock(initialstockid,materialid,materialname,quantity,initialstockdate) values(?,?,?,?,?)");
                        pst.setString(1, initialstockId);
                        pst.setString(2, materialId);
                        pst.setString(3, materialName);
                        pst.setDouble(4, quantity);
                        pst.setLong(5, DateInLong);
                        pst.executeUpdate();
                    }
                }
            }
            conn.commit();

        } catch (Exception e) {
            conn.rollback();
        } finally {
            conn.close();
        }
        return resultJSONObject;
    }

    @Override
    public boolean sendSummaryMessage(String userID, String summarymsgsentdate) throws JSONException, SQLException {
        boolean isMessageSent = false;

        try {
            conn = DBPool.getConnection();

            DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            long dt = new Date().getDate();
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            cal.add(Calendar.DATE, -1);
            String yesterdaysDate = dateFormat.format(cal.getTime());
            long yesterdaysDateInLong = new Date(yesterdaysDate).getTime();

            if (summarymsgsentdate.equals(yesterdaysDate)) {
                return false;
            } else {
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("select fullname, mobile from user where userid='" + userID + "'");

                if (rs.next()) {
                    double orderTotal = 0, purchaseTotal = 0, paymentTotal = 0;
                    String userFullName = rs.getString("fullname");
                    long mobileNo = rs.getLong("mobile");

                    // Order Total Amount of Yesterday
                    rs = st.executeQuery("select orderdate, sum(totalamount) as ordertotal from ordertable where orderdate=" + yesterdaysDateInLong + " group by orderdate");

                    if (rs.next()) {
                        orderTotal = rs.getDouble("ordertotal");
                    }
                    // Purchase Total Amount of Yesterday
                    rs = st.executeQuery("select purchasematerialdate, sum(totalamount) as purchasetotal from purchasematerial where purchasematerialdate=" + yesterdaysDateInLong + " group by purchasematerialdate");

                    if (rs.next()) {
                        purchaseTotal = rs.getDouble("purchasetotal");
                    }
                    // Sale Total Amount of Yesterday
                    rs = st.executeQuery("select paymentdate, sum(paymentamount) as paymenttotal from payment where paymentdate=" + yesterdaysDateInLong + " group by paymentdate");

                    if (rs.next()) {
                        paymentTotal = rs.getDouble("paymenttotal");
                    }

                    SmsDAOImpl smsDAOImpl = new SmsDAOImpl();
                    String messageTxt = "Hi " + userFullName + ", Summary of " + yesterdaysDate + " is :";
                    messageTxt += " Sale Amount : " + orderTotal + " Rs.";
                    messageTxt += " Purchase Amount : " + purchaseTotal + " Rs.";
                    messageTxt += " Salary Amount : " + paymentTotal + " Rs.  Thanks";
                    isMessageSent = smsDAOImpl.sendSMS(mobileNo + "", messageTxt);
                }

                if (isMessageSent) {
                    int res = st.executeUpdate("update userlogin set summarymsgsentdate = '" + yesterdaysDate + "' where userid = '" + userID + "'");
                    conn.commit();
                }
            }
        } catch (Exception e) {
            conn.rollback();
            e.printStackTrace();
        } finally {
            conn.close();
        }

        return isMessageSent;
    }
}
