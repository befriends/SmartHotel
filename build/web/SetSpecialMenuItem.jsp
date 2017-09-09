<%@page import="DaoImpl.OrderDaoImpl"%>
<%@page import="Dao.OrderDao"%>
<%@page import="org.json.JSONArray"%>
<%@page import="DaoImpl.MenuItemDaoImpl"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.MenuItemDao"%>
<%@page import="Dao.CommonDao"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8" session="true"%>
<%!
    String message = "";
    String userID = "";
%>
<%
    if (session.getAttribute("UserName") == null) {
        response.sendRedirect("login.jsp");
    }
    if (session.getAttribute("UserID") != null) {
        userID = session.getAttribute("UserID").toString();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Special Menu Item</title>
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <!--style for menu-->
         <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
         <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">

        <!--script for menu-->
	<script type="text/javascript" src="js/responsivemultimenu.js"></script>

        <script type="text/javascript" src="js/jquery.js"></script> 
        <!--script for menu-->
        <script type="text/javascript" src="js/responsivemultimenu.js"></script>

        <script src="js/bootstrap.min.js"></script>
        <script src="js/commonFunctions.js"></script>
        <link rel="stylesheet" href="css/jquery-ui.css">
        <script src="js/jquery-ui.js"></script>
        <script type="text/javascript" lang="javascript">
            $(document).ready(function() {
                $(document).on('keypress', 'input,select', function(e) {
                    if (e.which === 13) {
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
        <style type="text/css">
            .ui-autocomplete {
                min-height: 0px;
                max-height: 150px;
                overflow-y: scroll;
                overflow-x: hidden;
            }
        </style>
    </head>
    <body style="background-color: #555;">
        <jsp:include page="header.jsp"/>
        <div class="container">
            <!--  Header  -->
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
                    %>
                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Set/Unset Special Menu Item</span>
                    <div>
                        <fieldset style="border:1px solid silver; padding:5px;">
                            <form id="orderform" role="form" class="form-horizontal" name="orderfrm" action="MenuItemController" method="post">
                                <div class="form-group">
                                    <label for="menuitem" class="control-label col-sm-2">Menu Item : </label>
                                    <div class="col-sm-8">
                                        <input id="menuitem" type="text" class="form-control" name="menuitem" onblur="selectmenuitem()" placeholder="Enter Menu Item" required="">
                                        <input type="hidden" class="form-control" id="menuitemid" name="menuitemid" readonly="true" required="true"/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="isspecial" class="control-label col-sm-2">Is Special : </label>
                                    <div class="col-sm-8">
                                        <input type="checkbox" class="form-control" id="isspecial" name="isspecial" />
                                    </div>
                                </div>

                                <div class="form-group"> 
                                    <div class="col-sm-offset-2 col-sm-5">
                                        <button type="submit" name="submit" onclick="" value="Save Changes" class="btn btn-default" >Save Changes</button>
                                        <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                    </div>
                                </div>
                                <input type="hidden" name="act" value="1" />
                                <input type="hidden" name="submodule" value="specialmenu" />
                            </form>
                        </fieldset>

                        <table class="table table-condensed table-bordered table-hover" id="ordertablelist" style="table-layout:fixed;" id="tbl">
                            <thead>
                                <tr class="">
                                    <th class="text-center" style="width: 7%;">S. No.</th>
                                    <th style="width: 93%;">Menu Item</th>
                                    <!--<th style="width: 15%;">Is Special</th>-->
                                </tr>
                            </thead>

                            <tbody style="">
                            <%
                                HashMap<String, String> params = new HashMap<String, String>();
                                MenuItemDao menuItemDaoObj = new MenuItemDaoImpl();
                                String menuItemJson = menuItemDaoObj.getSpecialMenuItemList();
                                JSONObject responseJobj = new JSONObject(menuItemJson);
                                if(responseJobj.optBoolean("success", false)){
                                    JSONArray jarr = responseJobj.optJSONArray("data");
                                    for(int ind = 0; ind < jarr.length(); ind++){
                                        JSONObject jobj = jarr.getJSONObject(ind);
                            %>
                            <tr>
                                <td class="text-center"><%=(ind + 1) %></td>
                                <td><%=jobj.optString("menuitemname") %></td>
                                <!--<td></td>-->
                            </tr>
                            <%
                                    }
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
        <script type="text/javascript">
            var menuitemstore = "";
            var tablestore = "";
            $(document).ready(function() {
                //getting menuitems list
                $.ajax({
                    url: "OrderController?act=4&value=", // act=4 => action 4 is for getting record from DB.
                    context: document.body,
                    success: function(responseObj) {
                        menuitemstore = responseObj;
                        var menuitemjarr = JSON.parse(menuitemstore).data;
                        var menuitemlist = [];
                        var customidlist = [];
                        for (var c = 0; c < menuitemjarr.length; c++) {
                            var menuitemjobj = menuitemjarr[c];
                            var tempVal = menuitemjobj.menuitemname;
                            var customVal = menuitemjobj.customid;
                            menuitemlist[c] = tempVal;
                            customidlist[c] = customVal;
                        }

                        $("#menuitem").autocomplete({
                            source: menuitemlist,
                            minLength: 0
                        }).focus(function() {
                            $(this).autocomplete("search");
                        });
                        $("#customid").autocomplete({
                            source: customidlist,
                            minLength: 0
                        }).focus(function() {
                            $(this).autocomplete("search");
                        });
                    }
                });

            });

    function selectmenuitem(rec) {
        var menuitemjarr = JSON.parse(menuitemstore).data;
        var selectedMenuName = $('#menuitem').val();
        for (var cnt = 0; cnt < menuitemjarr.length; cnt++) {
            var menuitemjobj = menuitemjarr[cnt];
            var menuname = menuitemjobj.menuitemname;
            if (menuname === selectedMenuName) {
                $('#menuitemid').val(menuitemjobj.menuitemid);
                $('#isspecial')[0].checked = menuitemjobj.isspecial === 0 ? false : true;

                return false;
            }
        }
    }
        </script>
        <script type="text/javascript" src="js/GridViewController.js"></script>     
    </body>
</html>
