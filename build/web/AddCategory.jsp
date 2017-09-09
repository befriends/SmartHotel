
<%@page import="java.util.HashMap"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="DaoImpl.MenuItemDaoImpl"%>
<%@page import="Dao.MenuItemDao"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8" session="true"%>
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
        <title>Add Category</title>
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
            function submitUpdateForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "UpdateCategory.jsp?act=2";
                document.getElementById(f).submit();
            }

            function submitDeleteForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "MenuItemController?act=3";
                document.getElementById(f).submit();
            }
            function validate() {
                if (document.getElementById("categorynm").value == "") {
                    alert("category name may not be blank");
                    return false;
                }
            }

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

                        HashMap<String, String> params = new HashMap<String, String>();
                        params.put("submodule", "category"); // Database Table Name
                        params.put("columnname", "categoryid"); // Database Column Name
                        CommonDao commonDaoObj = new CommonDaoImpl();
                        String id = commonDaoObj.generateNextID(params);

                        MenuItemDao menuItemDaoObj = new MenuItemDaoImpl();

                    %>
                    <%!
                        JSONObject joFbj = null;
                    %>


                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Category</span>
                    <div style="max-height: 400px; overflow-y: scroll;overflow-x: hidden;">
                        <fieldset style="border:1px solid silver; padding:5px;">
                            <form role="form" id="orderform" class="form-horizontal" autocomplete="off" action="MenuItemController" method="post" onsubmit="return validate()">
                                <div class="form-group">
                                    <label for="categoryid" class="control-label col-sm-2">Category ID: </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="categoryid" name="customid" value="<%=id%>" readonly="true" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="categorynm" class="control-label col-sm-2">Category Name: </label>
                                    <div class="col-sm-8">
                                        <input type="text" autofocus="true" class="form-control" id="categorynm" placeholder="Enter Category Name" name="categoryname" required=""/>
                                    </div>
                                </div>

                                <div class="form-group"> 
                                    <div class="col-sm-offset-2 col-sm-5">
                                        <button type="submit" name="submit" value="Add" class="btn btn-default">Add Category</button>
                                        <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                        <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                    </div>
                                </div>
                                <input type="hidden" name="act" value="1" />
                                <input type="hidden" name="submodule" value="category" />
                            </form>
                        </fieldset>
                        <%
                            JSONObject categoryJSONObject = menuItemDaoObj.getCategoryList();
                            JSONArray itemarr = new JSONArray();
                            if (categoryJSONObject != null && categoryJSONObject.has("success") && categoryJSONObject.has("data")) {
                                itemarr = categoryJSONObject.getJSONArray("data");
                            }%>
                        <table class="table table-condensed table-bordered table-hover" style="table-layout:fixed;" id="tbl">
                            <thead>
                                <tr class="">
                                    <th style="display: none;">ID</th>
                                    <th style="width: 10%;text-align: center;">Sr. No.</th>
                                    <th style="width: 60%;">Category</th>
                                    <th style="width: 30%;">Action</th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    int cnt = 0;
                                    for (cnt = 0; cnt < itemarr.length(); cnt++) {
                                        JSONObject categoryObj = itemarr.getJSONObject(cnt);
                                %>
                                <tr class="info" id="editrecordid<%=cnt%>" style="display:none;">
                            <form name="editrecords">
                                <td style="display: none;">
                                    <label id="categoryid" style="display: none;"><%=categoryObj.getLong("categoryid")%></label>
                                    <label id="submodule" style="display: none;">category</label>
                                </td>
                                <td style="text-align: center;"><label><%=cnt + 1%></label></td>
                                <td><input type="text" name="categoryname" value="<%=categoryObj.get("categoryname")%>"/></td>
                                <td>
                                    <p class="btn btn-info" onClick="updaterecord(<%=cnt%>)"><span class="glyphicon glyphicon-save"></span>&nbsp;Save</p>
                                    &nbsp;|&nbsp;
                                    <p class="btn btn-default" onClick="cancel(<%=cnt%>)"><span class="glyphicon glyphicon-remove"></span>&nbsp;Cancel</p>
                            </form>
                            </tr>
                            <tr class="success" id="recordid<%=cnt%>">
                                <td style="display: none;">
                                    <label id="categoryid" style="display: none;"><%=categoryObj.getLong("categoryid")%></label>
                                    <label id="submodule" style="display: none;">category</label>
                                </td>
                                <td style="text-align: center;"><label><%=cnt + 1%></label></td>
                                <td><label name="categoryname"><%=categoryObj.get("categoryname")%></label></td>
                                <td>
                                    <p class="btn btn-success" onClick="showeditrecord(<%=cnt%>)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;Edit</p>
                                    &nbsp;|&nbsp;
                                    <p class="btn btn-danger" onClick="deleterecord(<%=cnt%>)"><span class="glyphicon glyphicon-trash"></span>&nbsp;Delete</p>
                            </tr>                                    
                            <%
                                }
                            %>
                            </tbody>
                        </table>

                    </div>
                </div>
            </div>

            <!--  Footer  -->
            <div class="container-fluid">
            </div>

        </div>
        <script type="text/javascript" src="js/GridViewController.js"></script>                            
    </body>
</html>
