<%-- 
    Document   : SelectBarrowMonth
    Created on : 23 Nov, 2016, 5:29:02 PM
    Author     : sai
--%>


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
        <title>Monthly Borrow Report</title>
        <link rel="stylesheet" href="css/style.css" />
     <script src="js/jquery.min.js"></script>
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <!--style for menu-->
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">

        <script type="text/javascript" src="js/jquery.js"></script> 
        <!--script for menu-->
        <script type="text/javascript" src="js/responsivemultimenu.js"></script>
        <script src="js/bootstrap.min.js"></script>        
        <script type="text/javascript" src="js/calendar.js"></script>
        <script>
        function validate() {
            if (document.getElementById("month").options[document.getElementById("month").selectedIndex].value == "") {
                    alert("Select Month");
                    return false;
            }else if (document.getElementById("year").options[document.getElementById("year").selectedIndex].value == "") {
                    alert("Select Year");
                    return false;
            }
         }

            function resetform() {
                document.getElementById("borrowmontform").reset();
            }
            </script>

    </head>
    <body style="background-color: #555;">
        <jsp:include page="header.jsp"/>
        <div class="container">
            <!--  Body  -->
            <div class="container-fluid">
                <div style="margin-left: auto; margin-right: auto; width: 100%; background-color: antiquewhite;">

                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Monthly Borrow Report</span>
                    <div style="max-height: 400px; overflow-y: scroll;overflow-x: hidden;">

                        <form role="form" class="form-horizontal" action="ReportController" target="_blank" method="post" id="borrowmontform" onsubmit="return validate()"> 
                            <div class="form-group"> 
                                <label for="subcategorynm"class="control-label col-sm-3">Select Month:</label>
                                <div class="col-sm-3">
                                    <select class="form-control" id='month' name="month" value="" autofocus="true" required="">
                                            <option value="">------ Select Month ------</option> 
                                            <option value='1'>January</option>
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
                                </div>
                                <div class="form-group"> 
                                <label for="subcategorynm"class="control-label col-sm-3">Select Year:</label>
                                <div class="col-sm-3">
                                    <select class="form-control" id="year" name="year" required="">
                                        <option value="">------ Select Year ------</option>
                                        <script>
                                            var myDate = new Date();
                                            var year = myDate.getFullYear();
                                            for (var i = 2016; i < 2031; i++) {
                                                document.write('<option value="' + i + '">' + i + '</option>');
                                            }
                                        </script>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group"> 
                                <div class="col-sm-offset-3 col-sm-5">
                                    <button type="submit" name="submit" value="Add" class="btn btn-default" >Generate</button>
                                    <button type="button" name="cancel" onclick="resetform()" value="Reset" class="btn btn-default col-sm-offset-1">Reset</button>
                                    <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                </div>
                            </div>
                            <input type="hidden" name="act" value="1" />
                            <input type="hidden" name="submodule" value="monthlyborrow" />
                        </form>
                    </div>
                </div>
                </body>
                </html>