
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("UserName") == null) {;

    } else if (session.getAttribute("UserName") != null && request.getParameter("logout") == null) {
        response.sendRedirect("home.jsp");
    } else if (session.getAttribute("UserName") != null && request.getParameter("logout") != null && Boolean.parseBoolean(request.getParameter("logout"))) {
        session.invalidate();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/voter login.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="css/normalize.css">
        <title>Login Page</title>
    </head>
    <body>
        <% if (request.getParameter("invalidflag") != null && Boolean.parseBoolean(request.getParameter("invalidflag"))) { %>
        <div style="text-align: center;background-color: wheat; padding: 5px; width: 70%;margin-left: auto;margin-right: auto;margin-top: 100px;">
            <p style="font-family: arial; font-size: 20px; font-weight: bold; color: red;">
                You entered wrong Username or Password. Please try again.
            </p>
        </div>
        <% }else if(request.getParameter("invalidflag") != null && !Boolean.parseBoolean(request.getParameter("invalidflag"))){%>
        <div style="text-align: center;background-color: wheat; padding: 5px; width: 70%;margin-left: auto;margin-right: auto;margin-top: 100px;">
        <p style="font-family: arial; font-size: 20px; font-weight: bold; color: red;">
                Your Database Connection Is Not Established. Please try again.
            </p>
        </div>
        <%}%>
        <!-----start-main---->
        <div class="login-form">
            <div class="head">
                <img src="images/ganlog.jpg" alt="" width="110" height="110" />
            </div>
            <form  action="validateLogin" name="login_form" method="post">
                <div style="text-align: center; color: #c7254e; font-size: 12px">
                    <label class="text" type="text" name="login1"><b>Login To Your Account</b></label></br>
                </div>
                <li>
                    <input type="text" class="text" tabindex="1" value="USERNAME" name="uname" onfocus="this.value = '';" onblur="if (this.value == '') {
                                this.value = 'USERNAME';
                            }" ><a href="#" tabindex="0" class=" icon user"></a>
                </li>
                <li>
                    <input type="password" value="Password" name="password" tabindex="2"onfocus="this.value = '';" onblur="if (this.value == '') {
                                this.value = 'Password';
                            }"><a href="#" tabindex="0"class="icon lock"></a>
                </li>
                <div class="p-container">
                    <%-- <label class="checkbox"><input type="checkbox" name="checkbox" checked><i></i>Remember Me</label> --%>
                    <input type="submit" tabindex="3" value="SIGN IN" >

                </div>
            </form>
                <div style="text-align: center; color: #c7254e; font-style: italic; font-size: 12px">
                    <label class="text" type="text" name="copyright">Copyright© <b>Ganeshvishwa</b> All rights reserved.</label>
                </div>
        </div>

        <!--//End-login-form-->


    </body>
</html>
