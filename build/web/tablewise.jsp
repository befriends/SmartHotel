
<%@page import="Dao.OrderDetailDao"%>
<%@page import="DaoImpl.OrderDetailDaoImpl"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
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
                <script src="js/bootstrap.min.js"></script>
                
                </head>
                <%!
                    //String orderJson = "";
                    //JSONObject obj = null;
                    //JSONArray jarr = null;
                    double sum1 = 0;
                    double sum2 = 0;
                %>
                <%
                 

                        HashMap<String, String> params = new HashMap<String, String>();

                        OrderDetailDao orderDao = new OrderDetailDaoImpl();
                        JSONObject jobj=orderDao.getOrderList11();
                        JSONArray jarr=new JSONArray();
                        if (jobj != null && jobj.has("success") && jobj.has("data")) {
                        jarr = jobj.getJSONArray("data");
                        // orderJson = orderDao.getOrderList11();
                        //orderJson = "{\"data\":[{\"menuItemId\":\"1\",\"menuItemName\":\"Table-1\",\"qty\":Order-1,\"rate\":5000,\"comment\":\"\"},{\"menuItemId\":\"2\",\"menuItemName\":\"Table-1\",\"qty\":Order-2,\"rate\":2000,\"comment\":\"\"},{\"menuItemId\":\"3\",\"menuItemName\":\"3\",\"qty\":5,\"rate\":150,\"comment\":\"\"},{\"menuItemId\":\"4\",\"menuItemName\":\"4\",\"qty\":1,\"rate\":100,\"comment\":\"\"},{\"menuItemId\":\"5\",\"menuItemName\":\"5\",\"qty\":6,\"rate\":100,\"comment\":\"\"}],\"success\":true,\"totalCount\":5,\"subTotal\":1950,\"table\":5}";
                        //JSONObject obj = new JSONObject(orderJson);
                        //JSONArray jarr = obj.getJSONArray("data");
                       // int tableNo = obj.getInt("table");
                        } %>

                <body style="background-color:#7E8F7C;">

                    <div class="container-fluid">
                        <!--  Header  -->
                        <div class="container-fluid">
                            <img src="images/header.jpg" class="img-rounded" width="100%" height="100px">
                        </div>

                        <!--  Body  -->
                        <div class="col-lg-12">

                            <div class="container-fluid col-sm-10" style="padding:10px;background-color:#A2AB58;height:500px;">
                                <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Table Report </span>
                                <table class="table table-bordered table-hover">
                                    <thead>
                                        <tr class="danger">
                                            <th class="col-md-1 text-center">Sr. No.</th>
                                            <th class="col-md-3">Table No</th>
                                            <th class="col-md-3">Date</th>
                                            <th class="col-md-1 text-right">Order No</th>
                                            <th class="col-md-2 text-right">Amount</th>
                                  
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            try{
                                                //sum1 = 0;
                                                for (int i = 0; i < jarr.length(); i++) {
                                                JSONObject orderObj = jarr.getJSONObject(i);
                                               // JSONObject item = jarr.getJSONObject(i);
                                              //  double rate = Double.parseDouble(item.getString("rate"));
                                              //  double qty = Double.parseDouble(item.getString("qty"));
                                                //  double subtotal = rate * qty;

                                              //  sum1 = sum1 + subtotal;
                                        %>
                                        <tr class="success">
                                            <td class="text-center"><%=i + 1%></td>
                                            <td><%=orderObj.get("tableno")%></td>
                                            <td><%=orderObj.get("orderdate")%></td>
                                            <td><%=orderObj.get("orderno")%></td>
                                            <td><%=orderObj.get("totalamount")%></td>

                                        </tr>
                                        <%
                                                }
                                            } catch (JSONException e) {
                                                e.printStackTrace();
                                            }
                                        %> 
                                    </tbody>
                                </table>
                                <input type="hidden" name="tabelnumber" value="" />
                                <button type="submit" class="btn btn-primary" style="position:  absolute;right:0;top:100" >Print </button>
                                <a href="home.jsp">
                                <button type="submit"  class="btn btn-primary" style="position:  absolute;left:0;top:0">Home </button>
                                </a>
                                <a href="home.jsp">
                                <button type="submit"  class="btn btn-primary" style="position:  absolute;left:0;top:100">Back </button>
                                </a>
        
                            </div>
                        </div>
                        <!--Body End-->
                    </div>                 
                </body>
                </html>
