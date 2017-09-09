
<%@page import="DaoImpl.BillingPageDaoImpl"%>
<%@page import="Dao.BillingPageDao"%>
<%@page import="DaoImpl.OrderDetailDaoImpl"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%
    if(session.getAttribute("UserName") == null){
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Hotel Project</title>
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
            <link href="css/style.css" rel="stylesheet">
                <script src="js/jquery.js"></script>
                <script src="js/bootstrap.min.js"></script>
                </head>
                <%!
                   //String orderJson = "";
                   // JSONObject obj = null;
                    //JSONArray jarr = null;
                    double sum1 = 0;
                    double sum2 = 0;
                %>
                <%
                   

                        HashMap<String, String> params = new HashMap<String, String>();
                        
                        BillingPageDao billDao = new BillingPageDaoImpl();
                        JSONObject jobj=billDao.getBill();
                        JSONArray jarr=new JSONArray();
                        if (jobj != null && jobj.has("success") && jobj.has("data")) {
                        jarr = jobj.getJSONArray("data");
                        // orderJson = orderDao.getOrderList11();
                    // orderJson = "{\"data\":[{\"menuItemId\":\"1\",\"menuItemName\":\"Paneer\",\"qty\":1,\"rate\":100,\"comment\":\"\"},{\"menuItemId\":\"2\",\"menuItemName\":\"2\",\"qty\":2,\"rate\":200,\"comment\":\"\"},{\"menuItemId\":\"3\",\"menuItemName\":\"3\",\"qty\":5,\"rate\":150,\"comment\":\"\"},{\"menuItemId\":\"4\",\"menuItemName\":\"4\",\"qty\":1,\"rate\":100,\"comment\":\"\"},{\"menuItemId\":\"5\",\"menuItemName\":\"5\",\"qty\":6,\"rate\":100,\"comment\":\"\"}],\"success\":true,\"totalCount\":5,\"subTotal\":1950,\"table\":5}";

                     //JSONObject obj = new JSONObject(orderJson);
                       
                       // JSONArray jarr = obj.getJSONArray("data");
                       // int tableNo = obj.getInt("table");
                        }%>
                
                <body style="background-color:#7E8F7C;">

                    <div class="container-fluid">
                      
                        <!--  Body  -->
                        <div class="col-lg-12">
                         
                            <div class="container-fluid col-sm-10" style="padding:10px;background-color:#A2AB58;height:500px;">
                                <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Bill </span>
                                <table class="table table-bordered table-hover">
                                    <thead>
                                        <tr class="danger">
                                            <th class="col-md-1 text-center">Sr. No.</th>
                                            <th class="col-md-3">Menu Item</th>
                                            <th class="col-md-1 text-right">Qty</th>
                                            <th class="col-md-2 text-right">Rate</th>
                                            <th class="col-md-2 text-right">Amount</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                                try{
                                                sum1 = 0;
                                                for (int i = 0; i < jarr.length(); i++) {
                                                JSONObject orderObj = jarr.getJSONObject(i);

                                                JSONObject item = jarr.getJSONObject(i);
                                                double rate = Double.parseDouble(item.getString("rate"));
                                                double qty = Double.parseDouble(item.getString("quantity"));
                                                double subtotal = rate * qty;

                                                sum1 = sum1 + subtotal;
                                        %>
                                        <tr class="success">
                                           <td class="text-center"><%=i + 1%></td>
                                            <td><%=orderObj.get("menuitemname")%></td>
                                            <td><%=orderObj.get("quantity")%></td>
                                            <td><%=orderObj.get("rate")%></td>
                                            <td class="text-right"><%=subtotal%></td>


                                        </tr>
                                        <%
                                                }
                                            } catch (JSONException e) {
                                                e.printStackTrace();
                                            }
                                        %> 
                                    </tbody>
                                </table>
                                <div class="form-group" style="position:  absolute;right:0;top:100">
                                    <label class="control-label col-sm-2">Total: </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form"  name="customid" value="<%=sum1%>" readonly="true" />
                                    </div>
                                </div><br><br>
                                <div class="form-group" style="position:  absolute;right:0;top:100">
                                    <label class="control-label col-sm-2">Discount: </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form" placeholder="Enter Discount if any" name="customid" />
                                    </div>
                                </div><br><br>
                                        <%
                                        sum2=sum1;
                                        %>
                                        <div class="form-group" style="position:  absolute;right:0;top:100">
                                    <label class="control-label col-sm-2">Grand Total: </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form"  name="customid" value="<%=sum2%>" readonly="true" />
                                    </div>
                                </div><br><br>
                                <input type="hidden" name="tabelnumber" value="" />
                                <button type="submit" class="btn btn-primary" style="position:  absolute;right:0;top:100" >Print </button>

                            </div>
                        </div>
                        <!--Body End-->
                    </div>                 
                </body>
                </html>
