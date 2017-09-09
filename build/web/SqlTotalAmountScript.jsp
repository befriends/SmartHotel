<%-- 
    Document   : SqlTotalAmountScript
    Created on : 18 Jul, 2017, 7:48:27 PM
    Author     : sai
--%>

<%@page import="org.json.JSONObject"%>
<%@page import="DaoImpl.ReportDaoImpl"%>
<%@page import="Dao.ReportDao"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            
             JSONObject jsonList = reportObj.UpdateTotalAmountRows();
        %>
    </body>
</html>
