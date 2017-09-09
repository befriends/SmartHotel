
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONArray"%>
<%@page import="DaoImpl.MenuItemDaoImpl"%>
<%@page import="Dao.MenuItemDao"%>
<%@page import="Controller.MenuItemController"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String message = "";
%>
<%
    if (session.getAttribute("UserName") == null) {
        response.sendRedirect("login.jsp");
    }
    if (session.getAttribute("roleid") != null && ((Integer) session.getAttribute("roleid")) == 2) {
        response.sendRedirect("home.jsp");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Menu Items</title>
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="css/normalize.css">
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <!--style for menu-->
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">

        <script type="text/javascript" src="js/jquery.js"></script> 
        <!--script for menu-->
        <script type="text/javascript" src="js/responsivemultimenu.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/commonFunctions.js"></script>
        <script type="text/javascript" lang="javascript">
            function submitUpdateForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "UpdateMenuItem.jsp?act=2";
                document.getElementById(f).submit();
            }

            function submitDeleteForm(cnt) {
                var f = "form" + cnt;
                document.getElementById(f).action = "MenuItemController?act=3";
                document.getElementById(f).submit();
            }

            function loadSubCategory() {
                var parentComboId = 'categorynm';
                var childComboId = 'subcategorynm';
                var url = 'MenuItemController';
                var submodule = 'subcategory';
                loadComboValues(parentComboId, childComboId, url, submodule);
            }
            function validate() {
                if (document.getElementById("categorynm").options[document.getElementById("categorynm").selectedIndex].value == "") {
                    alert("plz select Category");
                    return false;
                } else if (document.getElementById("subcategorynm").options[document.getElementById("subcategorynm").selectedIndex].value == "") {
                    alert("plz select Sub-Category");
                    return false;
                } else if (document.getElementById("itemName").value == "") {
                    alert("Item name may not be blank");
                    return false;
                } else if (document.getElementById("rate").value == "") {
                    alert("price may not be blank.");
                    return false;
                }
            }
            function numbersonly(e) {
                var unicode = e.charCode ? e.charCode : e.keyCode
                if (unicode != 8) { //if the key isn't the backspace key (which we should allow)
                    if ((unicode < 48 || unicode > 57) && (unicode < 9 || unicode > 10)) //if not a number
                        return false //disable key press
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
                    <%  //                                                           Only for  Disply message after execution
                        if (request.getParameter("result") != "" && request.getParameter("result") != null) {
                            JSONObject jobj = new JSONObject(request.getParameter("result"));
                            message = jobj.getString("message");
                            if (jobj.getBoolean("success")) {
                    %> <div class="alert alert-success fade in" style="text-align: center;">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                        <strong><%=message%></strong>
                    </div><%
                    } else {
                    %><div class="alert alert-danger fade in" style="text-align: center;">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                        <strong><%=message%></strong>
                    </div><%
                            }
                        }   /// End

                        HashMap<String, String> params = new HashMap<String, String>();
                        params.put("submodule", "menuitem"); // Database Table Name
                        params.put("columnname", "menuitemid"); // Database Column Name
                        CommonDao commonDaoObj = new CommonDaoImpl();
                        String id = commonDaoObj.generateNextID(params);

                        MenuItemDao menuItemDaoObj = new MenuItemDaoImpl();

                        JSONObject categoryJsonList = menuItemDaoObj.getCategoryList();
    //                            JSONObject subCategoryJsonList = menuItemDaoObj.getSubCategoryList();
                        //                    JSONArray json = menuItemDaoObj.getMenuItemDetailsList();
                        //                    int catlength = json.length();
                        //                    while(catlength > 0){
                        //                        JSONObject jobjCategory = json.getJSONObject(catlength);
                        //                        
                        //                        catlength--;
                        //                    }
                        //                    JSONArray subCatJson = detailedArray.getJSONArray("subcategory");

        //                    JSONArray menuItemJson = subCatJson.getJSONArray("menuitem");

                    %>
                    <%!
                        JSONObject jobj = null;
                    %>

                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Menu Item</span>
                    <div style="height: 500px; overflow-y: scroll;overflow-x: hidden;">
                        <fieldset  style="border:1px solid silver; padding:5px;">
                            <form role="form" id="orderform" class="form-horizontal" action="MenuItemController" method="post" onsubmit="return validate()">
                                <div class="form-group">
                                    <label for="menuitemid" class="control-label col-sm-2">Item ID:</label> 
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="menuitemid" name="customid" value="<%=id%>" readonly="true" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="categorynm"class="control-label col-sm-2">Category :</label>
                                    <div class="col-sm-8">
                                        <select class="form-control" id="categorynm" placeholder="Select Category Name" name="categoryid" onchange="loadSubCategory()" autofocus="true" required="">
                                            <option value="">--Please Select Category--</option>
                                            <%                    JSONArray jarr = categoryJsonList.getJSONArray("data");
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
                                <div class="form-group">
                                    <label for="subcategorynm"class="control-label col-sm-2">Sub-Category :</label>
                                    <div class="col-sm-8">
                                        <select class="form-control" id="subcategorynm" placeholder="Select Sub-Category Name" name="subcategoryid" required="">
                                            <option value="">--Please Select Sub Category--</option>
                                            <% //  JSONArray jarr1 = subCategoryJsonList.getJSONArray("data");
                                                //                                                for (int cnt = 0; cnt < jarr1.length(); cnt++) {
                                                //                                                    jobj = jarr1.getJSONObject(cnt);

                                            %>

                                            <%//                                                }
                                            %>
                                        </select> 
                                    </div>
                                </div>
                                <div class="form-group" >
                                    <label for="itemName" class="control-label col-sm-2">Item Name:</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="itemName" placeholder="Enter Menu Item Name" name="itemName" required=""/>
                                    </div>
                                </div>
                                <div class="form-group" >
                                    <label for="rate" class="control-label col-sm-2">Price:</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="rate" placeholder="Enter Price" name="rate" onkeypress="return numbersonly(event)" required=""/>
                                    </div>
                                </div>
                                <div class="form-group"> 
                                    <div class="col-sm-offset-2 col-sm-5">
                                        <button type="submit" name="submit" value="Add" class="btn btn-default">Add Menu Item</button>
                                        <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                        <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                    </div>
                                </div>
                                <input type="hidden" name="act" value="1" />
                                <input type="hidden" name="submodule" value="menuitem" />
                            </form>
                        </fieldset>
                        <%                                            //                    JSONObject jobj = new JSONObject(data);
                            //                    JSONArray jarr = jobj.getJSONArray("data");
                            //                MenuItemDao menuItemDaoObj = new MenuItemDaoImpl();
                            //String itemList = menuItemDaoObj.getMenuItemList();
                            //JSONArray itemarr = new JSONArray(itemList);
                            //                JSONArray jarr = jobj.getJSONArray("data");
                            // int cnt = 0;
                            // while (cnt < itemarr.length()) {
                            //  JSONObject obj = itemarr.getJSONObject(cnt);
                            JSONObject menuitemJSONObject = menuItemDaoObj.getMenuItemList();
                            JSONArray itemarr = new JSONArray();
                            if (menuitemJSONObject != null && menuitemJSONObject.has("success") && menuitemJSONObject.has("data")) {
                                itemarr = menuitemJSONObject.getJSONArray("data");
                            }
                        %>

                        <table class="table table-bordered table-hover" tyle="table-layout:fixed;" id="tbl" >
                            <thead>
                                <tr class="">
                                    <th style="display: none;">ID</th>
                                    <th style="width: 7%;text-align: center;">Sr. No.</th>
                                    <th style="width: 15%;">Category</th>
                                    <th style="width: 15%;">Sub Category</th>
                                    <th style="width: 30%;">Item Name</th>
                                    <th style="width: 10%;">Rate</th>
                                    <th style="width: 23%;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int ind = 0;
                                    for (ind = 0; ind < itemarr.length(); ind++) {
                                        JSONObject menuitemObj = itemarr.getJSONObject(ind);
                                %>
                                <tr class="info"id="editrecordid<%=ind%>" style="display:none;">
                            <form name="editrecords">
                                <td style="display: none;">
                                    <label id="categoryid" style="display: none;"><%=menuitemObj.getLong("categoryid")%></label>
                                    <label id="submodule" style="display: none;">menuitem</label>

                                </td>
                                <td style="text-align: center;"><label><%=ind + 1%></label></td>
                                <td><input type="text" name="categoryname" value="<%=menuitemObj.get("categoryname")%>" readonly /></td>

                                <td style="display: none;">
                                    <label id="subcategoryid" style="display: none;"><%=menuitemObj.getLong("subcategoryid")%></label>
                                    <label id="submodule" style="display: none;">Sub category</label>
                                </td>
                                <td><input type="text" name="subcategoryname" value="<%=menuitemObj.get("subcategoryname")%>" readonly /></td>
                                <td style="display: none;">
                                    <label id="menuitemid" style="display: none;"><%=menuitemObj.getLong("menuitemid")%></label>
                                    <label id="submodule" style="display: none;">Sub category</label>
                                </td>
                                <td><input type="text" name="menuitemname" value="<%=menuitemObj.get("menuitemname")%>"/></td>
                                <td><input type="text" name="rate" style="width:50px;" value="<%=menuitemObj.get("rate")%>"/></td>
                                <td>
                                    <p class="btn btn-info" onClick="updaterecord(<%=ind%>)"><span class="glyphicon glyphicon-save"></span>&nbsp;Save</p>
                                    &nbsp;|&nbsp;
                                    <p class="btn btn-default" onClick="cancel(<%=ind%>)"><span class="glyphicon glyphicon-remove"></span>&nbsp;Cancel</p>
                            </form>
                            </tr>
                            <tr class="success" id="recordid<%=ind%>">
                                <td style="display: none;">

                                    <label id="categoryid" style="display: none;"><%=menuitemObj.getLong("categoryid")%></label>
                                    <label id="submodule" style="display: none;">category</label>
                                </td>
                                <td style="text-align: center;"><label><%=ind + 1%></label></td>
                                <td><label name="categoryname"><%=menuitemObj.get("categoryname")%></label></td>
                                <td style="display: none;">
                                    <label id="subcategoryid" style="display: none;"><%=menuitemObj.getLong("subcategoryid")%></label>
                                    <label id="submodule" style="display: none;">subcategory</label>
                                </td>

                                <td><label name="subcategoryname"><%=menuitemObj.get("subcategoryname")%></label></td>
                                <td style="display: none;">
                                    <label id="menuitemid" style="display: none;"><%=menuitemObj.getLong("menuitemid")%></label>
                                    <label id="submodule" style="display: none;">menuitem</label>
                                </td>

                                <td><label name="menuitemname"><%=menuitemObj.get("menuitemname")%></label></td>
                                <td><label name="rate"><%=menuitemObj.get("rate")%></label></td>
                                <td>
                                    <p class="btn btn-success" onClick="showeditrecord(<%=ind%>)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;Edit</p>
                                    &nbsp;|&nbsp;
                                    <p class="btn btn-danger" onClick="deleterecord(<%=ind%>)"><span class="glyphicon glyphicon-trash"></span>&nbsp;Delete</p>
                            </tr>

                            </form>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript" src="js/GridViewController.js"></script> 
    </body>
</html>



