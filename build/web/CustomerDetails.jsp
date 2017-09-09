
<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashMap"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="Dao.CommonDao"%>
<%@page import="DaoImpl.UserDaoImpl"%>
<%@page import="Dao.UserDao"%>
<%@page import="Dao.UserDao"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONObject"%>
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
        <title>User</title>
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">
        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript" lang="javascript">

            function submitUpdateForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "UpdateUser.jsp?act=2";
                document.getElementById(f).submit();
            }

            function submitDeleteForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "UserController?act=3";
                document.getElementById(f).submit();
            }

            $(function() {
                $(".datepicker").datepicker();
            });

        </script>

    </head>
    <body>
        <div class="main_container" style="height: 600px;">
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
                            params.put("submodule", "customer"); // Database Table Name
                            params.put("columnname", "customerid"); // Database Column Name
                            CommonDao commonDaoObj = new CommonDaoImpl();
                            String id = commonDaoObj.generateNextID(params);

                            UserDao userDAOObj = new UserDaoImpl();

                        %>
                        <%!
                            JSONObject jobj = null;
                        %>


                        <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Waiter Details</span>

                        <div>
                            <fieldset style="border:1px solid silver; padding:5px;">
                                <form role="form" class="form-horizontal" action="UserController" method="post">

                                    <div class="form-group">
                                        <label for="customerid" class="control-label col-sm-2">Customer ID: </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="customerid" name="customid" value="<%=id%>" readonly="true" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="customername" class="control-label col-sm-2">Customer Name</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="customername" placeholder="Enter Customer full Name" name="customername" />
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="address" class="control-label col-sm-2">Address: </label>
                                        <div class="col-sm-8">
                                            <textarea type="text" class="form-control" id="address" placeholder="Enter address" name="address" ></textarea>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="mobile" class="control-label col-sm-2">Mobile no : </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="mobile" placeholder="Enter Mobile number" name="mobile" />
                                        </div>
                                    </div>
                                    <div class="form-group"> 
                                        <div class="col-sm-offset-2 col-sm-5">
                                            <button type="submit" name="submit" value="Add" class="btn btn-default">Add Customer</button>
                                            <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1">Cancel</button>
                                        </div>
                                    </div>
                                    <input type="hidden" name="act" value="1" />
                                    <input type="hidden" name="submodule" value="customer" />


                                </form>
                            </fieldset>
                            <table class="table table-bordered table-hover">
                                <thead>
                                    <tr class="danger">
                                        <th style="display: none;">ID</th>
                                        <th>Customer Name</th>
                                        <th>Address</th>
                                        <th>Mobile No</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%  String userList = userDAOObj.getCustomerList();
                                        JSONArray userarr = new JSONArray(userList);
                                        int cnt = 0;
                                        while (cnt < userarr.length()) {
                                            JSONObject obj = userarr.getJSONObject(cnt);
                                    %>
                                <form id="form<%=cnt%>" name="form<%=cnt%>" action="" method="POST">
                                    <tr class="success">
                                        <td style="display: none;">
                                            <input type="hidden" name="userid" value="<%=obj.getLong("customerid")%>" readonly />
                                            <input type="hidden" name="submodule" value="customer" readonly />
                                        </td>
                                        <td>
                                            <input type="text" name="customername" hidden="true" value="<%=obj.get("customername")%>" readonly /><%=obj.get("customername")%>
                                        </td>
                                        
                                        <td>
                                            <textarea class="form-control" name="address" hidden="true" value="<%=obj.get("address")%>" readonly ><%=obj.get("address")%></textarea>
                                        </td>
                                        <td>
                                            <input type="text" name="mobile" hidden="true" value="<%=obj.get("mobile")%>" readonly /><%=obj.get("mobile")%>
                                        </td>
                                        <td>
                                            <a href="#" class="btn btn-info btn-sm" onclick="submitUpdateForm(<%=cnt%>);">
                                                <span class="glyphicon glyphicon-pencil"></span> Update
                                            </a> 

                                            <a href="#" class="btn btn-danger btn-sm" onclick="submitDeleteForm(<%=cnt%>);">
                                                <span class="glyphicon glyphicon-remove"></span> Delete
                                            </a>

                                        </td>
                                    </tr>
                                </form>
                                <%
                                        cnt++;
                                    }
                                %>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>
            </body>
    
    </html>