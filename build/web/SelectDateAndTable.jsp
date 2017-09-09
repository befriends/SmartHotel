
<%@page import="org.json.JSONArray"%>
<%@page import="DaoImpl.TableDaoImpl"%>
<%@page import="Dao.TableDao"%>
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
        <title>JSP Page</title>

        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/calendar.js"></script>
<script>
        function validate() {
                if (document.getElementById("demo").value == "") {
                    alert("Date may not be blank");
                    return false;
                }
            }

            function resetform() {
                document.getElementById("dateform").reset();
            }
            </script>
        <style type="text/css">
            #menuitemlist{
                display:none;
                position: absolute;
                z-index: 3;
                background-color: white;
                min-width: auto;
                max-height: 200px;
                overflow-y: scroll;
            }

            #menuitemlist > div{
                padding: 5px;
            }

            #menuitemlist > div:hover{
                cursor: pointer;
                background-color: #dcdcdc;
            }
        </style>
    <body>
        <div class="main_container" style="height: 600px;">
            <!--Menu-->
            <div>
                <hr>
                <nav id="primary_nav_wrap" style="width: 100%;">
                    <ul>
                        <li class="current-menu-item"><a href="#">Home</a></li>

                        <li><a href="#">Product</a>
                            <ul>
                                <li ><a href="AddCategory.jsp">Category</a></li>                          
                                <li ><a href="AddSubCategory.jsp">Sub-Category</a></li>
                                <li ><a href="AddMenuItem.jsp">Menu Item</a></li>
                            </ul>
                        </li>
                        <li><a href="#">Sales</a>
                            <ul>
                                <li class="dir"><a href="#">Sales List</a></li>
                                <li class="dir"><a href="#">Sales Return</a></li>
                                <li class="dir"><a href="#">Day End</a></li>

                            </ul>
                        </li>
                        <li><a href="#">Payment</a></li>
                        <li><a href="#">Reports</a>
                            <ul>
                                <li><a href="#">Order Report</a></li>
                                <li><a href="#">Sales Report</a></li>
                                <li><a href="#">Payment Report</a></li>
                            </ul>
                        </li>
                        <li><a href="#">Profile </a>
                            <ul>
                                <li><a href="AddUser.jsp">User Profile</a></li>
                                <li><a href="#">Table</a></li>
                                <li><a href="login.jsp">Logout</a></li>
                            </ul>
                        </li>

                        <li><a href="#">Contact Us</a></li>
                    </ul>
                </nav>
                <hr>
            </div>

            <div class="container">
                <!--  Header  -->
                <div class="container-fluid">
                    <img sr width="100%" height="100px">
                </div>

                <!--  Body  -->
                <div class="container-fluid">

                    <div style="margin-left: auto; marght: auto; width: 80%; background-color: antiquewhite;">
                        <%
                            if (request.getParameter("result") != "" && request.getParameter("result") != null) {
                                JSONObject jobj = new JSONObject(request.getParameter("result"));
                                message = jobj.getString("message");
                                if (jobj.getBoolean("success")) {
                        %><div class="alert alert-success fade in">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                            <strong><%=message%></strong>
                        </div><%
                        } else {
                        %><div class="alert alert-danger fade in">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                            <strong><%=message%></strong>
                        </div><%
                                }
                            }
                        %>

                        <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Table And Date</span>
                        <div>
                            <fieldset style="border:1px solid silver; padding:5px;">
                                <form id="tableform" role="form" class="form-horizontal" name="tablefrm" action="ReportController" method="post" id="dateform" onsubmit="return validate()">
                                    <div class="form-group">
                                        <label for="tableno" class="control-label col-sm-2">Table : </label>
                                        <div class="col-sm-8">
                                            <select name="tableno" id="tableid" class="selectpicker" required="">
                                                <option>--Select Table--</option>
                                                <%
                                                    TableDao tableDaoObj = new TableDaoImpl();
                                                    JSONObject tableJObj = tableDaoObj.getAllTableList();
                                                    JSONArray tableJarr = tableJObj.getJSONArray("data");
                                                    for (int cnt = 0; cnt < tableJarr.length(); cnt++) {
                                                        JSONObject jobj = tableJarr.getJSONObject(cnt);
                                                %>
                                                <option value="<%=jobj.getString("tableno")%>"><%=jobj.getString("tablename")%></option>
                                                <%
                                                    }
                                                %>


                                            </select>
                                        </div>

                                    </div>
                                                Date:<input class="date-picker" type="text"  name="datepicker" value="" id="demo" placeholder="--- Select Date ---" autofocus="true" required=""/><br><br><br>

                                    <div class="form-group"> 
                                <div class="col-sm-offset-2 col-sm-5">
                                    <button type="submit" name="submit" value="Add" class="btn btn-default" >Generate</button>
                                    <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                    <button type="button" name="cancel" onclick="resetform()" value="Reset" class="btn btn-default col-sm-offset-1">Reset</button>
                                </div>
                            </div>
                                    <input type="hidden" name="act" value="1" />
                                    <input type="hidden" name="submodule" value="tabledate" />
                                </form>
                            </fieldset>
                            </body>
                            </html>
