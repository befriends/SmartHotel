
package DaoImpl;

import DBConnection.DBPool;
import Dao.UserDao;
import com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.HashMap;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.print.DocFlavor;
import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.print.attribute.HashPrintRequestAttributeSet;
import javax.print.attribute.PrintRequestAttributeSet;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class UserDaoImpl implements UserDao {

    Connection conn = null;
    private JSONObject returnJSONObject;
    

    @Override
    public String addUser(HashMap<String, String> params) throws SQLException {
        
        JSONObject jobj = null;
        
        String userName = "", address = "", mobileNo = "", gender = "", fullName = "", password = "",datepicker="";
        try {
            fullName = StringUtils.isNotEmpty(params.get("fullname")) ? params.get("fullname") : "";
            password = StringUtils.isNotEmpty(params.get("password")) ? params.get("password") : "";
            userName = StringUtils.isNotEmpty(params.get("username")) ? params.get("username") : "";
            address = StringUtils.isNotEmpty(params.get("address")) ? params.get("address") : "";
            mobileNo = StringUtils.isNotEmpty(params.get("mobile")) ? params.get("mobile") : "";
            gender = StringUtils.isNotEmpty(params.get("gender")) ? params.get("gender") : "";
            datepicker = StringUtils.isNotEmpty(params.get("datepicker")) ? params.get("datepicker") : "";
            
            
            SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
	    String dateInString = datepicker;
            java.util.Date date = formatter.parse(dateInString);
            java.sql.Date sqlDate = new Date(date.getTime());
            
            String currentDate = new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date());
//                    String year = currentDate.substring(currentDate.lastIndexOf("/")+1);
//                    String month = currentDate.substring(currentDate.indexOf("/")+1,currentDate.lastIndexOf("/"));
//                    String day = currentDate.substring(0,currentDate.indexOf("/"));
            
             conn = DBPool.getConnection();
             conn.setAutoCommit(false);

            PreparedStatement pst = null;
//            pst = conn.prepareStatement("select count(*) from userlogin where username = ?");
//            pst.setString(1, userName);
//            ResultSet rs1 = pst.executeQuery();
//            rs1.next();
//
//            if (rs1.getInt(1) > 0) {
//                jobj = new JSONObject();
//                jobj.put("message", "User Name is already in use. Please try another Username.");
//                jobj.put("success", false);
//                return jobj.toString();
//            }

            pst = conn.prepareStatement("insert into userlogin(userid,username,password,summarymsgsentdate) values(?,?,?,?)");
            pst.setString(1, UUID.randomUUID().toString());
            pst.setString(2, userName);
            pst.setString(3, password);
            pst.setString(4, currentDate);
            int r = pst.executeUpdate();
            if (r > 0) {
                Statement st = conn.createStatement();
                ResultSet rs2 = st.executeQuery("select userid from userlogin where username='" + userName + "' and password='" + password + "'");
                rs2.next();
                String userid = rs2.getString(1);

                pst = conn.prepareStatement("insert into user(uid,fullname,address,mobile,gender,userid,dob) values(?,?,?,?,?,?,?)");
                pst.setString(1, UUID.randomUUID().toString());
                pst.setString(2, fullName);
                pst.setString(3, address);
                pst.setLong(4, Long.parseLong(mobileNo));
                pst.setString(5, gender);
                pst.setString(6, userid);
                pst.setDate(7,sqlDate);
                r = pst.executeUpdate();
                if (r > 0) {
                    jobj = new JSONObject();
                    jobj.put("message", "User Added Successfully.");
                    jobj.put("success", true);
                } else {
                    jobj = new JSONObject();
                    jobj.put("message", "Some error Occurred... Pease try again.");
                    jobj.put("success", false);
                    conn.rollback();
                }
            } else {
                jobj = new JSONObject();
                jobj.put("message", "User Name is already in use. Please try another Username.");
                jobj.put("success", false);
                conn.rollback();
            }
            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
            conn.rollback();
        } finally{
            conn.close();
        }
        return jobj.toString();
    }
    
    @Override
    public String addEmployee(HashMap<String, String> params) throws SQLException{
        
        JSONObject jobj = null;
        
        String customId = "", employeeName = "", designation="",address = "", mobileNo = "", gender = "",dob="",hiredate="";
        try {
            customId = StringUtils.isNotEmpty(params.get("customid")) ? params.get("customid") : "";
            employeeName = StringUtils.isNotEmpty(params.get("employeename")) ? params.get("employeename") : "";
            designation = StringUtils.isNotEmpty(params.get("designation")) ? params.get("designation") : "";
            address = StringUtils.isNotEmpty(params.get("address")) ? params.get("address") : "";
            mobileNo = StringUtils.isNotEmpty(params.get("mobile")) ? params.get("mobile") : "";
            gender = StringUtils.isNotEmpty(params.get("gender")) ? params.get("gender") : "";
            dob = StringUtils.isNotEmpty(params.get("dob")) ? params.get("dob") : "";
            hiredate = StringUtils.isNotEmpty(params.get("hiredate")) ? params.get("hiredate") : "";
            
             String fromyear = dob.substring(dob.lastIndexOf("/") + 1);
            String frommonth = dob.substring(dob.indexOf("/") + 1, dob.lastIndexOf("/"));
            String fromday = dob.substring(0, dob.indexOf("/"));
            String toyear = hiredate.substring(hiredate.lastIndexOf("/") + 1);
             String tomonth = hiredate.substring(hiredate.indexOf("/") + 1, hiredate.lastIndexOf("/"));
            String today = hiredate.substring(0, hiredate.indexOf("/"));

            long dobLong = new java.util.Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
            long hiredateLong = new java.util.Date(toyear + "/" + tomonth + "/" + today).getTime();

            
            
//            long dobLong = new java.util.Date(dob).getTime();
//            long hiredateLong = new java.util.Date(hiredate).getTime();
//   
//            SimpleDateFormat formatter = new SimpleDateFormat("DD/MM/YYYY"); // your template here
//            String dateInString = dob;
//            java.util.Date dateStr = formatter.parse(dateInString);
//            java.sql.Date dateDB = new java.sql.Date(dateStr.getTime());
//            
//            SimpleDateFormat formatter1 = new SimpleDateFormat("DD/MM/YYYY"); // your template here      
//            String dateInString1 = hiredate;
//            java.util.Date dateStr1 = formatter1.parse(dateInString1);
//            java.sql.Date dateDB1 = new java.sql.Date(dateStr.getTime());
//          
        
             conn = DBPool.getConnection();  
             conn.setAutoCommit(false);

            PreparedStatement pst = null;
            pst = conn.prepareStatement("select count(*) from employee where employeename = ?");
            pst.setString(1, employeeName);
            ResultSet rs1 = pst.executeQuery();
            rs1.next();

            if (rs1.getInt(1) > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Employee Name is already in use. Please try another Username.");
                jobj.put("success", false);
                return jobj.toString();
            }
            
                pst = conn.prepareStatement("select count(*) from employee where customid = ?");
                pst.setString(1, customId);
                rs1 = pst.executeQuery();
                rs1.next();
               
                if (rs1.getInt(1) == 0) {
                    pst = conn.prepareStatement("insert into employee(customid,employeename,designation,address,mobile,gender,dob,hiredate) values(?,?,?,?,?,?,?,?)");
                    pst.setString(1, customId);
                    pst.setString(2, employeeName);
                    pst.setString(3, designation);
                    pst.setString(4, address);
                    pst.setLong(5, Long.parseLong(mobileNo));
                    pst.setString(6, gender);
                    pst.setLong(7, dobLong);
                    pst.setLong(8, hiredateLong);
                    int r = pst.executeUpdate();
                    if (r > 0) {
                        jobj = new JSONObject();
                        jobj.put("message", "User Added Successfully.");
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
    
    
    @Override
    public String addCustomer(HashMap<String, String> params)throws SQLException {
        
        JSONObject jobj = null;
        
        String customId = "", customerName = "", address = "", mobileNo = "";
        try {
            customId = StringUtils.isNotEmpty(params.get("customid")) ? params.get("customid") : "";
            customerName = StringUtils.isNotEmpty(params.get("customername")) ? params.get("customername") : "";
            address = StringUtils.isNotEmpty(params.get("address")) ? params.get("address") : "";
            mobileNo = StringUtils.isNotEmpty(params.get("mobile")) ? params.get("mobile") : "";

            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement pst = null;
            pst = conn.prepareStatement("select count(*) from customer where customername = ?");
            pst.setString(1, customerName);
            ResultSet rs1 = pst.executeQuery();
            rs1.next();

            if (rs1.getInt(1) > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Customer Name is already in use. Please try another Username.");
                jobj.put("success", false);
                return jobj.toString();
            }

            pst = conn.prepareStatement("select count(*) from customer where customid = ?");
            pst.setString(1, customId);
            rs1 = pst.executeQuery();
            rs1.next();

            if (rs1.getInt(1) == 0) {
                pst = conn.prepareStatement("insert into customer(customid,customername,address,mobile) values(?,?,?,?)");
                pst.setString(1, customId);
                pst.setString(2, customerName);
                pst.setString(3, address);
                pst.setLong(4, Long.parseLong(mobileNo));
                int r = pst.executeUpdate();
                if (r > 0) {
                    jobj = new JSONObject();
                    jobj.put("message", "Customer Added Successfully.");
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
    
//
//    @Override
//    public String updateUser(HashMap<String, String> params) {
//        Connection conn = null;
//        boolean result = false;
//        String query = "";
//        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
//        try {
//            conn = DBPool.getConnection();
//            query = "UPDATE user ";
//            if (params.containsKey("name") && !params.get("name").isEmpty()) {
//                String name = params.get("name");
//                query += "SET name='" + name + '"';
//            }
//            if (params.containsKey("address") && !params.get("address").isEmpty()) {
//                String address = params.get("address");
//                query += "SET address='" + address + '"';
//            }
//            if (params.containsKey("mobile") && !params.get("mobile").isEmpty()) {
//                String mobile = params.get("mobile");
//                query += "SET category='" + mobile + '"';
//            }
//            if (params.containsKey("gender") && !params.get("gender").isEmpty()) {
//                String gender = params.get("gender");
//                query += "SET subcategory='" + gender + '"';
//            }
//            query += "where id='"+params.get("address")+'"';
//            PreparedStatement pst = conn.prepareStatement(query);
//            int r = pst.executeUpdate();
//            if (r > 0) {
//                result = true;
//            }
//
//        } catch (MySQLIntegrityConstraintViolationException e) {
//            return false;
//        } catch (Exception e) {
//            JOptionPane.showMessageDialog(frame, e.getMessage());
//            return false;
//        }
//        return result;
//    }

    @Override
    public String getUserList() throws SQLException{

        ResultSet rs = null;
        JSONArray jarr = new JSONArray();
        try {

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            rs = st.executeQuery("select u.userid,ul.username,u.address,u.fullname,u.mobile,u.gender from user u inner join userlogin ul on u.userid = ul.userid where u.isdeleted = '0' and ul.roleid = 2");

            while (rs.next()) {
                JSONObject jobj = new JSONObject();
                jobj.put("userid", rs.getString(1));
                jobj.put("username", rs.getString(2));
                jobj.put("address", rs.getString(3));
                jobj.put("fullname", rs.getString(4));
                jobj.put("mobile", rs.getString(5));
                jobj.put("gender", rs.getString(6));

                jarr.put(jobj);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }finally{
            conn.close();
        }

        return jarr.toString();
    }
    
    @Override
    public JSONObject getEmployeeList() throws JSONException, SQLException {

        ResultSet rs = null;
        JSONObject returnJSONObject = new JSONObject();
        JSONArray jarr = new JSONArray();
        try {
            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            rs = st.executeQuery("select employeeid,employeename,designation,address,mobile,gender,customid,dob,hiredate from employee where isdeleted = '0'");

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
                    jobj.put("employeeid", rs.getLong(1));
                    jobj.put("employeename", rs.getString(2));
                    jobj.put("designation", rs.getString(3));
                    jobj.put("address", rs.getString(4));
                    jobj.put("mobile", rs.getString(5));
                    jobj.put("gender", rs.getString(6));
                    jobj.put("customid", rs.getString(7));

                    Date date = new Date(rs.getLong(8));
                    SimpleDateFormat df2 = new SimpleDateFormat("dd/MM/yyyy");
                    String dateText = df2.format(date);
                    jobj.put("dob", dateText);

                    Date date1 = new Date(rs.getLong(9));
                    SimpleDateFormat df21 = new SimpleDateFormat("dd/MM/yyyy");
                    String dateText1 = df21.format(date1);
                    jobj.put("hiredate", dateText1);

                    jarr.put(jobj);
                }
            }
            returnJSONObject.put("data", jarr);

            returnJSONObject.put("success", "true");

        } catch (SQLException e) {
            Logger.getLogger(MenuItemDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } catch (JSONException e) {
            Logger.getLogger(MenuItemDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } finally {
            conn.close();
        }
        return returnJSONObject;
    }
    
     @Override
    public String getCustomerList() throws SQLException {

        ResultSet rs = null;
        JSONArray jarr = new JSONArray();
        try {

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            rs = st.executeQuery("select customerid,customername,address,mobile,customid from customer where isdeleted = '0'");

            while (rs.next()) {
                JSONObject jobj = new JSONObject();
                jobj.put("customerid", rs.getLong(1));
                jobj.put("customername", rs.getString(2));
                jobj.put("address", rs.getString(3));
                jobj.put("mobile", rs.getString(4));
                jobj.put("customid", rs.getString(5));
                jarr.put(jobj);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            conn.close();
        }

        return jarr.toString();
    }
    

    @Override
    public String deleteUser(String id) throws SQLException{
        Connection conn = null;
        JSONObject jobj = null;
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);
            Statement st = conn.createStatement();
            String query = "UPDATE user SET isdeleted = '1' WHERE userid = '" + id + "'";
            int r = st.executeUpdate(query);
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "User Deleted Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
                conn.rollback();
            }
            conn.commit();
        } catch (Exception e) {
            conn.rollback();
        } finally {
            conn.close();
        }
                
        return jobj.toString();
    }

    @Override
    public String updateUser(HashMap<String, String> params) throws SQLException{
        Connection conn = null;
        JSONObject jobj = null;
        String query = "";
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);
            query = "UPDATE user SET fullname=?,address=?,mobile=?,gender=? where userid=?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setString(1, params.get("fullname"));
            pst.setString(2, params.get("address"));
            pst.setLong(3, Long.parseLong(params.get("mobile")));
            pst.setString(4, params.get("gender"));
            pst.setLong(5, Long.parseLong(params.get("userid")));

            int r = pst.executeUpdate();
            if (r > 0) {
                query = "UPDATE userlogin SET username=?,password=? where userid=?";
                pst = conn.prepareStatement(query);
                pst.setString(1, params.get("username"));
                pst.setString(2, params.get("password"));
                pst.setLong(3, Long.parseLong(params.get("userid")));
                r = pst.executeUpdate();
                
                jobj = new JSONObject();
                jobj.put("message", "Record Update Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
                conn.rollback();
            }
            conn.commit();

        } catch (Exception e) {
            JOptionPane.showMessageDialog(frame, e.getMessage());
            conn.rollback();
        }
        finally 
        {
            conn.close();
        }
        return jobj.toString();
    }
    
     @Override
    public JSONObject getEmployeeJsonList() throws JSONException, IOException, SQLException {

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();

        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            rs = st.executeQuery("select * from employee");

            if (null != rs) {

                while (rs.next()) {

                    JSONObject jobj = new JSONObject();

                    jobj.put("employeeid", rs.getLong(1));

                    jobj.put("employeename", null != rs.getString(2) ? rs.getString(2) : "");

                    jobj.put("customid", null != rs.getString(3) ? rs.getString(3) : "");
                    
                    jobj.put("designation", null != rs.getString(10) ? rs.getString(10) : "");
                    
                    jarr.put(jobj);
                }
            }

            returnJSONObject.put("data", jarr);

            returnJSONObject.put("success", "true");

        } catch (JSONException e) {
            Logger.getLogger(UserDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } catch (SQLException e) {
            Logger.getLogger(UserDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } finally {
            conn.close();
        }

        return returnJSONObject;
    }
    
    @Override
    public JSONObject getEmployeeJsonList1(String designation) throws JSONException, IOException, SQLException {

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();

        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            
            String designation1 = designation;
            
            String query= "select employeeid,employeename,customid,designation from employee where designation ='"+designation1+"'";
            
            rs = st.executeQuery(query);

            if (null != rs) {

                while (rs.next()) {

                    JSONObject jobj = new JSONObject();

                    jobj.put("id", rs.getLong(1));

                    jobj.put("name", null != rs.getString(2) ? rs.getString(2) : "");

                    jobj.put("customid", null != rs.getString(3) ? rs.getString(3) : "");
                    
                    jobj.put("designation", null != rs.getString(4) ? rs.getString(4) : "");
                               
                    jarr.put(jobj);
                }
            }

            returnJSONObject.put("data", jarr);

            returnJSONObject.put("success", "true");

        } catch (JSONException e) {
            Logger.getLogger(UserDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } catch (SQLException e) {
            Logger.getLogger(UserDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } finally {
            conn.close();
        }

        return returnJSONObject;
    }
    
       @Override
    public String updateEmployee(HashMap<String, String> params)throws SQLException{
        Connection conn = null;
        JSONObject jobj = null;
        String query = "";
         String customId = "", employeeName = "", designation="",address = "", mobileNo = "", gender = "",dob="",hiredate="";
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
          try {
              customId = StringUtils.isNotEmpty(params.get("customid")) ? params.get("customid") : "";
            employeeName = StringUtils.isNotEmpty(params.get("employeename")) ? params.get("employeename") : "";
            designation = StringUtils.isNotEmpty(params.get("designation")) ? params.get("designation") : "";
            address = StringUtils.isNotEmpty(params.get("address")) ? params.get("address") : "";
            mobileNo = StringUtils.isNotEmpty(params.get("mobile")) ? params.get("mobile") : "";
            gender = StringUtils.isNotEmpty(params.get("gender")) ? params.get("gender") : "";
            dob = StringUtils.isNotEmpty(params.get("dob")) ? params.get("dob") : "";
            hiredate = StringUtils.isNotEmpty(params.get("hiredate")) ? params.get("hiredate") : "";
            
             String fromyear = dob.substring(dob.lastIndexOf("/") + 1);
            String frommonth = dob.substring(dob.indexOf("/") + 1, dob.lastIndexOf("/"));
            String fromday = dob.substring(0, dob.indexOf("/"));
            String toyear = hiredate.substring(hiredate.lastIndexOf("/") + 1);
             String tomonth = hiredate.substring(hiredate.indexOf("/") + 1, hiredate.lastIndexOf("/"));
            String today = hiredate.substring(0, hiredate.indexOf("/"));

            long dobLong = new java.util.Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
            long hiredateLong = new java.util.Date(toyear + "/" + tomonth + "/" + today).getTime();
              conn = DBPool.getConnection();
              conn.setAutoCommit(false);
              query = "UPDATE employee SET employeename=?,designation=?,address=?,mobile=?,gender=?,dob=?,hiredate=? where employeeid=?";
              PreparedStatement pst = conn.prepareStatement(query);
              pst.setString(1, params.get("employeename"));
              pst.setString(2, params.get("designation"));
              pst.setString(3, params.get("address"));
              pst.setLong(4, Long.parseLong(params.get("mobile")));
              pst.setString(5, params.get("gender"));
              pst.setLong(6,dobLong);
              pst.setLong(7, hiredateLong);
              pst.setLong(8, Long.parseLong(params.get("employeeid")));
              int r = pst.executeUpdate();
              if (r > 0) {
                  jobj = new JSONObject();
                  jobj.put("message", "Record Update Successfully.");
                  jobj.put("success", true);
              } else {
                  jobj = new JSONObject();
                  jobj.put("message", "Some error Occurred... Pease try again.");
                  jobj.put("success", false);
                  conn.rollback();
                  
              }
              conn.commit();

          } catch (Exception e) {
            JOptionPane.showMessageDialog(frame, e.getMessage());
            conn.rollback();
        }
          finally 
          {
              conn.close();
          }  
        return jobj.toString();
    }
    @Override
    public String deleteEmployee(String id)throws SQLException {
        Connection conn = null;
        JSONObject jobj = null;
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);
            
            Statement st = conn.createStatement();
            int r = st.executeUpdate("update employee set isdeleted=1 where employeeid=" + id);
                if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Employee Deleted Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
                conn.rollback();
            }
                conn.commit();
        } catch (Exception e) {
            conn.rollback();
        }
        finally{
            conn.close();
        }
        return jobj.toString();
    }

    @Override
    public JSONObject backupdb() throws SQLException, JSONException {
        Connection conn = null;
        JSONObject jobj = null;
        
        Process p = null;
        try {
            conn = DBPool.getConnection();
            String currentDate = new SimpleDateFormat("dd-MM-yyyy").format(new java.util.Date());
            
            String pathToMySql = "C:\\Program Files\\MySQL\\MySQL Server 5.7\\bin\\";
           
            if(System.getProperty("os.name").startsWith("Windows")){
                ResultSet rs = conn.createStatement().executeQuery("select @@basedir");
                if(rs.next()){
                    pathToMySql = rs.getString(1);
                    pathToMySql += "bin\\";
                    pathToMySql = pathToMySql.replaceAll("\\\\", "\\\\\\\\");
                }
            } else{
                pathToMySql = "";
            }
            
            File dir = new File("E:/backupdb");
            boolean isdirsuccess = true;
            if(!dir.exists()){
                isdirsuccess = dir.mkdirs();
            }
            if(isdirsuccess){
                Runtime runtime = Runtime.getRuntime();
                p = runtime.exec(pathToMySql+"mysqldump -uroot -ptoor --add-drop-database -B smarthotel -r E:/backupdb/dbbackup" + currentDate + ".sql");
//                p = runtime.exec("mysqldump -uroot -psairam test > D:/backupdb/dbbackup" + currentDate + ".sql");
                int processComplete = p.waitFor();

                if (processComplete == 0) {

                    jobj = new JSONObject();
                    jobj.put("successMessage", "Backup created successfully!");
                    jobj.put("success", true);

                } else {
                    jobj = new JSONObject();
                    jobj.put("failureMessage", "Backup creation failed... Pease try again.");
                    jobj.put("success", false);
                }
                
            } else{
                jobj = new JSONObject();
                jobj.put("failureMessage", "Directory not found... Pease try again.");
                jobj.put("success", false);
            }


        } catch (Exception e) {
            jobj = new JSONObject();
            jobj.put("failureMessage", "Some error occurred... Pease try again.");
            jobj.put("success", false);
            e.printStackTrace();
        }
        finally{
            conn.close();
        }
        return jobj;
    }

    @Override
    public JSONObject getAvailablePrinters() throws SQLException, JSONException {
        JSONObject respoJSONObject = new JSONObject();
        try{
            DocFlavor flavor = DocFlavor.SERVICE_FORMATTED.PAGEABLE;
            PrintRequestAttributeSet patts = new HashPrintRequestAttributeSet();
            PrintService[] ps = PrintServiceLookup.lookupPrintServices(flavor, patts);

            System.out.println("Available printers: " + Arrays.asList(ps));

            JSONArray jarr = new JSONArray();
            for (PrintService printService : ps) {
                JSONObject jobj = new JSONObject();
                jobj.put("printername", printService.getName());
                
                jarr.put(jobj);
            }
            respoJSONObject.put("success", true);
            respoJSONObject.put("data", jarr);
        } catch(Exception ex){
            respoJSONObject.put("success", false);
            ex.printStackTrace();
        } finally{
        }
        return respoJSONObject;
    }
    
    public JSONObject getMasterSettings()throws SQLException, JSONException {
        JSONObject respoJSONObject = new JSONObject();
        try{
            JSONArray jarr = new JSONArray();
            JSONObject jobj = new JSONObject();
            
            Connection conn = DBPool.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select * from mastersetting");
            while(rs.next()){
                jobj.put("duplicatePrint", rs.getInt("isduplicateprint"));
                jobj.put("duplicatePrinterName", rs.getString("duplicateprintername"));
            }
            jarr.put(jobj);
            
            respoJSONObject.put("success", true);
            respoJSONObject.put("data", jarr);
        } catch(Exception ex){
            respoJSONObject.put("success", false);
            ex.printStackTrace();
        } finally{
        }
        return respoJSONObject;
    }
 
}
