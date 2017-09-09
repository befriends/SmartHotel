
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
    </head>
    <body>
        <div><h2>Monthly Purchase Material</h2></div><br>
        <form role="form" class="form-horizontal" action="ReportController" method="post"> 

        <div id="head1" style="width:15%;float:left;margin-left:25px;">

            <select class="form-control" id='month'placeholder="Select Month" name="month" value="" autofocus="true" required="">

                <option value=''>--Select Month--</option> 
                <option selected value='1'>Janaury</option>
                <option value='2'>February</option>
                <option value='3'>March</option>
                <option value='4'>April</option>
                <option value='5'>May</option>
                <option value='6'>June</option>
                <option value='7'>July</option>
                <option value='8'>August</option>
                <option value='9'>September</option>
                <option value='10'>October</option>
                <option value='11'>November</option>
                <option value='12'>December</option>

            </select> 
        </div> 
        
            <select id="year" name="year" required="">
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
            <input type="hidden" name="submodule" value="monthlypurchase" />
</form>

    </body>
</html>
