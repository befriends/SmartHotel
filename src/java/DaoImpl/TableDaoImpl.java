package DaoImpl;

import DBConnection.DBPool;
import Dao.TableDao;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFrame;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class TableDaoImpl implements TableDao {

    Connection conn = null;

    @Override
    public String addTable(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;
        String tableid = "", TableName = "", tablenumber = "";
        try {
            tableid = StringUtils.isNotEmpty(params.get("tableid")) ? params.get("tableid") : "";
            TableName = StringUtils.isNotEmpty(params.get("tablename")) ? params.get("tablename") : "";
            tablenumber = StringUtils.isNotEmpty(params.get("tableno")) ? params.get("tableno") : "";
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement pst = null;
            Statement st = conn.createStatement();
            pst = conn.prepareStatement("select count(*) from tabledetails where tablename = ?");
            pst.setString(1, " TableName");
            ResultSet rs;
            rs = pst.executeQuery();
            rs.next();

            if (rs.getInt(1) == 0) {
                pst = conn.prepareStatement("insert into tabledetails(tablename,tableid,tableno) values(?,?,?)");
                pst.setString(1, TableName);
                pst.setString(2, tableid);
                pst.setString(3, tablenumber);
                int r = pst.executeUpdate();
                if (r > 0) {
                    jobj = new JSONObject();
                    jobj.put("message", "Table Added Successfully.");
                    jobj.put("success", true);
                } else {
                    jobj = new JSONObject();
                    jobj.put("message", "Some error Occurred... Pease try again.");
                    jobj.put("success", false);
                    conn.rollback();
                }
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Table Name is already used. Please try another.");
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
    public String addTotalcountOfTable(int count) throws SQLException {
        JSONObject jobj = null;
        JFrame frame = new JFrame("JOptionPane showMessageDialog example");
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);
            Statement st = conn.createStatement();
            String query = "UPDATE totaltable SET totaltablecol =" + count + "where id=1";
            int r = st.executeUpdate(query);
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Table Count Successfully.");
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
    public JSONObject getTableList(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        JSONArray jarr = new JSONArray();
        int mode;
        mode = Integer.parseInt(params.get("mode"));
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);
            if (mode == 1) {
                Statement st = conn.createStatement();
                String query = "select tableid,tablename,tableno,isbooked,isreserved from tabledetails order by tableno";
                ResultSet rs = st.executeQuery(query);

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
                    jobj.put("tableid", rs.getString(1));
                    jobj.put("tablename", rs.getString(2));
                    jobj.put("tableno", rs.getString(3));
                    jobj.put("isbooked", rs.getInt(4));
                    jobj.put("isreserved", rs.getInt(5));
                    jarr.put(jobj);
                }
            }
//                else if (mode == 2) {
//                Statement st = conn.createStatement();
//                String query = "select tablename,tableno,isbooked,isreserved,isactive from tabledetails where isactive=0 and isbooked=1 and isreserved=0 order by tableno";
//                ResultSet rs = st.executeQuery(query);
//
//                while (rs.next()) {
//                    JSONObject jobj = new JSONObject();
//                    // jobj.put("tableid", rs.getString(1));
//                    jobj.put("tablename", rs.getString(1));
//                    jobj.put("tableno", rs.getString(2));
////                    jobj.put("isbooked", rs.getInt(3));
////                    jobj.put("isreserved", rs.getInt(4));
////                    jobj.put("isactive", rs.getInt(5));
//                    jarr.put(jobj);
//                }
//            } else {
//                Statement st = conn.createStatement();
//                String query = "select * from tabledetails where isactive=0 and isbooked=0  order by tableno";
//                ResultSet rs = st.executeQuery(query);
//
//                while (rs.next()) {
//                    JSONObject jobj = new JSONObject();
//                     jobj.put("tableid", rs.getString(1));
//                    jobj.put("tablename", rs.getString(2));
//                    jobj.put("tableno", rs.getString(3));
//                    jobj.put("isactive", rs.getInt(4));
//                    jobj.put("isbooked", rs.getInt(5));
////                    jobj.put("isreserved", rs.getInt(4));
//                    
//                    jarr.put(jobj);
//                }
//            }
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            respoJSONObject.put("success", false);
            respoJSONObject.put("message", "Some error occurred when saving order. Please try again.");
            conn.rollback();
        } finally {
            conn.close();
        }
        return respoJSONObject;

    }

    @Override
    public JSONObject getAllTableList() throws JSONException, IOException, SQLException {

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();
//         Connection conn =null;
        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            rs = st.executeQuery("select * from tabledetails order by tableno");

            if (null != rs) {

                while (rs.next()) {

                    JSONObject jobj = new JSONObject();

                    jobj.put("tableid", rs.getString(1));
                    jobj.put("tablename", null != rs.getString(2) ? rs.getString(2) : "");
                    jobj.put("tableno", null != rs.getString(3) ? rs.getString(3) : "");
                    jobj.put("isbooked", rs.getInt(4));
                    jobj.put("isreserved", rs.getInt(5));

                    jarr.put(jobj);
                }
            }

            returnJSONObject.put("data", jarr);
            returnJSONObject.put("totalCount", jarr.length());
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
        } finally {
            conn.close();
        }

        return returnJSONObject;
    }

    @Override
    public JSONObject getAllActiveTableList() throws JSONException, IOException, SQLException {

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();
        Connection conn = null;
        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            rs = st.executeQuery("select * from tabledetails where isbooked=1 order by tableno");

            if (null != rs) {

                while (rs.next()) {

                    JSONObject jobj = new JSONObject();

                    jobj.put("tableid", rs.getString(1));
                    jobj.put("tablename", null != rs.getString(2) ? rs.getString(2) : "");
                    jobj.put("tableno", null != rs.getString(3) ? rs.getString(3) : "");
                    jobj.put("isbooked", rs.getInt(4));
                    jobj.put("isreserved", rs.getInt(5));

                    jarr.put(jobj);
                }
            }

            returnJSONObject.put("data", jarr);
            returnJSONObject.put("totalCount", jarr.length());
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
        } finally {
            conn.close();
        }

        return returnJSONObject;
    }

    @Override
    public JSONObject getFreeTable() throws JSONException, IOException, SQLException {

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();

        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            String query = "select * from tabledetails where isbooked=0 order by tableno";

            rs = st.executeQuery(query);

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
                    jobj.put("tableid", rs.getString(1));
                    jobj.put("tablename", null != rs.getString(2) ? rs.getString(2) : "");
                    jobj.put("tableno", null != rs.getString(3) ? rs.getString(3) : "");
                    jarr.put(jobj);
                }
            }
            returnJSONObject.put("data", jarr);

            returnJSONObject.put("success", "true");

        } catch (SQLException e) {
            Logger.getLogger(OrderDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } catch (JSONException e) {
            Logger.getLogger(OrderDaoImpl.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            returnJSONObject.put("success", "false");
            returnJSONObject.put("message", e.getMessage());
        } finally {
            conn.close();
        }
        return returnJSONObject;
    }
    @Override
    public JSONObject getMasterSeting() throws JSONException, IOException, SQLException {

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();
        Connection conn = null;
        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            rs = st.executeQuery("select isborrow,ishide,isgst,isservice from mastersetting ");

            if (null != rs) {

                while (rs.next()) {

                    JSONObject jobj = new JSONObject();                    
                    jobj.put("isborrow", rs.getInt(1));
                    jobj.put("isprinthide", rs.getInt(2));
                    jobj.put("isGST", rs.getInt(3));
                    jobj.put("isService", rs.getInt(4));

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
        } finally {
            conn.close();
        }

        return returnJSONObject;
    }


}
