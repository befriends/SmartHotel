

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
    </head>
    <body>
          <div class="container">
        <div class="container-fluid">
                <img src="images/header.jpg" class="img-rounded" width="100%" height="100px">
            </div>
              <div class="container-fluid">
        <div style="margin-left: auto; margin-right: auto; width:80%; background-color: antiquewhite;" >
            <%
                String subcategoryid=request.getParameter("subcategoryid");
                String subcategoryname=request.getParameter("subcategoryname");
            %>
        <h1>SubCategory Update Form</h1><br>
        <div>
            <fieldset style="border:1px solid silver; padding:5px;">
                <form action="MenuItemController" method="Post" name="updateSubCategory_form" style="color: orangered">
                    Sub-Category ID : SUB<%=subcategoryid%><br><input type="hidden" name="subcategoryid" value="<%=subcategoryid%>"/>
                        Sub-Category Name : <input type="text" name="subcategoryname" value="<%=subcategoryname%>" style="color: red;"/><br>
                        <input type="submit" name="submit" value="Update"/>
                        <a href="AddSubCategory.jsp"> <input type="button" name="cancel" value="Exit"/></a>
                        <input type="hidden" name="act" value="2" />
                        <input type="hidden" name="submodule" value="subcategory" />
                    </form>
        </fieldset>
            </div>
                </div>
    </body>
</html>
