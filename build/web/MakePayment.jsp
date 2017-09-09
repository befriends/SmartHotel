
<%@page import="DaoImpl.UserDaoImpl"%>
<%@page import="Dao.UserDao"%>
<%@page import="Dao.UserDao"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONArray"%>
<%@page import="DaoImpl.MenuItemDaoImpl"%>
<%@page import="Dao.MenuItemDao"%>
<%@page import="Controller.MenuItemController"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String message = "";
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
        <title>Make Employee Payment</title>
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <!--style for menu-->
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">
        <link rel="stylesheet" href="css/normalize.css">
        <!--script for menu-->
        <script type="text/javascript" src="js/responsivemultimenu.js"></script>
        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/jquery.js"></script> 
        <script src="js/commonFunctions.js"></script>
        <!--<script type="text/javascript" src="js/calendar.js"></script>-->
        <link href = "css/jquery-ui.css"rel = "stylesheet">
        <script src = "js/jquery.js"></script>
        <script src = "js/jquery-ui.js"></script>
        <script type="text/javascript" lang="javascript">

            function myFunction() {
                var d = new Date();
                d.setDate();
                document.getElementById("demo").innerHTML = d;
            }

            function submitUpdateForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "UpdateMenuItem.jsp?act=2";
                document.getElementById(f).submit();
            }

            function submitDeleteForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "MenuItemController?act=3";
                document.getElementById(f).submit();
            }

            function loadEmployeeName() {
                var parentComboId = 'designation';
                var childComboId = 'employeename';
                var url = 'UserController';
                var submodule = 'employee';
                loadComboValues1(parentComboId, childComboId, url, submodule);
            }
            function validate() {
                if (document.getElementById("demo").value == "") {
                    alert("Date may not be blank.");
                    return false;
                } else if (document.getElementById("designation").options[document.getElementById("designation").selectedIndex].value == "") {
                    alert("plz select Designation");
                    return false;
                } else if (document.getElementById("employeename").options[document.getElementById("employeename").selectedIndex].value == "") {
                    alert("plz select Employeename");
                    return false;
                } else if (document.getElementById("paymentamount").value == "") {
                    alert("Amount may not be blank");
                    return false;
                }
            }
            function resetform() {
                document.getElementById("orderform").reset();
            }

            $(document).ready(function()
            {
                $("#demo").datepicker({
                    dateFormat: 'dd/mm/yy'
                });
            });
            
             $(document).ready(function() {
                jQuery.extend(jQuery.expr[':'], {
                    focusable: function(el, index, selector) {
                        return $(el).is('a, button, :input, [tabindex]');
                    }
                });

                $(document).on('keypress', 'input,select', function(e) {
                    if (e.which == 13) {
                        e.preventDefault();
                        // Get all focusable elements on the page
                        var $canfocus = $(':focusable');
                        var index = $canfocus.index(this) + 1;
                        if (index >= $canfocus.length)
                            index = 0;
                        $canfocus.eq(index).focus();
                    }
                });
            });

        </script>
    </head>
    <body style="background-color: #555;">
        <jsp:include page="header.jsp"/>
        <div class="container">
            <!--  Body  -->
            <div class="container-fluid">

                <div style="margin-left: auto; margin-right: auto; width: 100%; background-color: antiquewhite;">
                    <%  //                                                           Only for  Disply message after execution
                        if (request.getParameter("result") != "" && request.getParameter("result") != null) {
                            JSONObject jobj = new JSONObject(request.getParameter("result"));
                            message = jobj.getString("message");
                            if (jobj.getBoolean("success")) {
                                %>          <div class="alert alert-success fade in" style="text-align: center;">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                        <strong><%=message%></strong>
                    </div><%
                    } else {
                                %>      <div class="alert alert-success fade in" style="text-align: center;">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                        <strong><%=message%></strong>
                        </div><%
                                }
                            }   /// End

                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("submodule", "payment"); // Database Table Name
                            params.put("columnname", "paymentid"); // Database Column Name
                            CommonDao commonDaoObj = new CommonDaoImpl();
                            String id = commonDaoObj.generateNextID(params);

                            UserDao userDaoObj = new UserDaoImpl();

                            JSONObject employeeJsonList = userDaoObj.getEmployeeJsonList();


                        %>
                        <%!
                            JSONObject jobj = null;
                        %>

                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;"> Make Employee Payment</span>
                    <div>
                        <fieldset  style="border:1px solid silver; padding:5px;">
                            <form role="form" id="orderform" class="form-horizontal" action="PaymentController" method="post" onkeypress="myFunction()" onsubmit="return validate()">
                                <div class="form-group">
                                    <label for="paymentid" class="control-label col-sm-2">Payment ID:</label> 
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="paymentid" name="customid" value="<%=id%>" readonly="true" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="datepicker1"class="control-label col-sm-2">Enter Date:</label>
                                    <div class="col-sm-8">
                                        <input class="date-picker" type="text" placeholder="Enter Payment Date" name="datepicker1" value="" id="demo" required=""/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="designation"class="control-label col-sm-2">Designation :</label>
                                    <div class="col-sm-8">
                                        <select class="form-control" id="designation" placeholder="Select Employee Designation" name="designation" onchange="loadEmployeeName();" required="">
                                            <option value="" >--Please Select Designation--</option>
                                            <option value="COOK">COOK</option>
                                            <option value="WAITER">WAITER</option>
                                            <option value="MANAGER">MANAGER</option>
                                            <option value="STAFF">STAFF</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="employeename"class="control-label col-sm-2">Employee-Name :</label>
                                    <div class="col-sm-8">
                                        <select class="form-control" id="employeename" placeholder="Select Employee Name" name="employeeid" required="">
                                            <option value="">--Please Select Employee Name--</option>
                                        </select> 
                                    </div>
                                </div>
                                <div class="form-group" >
                                    <label for="modeofpayment" class="control-label col-sm-2">Mode Of Payment:</label>
                                    <div class="col-sm-8">
                                        <SELECT NAME="modeofpayment"placeholder="Select Mode Of Payment" required="">
                                            <OPTION VALUE="1">CASH</OPTION>
                                            <OPTION VALUE="2">CHEQUE</OPTION>
                                        </SELECT>
                                    </div>
                                </div>
                                <div class="form-group" >
                                    <label for="paymentamount" class="control-label col-sm-2">Amount:</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="paymentamount" placeholder="Enter Salary Amount" name="paymentamount" required=""/>
                                    </div>
                                </div>
                                <div class="form-group"> 
                                    <div class="col-sm-offset-2 col-sm-5">
                                        <button type="submit" name="submit" value="Save" class="btn btn-default">Make Payment</button>
                                        <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                        <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                    </div>
                                </div>
                                <input type="hidden" name="act" value="1" />

                            </form>
                        </fieldset>


                    </div>
                </div>
            </div>
            <div class="container-fluid">

            </div>
    </body>
</html>



