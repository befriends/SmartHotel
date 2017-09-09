<%-- 
    Document   : Review
    Created on : 14 Oct, 2016, 10:50:56 AM
    Author     : sai
--%>


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
        <title>Review</title>
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


            function myFunction() {
                var d = new Date();
                d.setDate();
                document.getElementById("dob").innerHTML = d;
                // document.getElementById("hiredate").innerHTML = d;
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
                    %>
                    <%!
                        JSONObject jobj = null;
                    %>


                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Review Details</span>

                    <div style="max-height: 400px; overflow-y: scroll;overflow-x: scroll;">
                        <fieldset style="border:1px solid silver; padding:5px;">
                            <form role="form" id="reviewform" class="form-horizontal" action="ReviewController" method="post"  onkeypress="myFunction()" onsubmit="return validate()" >

                                <div class="form-group">
                                    <label for="customername" class="control-label col-sm-3">Name :</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="customername" placeholder="--- Enter  full Name ---" name="customername" required=""/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="address" class="control-label col-sm-3"> Address: </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="address" name="address" placeholder="--- Enter Address ---" value=""/>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="mobile" class="control-label col-sm-3">Mobile No : </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="mobile" placeholder="--- Enter Mobile number ---" name="mobile" onkeypress="return numbersonly(event)" onkeyup="return limitlength(this, 10)" required=""/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="phone" class="control-label col-sm-3">Phone No : </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="phone" placeholder="--- Enter Phone ---- " name="phone"/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="phone" class="control-label col-sm-3">Email Id: </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="emailid" placeholder="--- Enter Email Id --- " name="emailid" required=""/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="dob" class="control-label col-sm-3">D.O.B.: </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="date-picker" id="dob" placeholder="Enter DOB" name="dob" value="" required=""/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="foodquality" class="control-label col-sm-3"> Food Quality : </label>
                                    <div class="col-sm-4">                                        
                                        <input type="radio" name="ratingfoodquality" value="1" class="star">
                                        <input type="radio" name="ratingfoodquality" value="2" class="star">
                                        <input type="radio" name="ratingfoodquality" value="3" class="star">
                                        <input type="radio" name="ratingfoodquality" value="4" class="star">
                                        <input type="radio" name="ratingfoodquality" value="5" class="star">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="service" class="control-label col-sm-3"> Service : </label>
                                    <div class="col-sm-4">                                        
                                        <input type="radio" name="ratingservice" value="1" class="star">
                                        <input type="radio" name="ratingservice" value="2" class="star">
                                        <input type="radio" name="ratingservice" value="3" class="star">
                                        <input type="radio" name="ratingservice" value="4" class="star">
                                        <input type="radio" name="ratingservice" value="5" class="star">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="hotelenvironment" class="control-label col-sm-3"> Hotel Environment : </label>
                                    <div class="col-sm-4">                                        
                                        <input type="radio" name="ratingenvironment" value="1" class="star">
                                        <input type="radio" name="ratingenvironment" value="2" class="star">
                                        <input type="radio" name="ratingenvironment" value="3" class="star">
                                        <input type="radio" name="ratingenvironment" value="4" class="star">
                                        <input type="radio" name="ratingenvironment" value="5" class="star">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="comment" class="control-label col-sm-3">Comment: </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="comment" placeholder="--- Enter Comment ---" name="comment" value="" required=""/>
                                    </div>
                                </div>

                                <div class="form-group"> 
                                    <div class="col-sm-offset-3 col-sm-5">
                                        <button type="submit" name="submit" value="Add" class="btn btn-default">Generate</button>
                                        <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                        <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1">Cancel</button>
                                    </div>
                                </div>
                                <input type="hidden" name="act" value="1" />
                                <input type="hidden" name="submodule" value="review" />


                            </form>
                        </fieldset>
                    </div>

                </div>
            </div>
            <script type="text/javascript" src="js/GridViewUserController.js"></script>      
    </body>

</html>