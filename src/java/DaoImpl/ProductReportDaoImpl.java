
package DaoImpl;

import DBConnection.DBPool;
import Dao.ProductReportDao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONObject;

public class ProductReportDaoImpl implements ProductReportDao {
    
    Connection conn=null;
    @Override
    public String addProductReport(HashMap<String, String> params) throws SQLException{

        JSONObject jsonobj = null;

        String itemId = "", itemName = "", itemPrice = "";

        itemId = StringUtils.isNotEmpty(params.get("itemid")) ? params.get("itemid") : "";
        itemName = StringUtils.isNotEmpty(params.get("itemname")) ? params.get("itemname") : "";
        itemPrice = StringUtils.isNotEmpty(params.get("itemprice")) ? params.get("itemprice") : "";

        conn = DBPool.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement("insert into productreport (itemid,itemname,itemprice) values(?,?,?)");
            ps.setString(1, itemId);
            ps.setString(2, itemName);
            ps.setString(3, itemPrice);
            int r = ps.executeUpdate();

            if (r > 0) {
                jsonobj = new JSONObject();
                jsonobj.put("message", "ProductReport Added Successfully....");
                jsonobj.put("success", true);

            } else {
                jsonobj = new JSONObject();
                jsonobj.put("message", "Some error Occurred...!!!! Pease try again...");
                jsonobj.put("success", false);
            }
        } catch (Exception ex) {
            Logger.getLogger(ProductReportDaoImpl.class.getName()).log(Level.SEVERE, null, ex);
        } finally{
            conn.close();
        }
        return jsonobj.toString();
    }

    @Override
    public String getProductReportList() throws SQLException{
        
        JSONArray jsona=new JSONArray();
        ResultSet rs=null;
        
        try {
            conn=DBPool.getConnection();
            Statement ps = conn.createStatement();
            rs=ps.executeQuery("SELECT itemid,itemname,itemprice FROM productreport");
            while(rs.next())
            {
                JSONObject json=new JSONObject();
                json.put("itemid", rs.getString(1));
                json.put("itemname",rs.getString(2));
                json.put("itemprice",rs.getString(3));
                
                jsona.put(json);
            }
            
        } catch (Exception ex) {
            Logger.getLogger(ProductReportDaoImpl.class.getName()).log(Level.SEVERE, null, ex);
        } finally{
            conn.close();
        }
        
        return jsona.toString();
        
    }

    @Override
    public String DeleteProductReport(String id) throws SQLException{
          JSONObject jobj=null;
        try {
            conn=DBPool.getConnection();
            PreparedStatement ps=conn.prepareStatement("delete from productreport where itemid='"+id+"'");
            int r = ps.executeUpdate();
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Product Deleted Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
            }
            
        } catch (Exception ex) {
            Logger.getLogger(ProductReportDaoImpl.class.getName()).log(Level.SEVERE, null, ex);
        }finally{
            conn.close();
        }
      return jobj.toString();
    }

 
    
}
