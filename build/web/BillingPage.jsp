
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="DaoImpl.OrderDetailDaoImpl"%>
<%@page import="Dao.OrderDetailDao"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.lang.*"%>
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
                document.getElementById(f).action = "#?act=2";
                document.getElementById(f).submit();
            }

            function submitDeleteForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "#?act=3";
                document.getElementById(f).submit();
            }
            function submitBillingForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "#?act=4";
                document.getElementById(f).submit();
            }
            

            
        </script>

            
        
    </head>
    <body>
        <div class="order" style="height: 600px;">
            <h1>Billing Page</h1>
                    
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
                  String discount="",discountreason="",orderid="",menuitem="",amount="",paidamount="",tableno="",reason="",date="";
                             
                              orderid=request.getParameter("orderid");
                              menuitem=request.getParameter("menuitem");
                              amount=request.getParameter("amount");
                              paidamount=request.getParameter("paidamount");
                              tableno=request.getParameter("tableno");
                              reason=request.getParameter("reason");
                              date=request.getParameter("date");
                             
                             
                             discountreason=StringUtils.isNotEmpty(request.getParameter("discountreason")) ? request.getParameter("discountreason") : "none";
                            // discount=StringUtils.isNotEmpty(request.getParameter("discount")) ? request.getParameter("discount") : "00";
                             
                             //discount="5";
                             
                             int a=Integer.parseInt(amount);
                             int b=Integer.parseInt(paidamount);
                             int c=Integer.parseInt(discount);
                             int discou=((a-b)*c)/100;
                             
                             int total=a-discou;
                        %>
                        <span class="label label-primary center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle; border-radius:8px; ">Billing Page</span>
                </div>
                        
                    <fieldset style=" padding:20px;" class="conform">
                    <form  role="form" class="form-horizontal" action="" method="Post">


                        <div class="orderdetails1">
                            
                            <div class="form-group">
                                    <label for="discount" class="control-label col-sm-2">Discount: </label>
                                    <div class="col-sm-7">
                                        <input type="text" class="form-control" id="discount" placeholder="Enter Discount Amount" name="discount"/>
                                    </div>
                                </div>
                            
                            
                        </div>   
                        <div class="orderdetails2">
                            
                             <div class = "form-group">
                                    <label for="discountreason" class="control-label col-xs-4">Discount Reason: </label>
                                    <div class="">
                                        <textarea class = "form-control" rows = "3" cols = "6" name="discountreason" placeholder="Enter The Reason....!!!"></textarea>
                                    </div>
                             </div>
                        </div>                           

                        <div class="form-group"> 
                            <div class="col-sm-offset-4 col-sm-7">
                                <button type="submit" name="adddiscount" value="adddiscount" class="btn btn-primary">Add Discount</button>
                                <a href="#"><button type="button" name="back" value="back" class="btn btn-primary col-sm-offset-1">Back</button></a>
                                <a href="#"><button type="button" name="cancel" value="Cancel" class="btn btn-primary col-sm-offset-1">Cancel</button></a>
                                
                            </div>
                        </div>
                        <input type="hidden" name="act" value="1" />
                        <input type="hidden" name="submodule" value="BillingPage" />
                    </form>
                </fieldset>    
            <table class="table table-bordered table-hover">
                        <thead>
                            <tr class="danger">
                                <th>OrderID</th>
                                <th>TableNO</th>
                                <th>ListOfMenuItem</th>
                                <th>Quality</th>
                                <th>UnitPrice</th>
                                <th>Amount</th>
                                <th>Paid Amount</th>
                                <th>Paid Reason</th>
                                <th>Date</th>
                                <th>Discount</th>
                                <th>Discount Reason</th>
                                <th>Total Amount</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <%-- <tbody>

                            <%--
                                OrderDetailDao orderDao=new OrderDetailDaoImpl();

                                String orderList = orderDao.getOrderList();
                                JSONArray pdarr = new JSONArray(orderList);
                                int cnt = 0;
                                while (cnt < pdarr.length()) {
                                    JSONObject obj = pdarr.getJSONObject(cnt);

                           --%>
                           

                        <form id="form" name="form" action="" method="POST">
                            <tr class="success">
                                <td>
                                    <input type="hidden" name="orderid" value="<%=orderid%>" readonly /><%=orderid%>
                                    <input type="hidden" name="submodule" value="OrderDetail" readonly />
                                </td>
                                <td>
                                    <input type="hidden" name="tableno" value="<%=tableno%>" readonly /><%=tableno%>
                                </td>

                                <td>
                                    <input type="text" name="menuitem" hidden="true" value="<%=menuitem%>" readonly /><%=menuitem%>
                                </td>
                                <td>
                                    <input type="hidden" name="quality" value="" readonly />
                                    
                                </td>
                                <td>
                                    <input type="hidden" name="unitprice" value="" readonly />
                                    
                                </td>
                                <td>
                                    <input type="text" name="amount" hidden="true" value="<%=amount%>" readonly /><%=amount%>
                                </td>
                                <td>
                                    <input type="text" name="paidamount" hidden="true" value="<%=paidamount%>" readonly /><%=paidamount%>
                                </td>
                                <td>
                                    <input type="text" name="reason" hidden="true" value="<%=reason%>" readonly /><%=reason%>
                                </td>
                                <td>
                                    <input type="text" name="date" hidden="true" value="<%=date%>" readonly /><%=date%>
                                </td>
                                <td>
                                    <input type="text" name="discount" hidden="true" value="<%=discount%>" readonly /><%=discount%>% =<%=discou%>
                                </td>
                                <td>
                                    <input type="text" name="discountreason" hidden="true" value="<%=discountreason%>" readonly /><%=discountreason%>
                                </td>
                                 
                                <td>
                                    <input type="text" name="totalamount" hidden="true" value="<%=total%>" readonly /><%=total%>
                                </td>
                                
                                <td>
                                    <a href="#" class="btn btn-info btn-sm" onclick="submitUpdateForm(<%--=cnt--%>);">
                                        <span class="glyphicon glyphicon-pencil"></span> Update
                                    </a> 

                                    <a href="#" class="btn btn-danger btn-sm" onclick="submitDeleteForm(<%--=cnt--%>);">
                                        <span class="glyphicon glyphicon-remove"></span> Delete
                                    </a>
                                     <a href="#" class="btn btn-warning btn-sm" onclick="submitBillingForm(<%--=cnt--%>);">
                                        <span class="glyphicon glyphicon-check"></span> Bill
                                    </a>   

                                </td>
                            </tr>
                        </form>
                        <%--
                                cnt++;
                            }
                       --%>
                        </tbody>
                    </table>
        </div>
    </body>
</html>
