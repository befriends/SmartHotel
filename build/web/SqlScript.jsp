<%-- 
    Document   : SqlScript
    Created on : 27 Jun, 2017, 7:22:01 PM
    Author     : sai
--%>

<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONObject"%>
<%@page import="Dao.ReportDao"%>
<%@page import="DaoImpl.ReportDaoImpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String message = "";
    String userID = "";
%>
<%
    if (session.getAttribute("UserName") == null) {
        response.sendRedirect("login.jsp");
    }
    if (session.getAttribute("UserID") != null) {
        userID = session.getAttribute("UserID").toString();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            HashMap<String, String> params = new HashMap<String, String>();
            ReportDao reportObj = new ReportDaoImpl();
            
             JSONObject jsonList = reportObj.UpdateRows();
        %>
    </body>
</html>
