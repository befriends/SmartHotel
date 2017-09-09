/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DaoImpl;

import DBConnection.DBPool;
import Dao.StockSystemPreferencesDao;
import com.mysql.jdbc.StringUtils;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author sai
 */
public class StockSystemPreferencesDaoImpl implements StockSystemPreferencesDao {

    @Override
    public JSONObject saveSystemPreferences(HashMap<String, String> params) throws JSONException, IOException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        Connection conn = null;
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);

            int messageNotificationFlag = 0;
            int isDuplicatePrint = 0;
            int isPrintHide = 0;
            int isBorrow = 0;
            int isGST = 0;
            int isService = 0;
            String duplicatePrinterName = "";

            if (Boolean.parseBoolean(params.get("messagenotificationflag"))) {
                messageNotificationFlag = 1;
            }
            if (Boolean.parseBoolean(params.get("isDuplicatePrint"))) {
                isDuplicatePrint = 1;
            }
            if (Boolean.parseBoolean(params.get("isprinthide"))) {
                isPrintHide = 1;
            }
            if (Boolean.parseBoolean(params.get("isborrow"))) {
                isBorrow = 1;
            }
            if (Boolean.parseBoolean(params.get("isGST"))) {
                isGST = 1;
            }
            if (Boolean.parseBoolean(params.get("isService"))) {
                isService = 1;
            }
            duplicatePrinterName = params.get("duplicatePrinterName");
           

            if (!StringUtils.isNullOrEmpty(params.get("userid"))) {
                String userId = (params.get("userid"));

                PreparedStatement pst = conn.prepareStatement("update userlogin set messagenotificationflag=? where userid=?");
                pst.setInt(1, messageNotificationFlag);
                pst.setString(2, userId);

                int res = pst.executeUpdate();

                pst = conn.prepareStatement("update mastersetting set isduplicateprint=?, duplicateprintername=?,isborrow=?,ishide=?,isgst=?,isservice=?");
                pst.setInt(1, isDuplicatePrint);
                pst.setString(2, duplicatePrinterName);
                pst.setInt(3, isBorrow);
                pst.setInt(4, isPrintHide);
                pst.setInt(5, isGST);
                pst.setInt(6, isService);

                res = pst.executeUpdate();

                conn.commit();
                respoJSONObject.put("success", true);
                respoJSONObject.put("message", "New settings applied successfully.");
            } else {
                respoJSONObject.put("success", false);
                respoJSONObject.put("message", "UserdID is empty.");
            }
        } catch (Exception e) {
            conn.rollback();
            respoJSONObject.put("success", false);
            respoJSONObject.put("success", "Some error occurred. Please try again.");
        } finally {
            conn.close();
        }
        return respoJSONObject;
    }

    @Override
    public JSONObject saveGSTChanges(HashMap<String, String> params) throws JSONException, IOException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        Connection conn = null;
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);
            PreparedStatement pst = null;
            String  CGST = "", SGST = "";

            CGST = !StringUtils.isNullOrEmpty(params.get("CGST")) ? params.get("CGST") : "0";
            SGST = !StringUtils.isNullOrEmpty(params.get("SGST")) ? params.get("SGST") : "0";

            pst = conn.prepareStatement("update mastersetting set CGST=?, SGST=?");
            pst.setDouble(1, Double.parseDouble(CGST));
            pst.setDouble(2, Double.parseDouble(SGST));

            int res = pst.executeUpdate();

            conn.commit();
            respoJSONObject.put("success", true);
            respoJSONObject.put("message", "GST applied successfully.");

        } catch (Exception e) {
            conn.rollback();
            respoJSONObject.put("success", false);
            respoJSONObject.put("success", "Some error occurred. Please try again.");
        } finally {
            conn.close();
        }
        return respoJSONObject;
    }
    @Override
    public JSONObject saveServiceTaxChanges(HashMap<String, String> params) throws JSONException, IOException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        Connection conn = null;
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);
            PreparedStatement pst = null;
            String  serviceTax = "";

            serviceTax = !StringUtils.isNullOrEmpty(params.get("servicetax")) ? params.get("servicetax") : "0";
            
            pst = conn.prepareStatement("update mastersetting set servicetax=?");
            pst.setDouble(1, Double.parseDouble(serviceTax));
            
            int res = pst.executeUpdate();

            conn.commit();
            respoJSONObject.put("success", true);
            respoJSONObject.put("message", "Service Tax applied successfully.");

        } catch (Exception e) {
            conn.rollback();
            respoJSONObject.put("success", false);
            respoJSONObject.put("success", "Some error occurred. Please try again.");
        } finally {
            conn.close();
        }
        return respoJSONObject;
    }

}
