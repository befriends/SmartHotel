
package DaoImpl;

import DBConnection.DBPool;
import Dao.OrderDetailDao;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


public class OrderDetailDaoImpl implements OrderDetailDao {
    
    Connection con=null;

    @Override
    public String addOrderDetail(HashMap<String ,String> params) throws SQLException
    {
        JSONObject jsonobj=null;
        String orderid="",menuitemid="",quantity="",comment="", tableno="" ;
       
       
        orderid = StringUtils.isNotEmpty(params.get("orderid")) ? params.get("orderid") : "";
        quantity = StringUtils.isNotEmpty(params.get("quantity")) ? params.get("quantity") : "";
        menuitemid=StringUtils.isNotEmpty(params.get("menuitemid")) ? params.get("menuitemid") : "";
        //amount=StringUtils.isNotEmpty(params.get("amount")) ? params.get("amount") :"";
        comment = StringUtils.isNotEmpty(params.get("comment")) ? params.get("comment") : "";
        tableno=StringUtils.isNotEmpty(params.get("tableno")) ? params.get("tableno") : "";
        
        Calendar calendar = Calendar.getInstance();
        java.sql.Date date = new java.sql.Date(calendar.getTime().getTime());
       
        con=DBPool.getConnection();
        con.setAutoCommit(false);
        
        try {
            PreparedStatement ps=con.prepareStatement("insert into orderdetails (orderid,menuitemid,quantity,comment,tableno) values(?,?,?,?,?)");
            ps.setString(1,orderid);
            ps.setString(2,menuitemid);
            ps.setString(3,quantity);
            ps.setString(4,comment);
            ps.setString(5,tableno);
            
            int r=ps.executeUpdate();
            if(r>0)
           {
               jsonobj=new JSONObject();
               jsonobj.put("message","Order Added Successfully....");
               jsonobj.put("success", true);
           }
           else
           {
               jsonobj=new JSONObject();
               jsonobj.put("message","Some error Occurred...!!!! Pease try again...");
               jsonobj.put("success", false);
//               con.rollback();
           }
            con.commit();
        } catch (Exception ex) {
            Logger.getLogger(OrderDetailDaoImpl.class.getName()).log(Level.SEVERE, null, ex);
            con.rollback();
        }
        finally
        {
            con.close();
        }
        
       return jsonobj.toString(); 
    }

    @Override
    public String DeleteOrderDetail(String id) throws SQLException{
        
        JSONObject jobj=null;
        try {
            con=DBPool.getConnection();
            con.setAutoCommit(false);
            PreparedStatement ps=con.prepareStatement("UPDATE orderdetails SET doneflag = '1' WHERE orderid ='"+id+"' ");
            int r = ps.executeUpdate();
            if (r > 0) {
                jobj = new JSONObject();
                jobj.put("message", "Order Deleted Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred... Pease try again.");
                jobj.put("success", false);
//                con.rollback();
            }
            con.commit();
            
        } catch (Exception ex) {
            Logger.getLogger(ProductReportDaoImpl.class.getName()).log(Level.SEVERE, null, ex);
            con.rollback();
        }
        finally
        {
            con.close();
        }
      return jobj.toString();
        
         }

    @Override
    public String getOrderList() throws SQLException{
        JSONArray jsona = new JSONArray();
        ResultSet rs = null;

        try {
            con = DBPool.getConnection();
            Statement ps = con.createStatement();
            rs = ps.executeQuery("SELECT orderid,listofmenuitem,amount,paidamount,reason,date,tableno FROM orderdetails where doneflag=0;");
            while (rs.next()) {
                JSONObject json = new JSONObject();
                json.put("orderid", rs.getInt(1));
                json.put("menuitem", rs.getString(2));
                json.put("amount", rs.getString(3));
                json.put("paidamount", rs.getString(4));
                json.put("reason", rs.getString(5));
                json.put("date", rs.getDate(6));
                json.put("tableno", rs.getString(7));

                jsona.put(json);
            }

        } catch (Exception ex) {
            Logger.getLogger(ProductReportDaoImpl.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            con.close();
        }
        return jsona.toString();
    }

    
    @Override
    public JSONObject getOrderList11()throws JSONException, IOException, SQLException {
        
        JSONArray jsona = new JSONArray();
         JSONObject returnJSONObject = new JSONObject();
        ResultSet rs = null;

        try {
            con = DBPool.getConnection();
            Statement ps = con.createStatement();
            rs = ps.executeQuery("select t.tableno,o.orderdate,o.orderno,o.totalamount from tabledetails t join tableordermapping m on m.tableid=t.tableid join ordertable o on o.orderid=m.orderid order by t.tableno;");
            while (rs.next()) {
                JSONObject json = new JSONObject();
                json.put("tableno", rs.getString(1));
//                long val = 1346524199000l;
                Date date = new Date(rs.getLong(2));
                SimpleDateFormat df2 = new SimpleDateFormat("dd/MM/yyyy");
                String dateText = df2.format(date);
                json.put("orderdate", dateText);
                json.put("orderno", rs.getString(3));
                json.put("totalamount", rs.getInt(4));
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
            Logger.getLogger(ProductReportDaoImpl.class.getName()).log(Level.SEVERE, null, ex);
        } finally{
            con.close();
        }

        return returnJSONObject;
    }

    @Override
    public String UpdateOrderDetail(HashMap<String, String> params)throws SQLException {
        
           JSONObject jobj = null;
            String query = "";
            
        try {
            
            
            con = DBPool.getConnection();
            con.setAutoCommit(false);
            query = "UPDATE orderdetails SET listofmenuitem=?,amount=?,paidamount=?,reason=?,tableno=? where orderid=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, params.get("menuitem"));
            pst.setString(2, params.get("amount"));
            pst.setString(3,params.get("paidamount"));
            pst.setString(4, params.get("reason"));
            pst.setString(5, params.get("tableno"));
            pst.setString(6, params.get("orderid"));
            
            int r = pst.executeUpdate();
            if (r > 0) {

                jobj = new JSONObject();
                jobj.put("message", "Order Update Successfully.");
                jobj.put("success", true);
            } else {
                jobj = new JSONObject();
                jobj.put("message", "Some error Occurred...!!!! Pease try again.");
                jobj.put("success", false);
                con.rollback();
            }
            con.commit();
            
           
        } catch (Exception ex) {
            Logger.getLogger(OrderDetailDaoImpl.class.getName()).log(Level.SEVERE, null, ex);
            con.rollback();
            
        }finally
        {
            con.close();
        }
         return jobj.toString();
    }
}
