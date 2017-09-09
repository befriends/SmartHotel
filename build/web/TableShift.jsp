
<%@page import="DaoImpl.TableDaoImpl"%>
<%@page import="Dao.TableDao"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="DaoImpl.OrderDaoImpl"%>
<%@page import="Dao.OrderDao"%>
<%@page import="Dao.CommonDao"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String message = "";
%>
<%
    if (session.getAttribute("UserName") == null) {
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Table Shift</title>
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
        <script type="text/javascript" lang="javascript">  
            function resetform() {
                document.getElementById("tableshiftform").reset();
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
                                    %><div class="alert alert-success fade in" style="text-align: center;">
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

                    
                        TableDao tableDAOObj = new TableDaoImpl();

                        JSONObject jsonList = tableDAOObj.getAllActiveTableList();
                        JSONObject jsonListFree = tableDAOObj.getFreeTable();
                    %>
                    <%!
                        JSONObject jobj = null;
                    %>


                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Table Shift</span>

                    <div style="max-height: 400px; overflow-y: scroll;overflow-x: hidden;">
                        <fieldset style="border:1px solid silver; padding:5px;">
                            <form role="form" id="tableshiftform" class="form-horizontal" action="OrderController" method="post">
                                <div class="form-group">
                                    <label for="tablenm"class="control-label col-sm-3"> Booked Table:</label>
                                    <div class="col-sm-8">
                                        <select class="form-control" id="tableid" placeholder=""  name="bookedtableid" autofocus="" required="">
                                            <option value=""> Select Table</option>
                                            <%
                                                JSONArray jarr = jsonList.getJSONArray("data");

                                                for (int cnt = 0; cnt < jarr.length(); cnt++) {
                                                    jobj = jarr.getJSONObject(cnt);

                                            %>
                                            <option value="<%=jobj.getString("tableid")%>"><%=jobj.getString("tablename")%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                        <div class="form-group">
                                    <label for="tablenm"class="control-label col-sm-3"> Shift Table:</label>
                                    <div class="col-sm-8">
                                        <select class="form-control" id="tableno" placeholder=""  name="shifttableid" autofocus="" required="">
                                            <option value=""> Select Table</option>
                                            <%
                                                JSONArray jarr1 = jsonListFree.getJSONArray("data");

                                                for (int cnt = 0; cnt < jarr1.length(); cnt++) {
                                                    jobj = jarr1.getJSONObject(cnt);

                                            %>
                                            <option value="<%=jobj.getString("tableid")%>"><%=jobj.getString("tablename")%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>


                                <div class="form-group"> 
                                    <div class="col-sm-offset-3 col-sm-5">
                                        <button type="submit" name="submit" value="Add" class="btn btn-default">Add</button>
                                        <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                        <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                    </div>
                                </div>
                                <input type="hidden" name="act" value="2" />
                                <input type="hidden" name="submodule" value="shifttable" />


                            </form>
                        </fieldset>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
