<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        ID : <%=request.getParameter("id") %>
        Category : <%=request.getParameter("category") %>
        Sub Category : <%=request.getParameter("subcategory") %>
        Item Name : <%=request.getParameter("itemname") %>
        Rate : <%=request.getParameter("rate") %>
    </body>
</html>
