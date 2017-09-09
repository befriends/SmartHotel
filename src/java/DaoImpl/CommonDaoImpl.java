package DaoImpl;

import DBConnection.DBPool;
import Dao.CommonDao;
import java.sql.*;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CommonDaoImpl implements CommonDao {

    Connection conn = null;

    @Override
    public String generateNextID(HashMap<String, String> params) {

        String id = "";
        try {
            String subModule = params.get("submodule");
            String columnName = params.get("columnname");
            conn = DBPool.getConnection();
            Statement st = conn.createStatement();

            ResultSet rs = st.executeQuery("select MAX(" + columnName + ") from " + subModule + ";");

            int max = 0;

            if (rs.next()) {

                max = rs.getInt(1) + 1;
            }

            switch (subModule) {
                case "category":
                    id = "CAT" + max;
                    break;
                case "subcategory":
                    id = "SBT" + max;
                    break;
                case "menuitem":
                    id = "MNT" + max;
                    break;
                case "ProductReport":
                    id = "" + max; //id="PD"+max;
                    break;
                case "user":
                    id = "USE" + max;
                    break;
                case "orderdetail":
                    id = "ORD" + max;
                    break;
                case "employee":
                    id = "EMP" + max;
                    break;
                case "customer":
                    id = "CST" + max;
                    break;
                case "payment":
                    id = "PAY" + max;
                    break;
                case "materialstock":
                    id = "MAT" + max;
                    break;
                case "purchasematerial":
                    id = "PUR" + max;
                    break;
                case "expence":
                    id = "EXP" + max;
                    break;

            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(CommonDaoImpl.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return id;
    }

    @Override
    public JSONObject printHeder() throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        try {

            conn = DBConnection.DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select printheaderid,printheadername,printheaderaddress from printheader");

            JSONArray jarr = new JSONArray();
            while (rs.next()) {
                JSONObject jobj = new JSONObject();
                jobj.put("printheaderid", null != rs.getString(1) ? rs.getString(1) : "");
                jobj.put("printheadername", null != rs.getString(2) ? rs.getString(2) : "");
                jobj.put("printheaderaddress", null != rs.getString(3) ? rs.getString(3) : "");

                jarr.put(jobj);
            }
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            respoJSONObject.put("success", false);
            respoJSONObject.put("message", e.getMessage());
        } finally {
            conn.close();
        }

        return respoJSONObject;
    }

}
