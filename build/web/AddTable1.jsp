
<%@page import="java.util.HashMap"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="DaoImpl.MenuItemDaoImpl"%>
<%@page import="Dao.MenuItemDao"%>
<%@page import="org.json.JSONArray"%>
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
        <title>Add Category</title>
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <script src="js/jquery.js"></script>
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

        </script>
    </head>
    <body>
        <div class="main_container" style="height: 600px;">
            <!--Menu-->

            <div>
                <hr>
                <nav id="primary_nav_wrap" style="width: 100%;">
                    <ul>
                        <li class="current-menu-item"><a href="#">Home</a></li>

                        <li><a href="#">Product</a>
                            <ul>
                                <li ><a href="AddCategory.jsp">Category</a></li>                          
                                <li ><a href="AddSubCategory.jsp">Sub-Category</a></li>
                                <li ><a href="AddMenuItem.jsp">Menu Item</a></li>
                            </ul>
                        </li>
                        <li><a href="#">Sales</a>
                            <ul>
                                <li class="dir"><a href="#">Sales List</a></li>
                                <li class="dir"><a href="#">Sales Return</a></li>
                                <li class="dir"><a href="#">Day End</a></li>

                            </ul>
                        </li>
                        <li><a href="#">Payment</a></li>
                        <li><a href="#">Reports</a>
                            <ul>
                                <li><a href="#">Order Report</a></li>
                                <li><a href="#">Sales Report</a></li>
                                <li><a href="#">Payment Report</a></li>
                            </ul>
                        </li>
                        <li><a href="#">Profile </a>
                            <ul>
                                <li><a href="AddUser.jsp">UserProfile</a></li>
                                <li><a href="#">Table</a></li>
                                <li><a href="login.jsp">Logout</a></li>
                            </ul>
                        </li>

                        <li><a href="#">Contact Us</a></li>
                    </ul>
                </nav>
                <hr>
            </div>

            <div class="container">
                <!--  Header  -->
                <div class="container-fluid">
                    <img src="images/header.jpg" class="img-rounded" width="100%" height="100px">
                </div>

                <!--  Body  -->
                <div class="container-fluid">

                    <div style="margin-left: auto; margin-right: auto; width: 80%; background-color: antiquewhite;">
                        <%
                            if (request.getParameter("result") != "" && request.getParameter("result") != null) {
                                JSONObject jobj = new JSONObject(request.getParameter("result"));
                                message = jobj.getString("message");
                                if (jobj.getBoolean("success")) {
                        %><div class="alert alert-success fade in">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                            <strong>Success!</strong> Indicates a successful or positive action.
                        </div><%
                        } else {
                        %><div class="alert alert-danger fade in">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                            <strong>Success!</strong> Indicates a successful or positive action.
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
                        <div>
                            <fieldset style="border:1px solid silver; padding:5px;">
                                <form role="form" class="form-horizontal" action="MenuItemController" method="post">
                                    <div class="form-group">
                                        <label for="categoryid" class="control-label col-sm-2">Category ID: </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="categoryid" name="customid" value="<%=id%>" readonly="true" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="categorynm" class="control-label col-sm-2">Category Name: </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="categorynm" placeholder="Enter Category Name" name="categoryname" />
                                        </div>
                                    </div>

                                    <div class="form-group"> 
                                        <div class="col-sm-offset-2 col-sm-5">
                                            <button type="submit" name="submit" value="Add" class="btn btn-default">Add Category</button>
                                            <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1">Cancel</button>
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
                <tr class="danger">
                <th style="display: none;">ID</th>
                <th>Sr. No.</th>
                <th>Category</th>
                <th>Action</th>
                </tr>
                </thead>
                
		<tbody>
                <%
                int cnt = 0;
                for(cnt=0; cnt < itemarr.length(); cnt++){
                    JSONObject categoryObj = itemarr.getJSONObject(cnt);
                %>
		<tr class="info" id="editrecordid<%=cnt %>" style="display:none;">
		<form name="editrecords">
		<td style="display: none;">
                    <label id="categoryid" style="display: none;"><%=categoryObj.getLong("categoryid")%></label>
                    <label id="submodule" style="display: none;">category</label>
                </td>
		<td><label><%=cnt+1 %></label></td>
		<td><input type="text" name="categoryname" value="<%=categoryObj.get("categoryname")%>"/></td>
		<td>
                    <p class="btn btn-info" onClick="updaterecord(<%=cnt %>)"><span class="glyphicon glyphicon-save"></span>&nbsp;Save</p>
                    &nbsp;|&nbsp;
                    <p class="btn btn-default" onClick="cancel(<%=cnt %>)"><span class="glyphicon glyphicon-remove"></span>&nbsp;Cancel</p>
		</form>
		</tr>
		<tr class="success" id="recordid<%=cnt %>">
                <td style="display: none;">
                    <label id="categoryid" style="display: none;"><%=categoryObj.getLong("categoryid")%></label>
                    <label id="submodule" style="display: none;">category</label>
                </td>
		<td><label><%=cnt+1 %></label></td>
		<td><label name="categoryname"><%=categoryObj.get("categoryname")%></label></td>
                <td>
                    <p class="btn btn-success" onClick="showeditrecord(<%=cnt %>)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;Edit</p>
                    &nbsp;|&nbsp;
                    <p class="btn btn-danger" onClick="deleterecord(<%=cnt %>)"><span class="glyphicon glyphicon-trash"></span>&nbsp;Delete</p>
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
