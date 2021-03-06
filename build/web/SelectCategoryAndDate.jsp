<%-- 
    Document   : SelectCategoryAnd Date
    Created on : 24 Jun, 2017, 11:21:22 AM
    Author     : sai
--%>


<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="Dao.MenuItemDao"%>
<%@page import="DaoImpl.MenuItemDaoImpl"%>
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
        <title>Select Category and Date</title>
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
         <script src="js/commonFunctions.js"></script>
        <!--<script type="text/javascript" src="js/calendar.js"></script>-->
        <link href = "css/jquery-ui.css" rel = "stylesheet">
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
            function loadSubCategory() {
                var parentComboId = 'categorynm';
                var childComboId = 'subcategorynm';
                var url = 'MenuItemController';
                var submodule = 'subcategory';
                loadComboValues(parentComboId, childComboId, url, submodule);
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
    </head>
    <body style="background-color: #555;">
        <jsp:include page="header.jsp"/>
        <div class="container">
            <!--  Body  -->
            <div class="container-fluid">
                <div style="margin-left: auto; margin-right: auto; width: 100%; background-color: antiquewhite;">
                    <%
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

                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Category and Date Wise Report</span>
                    <div style="max-height: 400px; overflow-y: scroll;overflow-x: hidden;">

                        <form role="form" class="form-horizontal" id="dateform" target="_blank" action="ReportController" method="post"  onkeypress="myFunction()" > 
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
                                        <select class="form-control" id="subcategorynm" placeholder="Select Sub-Category Name" name="subcategoryid">
                                            <option value="">--Please Select Sub Category--</option>
                                            <% //  JSONArray jarr1 = subCategoryJsonList.getJSONArray("data");
                                                //                                                for (int cnt = 0; cnt < jarr1.length(); cnt++) {
                                                //                                                    jobj = jarr1.getJSONObject(cnt);

                                            %>

                                            <%//                                                }
                                            %>
                                        </select> 
                                    </div></div>
                            <div class="form-group">
                                <label for="fromdate" class="control-label col-sm-2">Select Form Date :</label>
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
                            <input type="hidden" name="submodule" value="categorytwodatewise" />
                            <input type="hidden" name="hourdiff" value="2" />
                        </form>
                    </div>
                </div>
            </div>
            <!--  Footer  -->
            <div class="container-fluid">
            </div>            
        </div>
    </body>
</html>

