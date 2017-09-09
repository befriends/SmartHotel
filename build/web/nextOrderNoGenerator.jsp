
<%@page import="org.json.JSONObject"%>
<%@page import="DaoImpl.OrderDaoImpl"%>
<%@page import="Dao.OrderDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String nextOrderID = "";
            OrderDao orderDAOObj = new OrderDaoImpl();
                    
            JSONObject jobj = orderDAOObj.generateNextOrderID();
            if(Boolean.parseBoolean(jobj.getString("success"))){
                 nextOrderID = jobj.getString("nextOrderNo");
            } else{
                nextOrderID = jobj.getString("message");
            }
        %>
        <h1>Next Order No. is : <%=nextOrderID %></h1>
    </body>
</html>
