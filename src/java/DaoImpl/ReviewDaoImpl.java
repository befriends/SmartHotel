/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DaoImpl;

import DBConnection.DBPool;
import Dao.ReviewDao;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author sai
 */
public class ReviewDaoImpl implements ReviewDao {

    Connection conn = null;
    private JSONObject returnJSONObject;

    @Override
    public String addReview(HashMap<String, String> params) throws SQLException {

        JSONObject jobj = null;

        String customerName = "", phoneNo = "", emailId = "", address = "", mobileNo = "", foodQuality = "", dob = "", comment = "", service = "", environment = "";
        try {
            customerName = StringUtils.isNotEmpty(params.get("customername")) ? params.get("customername") : "";
            address = StringUtils.isNotEmpty(params.get("address")) ? params.get("address") : "";
            mobileNo = StringUtils.isNotEmpty(params.get("mobile")) ? params.get("mobile") : "";
            phoneNo = StringUtils.isNotEmpty(params.get("phone")) ? params.get("phone") : "";
            emailId = StringUtils.isNotEmpty(params.get("emailid")) ? params.get("emailid") : "";
            dob = StringUtils.isNotEmpty(params.get("dob")) ? params.get("dob") : "";
            foodQuality = StringUtils.isNotEmpty(params.get("ratingenvironment")) ? params.get("ratingenvironment") : "";
            service = StringUtils.isNotEmpty(params.get("ratingfoodquality")) ? params.get("ratingfoodquality") : "";
            environment = StringUtils.isNotEmpty(params.get("ratingservice")) ? params.get("ratingservice") : "";
            comment = StringUtils.isNotEmpty(params.get("comment")) ? params.get("comment") : "";

            String fromyear = dob.substring(dob.lastIndexOf("/") + 1);
            String frommonth = dob.substring(dob.indexOf("/") + 1, dob.lastIndexOf("/"));
            String fromday = dob.substring(0, dob.indexOf("/"));

            long dobLong = new java.util.Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
//            long hiredateLong = new java.util.Date(toyear + "/" + tomonth + "/" + today).getTime();

            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement pst = null;
            pst = conn.prepareStatement("select count(*) from review where name = ?");
            pst.setString(1, customerName);
            ResultSet rs1 = pst.executeQuery();
            rs1.next();

            if (rs1.getInt(1) == 0) {
                pst = conn.prepareStatement("insert into review(reviewid,name,address,mobile,phone,email,dob,foodquality,service,environment,comment) values(?,?,?,?,?,?,?,?,?,?,?)");

                pst.setString(1, UUID.randomUUID().toString());
                pst.setString(2, customerName);
                pst.setString(3, address);
                pst.setLong(4, Long.parseLong(mobileNo));
                pst.setLong(5, 0); //Long.parseLong(phoneNo));
                pst.setString(6, emailId);
                pst.setLong(7, dobLong);
                pst.setString(8, foodQuality);
                pst.setString(9, environment);
                pst.setString(10, service);
                pst.setString(11, comment);
                int r = pst.executeUpdate();
                if (r > 0) {
                    jobj = new JSONObject();
                    jobj.put("message", "Customer Review Added Successfully.");
                    jobj.put("success", true);
                } else {
                    jobj = new JSONObject();
                    jobj.put("message", "Some error Occurred... Pease try again.");
                    jobj.put("success", false);
                    conn.rollback();

                }
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Customer Name is already used. Please try another.");
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

@Override
    public JSONObject getReviewList() throws JSONException, IOException, SQLException {

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();

        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            rs = st.executeQuery("select * from review");

            if (null != rs) {

                while (rs.next()) {

                    JSONObject jobj = new JSONObject();

                    jobj.put("reviewid", rs.getString(1));

                    jobj.put("name", null != rs.getString(2) ? rs.getString(2) : "");

                    jobj.put("address", null != rs.getString(3) ? rs.getString(3) : "");
                    jobj.put("mobile", rs.getLong(4));
                    jobj.put("phone", rs.getLong(5));
                    jobj.put("email", null != rs.getString(6) ? rs.getString(6) : "");
                    jobj.put("dob", rs.getLong(7));
                    jobj.put("foodquality", null != rs.getString(8) ? rs.getString(8) : "");
                    jobj.put("service", null != rs.getString(9) ? rs.getString(9) : "");
                    jobj.put("environment", null != rs.getString(10) ? rs.getString(10) : "");
                    jobj.put("comment", null != rs.getString(11) ? rs.getString(11) : "");

                    jarr.put(jobj);
                }
            }

            returnJSONObject.put("data", jarr);

            returnJSONObject.put("success", "true");

        } catch (JSONException e) {
            Logger.getLogger(MenuItemDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } catch (SQLException e) {
            Logger.getLogger(MenuItemDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } finally{
            conn.close();
        }

        return returnJSONObject;
    }

    @Override
    public JSONObject saveReview(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        boolean isBooked = false;
        String sqlquery = "";

        try {
            conn = DBConnection.DBPool.getConnection();
            conn.setAutoCommit(false);

            String reviewList = params.get("reviewList");
//            JSONArray orderJarr = new JSONObject(reviewList).getJSONArray("data");
            String customerName = new JSONObject(reviewList).getString("name");
            String dob = new JSONObject(reviewList).getString("dob");
            String emailId = new JSONObject(reviewList).getString("email");
            String mobileNo = new JSONObject(reviewList).getString("contact");
            String comment = new JSONObject(reviewList).getString("comment");
            String address = new JSONObject(reviewList).getString("address");
            String environment = new JSONObject(reviewList).getString("ratingenvironment");
            String foodQuality = new JSONObject(reviewList).getString("ratingfoodquality");
            String service = new JSONObject(reviewList).getString("ratingservice");
            
             String fromyear = dob.substring(dob.lastIndexOf("/")+1);
            String frommonth = dob.substring(dob.indexOf("/") + 1, dob.lastIndexOf("/"));
            String fromday = dob.substring(0, dob.indexOf("/"));

            long dobLong = new java.util.Date(fromyear + "/" + frommonth + "/" + fromday).getTime();           
            PreparedStatement pst = null;

            pst = conn.prepareStatement("insert into review(reviewid,name,address,mobile,email,dob,foodquality,service,environment,comment) values(?,?,?,?,?,?,?,?,?,?)");
            pst.setString(1, UUID.randomUUID().toString());
            pst.setString(2, customerName);
            pst.setString(3, address);
            pst.setLong(4, Long.parseLong(mobileNo));
//                    pst.setLong(5, Long.parseLong(phoneNo));
            pst.setString(5, emailId);
            pst.setLong(6, dobLong);
            pst.setString(7, foodQuality);
            pst.setString(8, environment);
            pst.setString(9, service);
            pst.setString(10, comment);
            int reviewDetailresult = pst.executeUpdate();
            if (reviewDetailresult > 0) {
                respoJSONObject = new JSONObject();
                respoJSONObject.put("message", "Customer Review Added Successfully.");
                respoJSONObject.put("success", true);
            } else {
                respoJSONObject = new JSONObject();
                respoJSONObject.put("message", "Some error Occurred... Pease try again.");
                respoJSONObject.put("success", false);
                conn.rollback();

            }

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
            conn.rollback();
            respoJSONObject.put("success", false);
            respoJSONObject.put("message", e.getMessage());
        } finally {
            conn.close();
        }

        return respoJSONObject;
    }

}
