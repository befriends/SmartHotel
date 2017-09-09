
<%@page import="java.util.HashMap"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="DaoImpl.MenuItemDaoImpl"%>
<%@page import="Dao.MenuItemDao"%>
<%@page import="Controller.MenuItemController"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8" session="true"%>
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
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="css/normalize.css">
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <!--style for menu-->
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">

        <script type="text/javascript" src="js/jquery.js"></script> 
        <!--script for menu-->
        <script type="text/javascript" src="js/responsivemultimenu.js"></script>
        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <title>JSP Page</title>
        <script type="text/javascript" lang="javascript">
            function submitUpdateForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "UpdateSubCategory.jsp?act=2";
                document.getElementById(f).submit();
            }

            function submitDeleteForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "MenuItemController?act=3";
                document.getElementById(f).submit();
            }
            function validate() {

                if (document.getElementById("categorynm").options[document.getElementById("categorynm").selectedIndex].value == 0) {
                    alert("plz select Category Name");
                    return false;


                } else if (document.getElementById("subcategorynm").value == "") {
                    alert("Subctegory name may not be blank");
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
//                        %><div class="alert alert-success fade in" style="text-align: center;">
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
                        params.put("submodule", "subcategory"); // Database Table Name
                        params.put("columnname", "subcategoryid"); // Database Column Name
                        CommonDao commonDaoObj = new CommonDaoImpl();
                        String id = commonDaoObj.generateNextID(params);

                        MenuItemDao menuItemDaoObj = new MenuItemDaoImpl();

                        JSONObject jsonList = menuItemDaoObj.getCategoryList();

                    %>
                    <%!
                        JSONObject jobj = null;
                    %>
                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Sub-Category</span>
                    <div style="height: 400px;overflow-y: scroll;overflow-x: hidden;">
                        <fieldset style="border:1px solid silver; padding:5px;">
                            <form role="form" id="orderform" class="form-horizontal" action="MenuItemController" method="post" onsubmit="return validate()">
                                <div class="form-group">
                                    <label for="subcategoryid" class="control-label col-sm-2">Sub-Category ID:</label> 
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="subcategoryid" name="customid" value="<%=id%>" readonly="true" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="categorynm"class="control-label col-sm-2">Category Name:</label>
                                    <div class="col-sm-8">
                                        <select class="form-control" id="categorynm" placeholder="Select Category Name" name="categoryid" autofocus="true" required="">
                                            <option value="">--Please Select Category--</option>
                                            <%
                                                JSONArray jarr = jsonList.getJSONArray("data");

                                                for (int cnt = 0; cnt < jarr.length(); cnt++) {
                                                    jobj = jarr.getJSONObject(cnt);

                                            %>
                                            <option value="<%=jobj.getLong("categoryid")%>"><%=jobj.getString("categoryname")%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div>
                                    <div class="form-group" >
                                        <label for="subcategoryname" class="control-label col-sm-2">Sub-Category Name:</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="subcategorynm" placeholder="Enter Sub-Category Name" name="subcategoryname" required=""/>
                                        </div>
                                    </div>
                                    <div class="form-group"> 
                                        <div class="col-sm-offset-2 col-sm-5">
                                            <button type="submit" name="submit" value="Add" class="btn btn-default">Add Sub-Category</button>
                                            <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                            <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                        </div>
                                    </div>
                                    <input type="hidden" name="act" value="1" />
                                    <input type="hidden" name="submodule" value="subcategory" />
                            </form>
                        </fieldset>
                        <%
                            JSONObject subCategoryList = menuItemDaoObj.getSubCategoryList();
                            JSONArray itemarr = subCategoryList.getJSONArray("data");
                            if (subCategoryList != null && subCategoryList.has("success") && subCategoryList.has("data")) {
                                itemarr = subCategoryList.getJSONArray("data");
                            }
                        %>

                        <table class="table table-condensed table-bordered table-hover"style="table-layout:fixed;" id="tbl" >
                            <thead>
                                <tr class="">
                                    <th style="display: none;">ID</th>
                                    <th style="width: 10%;text-align: center;">Sr. No.</th>
                                    <th style="width: 30%;">Category</th>
                                    <th style="width: 30%;">Sub Category</th>
                                    <th style="width: 30%;">Action</th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    //                    JSONObject jobj = new JSONObject(data);
                                    //                    JSONArray jarr = jobj.getJSONArray("data");
                                    //                MenuItemDao menuItemDaoObj = new MenuItemDaoImpl();
                                    // JSONObject subCategoryList = menuItemDaoObj.getSubCategoryList();
                                    //JSONArray itemarr = subCategoryList.getJSONArray("data");
                                    //                JSONArray jarr = jobj.getJSONArray("data");
                                    int cnt = 0;
                                    for (cnt = 0; cnt < itemarr.length(); cnt++) {
                                        JSONObject subcategoryObj = itemarr.getJSONObject(cnt);
                                %>
                                <tr class="info"id="editrecordid<%=cnt%>" style="display:none;">
                            <form name="editrecords">
                                <td style="display: none;">
                                    <label id="categoryid" style="display: none;"><%=subcategoryObj.getLong("categoryid")%></label>
                                    <label id="submodule" style="display: none;">subcategory</label>
                                </td>
                                <td style="text-align: center;"><label><%=cnt + 1%></label></td>
                                <td><input type="text" name="categoryname" value="<%=subcategoryObj.get("categoryname")%>" readonly /></td>

                                <td style="display: none;">
                                    <label id="subcategoryid" style="display: none;"><%=subcategoryObj.getLong("subcategoryid")%></label>
                                    <label id="submodule" style="display: none;">Sub category</label>
                                </td>
                                <td><input type="text" name="subcategoryname" value="<%=subcategoryObj.get("subcategoryname")%>"/></td>

                                <td>
                                    <p class="btn btn-info" onClick="updaterecord(<%=cnt%>)"><span class="glyphicon glyphicon-save"></span>&nbsp;Save</p>
                                    &nbsp;|&nbsp;
                                    <p class="btn btn-default" onClick="cancel(<%=cnt%>)"><span class="glyphicon glyphicon-remove"></span>&nbsp;Cancel</p>
                            </form>
                            </tr>
                            <tr class="success" id="recordid<%=cnt%>">
                                <td style="display: none;">
                                    <label id="categoryid" style="display: none;"><%=subcategoryObj.getLong("categoryid")%></label>
                                    <label id="submodule" style="display: none;">category</label>
                                </td>
                                <td style="text-align: center;"><label><%=cnt + 1%></label></td>
                                <td><label name="categoryname"><%=subcategoryObj.get("categoryname")%></label></td>
                                <td style="display: none;">
                                    <label id="subcategoryid" style="display: none;"><%=subcategoryObj.getLong("subcategoryid")%></label>
                                    <label id="submodule" style="display: none;">subcategory</label>
                                </td>

                                <td><label name="subcategoryname"><%=subcategoryObj.get("subcategoryname")%></label></td>
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
            <div class="container-fluid">
            </div>

        </div>
        <script type="text/javascript" src="js/GridViewController.js"></script> 
    </body>
</html>
