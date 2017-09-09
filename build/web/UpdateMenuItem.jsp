
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
         <div class="container">
        <div class="container-fluid">
                <img src="images/header.jpg" class="img-rounded" width="100%" height="100px">
            </div>
              <div class="container-fluid">
        <div style="margin-left: auto; margin-right: auto; width: 80%; background-color: antiquewhite;">         
            <%
                String menuitemid = request.getParameter("menuitemid");
                String menuitemname = request.getParameter("menuitemname");
                String rate = request.getParameter("rate");
            %>
            <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Update Menu Item</span>
            <div>
                <fieldset style="border:1px solid silver; padding:5px;">
                    <form action="MenuItemController" method="Post" name="updateMenuItem_form" style="color: orangered;">

                        MenuItem Code : ITM<%=menuitemid%><br><input type="hidden" name="menuitemid" value="<%=menuitemid%>"/>
                        Item Name : <input type="text" name="menuitemname" value="<%=menuitemname%>" style="color: red;"/><br>
                        Rate : <input type="text" name="rate" value="<%=rate%>" style="color: red;"/><br>
                        <input type="submit" name="submit" value="Update"/>
                        <a href="home.jsp"> <input type="button" name="cancel" value="Exit"/></a>
                        <input type="hidden" name="act" value="2" />
                        <input type="hidden" name="submodule" value="category" />
                    </form>
                </fieldset>
            </div>
        </div>
    </body>
</html>
