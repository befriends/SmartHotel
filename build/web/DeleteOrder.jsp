

<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String message = "";
%>
<%
    
    if(session.getAttribute("UserName") == null){
        response.sendRedirect("login.jsp");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Delete Order</title>
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
        <script type="text/javascript" lang="javascript">
            function validate() {
                if (document.getElementById("ordrenm").value == "") {
                    alert("Order Number may not be blank");
                    return false;
                }
            }

            function resetform() {
                document.getElementById("orderform").reset();
            }

            function numbersonly(e) {
                var unicode = e.charCode ? e.charCode : e.keyCode
                if (unicode != 8) { //if the key isn't the backspace key (which we should allow)
                    if ((unicode < 48 || unicode > 57) && (unicode < 9 || unicode > 10) && (unicode < 37 || unicode > 39)) //if not a number
                        return false //disable key press
                }
            }

        </script>
    </head>
    <body>
    <body style="background-color: #555;">
        <jsp:include page="header.jsp"/>
        <!--  Body  -->
        <div class="container-fluid">
            <div style="margin-left: auto; margin-right: auto; width: 90%; background-color: antiquewhite;">
                <%
                    if (request.getParameter("result") != "" && request.getParameter("result") != null) {
                        JSONObject jobj = new JSONObject(request.getParameter("result"));
                        message = jobj.getString("message");
                        if (jobj.getBoolean("success")) {
                %><span style="width: 100%;margin-left: auto;margin-right: auto;"><h3 style="color: crimson;"><%=message%></h3></span><br /><%
                        } else {
                    %><span style="width: 100%;margin-left: auto;margin-right: auto;"><h3 style="color: red;"><%=message%></h3></span><br /><%
                                    }
                                }
                    %>
                <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Delete Order Number</span><br>
                <div style="max-height: 400px; overflow-y: scroll;overflow-x: hidden;">

                    <form role="form" id="orderform" class="form-horizontal" action="OrderController" method="post" onsubmit="return validate()">

                        <div style="margin-left: auto; margin-right: auto; width: 100%; background-color: antiquewhite;">
                            <div class="form-group">
                                <label for="ordernm" class="control-label col-sm-2">Order Number: </label>
                                <div class="col-sm-8">
                                    <input type="text" autofocus="true" class="form-control" id="ordrenm" placeholder="Enter Order Number" name="ordername" onkeypress="return numbersonly(event)" required=""/>
                                </div>
                            </div>

                            <div class="form-group"> 
                                <div class="col-sm-offset-2 col-sm-5">
                                    <button type="submit" name="submit" value="delete" class="btn btn-default">Delete Order</button>
                                    <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                    <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                </div>
                            </div>
                            <input type="hidden" name="act" value="3" />
                            <input type="hidden" name="submodule" value="deleteorder" />


                    </form>
                </div>
            </div>
        </div>
    </div>


</body>
</html>
