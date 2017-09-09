<%-- 
    Document   : SelectMenuItemAndDate
    Created on : 24 Jun, 2017, 12:58:06 PM
    Author     : sai
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("UserName") == null) {
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>datewise</title>
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
        <!--<script type="text/javascript" src="js/calendar.js"></script>-->
        <link href = "css/jquery-ui.css"rel = "stylesheet">
        <script src = "js/jquery.js"></script>
        <script src = "js/jquery-ui.js"></script>
        <script>
            function myFunction() {
                var d = new Date();
                d.setDate();
                document.getElementById("demo").innerHTML = d;
            }
            function validate() {
                if (document.getElementById("demo").value == "") {
                    alert("Date may not be blank");
                    return false;
                }
            }

            function resetform() {
                document.getElementById("dateform").reset();
            }

            $(document).ready(function()
            {
                $("#demo").datepicker({
                    dateFormat: 'dd/mm/yy'
                });
                $("#todate").datepicker({
                    dateFormat: 'dd/mm/yy'
                });
            })(jQuery);

        </script>
        <style type="text/css">
            .ui-autocomplete {
                min-height: 0px;
                max-height: 150px;
                overflow-y: scroll;
                overflow-x: hidden;
            }
            #menuitemlist{
                display:none;
                position: absolute;
                z-index: 3;
                background-color: white;
                min-width: auto;
                max-height: 200px;
                overflow-y: scroll;
            }

            #menuitemlist > div{
                padding: 5px;
            }

            #menuitemlist > div:hover{
                cursor: pointer;
                background-color: #dcdcdc;
            }
        </style>
    </head>
    <body style="background-color: #555;">
        <jsp:include page="header.jsp"/>
        <div class="container">
            <!--  Body  -->
            <div class="container-fluid">
                <div style="margin-left: auto; margin-right: auto; width: 100%; background-color: antiquewhite;">

                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Menuitem And Date Wise Report</span>
                    <div style="max-height: 400px; overflow-y: scroll;overflow-x: hidden;">

                        <form role="form" class="form-horizontal" id="dateform" target="_blank" action="ReportController" method="post"  onkeypress="myFunction()" > 

                            <div class="form-group">
                                <label for="menuitem" class="control-label col-sm-2" style="margin-top: 10px;margin-bottom: 20px;">Menu Item : </label>
                                <div class="col-sm-8">
                                    <input id="menuitem" type="text" class="form-control" style="width: 250px; margin-top: 10px;"  name="menuitem" onblur="selectmenuitem()" onkeyup="searchmenu()" placeholder="Enter Menu Item"/>
                                    <input type="hidden" class="form-control" id="menuitemid" name="menuitemid" readonly="true" required="true"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="from" class="control-label col-sm-2">Select From Date :</label>
                                <div class="col-sm-8">
                                    <input class="date-picker" type="text"  name="datepicker1" value="" id="demo" placeholder="--- Select Date ---" required=""/><br><br>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="todate" class="control-label col-sm-2">Select To Date :</label>
                                <div class="col-sm-8">
                                    <input class="date-picker" type="text"  name="todate" value="" id="todate" placeholder="--- Select Date ---" required=""/><br><br>
                                </div>
                            </div>
                            <div class="form-group"> 
                                <div class="col-sm-offset-2 col-sm-5">
                                    <button type="submit" name="submit" value="Add" class="btn btn-default" >Generate</button>
                                    <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                    <button type="button" name="cancel" onclick="resetform()" value="Reset" class="btn btn-default col-sm-offset-1">Reset</button>
                                </div>
                            </div>
                            <input type="hidden" name="act" value="1" />
                            <input type="hidden" name="submodule" value="twodatewisemenuitemrecord" />
                        </form>
                    </div>
                </div>
            </div>
            <!--  Footer  -->
            <div class="container-fluid">
            </div>            
        </div>  
        <script type="text/javascript" lang="javascript">
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
//                        $("#customid").autocomplete({
//                            source: customidlist,
//                            minLength: 0
//                        }).focus(function() {
//                            $(this).autocomplete("search");
//                        });
                    }
                });
            });

            function selectmenuitem(rec) {
                var menuitemjarr = JSON.parse(menuitemstore).data;
                var selectedMenuName = $('#menuitem').val();
//                var selectedCustomID = $('#customid').val();
                for (var cnt = 0; cnt < menuitemjarr.length; cnt++) {
                    var menuitemjobj = menuitemjarr[cnt];
                    var menuname = menuitemjobj.menuitemname;
//                    var customID = menuitemjobj.customid;
                    if (menuname === selectedMenuName) {
                        $('#menuitemid').val(menuitemjobj.menuitemid);
//                        $('#menuitem').val(menuitemjobj.menuitemname);
//                        $('#rate').val(menuitemjobj.rate);
//                        $('#customid').val(menuitemjobj.customid);
//
//                        var parentComboId = 'menuitemid';
//                        var childComboId = 'messageid';
//                        var url = 'MenuItemController';
//                        var submodule = 'messagetype';
//                        loadComboValues(parentComboId, childComboId, url, submodule);
                        return false;
                    }
                }
                $('#menuitem').val("");
                $('#customid').val("");
            }




            function searchmenu() {
                var menuItemKey = $('#menuitem').val();
                $.ajax({
                    url: "OrderController?act=4&value=" + menuItemKey, // act=4 => action 4 is for getting record from DB.
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
                            source: function(request, response) {
                                var a = request.term.split(" ")[0];
                                var matcher = new RegExp("^" + a + "", "i");
                                response($.grep(menuitemlist, function(item) {
                                    return matcher.test(item);
                                }));
                            },
                        });
                        $("#customid").autocomplete({
                            source: customidlist,
                            minLength: 0
                        }).focus(function() {
                            $(this).autocomplete("search");
                        });
                    }
                });
            }

        </script>
    </body>
</html>
