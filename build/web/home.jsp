
<%@page contentType="text/html" pageEncoding="UTF-8" session="true"%>
<%
    if (session.getAttribute("UserName") == null) {
        response.sendRedirect("login.jsp");
    }
%>


<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
	<!--style for menu-->
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">

        <script type="text/javascript" src="js/jquery.js"></script> 
	<!--script for menu-->
	<script type="text/javascript" src="js/responsivemultimenu.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <title>Home Page</title>
    </head>

    <body style="background-color: #555;">
    <jsp:include page="header.jsp"/>
        <div class="container">
            <!--  Body  -->
            <div class="container-fluid">

            <div style="margin-left: auto; margin-right: auto; margin-top: -20px; width: 100%; height: 200px; background-color: antiquewhite;">
            <%
                if (session.getAttribute("UserName") != null) {
            %>
            <div style="text-align: center;"><br><h3>Welcome <font style="font-family: arial; font-size: 30px; font-weight: bold; color: maroon; text-decoration: underline;"><%=session.getAttribute("UserName") %></font></h3></div>
            <%
                } else{
            %>
                <strong><%=request.getParameter("msg")%></strong>
            <%  }
                if(request.getParameter("success") != null && Boolean.parseBoolean(request.getParameter("success"))){
            %>
                    <hr style="border-top: 2px solid goldenrod; width: 80%;line-height: 1px;"/>
                    <p style="color: green; text-align: center; font-size: 18px;"><strong><%=request.getParameter("message")%></strong></p>
            <%  
                } else if(request.getParameter("success") != null && !Boolean.parseBoolean(request.getParameter("success"))){
            %>
                    <hr style="border-top: 2px solid goldenrod; width: 80%;line-height: 1px;"/>
                    <p style="color: red; text-align: center; font-size: 18px;"><strong><%=request.getParameter("message")%></strong></p>
            <%
                }
            %>
            </div>
            </div>
        </div>
    </body>
</html>
