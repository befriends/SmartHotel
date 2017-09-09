
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
        <title>YearSalesReport</title>
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
                if (document.getElementById("year").options[document.getElementById("year").selectedIndex].value == "") {
                    alert("Select Year");
                    return false;
                }
            }

            function resetform() {
                document.getElementById("dateform").reset();
            }
        </script>

    </head>
    <body style="background-color: #555;">
        <jsp:include page="header.jsp"/>
        <div class="container">
            <!--  Body  -->
            <div class="container-fluid">
                <div style="margin-left: auto; margin-right: auto; width: 100%; background-color: antiquewhite;">

                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Yearly Sales Report</span>
                    <div style="max-height: 400px; overflow-y: scroll;overflow-x: hidden;">

                        <form role="form" class="form-horizontal" action="ReportController" target="_blank" method="post" id="dateform" onsubmit="return validate()"> 
                            <div class="form-group"> 
                                <label for="subcategorynm"class="control-label col-sm-3">Select Year:</label>
                                <div class="col-sm-3">
                                    <select class="form-control" id="year" name="year" autofocus="true" required="">
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
                            <input type="hidden" name="submodule" value="yearlysales" />
                        </form>
                    </div>
                </div>
                </body>
                </html>