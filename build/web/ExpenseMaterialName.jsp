

<%@page import="DaoImpl.PurchaseMaterialDaoImpl"%>
<%@page import="Dao.PurchaseMaterialDao"%>
<%@page import="DaoImpl.MenuItemDaoImpl"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.MenuItemDao"%>
<%@page import="Dao.CommonDao"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
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
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="css/normalize.css">
        <title>JSP Page</title>
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <!--style for menu-->
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">

        <script type="text/javascript" src="js/jquery.js"></script> 
        <!--script for menu-->
        <script type="text/javascript" src="js/responsivemultimenu.js"></script>
        <script src="js/bootstrap.min.js"></script>               
        <script type="text/javascript" lang="javascript">
            function validate() {

                if (document.getElementById("materialnm").options[document.getElementById("materialnm").selectedIndex].value == "") {
                    alert("plz select Material Name");
                    return false;
                }
            }
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
                    %><span style="width: 100%;margin-left: auto;margin-right: auto;"><h3 style="color: crimson;"><%=message%></h3></span><br /><%
                    } else {
                        %><span style="width: 100%;margin-left: auto;margin-right: auto;"><h3 style="color: red;"><%=message%></h3></span><br /><%
                                }
                            }

                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("submodule", "materialstock"); // Database Table Name
                            params.put("columnname", "materialname"); // Database Column Name
                            CommonDao commonDaoObj = new CommonDaoImpl();
                            String id = commonDaoObj.generateNextID(params);

                            PurchaseMaterialDao purchasematerialDAOObj = new PurchaseMaterialDaoImpl();
                            JSONObject jsonList = purchasematerialDAOObj.getMaterialList();

                        %>
                        <%!
                            JSONObject jobj = null;
                        %>
                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Expense Material</span>
                    <div>
                        <fieldset style="border:1px solid silver; padding:5px;">
                            <form role="form" id="orderform" class="form-horizontal" target="_blank" action="ReportController" method="post"  onsubmit="return validate()" >

                                <div class="form-group">
                                    <label for="materialnm" class="control-label col-sm-2"> Material Name:</label>
                                    <div class="col-sm-8">
                                        <select class="form-control" id="materialnm" name="materialid" autofocus="true" required="">
                                            <option value="">--- Select Material ---</option>
                                            <% 
                                             JSONArray jarr = jsonList.getJSONArray("data");

                                                for (int cnt = 0; cnt < jarr.length(); cnt++) {
                                                    jobj = jarr.getJSONObject(cnt);

                                            %>
                                            <option value="<%=jobj.getString("materialname")%>"><%=jobj.getString("materialname")%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group"> 
                                    <div class="col-sm-offset-2 col-sm-5">
                                        <button type="submit" name="submit" value="Add" class="btn btn-default">Click</button>
                                        <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>

                                    </div>
                                </div>
                                <input type="hidden" name="act" value="1" />
                                <input type="hidden" name="submodule" value="expensematerial" />
                            </form>
                        </fieldset>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
