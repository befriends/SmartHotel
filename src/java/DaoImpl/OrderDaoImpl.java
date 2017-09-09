/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DaoImpl;

import DBConnection.DBPool;
import Dao.OrderDao;
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
import java.util.Set;
import java.util.TreeSet;
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
public class OrderDaoImpl implements OrderDao {

//    Connection conn = null;
    @Override
    public JSONObject getSearchedMenuItemList(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        Connection conn = null;

        try {
            String value = params.get("value");
            conn = DBConnection.DBPool.getConnection();
            String query = "select menuitemid,menuitemname,rate,customid,isspecial from menuitem where isdeleted=0 ";
            String[] searchValue = value.split(" ");
            for (int i = 0; i < searchValue.length; i++) {
                if (i == 0) {
                    query += "and menuitemname like '" + searchValue[i] + "%' ";
                } else {
                    query += "and menuitemname like '% " + searchValue[i] + "%' ";
                }

            }
            query += " order by menuitemname Asc ";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            JSONArray jarr = new JSONArray();
            while (rs.next()) {
                JSONObject jobj = new JSONObject();
                jobj.put("menuitemid", rs.getLong(1));
                jobj.put("menuitemname", null != rs.getString(2) ? rs.getString(2) : "");
                jobj.put("rate", rs.getDouble(3));
                jobj.put("customid", null != rs.getString(4) ? rs.getString(4) : "");
                jobj.put("isspecial", rs.getInt(5));

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

    @Override
    public synchronized JSONObject saveOrder(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        boolean isBooked = false;
        boolean cancelFlag = false;
        Connection conn = null;
        try {
            conn = DBConnection.DBPool.getConnection();
            conn.setAutoCommit(false);

            String orderList = params.get("orderList");
            JSONArray orderJarr = new JSONObject(orderList).getJSONArray("data");
            String tableid = new JSONObject(orderList).getString("tableid");
            String tableno = new JSONObject(orderList).getString("tableno");
            String userid = new JSONObject(orderList).getString("userid");
//            int   quantit = new JSONObject(orderList).getInt("quantity");

            String tableOrderMappingId = UUID.randomUUID().toString();
            String orderId = UUID.randomUUID().toString();

            String sqlQuery = "select isbooked from tabledetails where tableid='" + tableid + "'";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                if (rs.getInt(1) == 1) {
                    isBooked = true;
                }
            }

            if (!isBooked) {
                sqlQuery = "insert into tableordermapping(id, tableid, orderid) values(?,?,?)";
                PreparedStatement pst = conn.prepareStatement(sqlQuery);
                pst.setString(1, tableOrderMappingId);
                pst.setString(2, tableid);
                pst.setString(3, orderId);

                int r = pst.executeUpdate();

                if (r > 0) {
                    sqlQuery = "update tabledetails set isbooked=1 where tableid='" + tableid + "'";
                    pst = conn.prepareStatement(sqlQuery);
                    int isTableUpdate = pst.executeUpdate();
                    if (isTableUpdate > 0) {
                        String currentDate = new SimpleDateFormat("dd/MM/yyyy").format(new Date());
                        String year = currentDate.substring(currentDate.lastIndexOf("/") + 1);
                        String month = currentDate.substring(currentDate.indexOf("/") + 1, currentDate.lastIndexOf("/"));
                        String day = currentDate.substring(0, currentDate.indexOf("/"));

                        String orderNo = "";
                        JSONObject resJobj = generateNextOrderID();
                        if (resJobj.has("nextOrderNo")) {
                            orderNo = resJobj.getString("nextOrderNo");
                        } else {
                            throw new Exception();
                        }

                        long today = new Date(year + "/" + month + "/" + day).getTime();
                        Calendar cal = Calendar.getInstance();
                        cal.setTime(new Date());
                        long currentDateTime = cal.getTimeInMillis();
                        cal.getTime();
                        sqlQuery = "insert into ordertable(orderid, orderdate, orderno, userid,orderdatetime) values(?,?,?,?,?)";
                        pst = conn.prepareStatement(sqlQuery);
                        pst.setString(1, orderId);
                        pst.setLong(2, today);
                        pst.setString(3, orderNo);
                        pst.setString(4, userid);
                        pst.setLong(5, currentDateTime);

                        int orderResult = pst.executeUpdate();

                        if (orderResult > 0) {
                            for (int cnt = 0; cnt < orderJarr.length(); cnt++) {
                                String orderDetailsId = UUID.randomUUID().toString();
                                JSONObject orderJobj = orderJarr.getJSONObject(cnt);

                                long menuitemid = orderJobj.getLong("menuitemid");

                                String message = orderJobj.has("message") ? orderJobj.getString("message") : "";

                                int quantity = orderJobj.getInt("quantity");

                                double rate = orderJobj.getDouble("rate");
                                if (quantity > 0 || cancelFlag) {

                                    sqlQuery = "insert into orderdetails(id, orderid, menuitemid, quantity, rate, comment, tableno, userid) values(?,?,?,?,?,?,?,?)";
                                    pst = conn.prepareStatement(sqlQuery);
                                    pst.setString(1, orderDetailsId);
                                    pst.setString(2, orderId);
                                    pst.setLong(3, menuitemid);
                                    pst.setInt(4, quantity);
                                    pst.setDouble(5, rate);
                                    pst.setString(6, message);
                                    pst.setString(7, tableno);
                                    pst.setString(8, userid);

                                    int orderDetailsResult = pst.executeUpdate();

                                    if (orderDetailsResult > 0) {
                                        respoJSONObject.put("orderno", orderNo);
                                        respoJSONObject.put("success", true);
                                        respoJSONObject.put("message", "Order added successfully with 'Order No.: " + orderNo + "'");
                                    } else {
                                        respoJSONObject.put("success", false);
                                        respoJSONObject.put("errormessage", "Some error occurred when saving order details. Please try again.");
                                        conn.rollback();
                                        break;
                                    }
                                } else {
                                    respoJSONObject.put("success", false);
                                    respoJSONObject.put("errormessage", "Please Select Positive Quantity. ");
                                    conn.rollback();
                                    break;
                                }
                            }
                            conn.commit();
                        } else {
                            respoJSONObject.put("success", false);
                            respoJSONObject.put("errormessage", "Some error occurred when saving order. Please try again.");
                            conn.rollback();
                        }
                    } else {
                        respoJSONObject.put("success", false);
                        respoJSONObject.put("errormessage", "Table not update When Saving table order mapping. Please try again.");
                        conn.rollback();
                    }

                } else {
                    respoJSONObject.put("success", false);
                    respoJSONObject.put("errormessage", "Some error occurred when saving table order mapping. Please try again.");
                    conn.rollback();
                }
            } else {
                respoJSONObject = saveOrderDetails(params);
            }
        } catch (Exception e) {
            e.printStackTrace();
            conn.rollback();
            respoJSONObject.put("success", false);
            respoJSONObject.put("errormessage", e.getMessage());
        } finally {
            conn.close();
        }

        return respoJSONObject;
    }

    @Override
    public JSONObject saveOrderDetails(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        Connection conn = null;
        try {
            conn = DBConnection.DBPool.getConnection();
            conn.setAutoCommit(false);
//            conn = DBConnection.DBPool.getConnection();
//            conn.setAutoCommit(false);
//            String message = "";

            String orderList = params.get("orderList");
            boolean cancelFlag = false;
            int orderDetailsResult = 0;
            JSONArray orderJarr = new JSONObject(orderList).getJSONArray("data");
            String tableid = new JSONObject(orderList).getString("tableid");
            String tableno = new JSONObject(orderList).getString("tableno");
            String userid = new JSONObject(orderList).getString("userid");

            String sqlQuery = "select tom.orderid from tableordermapping tom where tom.tableid='" + tableid + "' and tom.orderid in (select orderid from ordertable where iscomplete=0)";
            PreparedStatement pst = conn.prepareStatement(sqlQuery);

            ResultSet rs = pst.executeQuery();
            String orderId = "";
            while (rs.next()) {
                orderId = rs.getString(1);
            }

            for (int cnt = 0; cnt < orderJarr.length(); cnt++) {
                String orderDetailsId = "";
                JSONObject orderJobj = orderJarr.getJSONObject(cnt);
                long menuitemid = orderJobj.getLong("menuitemid");

                String message = orderJobj.has("message") ? orderJobj.getString("message") : "";
                int quantity = orderJobj.getInt("quantity");
                double rate = orderJobj.getDouble("rate");

                sqlQuery = "select id, quantity from orderdetails where orderid='" + orderId + "' and menuitemid='" + menuitemid + "'";
                Statement st = conn.createStatement();
                ResultSet orderDetails = st.executeQuery(sqlQuery);
                if (orderDetails.next()) {
                    if (quantity < 0 && (-quantity) <= orderDetails.getInt(2)) {
                        cancelFlag = true;
                    }
//                    if(orderDetails.getInt(2) == 0 && quantity <= 0){
//                        cancelFlag = false;
//                    }
                    if (quantity > 0 || cancelFlag) {
                        orderDetailsId = orderDetails.getString(1);
                        int qty = orderDetails.getInt(2);
                        sqlQuery = "update orderdetails set quantity=?, comment=? where id=?";
                        pst = conn.prepareStatement(sqlQuery);
                        pst.setInt(1, qty + quantity);
                        pst.setString(2, message);
                        pst.setString(3, orderDetailsId);
                        orderDetailsResult = pst.executeUpdate();
                        if (cancelFlag) {
                            String query = "insert into cancelorderdetails(id, orderid, menuitemid, quantity, rate, comment, tableno, userid) values(?,?,?,?,?,?,?,?)";
                            PreparedStatement pt = conn.prepareStatement(query);
                            pt.setString(1, UUID.randomUUID().toString());
                            pt.setString(2, orderId);
                            pt.setLong(3, menuitemid);
                            pt.setInt(4, quantity);
                            pt.setDouble(5, rate);
                            pt.setString(6, message);
                            pt.setString(7, tableno);
                            pt.setString(8, userid);
                            int cancelOrderSuccess = pt.executeUpdate();
                            if (cancelOrderSuccess > 0) {

                            } else {
                                respoJSONObject.put("success", false);
                                respoJSONObject.put("errormessage", "Some error occurred when saving cancel order details. Please try again.");
                                conn.rollback();
//                                conn.rollback();
                                break;
                            }
                        }
                    } else {
                        respoJSONObject.put("success", false);
                        respoJSONObject.put("errormessage", "Your cancel order quantity is greater than ordered quantity. Please enter correct quantity.");
                        conn.rollback();
                        break;
                    }
                } else if (quantity > 0) {
                    orderDetailsId = UUID.randomUUID().toString();
                    sqlQuery = "insert into orderdetails(id, orderid, menuitemid, quantity, rate, comment, tableno, userid) values(?,?,?,?,?,?,?,?)";
                    pst = conn.prepareStatement(sqlQuery);
                    pst.setString(1, orderDetailsId);
                    pst.setString(2, orderId);
                    pst.setLong(3, menuitemid);
                    pst.setInt(4, quantity);
                    pst.setDouble(5, rate);
                    pst.setString(6, message);
                    pst.setString(7, tableno);
                    pst.setString(8, userid);
                    orderDetailsResult = pst.executeUpdate();
                }

                if (orderDetailsResult > 0) {
                    String orderNo = "";
                    Statement state = conn.createStatement();
                    rs = state.executeQuery("select orderno from ordertable where orderid='" + orderId + "'");
                    if (rs.next()) {
                        orderNo = rs.getString(1);
                    }
                    respoJSONObject.put("orderno", orderNo);
                    respoJSONObject.put("success", true);
                    respoJSONObject.put("message", "Order added successfully.");
                } else {
                    respoJSONObject.put("success", false);
                    respoJSONObject.put("errormessage", "You have no existing order for these menuitem. So you can't cancel order.");
                    conn.rollback();
                    break;
                }
            }
            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
            conn.rollback();
            respoJSONObject.put("success", false);
            respoJSONObject.put("errormessage", e.getMessage());
        } finally {
            conn.close();
        }

        return respoJSONObject;
    }

    @Override
    public JSONObject getOrderList(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        JSONArray jarr = new JSONArray();
        Connection conn = null;
        double CGST =0,SGST =0,serviceTax=0;
        try {
            conn = DBConnection.DBPool.getConnection();

            String tableid = params.get("selectedTable");
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select od.menuitemid, mi.menuitemname, od.quantity, od.rate, od.`comment`, orderid "
                    + "from orderdetails od, menuitem mi where mi.menuitemid=od.menuitemid and "
                    + "orderid=(select tom.orderid from tableordermapping tom, ordertable ot where "
                    + "tom.tableid='" + tableid + "' and ot.orderid = tom.orderid and ot.iscomplete=0) and od.quantity > 0");

            while (rs.next()) {
                JSONObject jobj = new JSONObject();
                jobj.put("menuItemId", rs.getInt(1));
                jobj.put("menuItemName", rs.getString(2));
                jobj.put("qty", rs.getInt(3));
                jobj.put("rate", rs.getDouble(4));
                jobj.put("comment", rs.getString(5));
                jobj.put("orderid", rs.getString(6));
//                jobj.put("isprinted", rs.getString(7));

                jarr.put(jobj);
            }
           ResultSet rs1 =st.executeQuery("select CGST,SGST,servicetax from mastersetting");
            if(rs1.next()){
                 CGST = rs1.getDouble(1);
                 SGST = rs1.getDouble(2);
                 serviceTax = rs1.getDouble(3);
            }
            respoJSONObject.put("CGST", CGST);
            respoJSONObject.put("SGST", SGST);
            respoJSONObject.put("serviceTax", serviceTax);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("success", false);
            respoJSONObject.put("message", "Some error occurred.");
            e.printStackTrace();
        } finally {
            conn.close();
        }

        return respoJSONObject;
    }

    public JSONObject getOrderDetails(String orderID) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        JSONArray jarr = new JSONArray();
        Connection conn = null;
        try {
            conn = DBConnection.DBPool.getConnection();

            String sqlString = "select od.menuitemid, mi.menuitemname, od.quantity, od.rate, od.orderid, o.orderno, o.orderdate "
                    + "from orderdetails od, ordertable o, menuitem mi where mi.menuitemid=od.menuitemid and "
                    + "od.orderid=? and od.quantity > 0 and o.orderid=?";
            PreparedStatement pst = conn.prepareStatement(sqlString);
            pst.setString(1, orderID.replaceAll("\"", ""));
            pst.setString(2, orderID.replaceAll("\"", ""));
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                JSONObject jobj = new JSONObject();
                jobj.put("menuItemId", rs.getInt(1));
                jobj.put("menuItemName", rs.getString(2));
                jobj.put("qty", rs.getInt(3));
                jobj.put("rate", rs.getDouble(4));
                jobj.put("orderid", rs.getString(5));
                jobj.put("orderno", rs.getString(6));
                jobj.put("orderdate", rs.getLong(7));

                jarr.put(jobj);
            }
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("success", false);
            respoJSONObject.put("message", "Some error occurred.");
            e.printStackTrace();
        } finally {
            conn.close();
        }

        return respoJSONObject;
    }

    @Override
    public JSONObject makeBillPayment(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        JSONArray jarr = new JSONArray();
        Connection conn = null;
        try {
            conn = DBConnection.DBPool.getConnection();
            conn.setAutoCommit(false);

            String orderid = params.get("orderid");
            String subtotal = params.get("subtotal");
            String discount = params.get("discount").equals("") ? "0" : params.get("discount");
            String grandtotal = params.get("grandtotal");
            String customer = params.get("customer");
            String paymentmode = params.get("paymentmode");
            String chequeno = params.get("chequeno");
            String checkboxnotificationflag = params.get("checkboxnotificationflag");
            String totalpaidamount = params.get("totalpaidamount").equals("") ? "0" : params.get("totalpaidamount");
            String CGST = params.get("CGST").equals("") ? "0" : params.get("CGST");
            String SGST = params.get("SGST").equals("") ? "0" : params.get("SGST");
            String servicetax = params.get("servicetax").equals("") ? "0" : params.get("servicetax");
            String servicetaxper = params.get("servicetaxper").equals("") ? "0" : params.get("servicetaxper");

            String currentDate = new SimpleDateFormat("dd/MM/yyyy").format(new Date());
            String year = currentDate.substring(currentDate.lastIndexOf("/") + 1);
            String month = currentDate.substring(currentDate.indexOf("/") + 1, currentDate.lastIndexOf("/"));
            String day = currentDate.substring(0, currentDate.indexOf("/"));

            long today = new Date(year + "/" + month + "/" + day).getTime();

            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            long currentDateTime = cal.getTimeInMillis();

            String sqlQuery = "update ordertable set subtotal=" + Double.parseDouble(subtotal) + ", discount=" + Double.parseDouble(discount)
                    + ", totalamount=" + Double.parseDouble(grandtotal) + ", paymentmode=" + paymentmode + ", chequeno='" + chequeno + "',billdate=" + today + ",billdatetime=" + currentDateTime + ",totalpaidamount="+ Double.parseDouble(totalpaidamount) +",CGST="+ Double.parseDouble(CGST) +",SGST="+ Double.parseDouble(SGST) +",servicetax="+Double.parseDouble(servicetax)+",servicetaxperAmount="+ Double.parseDouble(servicetaxper) +", iscomplete=1 where orderid='" + orderid + "'";
//            PreparedStatement pst = conn.prepareStatement(sqlQuery);
//            pst.setDouble(1, Double.parseDouble(subtotal));
//            pst.setDouble(2, Double.parseDouble(discount));
//            pst.setDouble(3, Double.parseDouble(grandtotal));
//            pst.setString(4, orderid);
            Statement st = conn.createStatement();
            int r = st.executeUpdate(sqlQuery);
//            int r = pst.executeUpdate(sqlQuery);
            if (r > 0) {
                sqlQuery = "update tabledetails set isbooked=0,isreserved=0 where tableid=(select tableid from tableordermapping where orderid='" + orderid + "')";
                st.executeUpdate(sqlQuery);
            }

            if (checkboxnotificationflag.equalsIgnoreCase("1")) {

                String qury = "insert into customerborrowings(customerborrowingsid, customername, grandtotal,customerborrowingsdate,totalpaidamount) values(?,?,?,?,?)";
                PreparedStatement pst = conn.prepareStatement(qury);
                pst.setString(1, UUID.randomUUID().toString());
                pst.setString(2, customer);
                pst.setString(3, grandtotal);
                pst.setLong(4, today);
                pst.setString(5, totalpaidamount);

                int d = pst.executeUpdate();
            }

            deductStock(orderid, today);

            conn.commit();
            respoJSONObject.put("success", true);
            respoJSONObject.put("message", true);
        } catch (Exception e) {
            conn.rollback();
            respoJSONObject.put("success", false);
            respoJSONObject.put("message", "Some error occurred.");
            e.printStackTrace();
        } finally {
            conn.close();
        }

        return respoJSONObject;
    }

    @Override
    public void deductStock(String orderid, long today) throws JSONException, SQLException {

        Connection conn = null;
        try {
            conn = DBConnection.DBPool.getConnection();
//            conn.setAutoCommit(false);
            String sqlQuery = "select menuitemid, quantity from orderdetails where orderid='" + orderid + "'";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                long menuitemid = rs.getLong(1);
                int orderQuantity = rs.getInt(2);

                sqlQuery = "select materialid, quantity from menuitemcomposition where menuitemid=" + menuitemid;
                Statement compo = conn.createStatement();
                ResultSet compositionResult = compo.executeQuery(sqlQuery);
                while (compositionResult.next()) {
                    long materialid = compositionResult.getLong(1);
                    double compositionQty = compositionResult.getDouble(2);
                    double deductQty = compositionQty * orderQuantity;

                    sqlQuery = "select quantity from materialstock where materialid=" + materialid;
                    Statement material = conn.createStatement();
                    ResultSet materialResult = material.executeQuery(sqlQuery);

                    if (materialResult.next()) {
                        double stockQty = materialResult.getDouble(1);
                        double afterDeductQty = stockQty - deductQty;
                        sqlQuery = "update materialstock set quantity=" + afterDeductQty + " where materialid=" + materialid;
                        int re = conn.createStatement().executeUpdate(sqlQuery);

                        if (re > 0) {
                            sqlQuery = "select deductionquantity from orderdeductionmaterialstock where deductiondate = " + today + " and materialid = " + materialid;
                            ResultSet deductrs = conn.createStatement().executeQuery(sqlQuery);
                            if (deductrs.next()) {
                                double currentQty = deductrs.getDouble("deductionquantity");
                                sqlQuery = "update orderdeductionmaterialstock set deductionquantity = " + (currentQty + deductQty) + " where materialid = " + materialid;
                            } else {
                                sqlQuery = "insert into orderdeductionmaterialstock(idorderdeductionmaterialstock,deductiondate,materialid,deductionquantity) values('" + UUID.randomUUID().toString() + "'," + today + "," + materialid + "," + deductQty + ")";
                            }

                            re = conn.createStatement().executeUpdate(sqlQuery);
                        }
                    }
                }
            }
            conn.commit();
        } catch (Exception e) {
            conn.rollback();
            e.printStackTrace();
        } finally {
            conn.close();
        }
    }

    @Override
    public JSONObject generateNextOrderID() throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        Connection cn = null;
        Statement st = null;
        ResultSet rs = null;
        String sqlQuery = "", maxOrderNo = "", newOrderNo = "";
        try {
            cn = DBConnection.DBPool.getConnection();

            sqlQuery = "select max(orderno) from ordertable";
            st = cn.createStatement();
            rs = st.executeQuery(sqlQuery);
            while (rs.next()) {
                maxOrderNo = rs.getString(1);
            }

            if (maxOrderNo != null && !(maxOrderNo.equals(""))) {
                maxOrderNo = maxOrderNo.replace("ORD", "");
                long oldNo = Long.parseLong(maxOrderNo);
                long newNo = oldNo + 1;
                newOrderNo = String.valueOf(newNo);
                while (newOrderNo.length() < 9) {
                    newOrderNo = "0" + newOrderNo;
                }
                newOrderNo = "ORD" + newOrderNo;
            } else {
                newOrderNo = "ORD000000001";
            }

            respoJSONObject.put("nextOrderNo", newOrderNo);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("success", false);
            respoJSONObject.put("message", "Some error occurred.");
            e.printStackTrace();
        } finally {
            cn.close();
        }
        return respoJSONObject;
    }

    @Override
    public String deleteOrder(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = null;
        JSONArray jarr = new JSONArray();
        Statement st = null;
        ResultSet rs = null;
        Connection conn = null;
        String orderNumber = "", sqlQuery = "", paymentmode = "", orderNo = "";
        try {
            conn = DBConnection.DBPool.getConnection();

            orderNumber = StringUtils.isNotEmpty(params.get("ordername")) ? params.get("ordername") : "";

            while (orderNumber.length() < 9) {
                orderNumber = "0" + orderNumber;
            }
            orderNumber = "ORD" + orderNumber;

            sqlQuery = "select paymentmode,orderno from ordertable where orderno='" + orderNumber + "'";
            st = conn.createStatement();

            rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                paymentmode = rs.getString(1);
                String orderno = rs.getString(2);
            }
            if (!paymentmode.equals("1")) {

                PreparedStatement ps = conn.prepareStatement("UPDATE ordertable SET isdeleted = 1 WHERE orderno ='" + orderNumber + "' and iscomplete=1 ");
                int r = ps.executeUpdate();
                if (r > 0) {
                    respoJSONObject = new JSONObject();
                    respoJSONObject.put("message", "Order Deleted Successfully.");
                    respoJSONObject.put("success", true);

                } else {
                    respoJSONObject = new JSONObject();
                    respoJSONObject.put("message", "You Cant Delete Order.");
                    respoJSONObject.put("success", true);
                }
            } else {
                respoJSONObject = new JSONObject();
                respoJSONObject.put("message", "You Cant Delete Cash Payment Order.");
                respoJSONObject.put("success", true);
            }

        } catch (Exception e) {
            respoJSONObject = new JSONObject();
            respoJSONObject.put("message", "Some error occurred.");
            respoJSONObject.put("success", false);
            e.printStackTrace();

        } finally {
            conn.close();
        }

        return respoJSONObject.toString();
    }

    @Override
    public JSONObject TableShift(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject responseJobj = new JSONObject();
        Connection conn = null;
        Statement st = null;
        String bookedTableId = "", shiftTableId = "", orderId = "", tableId = "", query = "";
        try {
            bookedTableId = StringUtils.isNotEmpty(params.get("bookedtableid")) ? params.get("bookedtableid") : "";
            shiftTableId = StringUtils.isNotEmpty(params.get("shifttableid")) ? params.get("shifttableid") : "";

            conn = DBConnection.DBPool.getConnection();

            conn.setAutoCommit(false);

            String sqlQuery = "SELECT ot.orderid,tm.tableid  FROM tableordermapping tm,ordertable ot where tm.tableid='" + bookedTableId + "' and ot.orderid  = tm.orderid and iscomplete = 0 ";
            PreparedStatement pst = conn.prepareStatement(sqlQuery);

            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                orderId = rs.getString(1);
                tableId = rs.getString(2);
            }
            st = conn.createStatement();
            query = "update tableordermapping set tableid = '" + shiftTableId + "' where tableid ='" + tableId + "' and orderid ='" + orderId + "'";
            int tableOrderMapping = st.executeUpdate(query);
            if (tableOrderMapping > 0) {

                query = "update tabledetails set isbooked =0 where tableid ='" + tableId + "'";
                st.executeUpdate(query);
                query = "update tabledetails set isbooked =1 where tableid ='" + shiftTableId + "'";
                int r = st.executeUpdate(query);
                if (r > 0) {

                    responseJobj.put("message", "Order Shifted Successfully.");
                    responseJobj.put("success", true);
                    conn.commit();
                } else {
                    responseJobj.put("message", "Some Error Occurs.Please Try Again.");
                    responseJobj.put("success", false);
                }
            } else {
                responseJobj.put("message", "Some Error during Table Shifting.Please Try Again.");
                responseJobj.put("success", false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            conn.rollback();
            responseJobj.put("success", false);
            responseJobj.put("message", e.getMessage());
        } finally {
            conn.close();

        }
        return responseJobj;
    }

    @Override
    public JSONObject getCategoryPrinterNamesFromMenuitem(String menuitemidlist) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        Connection conn = null;
        try {
            conn = DBPool.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select m.menuitemid as menuitemid, c.printername as printername from menuitem m, category c where m.categoryid=c.categoryid and menuitemid in (" + menuitemidlist + ")");

            Set printersList = new TreeSet();
            JSONObject menuitemPrinterJobj = new JSONObject();
            while (rs.next()) {
                printersList.add(rs.getString("printername"));
                menuitemPrinterJobj.put(rs.getLong("menuitemid") + "", rs.getString("printername"));
            }
            respoJSONObject.put("menuitemPrinterJobj", menuitemPrinterJobj);
            respoJSONObject.put("printersList", printersList.toString());
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("success", false);
            respoJSONObject.put("data", "[]");
            conn.rollback();
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject;
    }
    
    @Override
    public JSONObject UpdateEditOrder(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        JSONArray jarr = new JSONArray();
        Connection conn = null;
        try {
            conn = DBConnection.DBPool.getConnection();
            conn.setAutoCommit(false);
            Statement st = conn.createStatement();
            String orderid = params.get("orderid");
                        
            String sqlQuery = "update ordertable set isedited=1 where orderid ='"+orderid+"'";
                st.executeUpdate(sqlQuery);                      
            conn.commit();
            respoJSONObject.put("success", true);
            respoJSONObject.put("message", true);
        } catch (Exception e) {
            conn.rollback();
            respoJSONObject.put("success", false);
            respoJSONObject.put("message", "Some error occurred.");
            e.printStackTrace();
        } finally {
            conn.close();
        }

        return respoJSONObject;
    }

//    @Override
//    public String savePrint(HashMap<String, String> params) throws JSONException, SQLException {
//        JSONObject respoJSONObject = new JSONObject();
//        JSONObject jobj=null;
//        JSONArray jarr = new JSONArray();
//        boolean isBooked = false;
//        boolean cancelFlag = false;
//        String orderNumber = "",tableid="";
//        try {
//            conn = DBConnection.DBPool.getConnection();
//            Statement st = conn.createStatement();
//            conn.setAutoCommit(false);
//            orderNumber = StringUtils.isNotEmpty(params.get("ordernumber")) ? params.get("ordernumber") : "";
//            tableid = StringUtils.isNotEmpty(params.get("tableid")) ? params.get("tableid") : "";
//            ResultSet rs = st.executeQuery("select od.menuitemid,od.quantity,od.rate,od.comment,ot.orderid,ot.orderno,ot.userid,od.tableno from ordertable ot, orderdetails od where ot.orderno='"+ orderNumber +"' and ot.orderid = od.orderid");
//            while (rs.next()) {
//                jobj = new JSONObject();
//                jobj.put("menuitemid", rs.getString(1));
//                jobj.put("quantity", rs.getDouble(2));
//                jobj.put("rate", rs.getDouble(3));
//                jobj.put("comment", rs.getString(4));
//                jobj.put("orderid", rs.getString(5));
//                jobj.put("orderno", rs.getString(6));
//                jobj.put("userid", rs.getString(7));
//                jobj.put("tableno", rs.getString(8));
//                jobj.put("tableid", tableid);
//
//                jarr.put(jobj);
//            }
////            
//            respoJSONObject.put("data", jarr);
////            respoJSONObject.put("orderid", rs.getString(5));
////            respoJSONObject.put("orderno", rs.getString(6));
////            respoJSONObject.put("userid", rs.getString(7));
////            respoJSONObject.put("tableno", rs.getString(8));
////            respoJSONObject.put("tableid", tableid);
////            respoJSONObject.put("tableid", tableid);
////            respoJSONObject.put("success", true);
//
//            
//        } catch (Exception e) {
//            e.printStackTrace();
//            conn.rollback();
//            respoJSONObject.put("success", false);
//            respoJSONObject.put("errormessage", e.getMessage());
//        } finally {
//            conn.close();
//        }
//
//        return respoJSONObject.toString();
//    }
}
