
package DaoImpl;

import DBConnection.DBPool;
import Dao.PaymentDao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONObject;

public class PaymentDaoImpl implements PaymentDao{

    Connection conn = null;

    @Override
    public String savePayment(HashMap<String, String> params)throws SQLException {
        JSONObject jobj = null;
        String customId = "", employeeId = "",modeOfPayment="",paymentAmount="",designation="",dateofpayment="";
        try {
            customId = StringUtils.isNotEmpty(params.get("customid")) ? params.get("customid") : "";
            employeeId = StringUtils.isNotEmpty(params.get("employeeid")) ? params.get("employeeid") : "";
            modeOfPayment = StringUtils.isNotEmpty(params.get("modeofpayment")) ? params.get("modeofpayment") : "";
            paymentAmount = StringUtils.isNotEmpty(params.get("paymentamount")) ? params.get("paymentamount") : "";
            designation = StringUtils.isNotEmpty(params.get("designation")) ? params.get("designation") : "";
            dateofpayment = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
//            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
//	    String dateInString = dateofpayment;
//            java.util.Date date = formatter.parse(dateInString);
//            java.sql.Date sqlDate = new java.sql.Date(date.getTime());
             String fromyear = dateofpayment.substring(dateofpayment.lastIndexOf("/") + 1);
            String frommonth = dateofpayment.substring(dateofpayment.indexOf("/") + 1, dateofpayment.lastIndexOf("/"));
            String fromday = dateofpayment.substring(0, dateofpayment.indexOf("/"));
            

            long fromDateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();

            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement pst = null;
            Statement st = conn.createStatement();
            pst = conn.prepareStatement("select count(*) from payment where customid = ?");
            pst.setString(1, customId);
            ResultSet rs = pst.executeQuery();
            rs.next();

            if (rs.getInt(1) == 0) {
                pst = conn.prepareStatement("insert into payment(employeeid,modeofpayment,paymentamount,paymentdate,designation,customid) values(?,?,?,?,?,?)");
                pst.setLong(1, Long.parseLong(employeeId));
                pst.setString(2, modeOfPayment);
                pst.setFloat(3, Float.parseFloat(paymentAmount));
                pst.setLong(4, fromDateInLong);
                pst.setString(5, designation);
                pst.setString(6, customId);

                int r = pst.executeUpdate();
                if (r > 0) {
                    jobj = new JSONObject();
                    jobj.put("message", "Payment Save Successfully.");
                    jobj.put("success", true);
                } else {
                    jobj = new JSONObject();
                    jobj.put("message", "Some error Occurred... Pease try again.");
                    jobj.put("success", false);
                    conn.rollback();
                }
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Custom ID is already used. Please try another.");
                jobj.put("success", false);
                conn.rollback();
            }
            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
            conn.rollback();
        } finally {
            conn.close();
        }
        return jobj.toString();
    }

}
