
<%@page import="DaoImpl.PurchaseMaterialDaoImpl"%>
<%@page import="Dao.PurchaseMaterialDao"%>
<%@page import="Dao.PurchaseMaterialDao"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String message = "";
%>
     <script src="js/jquery.min.js"></script>
<!--<script type="text/javascript" src="js/calendar.js"></script>-->
<script type="text/javascript" lang="javascript">

//    function myFunction() {
//        var d = new Date();
//        d.setDate();
//        document.getElementById("demo").innerHTML = d;
//    }
//    function validate() {
//                if (document.getElementById("purchasematerialname").value == "") {
//                    alert("Material name may not be blank");
//                    return false;
//                }else if (document.getElementById("quantity").value == "") {
//                    alert("Quantity name may not be blank");
//                    return false;
//                }
//            }

            function resetform() {
                document.getElementById("orderform").reset();
            }
            
            $(document).ready(function() {
                jQuery.extend(jQuery.expr[':'], {
                    focusable: function(el, index, selector) {
                        return $(el).is('a, button, :input, [tabindex]');
                    }
                });

                $(document).on('keypress', 'input,select', function(e) {
                    if (e.which == 13) {
                        e.preventDefault();
                        // Get all focusable elements on the page
                        var $canfocus = $(':focusable');
                        var index = $canfocus.index(this) + 1;
                        if (index >= $canfocus.length)
                            index = 0;
                        $canfocus.eq(index).focus();
                    }
                });
            });





</script>
<%
    if(session.getAttribute("UserName") == null){
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User</title>
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <!--style for menu-->
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">
        <script type="text/javascript" src="js/jquery.js"></script> 
        <!--script for menu-->
        <script type="text/javascript" src="js/responsivemultimenu.js"></script>
        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>

    </head>
    <body style="background-color: #555;">
    <jsp:include page="header.jsp"/>
            <div class="container">
                <!--  Body  -->
                <div class="container-fluid">

                    <div style="margin-left: auto; margin-right: auto; width: 100%; background-color: antiquewhite;">
                        <%
                            if (request.getParameter("result") != "" && request.getParameter("result") != null) {
                                JSONObject jobj = new JSONObject(request.getParameter("result"));
                                message = jobj.getString("message");
                                if (jobj.getBoolean("success")) {
                        %><div class="alert alert-success fade in"style="text-align: center;">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                            <strong><%=message%></strong>
                        </div><%
                        } else {
                        %><div class="alert alert-danger fade in" style="text-align: center;">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                            <strong><%=message%></strong>
                        </div><%
                                }
                            }

                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("submodule", "materialstock"); // Database Table Name
                            params.put("columnname", "materialid"); // Database Column Name
                            CommonDao commonDaoObj = new CommonDaoImpl();
                            String id = commonDaoObj.generateNextID(params);

                            PurchaseMaterialDao purchasematerialDAOObj = new PurchaseMaterialDaoImpl();

                        %>
                        <%!
                            JSONObject jobj = null;
                        %>


                        <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">New Material Entry</span>

                        <div>
                            <fieldset style="border:1px solid silver; padding:5px;">
                                <form role="form" id="orderform" class="form-horizontal" action="PurchaseMaterialController" method="post">

                                    <div class="form-group">
                                        <label for="purchasematerialid" class="control-label col-sm-2">Purchase Material ID: </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="userid" name="customid" value="<%=id%>" readonly="true" />
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="purchasematerialname" class="control-label col-sm-2">Material Name</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="purchasematerialname" placeholder="Enter Material Name" name="purchasematerialname" autofocus="true" required=""/>
                                        </div>
                                    </div>


                                    <div class="form-group">
                                        <label for="quantity" class="control-label col-sm-2">Quantity : </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="quantity" placeholder="Enter Initial Quantity " name="quantity" required=""/>
                                        </div>
                                    </div>

                                    <div class="form-group"> 
                                        <div class="col-sm-offset-2 col-sm-5">
                                            <button type="submit" name="submit" value="Add" class="btn btn-default">Add Material</button>
                                             <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                        <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                        </div>
                                    </div>
                                    <input type="hidden" name="act" value="1" />
                                    <input type="hidden" name="submodule" value="materialstock" />
                                </form>
                            </fieldset>
                                        <% 
                    JSONObject materialJSONObject = purchasematerialDAOObj.getMaterialList();
                    JSONArray itemarr = new JSONArray();
                    if (materialJSONObject != null && materialJSONObject.has("success") && materialJSONObject.has("data")) {
                        itemarr = materialJSONObject.getJSONArray("data");
                }%>
                            <table class="table table-bordered table-hover">
                                <thead>
                                    <tr class="">
                                        <th style="display: none;">ID</th>

                                        <th>Material Name</th>
                                        <th>Current Available Quantity</th>
                                        
                                    </tr>
                                </thead>
                                <tbody>
                                    
                                    <%
                                        int cnt = 0;
                                        for (cnt = 0; cnt < itemarr.length(); cnt++) {
                                            JSONObject materialObj = itemarr.getJSONObject(cnt);
                                    %>
                                <form id="form<%=cnt%>" name="form<%=cnt%>" action="" method="POST">
                                    <tr class="success">
                                        <td style="display: none;">
                                            <input type="hidden" name="materialid" value="<%=materialObj.getLong("materialid")%>" readonly />
                                            <input type="hidden" name="submodule" value="purchasematerial" readonly />
                                        </td>

                                        <td>
                                            <input type="text" name="materialname" hidden="true" value="<%=materialObj.get("materialname")%>" readonly /><%=materialObj.get("materialname")%>
                                        </td>

                                        <td>
                                            <input type="text" name="quantity" hidden="true" value="<%=materialObj.get("quantity")%>" readonly /><%=materialObj.get("quantity")%>
                                        </td>
                                       
                                    </tr>
                                </form>
                                <%
//                                        cnt++;
                                    }
                                %>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>

                </body>
                </html>
