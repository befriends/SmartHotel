
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONArray"%>
<%@page import="DaoImpl.UserDaoImpl"%>
<%@page import="Dao.UserDao"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String message = "";
    int usercount = 0;
%>
<%
    if(session.getAttribute("UserName") == null){
        response.sendRedirect("login.jsp");
    }
    if(session.getAttribute("roleid") != null && ((Integer) session.getAttribute("roleid")) == 2){
        response.sendRedirect("home.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User</title>
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <script src="js/jquery.js"></script>
        <!--style for menu-->
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">

        <!--script for menu-->
	<script type="text/javascript" src="js/responsivemultimenu.js"></script>
        
        <script src="js/bootstrap.min.js"></script>
        <!--<script type="text/javascript" src="js/calendar.js"></script>-->
        <script type="text/javascript" lang="javascript">

            function submitUpdateForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "UpdateUser.jsp?act=2";
                document.getElementById(f).submit();
            }

            function submitDeleteForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "UserController?act=3";
                document.getElementById(f).submit();
            }
            
            function myFunction() {
                var d = new Date();
                d.setDate();
                document.getElementById("demo").innerHTML = d;
            }
            function validate() {

                var userCount = $("#userListTbl tr").length - 1; // -1 for tr > th (first tr is always table header)
                if(userCount >= 10){ // Restrict user to add maximum 10 users.
                    alert("Sorry. You can add maximum 10 Users.");
                    return false;
                }
                    
                var mobile = document.getElementById("mobile").value;
                var pattern = /^\d{10}$/;

                if (document.getElementById("fullname").value === "") {
                    alert("Full name may not be blank");
                    return false;
                } else if (document.getElementById("address").value === "") {
                    alert("Adress may not be blank.");
                    return false;
                } else if (document.getElementById("mobile").value === "") {
                    alert("Mobile Number may not be blank.");
                    return false;
                } else if (document.getElementById("username").value === "") {
                    alert("Username may not be blank.");
                    return false;
                }
                else if (document.getElementById("password").value === "") {
                    alert("Password may not be blank.");
                    return false;
                }
                else if (pattern.test(mobile)) {
                    // alert("Your mobile number : " + mobile);
                    return true;
                } else {
                    alert("please write 10 digits valid mobile number");
                    return false;
                }
                if (document.getElementById("demo").value === "") {
                    alert("BirthDate may not be blank");
                    return false;
                }
                else if (document.getElementById("male").checked || document.getElementById("female").checked) {
                    alert('radio checked');
                } else {
                    alert('radio unchecked');
                }
            }
             function validateAlpha() {
                var textInput = document.getElementById("fullname").value;
                textInput = textInput.replace(/[^A-Za-z]/g, "");
                document.getElementById("fullname").value = textInput;

            }
            function numbersonly(e) {
                var unicode = e.charCode ? e.charCode : e.keyCode
                if (unicode != 8) { //if the key isn't the backspace key (which we should allow)
                    if ((unicode < 48 || unicode > 57) && (unicode < 9 || unicode > 10) && (unicode < 37 || unicode > 39)) //if not a number
                        return false //disable key press
                }
            }
            function limitlength(obj, length) {
                var maxlength = length
                if (obj.value.length > maxlength)
                    obj.value = obj.value.substring(0, maxlength)
            }
            function resetform() {
                document.getElementById("orderform").reset();
            }
             $(document).ready(function ()
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
                        <%
                            if (request.getParameter("result") != "" && request.getParameter("result") != null) {
                                JSONObject jobj = new JSONObject(request.getParameter("result"));
                                message = jobj.getString("message");
                                if (jobj.getBoolean("success")) {
                                    %><div class="alert alert-success fade in" style="text-align: center;">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                            <strong><%=message %></strong>
                        </div><%
                        } else {
                        %><div class="alert alert-danger fade in" style="text-align: center;">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                            <strong><%=message %></strong>
                        </div><%
                                }
                            }

                            UserDao userDAOObj = new UserDaoImpl();

                        %>
                        <%!
                            JSONObject jobj = null;
                        %>


                        <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">User Profile</span>

                        <div style="max-height: 400px; overflow-y: scroll;overflow-x: hidden;">
                            <fieldset style="border:1px solid silver; padding:5px;">
                                <form role="form" id="orderform" class="form-horizontal" action="UserController" method="post" onkeypress="myFunction()" onsubmit="return validate()">
                                    <div class="form-group">
                                        <label for="fullname" class="control-label col-sm-2">Full Name</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="fullname" placeholder="Enter User full Name" name="fullname" autofocus="true" required=""/>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="address" class="control-label col-sm-2">Address: </label>
                                        <div class="col-sm-8">
                                            <textarea type="text" class="form-control" id="address" placeholder="Enter address" name="address" required=""></textarea>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="mobile" class="control-label col-sm-2">Mobile no : </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="mobile" placeholder="Enter Mobile number" name="mobile" onkeypress="return numbersonly(event)" onkeyup="return limitlength(this, 10)" required=""/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="gender" class="control-label col-sm-2"> Gender : </label>
                                        <div class="col-sm-4">
                                            <div class="radio-inline">
                                                <label><input type="radio" class="form-control" id="gender"  name="gender" value="m" checked="true"/>Male</label>
                                            </div>
                                            <div class="radio-inline">
                                                <label><input type="radio" class="form-control" id="gender" name="gender" value="f"/>Female</label>
                                            </div>
                                            <div class="radio-inline">
                                                <label><input type="radio" class="form-control" id="gender" name="gender" value="o"/>Other</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="datepicker" class="control-label col-sm-2">D.O.B.: </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="date-picker" id="demo" placeholder="Enter DOB" name="datepicker" value="" required=""/><br><br>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="username" class="control-label col-sm-2">User Name : </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="username" placeholder="Enter User Name" name="username" required=""/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="password" class="control-label col-sm-2">Password  : </label>
                                        <div class="col-sm-8">
                                            <input type="password" class="form-control" id="password" placeholder="Enter Password Here" name="password" required=""/>
                                        </div>
                                    </div>
                                    <div class="form-group"> 
                                        <div class="col-sm-offset-2 col-sm-5">
                                            <button type="submit" name="submit" value="Add" class="btn btn-default">Add User</button>
                                            <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                            <button  type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                        </div>
                                    </div>
                                    <input type="hidden" name="act" value="1" />
                                    <input type="hidden" name="submodule" value="user" />


                                </form>
                            </fieldset>
                            <table class="table table-bordered table-hover" style="table-layout:fixed;" id="userListTbl">
                                <thead>
                                    <tr class="">
                                        <th style="display: none;">ID</th>
                                        <th style="width: 10%;text-align: center;">Sr. No.</th>
                                        <th style="width: 15%;">Full Name</th>
                                        <th style="width: 15%;">User Name</th>
                                        <th style="width: 15%;">Address</th>
                                        <th style="width: 15%;">Mobile No</th>
                                        <th style="width: 10%;">Gender</th>
                                        <th style="width: 20%;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%  String userList = userDAOObj.getUserList();
                                        JSONArray userarr = new JSONArray(userList);
                                        int cnt = 0;
                                        usercount = userarr.length();
                                        while (cnt < userarr.length()) {
                                            JSONObject obj = userarr.getJSONObject(cnt);
                                    %>
                                   
                                <form id="form<%=cnt%>" name="form<%=cnt%>" action="" method="POST">
                                    <tr class="success">
                                        <td style="display: none;">
                                            <input type="hidden" name="userid" value="<%=obj.getString("userid")%>" readonly />
                                            <input type="hidden" name="submodule" value="user" readonly />
                                        </td>
                                        <td><label><%=cnt + 1%></label></td>
                                        <td>
                                            <%=obj.optString("fullname", "")%>
                                        </td>
                                        <td>
                                            <%=obj.optString("username", "")%>
                                        </td>
                                        <td>
                                            <%=obj.optString("address", "")%>
                                        </td>
                                        <td>
                                            <%=obj.optString("mobile", "")%>
                                        </td>
                                        <td>
                                            <% if (obj.optString("gender", "m").equals("m")) {%><%="Male"%><%} else if (obj.optString("gender", "f").equals("f")) {%><%="Female"%><%} else {%><%="Other"%><%}%>
                                        </td>
                                        <td>
                                            <a href="#" class="btn btn-danger btn-sm" onclick="submitDeleteForm(<%=cnt%>);">
                                                <span class="glyphicon glyphicon-remove"></span> Delete
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
                </div>

                </body>
                </html>
