

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
        <link rel="stylesheet" href="css/style.css" />
        <script type="text/javascript" src="js/jquery.js"></script>
        <script type="text/javascript" src="js/calendar.js"></script>
    </head>
    <body>
         <div><h2>Yearly Purchase Material</h2></div><br>
        <form role="form" class="form-horizontal" action="ReportController" method="post"> 

       
            <select id="year" name="year" autofocus="true" required="">
  <script>
  var myDate = new Date();
  var year = myDate.getFullYear();
  for(var i = 2016; i < 2031; i++){
	  document.write('<option value="'+i+'">'+i+'</option>');
  }
  </script>
</select>
        <button type="submit" name="submit" value="Add" class="btn btn-default"  >Click</button>
         
            <input type="hidden" name="act" value="1" />
            <input type="hidden" name="submodule" value="yearlypurchase" />
</form>

    </body>
</html>
