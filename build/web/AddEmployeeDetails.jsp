
<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashMap"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="Dao.CommonDao"%>
<%@page import="DaoImpl.UserDaoImpl"%>
<%@page import="Dao.UserDao"%>
<%@page import="Dao.UserDao"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONObject"%>
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
        <link href = "css/jquery-ui.css"rel = "stylesheet">
        <script src = "js/jquery.js"></script>
        <script src = "js/jquery-ui.js"></script>


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
                document.getElementById("dob").innerHTML = d;
                // document.getElementById("hiredate").innerHTML = d;
            }
            function validate() {

                var mobile = document.getElementById("mobile").value;
                var pattern = /^\d{10}$/;

                if (document.getElementById("employeename").value === "") {
                    alert("Employee Name may not be blank");
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
                if (document.getElementById("dob").value === "") {
                    alert("BirthDate may not be blank");
                    return false;
                } else if (document.getElementById("hiredate").value === "") {
                    alert("Hiredate may not be blank");
                    return false;
                }
                else if (document.getElementById("male").checked || document.getElementById("female").checked) {
                    alert('radio checked');
                } else {
                    alert('radio unchecked');
                }
            }
            function validateAlpha() {
                var textInput = document.getElementById("employeename").value;
                textInput = textInput.replace(/[^A-Za-z]/g, "");
                document.getElementById("employeename").value = textInput;

            }
            function numbersonly(e) {
                var unicode = e.charCode ? e.charCode : e.keyCode
                if (unicode != 8) { //if the key isn't the backspace key (which we should allow)
                    if ((unicode < 48 || unicode > 57) && (unicode < 9 || unicode > 10)) //if not a number
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
            $(document).ready(function()
            {
                $("#hiredate").datepicker({
                    dateFormat: 'dd/mm/yy'
                });
                $("#dob").datepicker({
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
                        <strong><%=message%></strong>
                    </div><%
                    } else {
                                %><div class="alert alert-danger fade in" style="text-align: center;">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                        <strong><%=message%></strong>
                    </div><%
                            }
                        }

                        HashMap<String, String> params = new HashMap<String, String>();
                        params.put("submodule", "employee"); // Database Table Name
                        params.put("columnname", "employeeid"); // Database Column Name
                        CommonDao commonDaoObj = new CommonDaoImpl();
                        String id = commonDaoObj.generateNextID(params);

                        UserDao userDAOObj = new UserDaoImpl();

                    %>
                    <%!
                        JSONObject jobj = null;
                    %>


                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Employee Details</span>

                    <!--<div style="max-height: 400px; overflow-y: scroll;overflow-x: scroll;">-->
                    <fieldset style="border:1px solid silver; padding:5px;">
                        <form role="form" id="orderform" class="form-horizontal" action="UserController" method="post"  onkeypress="myFunction()" onsubmit="return validate()" >

                            <div class="form-group">
                                <label for="employeeid" class="control-label col-sm-3"> ID: </label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="employeeid" name="customid" value="<%=id%>" readonly="true" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="categorynm"class="control-label col-sm-3">Select Designation :</label>
                                <div class="col-sm-8">
                                    <select class="form-control" id="designation" placeholder="Select Category Name" name="designation" autofocus="true" required="">
                                        <option value="">--Please Select Designation--</option>
                                        <option value="COOK">COOK</option>
                                        <option value="WAITER">WAITER</option>
                                        <option value="MANAGER">MANAGER</option>
                                        <option value="STAFF">STAFF</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="employeename" class="control-label col-sm-3">Name</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="employeename" placeholder="Enter  full Name" name="employeename" required=""/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="address" class="control-label col-sm-3">Address: </label>
                                <div class="col-sm-8">
                                    <textarea type="text" class="form-control" id="address" placeholder="Enter address" name="address" required=""></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="mobile" class="control-label col-sm-3">Mobile no : </label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" id="mobile" placeholder="Enter Mobile number" name="mobile" onkeypress="return numbersonly(event)" onkeyup="return limitlength(this, 10)" required=""/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="gender" class="control-label col-sm-3"> Gender : </label>
                                <div class="col-sm-4">
                                    <div class="radio-inline">
                                        <label><input type="radio" class="form-control" id="gender"  name="gender" value="m" checked=""/>Male</label>
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
                                <label for="dob" class="control-label col-sm-3">D.O.B.: </label>
                                <div class="col-sm-8">
                                    <input type="text" class="date-picker" id="dob" placeholder="Enter DOB" name="dob" value="" required=""/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="hiredate" class="control-label col-sm-3">Hire Date.: </label>
                                <div class="col-sm-8">
                                    <input type="text" class="date-picker" id="hiredate" placeholder="Enter Hire Date" name="hiredate" value="" required=""/>
                                </div>
                            </div>

                            <div class="form-group"> 
                                <div class="col-sm-offset-3 col-sm-5">
                                    <button type="submit" name="submit" value="Add" class="btn btn-default">Add Employee</button>
                                    <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                    <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1">Cancel</button>
                                </div>
                            </div>
                            <input type="hidden" name="act" value="1" />
                            <input type="hidden" name="submodule" value="employee" />


                        </form>
                    </fieldset>
                    <%
                        JSONObject EmployeeList = userDAOObj.getEmployeeList();
                        JSONArray userar = EmployeeList.getJSONArray("data");
                        if (EmployeeList != null && EmployeeList.has("success") && EmployeeList.has("data")) {
                            userar = EmployeeList.getJSONArray("data");
                        }
                    %>

                    <table class="table table-bordered table-hover"  style="table-layout:fixed;" id="tbl">
                        <thead>
                            <tr class="">
                                <th style="display: none;">ID</th>
                                <th style="width: 5%;text-align: center;">Sr. No.</th>
                                <th style="width: 13%;">Employee Name</th>
                                <th style="width: 10%;">Designation</th>
                                <th style="width: 10%;">Address</th>
                                <th style="width: 12%;">Mobile No</th>
                                <th style="width: 7%;text-align: center;">Gender</th>
                                <th style="width: 10%;">DOB</th>
                                <th style="width: 10%;">Hire Date</th>
                                <th style="width: 20%;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%   //JSONObject userList = userDAOObj.getEmployeeList();
                                //JSONArray userarr = new JSONArray(userList);
                                int cnt = 0;
                                for (cnt = 0; cnt < userar.length(); cnt++) {
                                    JSONObject obj = userar.getJSONObject(cnt);
                            %>
                            <tr class="info" id="editrecordid<%=cnt%>" style="display:none;">
                        <form name="editrecords">

                            <td><label><%=cnt + 1%></label></td>
                            <td style="display: none;">
                                <label id="employeeid" style="display: none;"><%=obj.getLong("employeeid")%></label>
                                <label id="submodule" style="display: none;">employee</label>
                            </td>
                            <td>
                                <input type="text" name="employeename" value="<%=obj.get("employeename")%>"/>
                            </td>
                            <td>
                                <input type="text" name="designation" value="<%=obj.get("designation")%>" readonly />
                            </td>
                            <td>
                                <input type="text" name="address" value="<%=obj.get("address")%>"/>
                            </td>
                            <td>
                                <input type="text" name="mobile" value="<%=obj.getInt("mobile")%>"/></td>
                            <td>
                                <input type="text" name="gender" value="<%=obj.get("gender")%>"/></td>
                            <td>
                                <input type="text" name="dob" value="<%=obj.get("dob")%>"/></td>
                            <td>
                                <input type="text" name="hiredate" value="<%=obj.get("hiredate")%>"/></td>
                            <td>
                                <p class="btn btn-info" onClick="updaterecord(<%=cnt%>)"><span class="glyphicon glyphicon-save"></span>&nbsp;Save</p>
                                &nbsp;|&nbsp;
                                <p class="btn btn-default" onClick="cancel(<%=cnt%>)"><span class="glyphicon glyphicon-remove"></span>&nbsp;Cancel</p>
                        </form>
                        </tr>
                        <tr class="success" id="recordid<%=cnt%>">
                            <td style="display: none;">
                                <label id="employeeid" style="display: none;"><%=obj.getLong("employeeid")%></label>
                                <label id="submodule" style="display: none;">employee</label>
                            </td>
                            <td><label><%=cnt + 1%></label></td>
                            <td><label name="employeename"><%=obj.get("employeename")%></label></td>
                            <td><label name="designation"><%=obj.get("designation")%></label></td>
                            <td><label name="address"><%=obj.get("address")%></label></td>
                            <td><label name="mobile"><%=obj.get("mobile")%></label></td>
                            <td><label name="gender"><%=obj.get("gender")%></label></td>
                            <td><label name="dob"><%=obj.get("dob")%></label></td>
                            <td><label name="hiredate"><%=obj.get("hiredate")%></label></td>

                            <td>
                                <p class="btn btn-success" onClick="showeditrecord(<%=cnt%>)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;Edit</p>
                                &nbsp;|&nbsp;
                                <p class="btn btn-danger" onClick="deleterecord(<%=cnt%>)"><span class="glyphicon glyphicon-trash"></span>&nbsp;Delete</p>
                        </tr>  

                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
        <script type="text/javascript" src="js/GridViewController.js"></script>      
    </body>

</html>