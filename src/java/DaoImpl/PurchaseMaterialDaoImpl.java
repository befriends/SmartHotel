package DaoImpl;

import DBConnection.DBPool;
import Dao.PurchaseMaterialDao;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PurchaseMaterialDaoImpl implements PurchaseMaterialDao {

    Connection conn = null;

    @Override
    public String addPurchaseMaterial(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;

        String customId = "", materialid = "", unitprice = "", desription = "", quantity = "", totalamount = "", isinstock = "", datepicker1 = "", query = "";
        try {
            customId = StringUtils.isNotEmpty(params.get("customid")) ? params.get("customid") : "";
            materialid = StringUtils.isNotEmpty(params.get("materialid")) ? params.get("materialid") : "";
            unitprice = StringUtils.isNotEmpty(params.get("price")) ? params.get("price") : "";
            quantity = StringUtils.isNotEmpty(params.get("quantity")) ? params.get("quantity") : "";
            totalamount = StringUtils.isNotEmpty(params.get("totalamount")) ? params.get("totalamount") : "";
             boolean messageNotificationFlag = false;
            if( Boolean.parseBoolean(params.get("messageflag")) ){
                messageNotificationFlag = true;
            }

            datepicker1 = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
            String fromyear = datepicker1.substring(datepicker1.lastIndexOf("/") + 1);
            String frommonth = datepicker1.substring(datepicker1.indexOf("/") + 1, datepicker1.lastIndexOf("/"));
            String fromday = datepicker1.substring(0, datepicker1.indexOf("/"));

            long purchasematerialdate = new java.util.Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement pst = null;
             PreparedStatement pst1 = null;
            ResultSet rs1;
             ResultSet rs2;
             int q1;

            pst = conn.prepareStatement("select count(*) from purchasematerial where customid = ?");
            pst.setString(1, customId);
            rs1 = pst.executeQuery();
            rs1.next();

            if (rs1.getInt(1) == 0) {
                pst = conn.prepareStatement("insert into purchasematerial(customid,materialid,unitprice,quantity,totalamount,purchasematerialdate) values(?,?,?,?,?,?)");
                pst.setString(1, customId);
                pst.setString(2, materialid);
                pst.setFloat(3, Float.parseFloat(unitprice));
                pst.setDouble(4, Double.parseDouble(quantity));
                pst.setFloat(5, Float.parseFloat(totalamount));

                pst.setLong(6, purchasematerialdate);
                int r = pst.executeUpdate();
              

                    Statement st = conn.createStatement();
                    if(messageNotificationFlag){
                    rs2 = st.executeQuery("select quantity from materialstock where materialid = " + materialid + "");
                    rs2.next();
                    int quantity1 = rs2.getInt(1);
                     q1 = Integer.parseInt(quantity);
                    quantity1 = quantity1 + q1;
                   
                    query = "UPDATE materialstock SET quantity= " + quantity1 + " where materialid=" + materialid + "";
                    pst1 = conn.prepareStatement(query);
                    r = pst1.executeUpdate();
                    }

//                    jobj = new JSONObject();
//                    jobj.put("message", "Purchase Material Added And Update Successfully.");
//                    jobj.put("success", true);
//                } else {
//                    jobj = new JSONObject();
//                    jobj.put("message", "Some error Occurred... Pease try again.");
//                    jobj.put("success", false);
//                    conn.rollback();
//                }
                rs2 = st.executeQuery("select quantity from stockmaterialdetails where materialid = " + materialid + "");
            if(rs2.next()){
            int stockquantity1 = rs2.getInt(1);
             q1 = Integer.parseInt(quantity);
            stockquantity1 = stockquantity1 + q1;
//            PreparedStatement pst1 = null;
            query = "UPDATE stockmaterialdetails SET quantity= " + stockquantity1 + " where materialid=" + materialid + "";
            pst1 = conn.prepareStatement(query);
            r = pst1.executeUpdate();
            }else{
                                
                pst = conn.prepareStatement("insert into stockmaterialdetails(materialid,quantity,stockmaterialdetailsdate) values(?,?,?)");
               
                pst.setString(1, materialid);
                pst.setDouble(2, Double.parseDouble(quantity));                
                pst.setLong(3, purchasematerialdate);
                 r = pst.executeUpdate();
            }
                if (r > 0) {
                    jobj = new JSONObject();
                    jobj.put("message", "Material Added And Update Successfully.");
                    jobj.put("success", true);

                } else {
                    jobj = new JSONObject();
                    jobj.put("message", "Some error Occurred... Pease try again.");
                    jobj.put("success", false);
//                    conn.rollback();

                }

            } else {
                jobj = new JSONObject();
                jobj.put("message", "Custom ID is already used. Please try another.");
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
    public String getPurchaseMaterialList() throws SQLException {

        ResultSet rs = null;
        JSONArray jarr = new JSONArray();
        try {

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            rs = st.executeQuery("select purchasematerialid,purchasematerialname,price,desription,isinstock,customid,quantity,totalamount,purchasematerialdate from purchasematerial;");

            while (rs.next()) {
                JSONObject jobj = new JSONObject();
                jobj.put("purchasematerialid", rs.getLong(1));
                jobj.put("purchasematerialname", rs.getString(2));
                jobj.put("price", rs.getFloat(3));
                jobj.put("desription", rs.getString(4));
                jobj.put("isinstock", rs.getString(5));
                jobj.put("customid", rs.getString(6));
                jobj.put("quantity", rs.getLong(7));
                jobj.put("totalamount", rs.getFloat(8));
                jobj.put("purchasematerialdate", rs.getDate(9));
//                  Date date1 = new Date(rs.getLong(9));
//                SimpleDateFormat df21 = new SimpleDateFormat("dd/MM/yyyy");
//                String dateText1 = df21.format(date1);

                jarr.put(jobj);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally{
            conn.close();
        }

        return jarr.toString();
    }

    @Override
    public JSONObject getPurchaseList() throws JSONException, IOException, SQLException {

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();

        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            String query = "select materialid from materialstock";

            rs = st.executeQuery(query);

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
//                    jobj.put("subcategoryid", rs.getLong(1));
//                    jobj.put("categoryid", rs.getLong(2));
                    jobj.put("materialid", null != rs.getString(1) ? rs.getString(1) : "");
                    jobj.put("materialname", null != rs.getString(2) ? rs.getString(2) : "");
//                    jobj.put("customid", null != rs.getString(4) ? rs.getString(4) : "");
//                    jobj.put("categoryname", null != rs.getString(5) ? rs.getString(5) : "");
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
    public String addMaterialStock(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;

        String customId = "", materialName = "", quantity = "";
        try {
            customId = StringUtils.isNotEmpty(params.get("customid")) ? params.get("customid") : "";
            materialName = StringUtils.isNotEmpty(params.get("purchasematerialname")) ? params.get("purchasematerialname") : "";

            quantity = StringUtils.isNotEmpty(params.get("quantity")) ? params.get("quantity") : "";

            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement pst = null;
            Statement st = conn.createStatement();
            pst = conn.prepareStatement("select count(*) from materialstock where materialname = ?");
            pst.setString(1, materialName);
            ResultSet rs = pst.executeQuery();
            rs.next();

            if (rs.getInt(1) == 0) {
                pst = conn.prepareStatement("insert into materialstock(customid, materialname, quantity) values(?,?,?)");
                pst.setString(1, customId);
                pst.setString(2, materialName);
                pst.setDouble(3, Double.parseDouble(quantity));

                int r = pst.executeUpdate();
                if (r > 0) {
                    jobj = new JSONObject();
                    jobj.put("message", "Material Added Successfully.");
                    jobj.put("success", true);
                } else {
                    jobj = new JSONObject();
                    jobj.put("message", "Some error Occurred... Pease try again.");
                    jobj.put("success", false);
//                    conn.rollback();
                }
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Material is already exist. Please try another.");
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
    public JSONObject getMaterialList() throws JSONException, IOException, SQLException {

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();

        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

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
    public JSONObject getQuantityListJson(String materialid) throws Exception {

        JSONObject returnJSONObject = new JSONObject();
        JSONArray jarr = new JSONArray();
        ResultSet rs = null;
        try {

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            long categoryId = Long.parseLong(materialid);

            String query = "Select select * from materialstock where materialid=" + categoryId;

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
            }
            returnJSONObject.put("data", jarr);
            returnJSONObject.put("isSuccess", true);

        } catch (Exception ex) {
            ex.printStackTrace();
            returnJSONObject.put("data", "");
            returnJSONObject.put("isSuccess", false);
        } finally {
            conn.close();
        }

        return returnJSONObject;
    }

    @Override
    public JSONObject getStockList() throws JSONException, IOException, SQLException {

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();

        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            String query = "select materialname from materialstock";

            rs = st.executeQuery(query);

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
//                    jobj.put("subcategoryid", rs.getLong(1));
//                    jobj.put("categoryid", rs.getLong(2));
                    jobj.put("materialname", null != rs.getString(1) ? rs.getString(1) : "");
//                    jobj.put("customid", null != rs.getString(4) ? rs.getString(4) : "");
//                    jobj.put("categoryname", null != rs.getString(5) ? rs.getString(5) : "");
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
    public String addExpenceMaterial(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;

        String customId = "", materialid = "", quantity = "", datepicker1 = "", query = "";
        try {
            customId = StringUtils.isNotEmpty(params.get("customid")) ? params.get("customid") : "";
            materialid = StringUtils.isNotEmpty(params.get("materialid")) ? params.get("materialid") : "";
            quantity = StringUtils.isNotEmpty(params.get("quantity")) ? params.get("quantity") : "";
            datepicker1 = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
            String fromyear = datepicker1.substring(datepicker1.lastIndexOf("/") + 1);
            String frommonth = datepicker1.substring(datepicker1.indexOf("/") + 1, datepicker1.lastIndexOf("/"));
            String fromday = datepicker1.substring(0, datepicker1.indexOf("/"));

            long expencedate = new java.util.Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement pst = null;
            ResultSet rs1;

            pst = conn.prepareStatement("select count(*) from expence where customid = ?");
            pst.setString(1, customId);
            rs1 = pst.executeQuery();
            rs1.next();

            if (rs1.getInt(1) == 0) {
                pst = conn.prepareStatement("insert into expence(customid,materialid,quantity,expencedate) values(?,?,?,?)");
                pst.setString(1, customId);
                pst.setString(2, materialid);
                pst.setDouble(3, Double.parseDouble(quantity));
                pst.setLong(4, expencedate);
                int r = pst.executeUpdate();
                if (r > 0) {

                    Statement st = conn.createStatement();
                    ResultSet rs2 = st.executeQuery("select quantity from materialstock where materialid = " + materialid + "");
                    rs2.next();
                    int quantity1 = rs2.getInt(1);
                    int q1 = Integer.parseInt(quantity);
                    quantity1 = quantity1 - q1;
                    PreparedStatement pst1 = null;
                    query = "UPDATE materialstock SET quantity= " + quantity1 + " where materialid=" + materialid + "";
                    pst1 = conn.prepareStatement(query);
                    r = pst1.executeUpdate();

                    jobj = new JSONObject();
                    jobj.put("message", "Expence Material Added And Update Successfully.");
                    jobj.put("success", true);
                } else {
                    jobj = new JSONObject();
                    jobj.put("message", "Some error Occurred... Pease try again.");
                    jobj.put("success", false);
//                    conn.rollback();
                }
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Custom ID is already used. Please try another.");
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
    public String addComposition(HashMap<String, String> params) throws JSONException, IOException, SQLException {
        JSONObject responseJobj = new JSONObject();;
        try {
            conn = DBConnection.DBPool.getConnection();
            conn.setAutoCommit(false);

            String compositionList = params.get("compositionlistjson");
            JSONArray compositionJarr = new JSONObject(compositionList).getJSONArray("data");
            String menuitemid = new JSONObject(compositionList).getString("menuitemid");
            String menuitem = new JSONObject(compositionList).getString("menuitem");
            String userid = new JSONObject(compositionList).getString("userid");

            String sqlQuery = "select count(*) from menuitemcomposition where menuitemid=" + menuitemid;
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);
            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }

            if (count > 0) {
                String delQuery = "delete from menuitemcomposition where menuitemid=" + menuitemid;
                st = conn.createStatement();
                st.executeUpdate(delQuery);
            }

            sqlQuery = "insert into menuitemcomposition(idmenuitemcomposition, menuitemid, materialid, quantity) values(?,?,?,?)";
            for (int cnt = 0; cnt < compositionJarr.length(); cnt++) {
                long materialid = compositionJarr.getJSONObject(cnt).getLong("materialid");
                double quantity = compositionJarr.getJSONObject(cnt).getDouble("quantity");
                PreparedStatement pst = conn.prepareStatement(sqlQuery);
                pst.setString(1, UUID.randomUUID().toString());
                pst.setLong(2, Long.parseLong(menuitemid));
                pst.setLong(3, materialid);
                pst.setDouble(4, quantity);

                int ind = pst.executeUpdate();
            }
            responseJobj.put("message", "Composition created successfully.");
            responseJobj.put("success", true);
            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
            conn.rollback();
            responseJobj.put("message", "Some error occurred during Composition creation.");
            responseJobj.put("success", false);
        } finally {
            conn.close();
        }

        return responseJobj.toString();
    }

    @Override
    public String getCompositionDetails(HashMap<String, String> params) throws JSONException, IOException, SQLException {
        JSONObject responseJSONObj = new JSONObject();;
        try {
            conn = DBConnection.DBPool.getConnection();
            conn.setAutoCommit(false);

            String menuitemid = params.get("menuitemid");
            String menuitemname = params.get("menuitemname");

            String sqlQuery = "select ms.materialid, ms.materialname, mic.quantity from menuitemcomposition mic left join materialstock ms on mic.materialid = ms.materialid where mic.menuitemid=" + menuitemid;
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);

            JSONArray jarr = new JSONArray();
            while (rs.next()) {
                JSONObject jobj = new JSONObject();
                jobj.put("materialid", rs.getLong(1));
                jobj.put("materialname", rs.getString(2));
                jobj.put("quantity", rs.getDouble(3));

                jarr.put(jobj);
            }

            responseJSONObj.put("menuitemid", menuitemid);
            responseJSONObj.put("menuitemname", menuitemname);
            responseJSONObj.put("data", jarr);
            responseJSONObj.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            responseJSONObj.put("success", false);
            responseJSONObj.put("message", "Some error occurred. Please try again.");
        } finally {
            conn.close();
        }

        return responseJSONObj.toString();
    }

    @Override
    public JSONObject stockMaterialDetailsList() throws JSONException, IOException, SQLException{

        ResultSet rs = null;

        JSONObject returnJSONObject = new JSONObject();

        JSONArray jarr = new JSONArray();

        try {

            returnJSONObject.put("success", "false");

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();

            String query = "Select sm.materialid ,sm.quantity ,ms.materialname from stockmaterialdetails sm,materialstock ms where sm.materialid=ms.materialid order by ms.materialname";

            rs = st.executeQuery(query);

            if (null != rs) {

                while (rs.next()) {
                    JSONObject jobj = new JSONObject();
//                    jobj.put("stockmaterialdetailsid", rs.getLong(1));
                    jobj.put("materialid", rs.getLong(1));
                    jobj.put("quantity", rs.getDouble(2));
                    jobj.put("materialname", null != rs.getString(3) ? rs.getString(3) : "");
//                    jobj.put("customid", null != rs.getString(4) ? rs.getString(4) : "");
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
    public String addCounterMaterialStock(HashMap<String, String> params) throws SQLException {
        JSONObject jobj = null;

        String  materialid = "", quantity = "", query = "";
        try {

            materialid = StringUtils.isNotEmpty(params.get("materialname")) ? params.get("materialname") : "";
            quantity = StringUtils.isNotEmpty(params.get("quantity")) ? params.get("quantity") : "";

//            datepicker1 = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
//            String fromyear = datepicker1.substring(datepicker1.lastIndexOf("/") + 1);
//            String frommonth = datepicker1.substring(datepicker1.indexOf("/") + 1, datepicker1.lastIndexOf("/"));
//            String fromday = datepicker1.substring(0, datepicker1.indexOf("/"));
//
//            long purchasematerialdate = new java.util.Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement pst = null;
            ResultSet rs2;
            int r;

            Statement st = conn.createStatement();
             rs2 = st.executeQuery("select quantity from stockmaterialdetails where materialid = " + materialid + "");
           if(rs2.next()){
            int quantity1 = rs2.getInt(1);
          
            int q1 = Integer.parseInt(quantity);
            quantity1 = quantity1 - q1;
            PreparedStatement pst1 = null;
            query = "UPDATE stockmaterialdetails SET quantity= " + quantity1 + " where materialid=" + materialid + "";
            pst1 = conn.prepareStatement(query);
            r = pst1.executeUpdate();

            rs2 = st.executeQuery("select quantity from materialstock where materialid = " + materialid + "");
            rs2.next();
           int stockquantity1 = rs2.getInt(1);
            q1 = Integer.parseInt(quantity);
            stockquantity1 = stockquantity1 + q1;
            query = "UPDATE materialstock SET quantity= " + stockquantity1 + " where materialid=" + materialid + "";
            pst1 = conn.prepareStatement(query);
            r = pst1.executeUpdate();
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Material Update Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
                conn.rollback();
            }

            conn.commit();
            }else {
                jobj = new JSONObject();
                jobj.put("message", "Please Add This Material.");
                jobj.put("success", false);
                conn.rollback();
            }
        } catch (Exception e) {
            e.printStackTrace();
            conn.rollback();
        } finally {
            conn.close();
        }

        return jobj.toString();
    }

}
