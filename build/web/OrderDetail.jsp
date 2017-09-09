
<%@page import="org.json.JSONArray"%>
<%@page import="DaoImpl.OrderDetailDaoImpl"%>
<%@page import="Dao.OrderDetailDao"%>
<%@page import="org.json.JSONObject"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="DaoImpl.MenuItemDaoImpl"%>
<%@page import="Dao.MenuItemDao"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String message = "";


%>
<%
    if(session.getAttribute("UserName") == null){
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="css/normalize.css">
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript" lang="javascript">
            function submitUpdateForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "UpdateOrderDetail.jsp?act=2";
                document.getElementById(f).submit();
            }

            function submitDeleteForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "OrderDetailController?act=3";
                document.getElementById(f).submit();
            }
            function submitBillingForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "BillingPage.jsp?act=4";
                document.getElementById(f).submit();
            }


            $('#menuitem').multiselect();
        </script>
    </head>
    <body>
        <div class="container-fluid">

                <div style="margin-left: auto; margin-right: auto; width: 80%; background-color: antiquewhite;">
                <h1>OrderDetails Form</h1>
                <div class="result" >

                    <% if (request.getParameter("result") != "" && request.getParameter("result") != null) {
                            JSONObject jobj = new JSONObject(request.getParameter("result"));
                            message = jobj.getString("message");
                            if (jobj.getBoolean("success")) {
                    %> 
                    <div class="alert alert-success fade in">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                        <strong>Success!</strong><h5><%=message%></h5>
                    </div>
                    <% } else {%>
                    <div class="alert alert-danger fade in">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                        <strong>Unsuccess!</strong><h5><%=message%></h5>
                    </div> 
                    <% }
                        }

                        HashMap<String, String> params = new HashMap<String, String>();
                        params.put("submodule", "orderdetail"); // Database Table Name
                        params.put("columnname", "orderid"); // Database Column Name
                        CommonDao commonDaoObj = new CommonDaoImpl();
                        String id = commonDaoObj.generateNextID(params);

                        OrderDetailDao orderDao = new OrderDetailDaoImpl();
                        MenuItemDao menuItemDaoObj = new MenuItemDaoImpl();

                        JSONObject menuitemJsonList = menuItemDaoObj.getMenuItemList();

                    %>
                    <%!                          JSONObject jobj = null;
                    %>

                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Order Detail</span>
                </div>
                <fieldset style="border:1px solid silver; padding:5px;">
                    <form  role="form" class="form-horizontal" action="OrderDetailController" method="Post" name="orderform">
                        <div class="form-group">
                                <label for="orderid" class="control-label col-sm-2">Order ID: </label>
                                <div class="col-xs-6">
                                    <input type="text" class="form-control" id="orderid" name="orderid" value="<%=id%>" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="menuitemnm" class="control-label col-sm-2">Menu Item :</label>
                                <div class="col-xs-6">
                                    <select class="form-control" id="menuitemnm" placeholder="Select MenuItem Name" name="menuitemid" required="">
                                        <option>--Please Select Menu Item--</option>
                                        <% JSONArray jarr = menuitemJsonList.getJSONArray("data");
                                            for (int cnt = 0; cnt < jarr.length(); cnt++) {
                                                jobj = jarr.getJSONObject(cnt);

                                        %>
                                        <option value="<%=jobj.getLong("menuitemid")%>"><%=jobj.getString("menuitemname")%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="amount" class="control-label col-sm-2">Amount: </label>
                                <div class="col-xs-6">
                                    <input type="text" class="form-control" id="amount" placeholder="Enter Amount" name="amount" required=""/>
                                </div>
                            </div>
                                    <div class="form-group">
                                <label for="quantity" class="control-label col-sm-2">Quantity: </label>
                                <div class="col-xs-6">
                                    <input type="text" class="form-control" id="amount" placeholder="Enter Quantity" name="quantity" required=""/>
                                </div>
                            </div>
                                    
                               
                                     <div class = "form-group">
                                    <label for="comment" class="control-label col-xs-2">Comment: </label>
                                    <div class="col-xs-6">
                                        <textarea class = "form-control" rows = "2" cols = "4" name="comment" placeholder="Enter The comment if any....!!!" required=""></textarea>
                                    </div>
                                </div>

                        </div>
                        <div class="form-group"> 
                            <div class="col-sm-offset-4 col-sm-8">
                                <button type="submit" name="addorder" value="Add Order" class="btn btn-primary">Add Order</button>
                                <a href="#"><button type="button" name="cancel" value="Cancel" class="btn btn-primary col-sm-offset-1">Cancel</button></a>
                            </div>
                        </div>
                        <input type="hidden" name="act" value="1" />
                        <input type="hidden" name="submodule" value="OrderDetail" />
                    </form>
                </fieldset>
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr class="danger">
                            <th>OrderID</th>
                            <th>Table No</th>
                            <th>ListOfMenuItem</th>
                            <th>Amount</th>
                            <th>Paid Amount</th>
                            <th>Reason</th>
                            <th>Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>

                        <%
                            String orderList = orderDao.getOrderList();
                            JSONArray pdarr = new JSONArray(orderList);
                            int cnt = 0;
                            while (cnt < pdarr.length()) {
                                JSONObject obj = pdarr.getJSONObject(cnt);


                        %>

                    <form id="form<%=cnt%>" name="form<%=cnt%>" action="" method="POST">
                        <tr class="success">
                            <td>
                                <input type="hidden" name="orderid" value="<%=obj.getInt("orderid")%>" readonly /><%=obj.getInt("orderid")%>
                                <input type="hidden" name="submodule" value="OrderDetail" readonly />
                            </td>
                            <td>
                                <input type="hidden" name="tableno" value="<%=obj.getInt("tableno")%>" readonly /><%=obj.getInt("tableno")%>
                            </td>

                            <td>
                                <input type="text" name="menuitem" hidden="true" value="<%=obj.get("menuitem")%>" readonly /><%=obj.get("menuitem")%>
                            </td>
                            <td>
                                <input type="text" name="amount" hidden="true" value="<%=obj.get("amount")%>" readonly /><%=obj.get("amount")%>
                            </td>
                            <td>
                                <input type="text" name="paidamount" hidden="true" value="<%=obj.get("paidamount")%>" readonly /><%=obj.get("paidamount")%>
                            </td>
                            <td>
                                <input type="text" name="reason" hidden="true" value="<%=obj.get("reason")%>" readonly /><%=obj.get("reason")%>
                            </td>
                            <td>
                                <input type="text" name="date" hidden="true" value="<%=obj.get("date")%>" readonly /><%=obj.get("date")%>
                            </td>
                            <td>
                                <a href="#" class="btn btn-info btn-sm" onclick="submitUpdateForm(<%=cnt%>);">
                                    <span class="glyphicon glyphicon-pencil"></span> Update
                                </a> 

                                <a href="#" class="btn btn-danger btn-sm" onclick="submitDeleteForm(<%=cnt%>);">
                                    <span class="glyphicon glyphicon-remove"></span> Delete
                                </a>
                                <a href="#" class="btn btn-warning btn-sm" onclick="submitBillingForm(<%=cnt%>);">
                                    <span class="glyphicon glyphicon-check"></span> Bill
                                </a>   

                            </td>
                        </tr>
                    </form>
                    <%
                            cnt++;
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
