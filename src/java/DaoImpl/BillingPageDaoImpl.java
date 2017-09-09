
package DaoImpl;

import DBConnection.DBPool;
import Dao.BillingPageDao;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class BillingPageDaoImpl implements BillingPageDao {

    Connection conn=null;
    
    @Override
   public String Discount(HashMap<String, String> params) throws SQLException{
        
        JSONObject jobj = null;
            String query = "";
            
        try {
            conn = DBPool.getConnection();
            conn.setAutoCommit(false);
            query = "UPDATE orderDetail SET discount=? ,discountreason=?,totalamount=? where orderid=?";
            PreparedStatement pst = conn.prepareStatement(query);
           
            pst.setString(1, params.get("discount"));
            pst.setString(2, params.get("discountreason"));
            pst.setString(3, params.get("total"));
            pst.setString(4, params.get("orderid"));
            int r = pst.executeUpdate();
            if (r > 0) {

                jobj = new JSONObject();
                jobj.put("message", "Discount Added Successfully.");
                jobj.put("success", true);
            } else {
                
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred...!!!! Pease try again.");
                jobj.put("success", false);   
            }
            conn.commit();
           
        } catch (Exception ex) {
            Logger.getLogger(OrderDetailDaoImpl.class.getName()).log(Level.SEVERE, null, ex);
            conn.rollback();
        }
        finally
        {
            conn.close();
        }
         return jobj.toString();
   
    }
   
   @Override
    public JSONObject getBill()throws JSONException, IOException, SQLException{
        
        JSONArray jsona = new JSONArray();
         JSONObject returnJSONObject = new JSONObject();
        ResultSet rs = null;

        try {
            conn = DBPool.getConnection();
            Statement ps = conn.createStatement();
            rs = ps.executeQuery("select m.menuitemname,d.quantity,m.rate from ordertable o join orderdetails d on d.orderid=o.orderid join menuitem m on m.menuitemid=d.menuitemid order by o.orderno;");
            while (rs.next()) {
                JSONObject json = new JSONObject();
                json.put("menuitemname", rs.getString(1));
                json.put("quantity", rs.getInt(2));
                json.put("rate", rs.getFloat(3));
               // json.put("subtotal", rs.getDouble(4));
//                json.put("orderid", rs.getInt(1));
//                json.put("menuitem", rs.getString(2));
//                json.put("amount", rs.getString(3));
//                json.put("paidamount", rs.getString(4));
//                json.put("reason", rs.getString(5));
//                json.put("date", rs.getDate(6));
//                json.put("tableno", rs.getString(7));

                jsona.put(json);
            }
              returnJSONObject.put("data", jsona);

            returnJSONObject.put("success", "true");


        } catch (Exception ex) {
            conn.rollback();
            Logger.getLogger(ProductReportDaoImpl.class.getName()).log(Level.SEVERE, null, ex);
        } finally{
            conn.close();
        }

        return returnJSONObject;
    }

    
}
