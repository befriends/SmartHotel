
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("UserName") == null){
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="css/style.css" />
        <script type="text/javascript" src="js/jquery.js"></script>
        <script type="text/javascript" src="js/calendar.js"></script>
        <script>
            function myFunction() {
                var d = new Date();
                d.setDate();
                document.getElementById("demo").innerHTML = d;
            }
        </script>
    </head>
    <body>
        <div><h2>Purchase Material</h2></div><br>
       <form role="form" class="form-horizontal" action="ReportController" method="post"  onkeypress="myFunction()"> 
           Select Date:<input class="date-picker" type="text"  name="datepicker1" value="" id="demo" placeholder="--- Select Date ---" autofocus="true" required=""/><br><br>
            <button type="submit" name="submit" value="Add" class="btn btn-default" >OK</button>
            <input type="hidden" name="act" value="1" />
            <input type="hidden" name="submodule" value="purchasedate" />
</form>
    </body>
</html>
