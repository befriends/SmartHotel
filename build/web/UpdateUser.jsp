
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
        <div style="margin-left: auto; margin-right: auto; width: 80%; background-color: antiquewhite;">

            <%
                String userid = request.getParameter("userid");
                String username = request.getParameter("username");
                String fullname = request.getParameter("fullname");
                String address = request.getParameter("address");
                String mobile = request.getParameter("mobile");
                String gender = request.getParameter("gender");
                String customid = request.getParameter("customid");
            %>
            <h1>User Form</h1><br>
            <div>
                <fieldset title="addUser" style="width: 50%;height: 200px;text-align: center;">
                    <form action="UserController" method="Post" name="addUser_form" style="color: orangered;">
                        ID : USE<%=userid %><br><input type="hidden" name="userid" value="<%=userid %>"/>
                        Full Name : <input type="text" name="fullname" value="<%=fullname %>" style="color: red;"/><br>
                        Address : <input type="text" name="address" value="<%=address %>" style="color: red;"/><br>
                        Mob no : <input type="text" name="mobile" value="<%=mobile %>" style="color: red;"/><br>
                        Gender :
                        <input type="radio" name="gender" value="m" <% if(gender.equals("m")){%>checked="" <% }%> /> Male
                        <input type="radio" name="gender" value="f" <% if(gender.equals("f")){%>checked="" <% }%>/> Female
                        <input type="radio" name="gender" value="o" <% if(gender.equals("o")){%>checked="" <% }%>/> Other<br>
                        User Name : <input type="text" name="username" value="<%=username %>" style="color: red;"/><br>
                        Password  : <input type="password" name="password" value="" style="color: red;"/><br>
                        <input type="submit" name="submit" value="Add"/>
                        <a href="home.jsp"> <input type="button" name="cancel" value="Exit"/></a>
                        <input type="hidden" name="act" value="2" />
                        <input type="hidden" name="submodule" value="user" />
                   
                    </form>
                </fieldset>
            </div>
            </div>
    </body>
</html>
