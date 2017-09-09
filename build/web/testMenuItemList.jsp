<%-- 
    Document   : testMenuItemList
    Created on : 3 Apr, 2016, 6:51:59 PM
    Author     : sai
--%>

<%@page import="DaoImpl.MenuItemDaoImpl"%>
<%@page import="Dao.MenuItemDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <%
        MenuItemDao daoObj = new MenuItemDaoImpl();
        
        String json = daoObj.getMenuItemDetailsList();
        %>
        <%=json %>
    </body>
</html>
