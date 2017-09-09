package DaoImpl;

import DBConnection.DBPool;
import Dao.MenuItemDao;
import com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class MenuItemDaoImpl implements MenuItemDao {

    Connection conn = null;

    @Override
    public String addCategory(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;
        String customId = "", categoryName = "";
        try {
            customId = StringUtils.isNotEmpty(params.get("customid")) ? params.get("customid") : "";
            categoryName = StringUtils.isNotEmpty(params.get("categoryname")) ? params.get("categoryname") : "";

            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement pst = null;
            Statement st = conn.createStatement();
            pst = conn.prepareStatement("select count(*) from category where categoryname = ?");
            pst.setString(1, categoryName);
            ResultSet rs = pst.executeQuery();
            rs.next();

            if (rs.getInt(1) == 0) {
                pst = conn.prepareStatement("insert into category(categoryname, customid) values(?,?)");
                pst.setString(1, categoryName);
                pst.setString(2, customId);

                int r = pst.executeUpdate();
                if (r > 0) {
                    jobj = new JSONObject();
                    jobj.put("message", "Category Added Successfully.");
                    jobj.put("success", true);
                } else {
                    jobj = new JSONObject();
                    jobj.put("message", "Some error Occurred... Pease try again.");
                    jobj.put("success", false);
                    conn.rollback();
                }
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Category Name is already used. Please try another.");
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
    public String addSubCategory(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;
        String customId = "", categoryId = "", subcategoryName = "";

        try {
            customId = StringUtils.isNotEmpty(params.get("customid")) ? params.get("customid") : "";
            categoryId = StringUtils.isNotEmpty(params.get("categoryid")) ? params.get("categoryid") : "";
            subcategoryName = StringUtils.isNotEmpty(params.get("subcategoryname")) ? params.get("subcategoryname") : "";

            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement pst = null;
            Statement st = conn.createStatement();
            pst = conn.prepareStatement("select count(*) from subcategory where subcategoryname = ?");
            pst.setString(1, subcategoryName);
            ResultSet rs = pst.executeQuery();
            rs.next();

            if (rs.getInt(1) == 0) {
                pst = conn.prepareStatement("insert into subcategory(categoryid, subcategoryname, customid) values(?,?,?)");
                pst.setLong(1, Long.parseLong(categoryId));
                pst.setString(2, subcategoryName);
                pst.setString(3, customId);

                int r = pst.executeUpdate();
                if (r > 0) {
                    jobj = new JSONObject();
                    jobj.put("message", "Sub-Category Added Successfully.");
                    jobj.put("success", true);
                } else {
                    jobj = new JSONObject();
                    jobj.put("message", "Some error Occurred... Pease try again.");
                    jobj.put("success", false);
                    conn.rollback();
                }
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Sub-Category name is already exist. Please try another.");
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
    public String addMenuItem(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;
        String customId = "", categoryId = "", itemName = "", rate = "";
        long subcategoryId = 0;

        try {
            customId = StringUtils.isNotEmpty(params.get("customid")) ? params.get("customid") : "";
            categoryId = StringUtils.isNotEmpty(params.get("categoryid")) ? params.get("categoryid") : "";
//            subcategoryId = StringUtils.isNotEmpty(params.get("subcategoryid")) ? params.get("subcategoryid") : "";
            if (StringUtils.isNotEmpty(params.get("subcategoryid"))) {
                subcategoryId = Long.parseLong(params.get("subcategoryid"));
            }
            rate = StringUtils.isNotEmpty(params.get("rate")) ? params.get("rate") : "";
            itemName = StringUtils.isNotEmpty(params.get("itemName")) ? params.get("itemName") : "";

            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement pst = null;
            Statement st = conn.createStatement();
            pst = conn.prepareStatement("select count(*) from menuitem where menuitemname = ?");
            pst.setString(1, itemName);
            ResultSet rs = pst.executeQuery();
            rs.next();

            if (rs.getInt(1) == 0) {
                pst = conn.prepareStatement("insert into menuitem(categoryid,subcategoryid, menuitemname, customid,rate) values(?,?,?,?,?)");
                pst.setLong(1, Long.parseLong(categoryId));
                pst.setLong(2, subcategoryId);
//                pst.setLong(2, Long.parseLong(subcategoryId));
                pst.setString(3, itemName);
                pst.setString(4, customId);
                pst.setFloat(5, Float.parseFloat(rate));

                int r = pst.executeUpdate();
                if (r > 0) {
                    jobj = new JSONObject();
                    jobj.put("message", "MenuItem Added Successfully.");
                    jobj.put("success", true);
                } else {
                    jobj = new JSONObject();
                    jobj.put("message", "Some error Occurred... Pease try again.");
                    jobj.put("success", false);
//                    conn.rollback();
                }
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Menu Item Name is already used. Please try another.");
                jobj.put("success", false);
//                conn.rollback();
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
    public String addMessage(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;
        String categoryId = "", message = "";
        try {
            // customId = StringUtils.isNotEmpty(params.get("customid")) ? params.get("customid") : "";
            categoryId = StringUtils.isNotEmpty(params.get("categoryid")) ? params.get("categoryid") : "";
            message = StringUtils.isNotEmpty(params.get("message")) ? params.get("message") : "";

            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement pst = null;
            //Statement st = conn.createStatement();
            //pst = conn.prepareStatement("select count(*) from message where messagetype = ?");
            // pst.setString(1, message);
            // ResultSet rs = pst.executeQuery();
            //rs.next();

            //if (rs.getInt(1) == 0) {
            pst = conn.prepareStatement("insert into message(messageid,messagetype,categoryid) values(?,?,?)");
            pst.setString(1, UUID.randomUUID().toString());
            pst.setString(2, message);
            pst.setLong(3, Long.parseLong(categoryId));

            int r = pst.executeUpdate();
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Message Added Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
//                conn.rollback();
            }
            //} else {
            //   jobj = new JSONObject();
            //   jobj.put("message", "Message is already used. Please try another.");
            //   jobj.put("success", false);
            //   conn.rollback();
            //}
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
    public JSONObject getCategoryList() throws JSONException, IOException, SQLException{

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();

        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            rs = st.executeQuery("select categoryid, categoryname, customid, printername from category where isdeleted=0 order by categoryname");

            if (null != rs) {

                while (rs.next()) {

                    JSONObject jobj = new JSONObject();

                    jobj.put("categoryid", rs.getLong(1));

                    jobj.put("categoryname", null != rs.getString(2) ? rs.getString(2) : "");

                    jobj.put("customid", null != rs.getString(3) ? rs.getString(3) : "");
                    
                    jobj.put("printername", null != rs.getString(4) ? rs.getString(4) : "");

                    jarr.put(jobj);
                }
            }

            returnJSONObject.put("data", jarr);

            returnJSONObject.put("success", "true");

        } catch (JSONException e) {
            conn.rollback();
            Logger.getLogger(MenuItemDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } catch (SQLException e) {
            conn.rollback();
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
    public JSONObject getSubCategoryList() throws JSONException, IOException ,SQLException{

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();

        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            String query = "Select sc.subcategoryid,sc.categoryid,sc.subcategoryname,sc.customid,c.categoryname from subcategory sc,category c where sc.categoryid=c.categoryid and sc.isdeleted=0 order by c.categoryname";

            rs = st.executeQuery(query);

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
                    jobj.put("subcategoryid", rs.getLong(1));
                    jobj.put("categoryid", rs.getLong(2));
                    jobj.put("subcategoryname", null != rs.getString(3) ? rs.getString(3) : "");
                    jobj.put("customid", null != rs.getString(4) ? rs.getString(4) : "");
                    jobj.put("categoryname", null != rs.getString(5) ? rs.getString(5) : "");
                    jarr.put(jobj);
                }
            }
            returnJSONObject.put("data", jarr);

            returnJSONObject.put("success", "true");

        } catch (SQLException e) {
            conn.rollback();
            Logger.getLogger(MenuItemDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } catch (JSONException e) {
            conn.rollback();
            Logger.getLogger(MenuItemDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } finally{
            conn.close();
            return returnJSONObject;
        }
    }

    @Override
    public JSONObject getSubCategoryListJson(String categoryid) throws Exception {

        JSONObject returnJSONObject = new JSONObject();
        JSONArray jarr = new JSONArray();
        ResultSet rs = null;
        try {

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            long categoryId = Long.parseLong(categoryid);

            String query = "Select subcategoryid,subcategoryname,customid from subcategory where categoryid=" + categoryId;

            rs = st.executeQuery(query);

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
                    jobj.put("id", rs.getLong(1));
//                    jobj.put("categoryid", rs.getLong(2));
                    jobj.put("name", null != rs.getString(2) ? rs.getString(2) : "");
                    jobj.put("customid", null != rs.getString(3) ? rs.getString(3) : "");
//                    jobj.put("categoryname", null != rs.getString(5) ? rs.getString(5) : "");
                    jarr.put(jobj);
                }
            }
            returnJSONObject.put("data", jarr);
            returnJSONObject.put("isSuccess", true);

        } catch (Exception ex) {
            conn.rollback();
            ex.printStackTrace();
            returnJSONObject.put("data", "");
            returnJSONObject.put("isSuccess", false);
        } finally {
            conn.close();
        }

        return returnJSONObject;
    }

    @Override
    public JSONObject getMenuItemList() throws JSONException, IOException, SQLException {

        ResultSet rs = null;
        JSONObject returnJSONObject = new JSONObject();
        JSONArray jarr = new JSONArray();
        JSONArray jarr1 = new JSONArray();
        try {
            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            String query = "Select m.menuitemid,m.categoryid,m.subcategoryid,m.menuitemname,m.customid,m.rate,c.categoryname,sc.subcategoryname,m.isspecial from menuitem m,category c,subcategory sc where m.categoryid=c.categoryid and m.subcategoryid=sc.subcategoryid and m.isdeleted=0";
            rs = st.executeQuery(query);
//            rs.next();

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
                    jobj.put("menuitemid", rs.getLong(1));
                    jobj.put("categoryid", rs.getLong(2));
                    jobj.put("subcategoryid", rs.getLong(3));
                    jobj.put("menuitemname", null != rs.getString(4) ? rs.getString(4) : "");
                    jobj.put("customid", null != rs.getString(5) ? rs.getString(5) : "");
                    jobj.put("rate", null != rs.getString(6) ? rs.getString(6) : "");
                    jobj.put("categoryname", null != rs.getString(7) ? rs.getString(7) : "");
                    jobj.put("subcategoryname", null != rs.getString(8) ? rs.getString(8) : "");
                    jobj.put("isspecial", rs.getInt(9));
                    jarr.put(jobj);
                }

            }
            st = conn.createStatement();
            String query1 = "Select messageid,messagetype,categoryid from message where isactive=1";
            rs = st.executeQuery(query1);
//            rs.next();

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj1 = new JSONObject();
                    jobj1.put("messageid", rs.getString(1));
                    jobj1.put("messagetype", null != rs.getString(2) ? rs.getString(2) : "");
                    jobj1.put("categoryid", rs.getLong(3));
                    jarr1.put(jobj1);
                }

            }
            returnJSONObject.put("data", jarr);
            returnJSONObject.put("data1", jarr1);
            returnJSONObject.put("success", "true");

        } catch (SQLException e) {
            conn.rollback();
            Logger.getLogger(MenuItemDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } catch (JSONException e) {
            conn.rollback();
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
    public JSONObject getMessageListJson() throws JSONException, IOException, SQLException{

        ResultSet rs = null;
        JSONObject returnJSONObject = new JSONObject();
        JSONArray jarr = new JSONArray();
        try {
            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            String query = "Select messageid,messagetype from message where isactive=1";
            rs = st.executeQuery(query);
//            rs.next();

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
                    jobj.put("messageid", rs.getString(1));
                    jobj.put("messagetype", null != rs.getString(2) ? rs.getString(2) : "");
                    jarr.put(jobj);
                }

            }
            returnJSONObject.put("data", jarr);

            returnJSONObject.put("success", "true");

        } catch (SQLException e) {
            conn.rollback();
            Logger.getLogger(MenuItemDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } catch (JSONException e) {
            conn.rollback();
            Logger.getLogger(MenuItemDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        }finally{
            conn.close();
            return returnJSONObject;
        }
    }

    @Override
    public JSONArray getMenuItemDetailsList() throws SQLException{

        ResultSet rs = null;
        JSONArray jarr = new JSONArray();
        try {

            conn = DBPool.getConnection();

            Statement st1 = conn.createStatement();
            String query = "Select categoryid,categoryname,customid from category";
            rs = st1.executeQuery(query);
            while (rs.next()) {
                JSONArray jarrSubCategory = new JSONArray();
                JSONObject jobjcategory = new JSONObject();
                jobjcategory.put("categoryid", rs.getLong(1));
                jobjcategory.put("categoryname", rs.getString(2));
                jobjcategory.put("customid", rs.getString(3));

                long categoryid = rs.getLong(1);
                query = "Select subcategoryid,subcategoryname,customid from subcategory where categoryid=" + categoryid;
                Statement st2 = conn.createStatement();
                ResultSet rs1 = st2.executeQuery(query);
                while (rs1.next()) {
                    JSONArray jarrItem = new JSONArray();
                    JSONObject jobjSubCategory = new JSONObject();
                    jobjSubCategory.put("subcategoryid", rs1.getLong(1));
                    jobjSubCategory.put("subcategoryname", rs1.getString(2));
                    jobjSubCategory.put("customid", rs1.getString(3));

                    long subcategoryid = rs1.getLong(1);
                    query = "Select menuitemid,menuitemname,customid,rate from menuitem where subcategoryid=" + subcategoryid;
                    Statement st3 = conn.createStatement();
                    ResultSet rs2 = st3.executeQuery(query);
                    while (rs2.next()) {
                        JSONObject jobjItem = new JSONObject();
                        jobjItem.put("menuitemid", rs2.getLong(1));
                        jobjItem.put("menuitemname", rs2.getString(2));
                        jobjItem.put("customid", rs2.getString(3));
                        jobjItem.put("rate", rs2.getString(4));
                        jarrItem.put(jobjItem);
                    }
                    jobjSubCategory.put("menuitem", jarrItem);
                    jarrSubCategory.put(jobjSubCategory);
                }

                jobjcategory.put("subcategory", jarrSubCategory);
                jarr.put(jobjcategory);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally{
            conn.close();
        }

        return jarr;
    }
//    
//    @Override
//    public boolean addMenuItem(HashMap<String, String> params) {    
//        boolean result = false;
//        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
//        try {
//
//            conn = DBPool.getConnection();
//            String category = params.get("category");
//            String subCategory = params.get("subCategory");
//            String itemName = params.get("itemName");
//            String rate = params.get("rate");
//            PreparedStatement pst = conn.prepareStatement("insert into menuitem(category,subCategory,itemName,rate) values(?,?,?,?)");
//            pst.setString(1, category);
//            pst.setString(2, subCategory);
//            pst.setString(3, itemName);
//            pst.setString(4, rate);
//            int r = pst.executeUpdate();
//            if (r > 0) {
//                result = true;
//            }
//        } catch (MySQLIntegrityConstraintViolationException e) {
//            result = false;
//        } catch (Exception e) {
//            JOptionPane.showMessageDialog(frame, e.getMessage());
//            result = false;
//        }
//        return result;
//    }

    @Override
    public JSONObject getMessageList() throws JSONException, IOException, SQLException{

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();

        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            String query = "select m.messageid,m.messagetype,m.isactive,m.categoryid,c.categoryname from message m,category c where m.categoryid=c.categoryid and m.isdeleted=0 order by m.categoryid";

            rs = st.executeQuery(query);

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
                    jobj.put("messageid", rs.getString(1));
                    jobj.put("messagetype", null != rs.getString(2) ? rs.getString(2) : "");
                    jobj.put("isactive", rs.getDouble(3));
                    jobj.put("categoryid", rs.getLong(4));
                    jobj.put("categoryname", null != rs.getString(5) ? rs.getString(5) : "");
                    //jobj.put("customid", null != rs.getString(4) ? rs.getString(4) : "");
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
        } finally{
            conn.close();
        }
        return returnJSONObject;
    }

    @Override
    public String updateCategory(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;
        String query = "";
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            query = "UPDATE category SET categoryname=? where categoryid=?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setString(1, params.get("categoryname"));
            pst.setLong(2, Long.parseLong(params.get("categoryid")));
            int r = pst.executeUpdate();
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Record Update Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
//                conn.rollback();
            }
            conn.commit();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(frame, e.getMessage());
            conn.rollback();
        } finally {
            conn.close();
        }
        return jobj.toString();
    }

    @Override
    public String updateSubCategory(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;
        String query = "";
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            query = "UPDATE subcategory SET subcategoryname=? WHERE subcategoryid=?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setString(1, params.get("subcategoryname"));
            pst.setLong(2, Long.parseLong(params.get("subcategoryid")));
            int r = pst.executeUpdate();
            if (r > 0) {

                jobj = new JSONObject();
                jobj.put("message", "Record Update Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
//                conn.rollback();
            }
            conn.commit();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(frame, e.getMessage());
            conn.rollback();
        } finally {
            conn.close();
        }
        return jobj.toString();
    }

    @Override
    public String updateMenuItem(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;
        String query = "";
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            query = "UPDATE menuitem SET menuitemname=?,rate=? where menuitemid=?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setString(1, params.get("menuitemname"));
            pst.setFloat(2, Float.parseFloat(params.get("rate")));
            pst.setLong(3, Long.parseLong(params.get("menuitemid")));
            int r = pst.executeUpdate();
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Record Update Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
//                conn.rollback();
            }
            conn.commit();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(frame, e.getMessage());
            conn.rollback();
        } finally {
            conn.close();
        }
        return jobj.toString();
    }

    @Override
    public String updateMessage(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;
        String query = "", isactive = "", messageid = "";
        int isactive1 = 0;
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
        try {
            isactive = StringUtils.isNotEmpty(params.get("isactive")) ? params.get("isactive") : "";
            messageid = StringUtils.isNotEmpty(params.get("messageid")) ? params.get("messageid") : "";

            if (isactive.equalsIgnoreCase("N")) {
                isactive1 = 0;
            } else {
                isactive1 = 1;
            }

            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            query = "UPDATE message SET isactive=" + isactive1 + " where messageid='" + messageid + "'";
            PreparedStatement pst = conn.prepareStatement(query);

            int r = pst.executeUpdate();
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Record Update Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
//                conn.rollback();
            }
            conn.commit();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(frame, e.getMessage());
            conn.rollback();
        } finally {
            conn.close();
        }
        return jobj.toString();
    }

    @Override
    public String outOfStoke(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            String id = params.get("id");
            String hidden = params.get("hidden");
            PreparedStatement pst = conn.prepareStatement("UPDATE menuitem SET hiddetemp='" + hidden + "' WHERE id='" + id + '"');
            int r = pst.executeUpdate();
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Record Update Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
//                conn.rollback();
            }
            conn.commit();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(frame, e.getMessage());
            conn.rollback();
        } finally {
            conn.close();
            return jobj.toString();
        }
    }

    @Override
    public String deleteMenuItem(String id) throws SQLException {
        JSONObject jobj = null;
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            Statement st = conn.createStatement();
            int r = st.executeUpdate("update menuitem set isdeleted=1 where menuitemid=" + id);
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Menu Item Deleted Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
//                conn.rollback();
            }
            conn.commit();
        } catch (Exception e) {
            conn.rollback();
        } finally {
            conn.close();
            return jobj.toString();
        }
    }

    @Override
    public String deleteCategory(String id) throws SQLException {
        JSONObject jobj = null;
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            Statement st = conn.createStatement();
            int r = st.executeUpdate("update category set isdeleted=1 where categoryid=" + id);
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Category Deleted Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
//                conn.rollback();
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
    public String deleteSubCategory(String id) throws SQLException {
        JSONObject jobj = null;
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            Statement st = conn.createStatement();
            int r = st.executeUpdate("update subcategory set isdeleted=1 where subcategoryid=" + id);
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Sub-Category Deleted Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
//                conn.rollback();
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
    public String deleteMessage(String id) throws SQLException {
        JSONObject jobj = null;
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            Statement st = conn.createStatement();
            int r = st.executeUpdate("update message set isdeleted=1 where messageid= '" + id + "'");
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Message Deleted Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
//                conn.rollback();
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
    public String listOfMenuItemList() throws SQLException{
        String result = "";
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");

        try {
            conn = DBPool.getConnection();
            Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery("select * from menuitem where hiddentemp=0");
            JSONArray jarr = new JSONArray();
            while (rs.next()) {
                JSONObject json = new JSONObject();
                json.put("id", rs.getInt(1));
                json.put("category", rs.getString(2));
                json.put("subcategory", rs.getString(3));
                json.put("itemname", rs.getString(4));
                json.put("rate", rs.getInt(5));
                jarr.put(json);
            }
            result = jarr.toString();
        } catch (Exception e) {
            conn.rollback();
        } finally{
            conn.close();
        }
        return result;

    }


    @Override
    public JSONObject getMessageTypeByCategory(String menuitemid) throws Exception {
        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();

        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            String query = "select messageid,messagetype from message where categoryid=(select categoryid from menuitem where menuitemid=" + menuitemid + ") and isactive=1 and isdeleted=0";

            rs = st.executeQuery(query);

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
                    jobj.put("id", rs.getString(1));
                    jobj.put("name", null != rs.getString(2) ? rs.getString(2) : "");
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
        } finally{
            conn.close();
        }
        return returnJSONObject;
    }

    @Override
    public String setSpecialMenuItem(HashMap<String, String> params) throws SQLException, JSONException {
        JSONObject respoJSONObject = new JSONObject();
        try{
            long menuitemid = Long.parseLong(params.get("menuitemid"));
            int isspecial = Integer.parseInt(params.get("isspecial"));
            conn = DBPool.getConnection();
            
            Statement st = conn.createStatement();
            int row = st.executeUpdate("update menuitem set isspecial="+isspecial+" where menuitemid="+menuitemid);
            
            if(row > 0){
                conn.commit();
                respoJSONObject.put("success", true);
                respoJSONObject.put("message", "Menu Item updated successfully.");
            } else{
                respoJSONObject.put("success", false);
                respoJSONObject.put("message", "Menu Item not updated.");
            }
        } catch(Exception e){
            respoJSONObject.put("success", false);
            respoJSONObject.put("message", "Some error occurred. Please try again.");
            conn.rollback();
            System.out.println(e);
        } finally{
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String getSpecialMenuItemList() throws SQLException, JSONException{
        JSONObject respoJSONObject = new JSONObject();
        String result = "";

        try {
            conn = DBPool.getConnection();
            Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery("select menuitemid,menuitemname,isspecial from menuitem where isspecial=1 and isdeleted=0");
            JSONArray jarr = new JSONArray();
            while (rs.next()) {
                JSONObject json = new JSONObject();
                json.put("menuitemid", rs.getLong(1));
                json.put("menuitemname", rs.getString(2));
                json.put("isspecial", rs.getInt(3));
                jarr.put(json);
            }
            respoJSONObject.put("success", true);
            respoJSONObject.put("data", jarr);
            result = jarr.toString();
        } catch (Exception e) {
            respoJSONObject.put("success", false);
            conn.rollback();
            return result;
        } finally{
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String setCategoryPrinter(HashMap<String, String> params) throws SQLException, JSONException {
        JSONObject respoJSONObject = new JSONObject();
        
        try{
            String printerName = params.get("printername");
            String categoryIdList = params.get("categoryid");
            conn = DBPool.getConnection();
            
            Statement st = conn.createStatement();
            st.executeUpdate("update category set printername = '"+printerName+"' where categoryid in ("+categoryIdList+")");
            
            conn.commit();
            respoJSONObject.put("success", true);
            respoJSONObject.put("message", "Printer for Category is updated successfully.");
        } catch(Exception e){
            conn.rollback();
            respoJSONObject.put("success", false);
            respoJSONObject.put("message", "Some error occurred. Please try again.");
            e.printStackTrace();
        } finally{
            conn.close();
        }
        return respoJSONObject.toString();
    }
}
