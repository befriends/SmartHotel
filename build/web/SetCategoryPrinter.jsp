<%-- 
    Document   : SetCategoryPrinter
    Created on : 29 Jan, 2017, 1:17:28 PM
    Author     : Ashish Mohite
--%>

<%@page import="DaoImpl.UserDaoImpl"%>
<%@page import="Dao.UserDao"%>
<%@page import="java.util.HashMap"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="DaoImpl.MenuItemDaoImpl"%>
<%@page import="Dao.MenuItemDao"%>
<%@page import="Controller.MenuItemController"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8" session="true"%>
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
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="css/normalize.css">
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <!--style for menu-->
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">

        <script type="text/javascript" src="js/jquery.js"></script> 
	<!--script for menu-->
	<script type="text/javascript" src="js/responsivemultimenu.js"></script>
        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>
        
        <!-- Include the plugin's CSS and JS: -->
        <script type="text/javascript" src="js/bootstrap-multiselect.js"></script>
        <link rel="stylesheet" href="css/bootstrap-multiselect.css" type="text/css"/>
        <title>Set Printer</title>
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
                                params.put("submodule", "subcategory"); // Database Table Name
                                params.put("columnname", "subcategoryid"); // Database Column Name
                                CommonDao commonDaoObj = new CommonDaoImpl();
                                String id = commonDaoObj.generateNextID(params);

                                MenuItemDao menuItemDaoObj = new MenuItemDaoImpl();

                                JSONObject jsonList = menuItemDaoObj.getCategoryList();

                            %>
                            <%!
                                JSONObject jobj = null;
                            %>
                        <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Set Printer</span>
                        <div style="height: 400px;overflow-y: scroll;overflow-x: hidden;">
                            <fieldset style="border:1px solid silver; padding:5px;">
                                <form role="form" id="orderform" class="form-horizontal" action="MenuItemController" method="post">
                                    <div class="form-group">
                                        <label for="categorynm"class="control-label col-sm-2">Category Name:</label>
                                        <div class="col-sm-8">
                                            <select class="form-control selectpicker" id="categorynm" placeholder="Select Category Name" name="categoryid" autofocus="true" required="" multiple>
                                                <%
                                                    JSONArray jarr = jsonList.getJSONArray("data");

                                                    for (int cnt = 0; cnt < jarr.length(); cnt++) {
                                                        jobj = jarr.getJSONObject(cnt);

                                                %>
                                                <option value="<%=jobj.getLong("categoryid")%>"><%=jobj.getString("categoryname")%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="printernm" class="control-label col-sm-2">Printer Name:</label>
                                        <div class="col-sm-8">
                                            <select class="form-control" id="printernm" placeholder="Select Printer Name" name="printernm" >
                                                <option value="">--Please Select Printer--</option>
<!--                                                <option value="Test Printer">Test Printer</option>
                                                <option value="Test Printer2">Test Printer2</option>-->
                                                <%
                                                    UserDao userDaoObj = new UserDaoImpl();
                                                    jsonList = userDaoObj.getAvailablePrinters();
                                                    jarr = jsonList.getJSONArray("data");

                                                    for (int cnt = 0; cnt < jarr.length(); cnt++) {
                                                        jobj = jarr.getJSONObject(cnt);
                                                %>
                                                <option value="<%=jobj.getString("printername")%>"><%=jobj.getString("printername")%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group"> 
                                        <div class="col-sm-offset-2 col-sm-5">
                                            <button type="submit" name="submit" value="Set" class="btn btn-default">Set Printer</button>
                                            <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                        </div>
                                    </div>
                                    <input type="hidden" name="act" value="1" />
                                    <input type="hidden" name="submodule" value="printer" />
                                </form>
                            </fieldset>
                        </div>
                    </div>
                </div>
                <div class="container-fluid">
                </div>

            </div>
            <script type="text/javascript" src="js/GridViewController.js"></script> 
            

    <!-- Initialize the plugin: -->
    <script type="text/javascript">
        $(document).ready(function() {
            $('#categorynm').multiselect();
        });
    </script>
    </body>
</html>
