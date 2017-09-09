
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%!
    String message="";
 %>
 <%
    if (session.getAttribute("UserName") == null) {
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="css/normalize.css">
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript" lang="javascript"></script>
        <title>JSP Page</title>
    </head>
    <body>
        <div class="order" style="height: 600px;">
            <h1>OrderDetailUpdate</h1>
            <div class="container-fluid" style="margin-top:20px ">

                <div class="result" >
                        <% 

                             String orderid=request.getParameter("orderid");
                             String menuitem=request.getParameter("menuitem");
                             String amount=request.getParameter("amount");
                             String paidamount=request.getParameter("paidamount");
                             String tableno=request.getParameter("tableno");
                             String reason=request.getParameter("reason");
                             
                        %>

                    <span class="label label-primary center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle; border-radius:8px; ">Order Details</span>
                </div>
                <fieldset style=" padding:20px;" class="conform">
                    <form  role="form" class="form-horizontal" action="OrderDetailController" method="Post">


                        <div class="orderdetails1">
                            <div class="form-group">
                                <label for="orderid" class="control-label col-sm-3">Order ID: </label>
                                <div class="col-xs-7">
                                    <input type="text" class="form-control" id="orderid" name="orderid" readonly  value="<%=orderid%>" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="menuitem" class="control-label col-sm-3">Menu Item: </label>
                                <div class="col-xs-7">
                                    <%-- <input type="text" class="form-control" id="menuitem"  name="menuitem" value="<%=menuitem%>"/> --%>
                                      <select class="form-control" id="menuitem" name="menuitem">
                                        <option value=""></option>
                                            <option value="paneer">paneer</option>
                                            <option value="roti">roti</option>
                                            <option value="masala">masala</option>
                                            <option value="tea">tea</option>
                                            <option value="panipuri">panipuri</option>
                                            <option value="bidlari">bislary</option>
                                            <option value="rice">rice</option>
                                            <option value="dal">dal</option>
                                            <option value="other">other</option>
                                        
                                    </select> 
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="amount" class="control-label col-sm-3">Amount: </label>
                                <div class="col-xs-7">
                                    <input type="text" class="form-control" id="amount" value="<%=amount%>" name="amount"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="paidamount" class="control-label col-sm-3">Paid Amount: </label>
                                <div class="col-xs-7">
                                    <input type="text" class="form-control" id="paidamount" value="<%=amount%>" name="paidamount"/>
                                </div>
                            </div>
                        </div>   
                        <div class="orderdetails2">
                            <div class = "form-group">
                                    <label for="tableno" class="control-label col-xs-4">Table NO: </label>
                                    <div class="">
                                        <input type="text" class="form-control" id="tableno" name="tableno" value="<%=tableno%>" />
                                    </div>
                            </div>
                            <div class = "form-group">
                                <label for="reason" class="control-label col-xs-4">Reason: </label>
                                <div class="">
                                    <textarea class = "form-control" rows = "3" cols = "6" name="reason" value="<%=reason%>"> <%=reason%></textarea>
                                </div>
                            </div>
                        </div>                           

                        <div class="form-group"> 
                            <div class="col-sm-offset-4 col-sm-8">
                                <button type="submit" name="addorder" value="OrderUpdate" class="btn btn-primary">Update Order</button>
                                <a href="#"><button type="button" name="cancel" value="Cancel" class="btn btn-primary col-sm-offset-1">Cancel</button></a>
                            </div>
                        </div>
                        <input type="hidden" name="act" value="2" />
                        <input type="hidden" name="submodule" value="OrderDetail" />
                    </form>
                </fieldset>

            </div>
        </div>
    </body>
</html>
