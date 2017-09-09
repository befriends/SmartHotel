<%-- 
    Document   : StockMasterForm
    Created on : 3 Dec, 2016, 10:33:49 AM
    Author     : sai
--%>


<%@page import="DaoImpl.UserDaoImpl"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="Dao.UserDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8" session="true"%>


<%!
    boolean messageflag = false;
    boolean duplicatemessageflag = false;
    boolean isprinthide = false;
    boolean isborrow = false;
    boolean isGST = false;
    boolean isService = false;
    String userid = "";
%>
<%
    if (session.getAttribute("UserName") == null) {
        response.sendRedirect("login.jsp");
    } else {
        if (session.getAttribute("messagenotificationflag") != null) {
            messageflag = (Boolean) session.getAttribute("messagenotificationflag");
        }
        if (session.getAttribute("isDuplicatePrint") != null) {
            duplicatemessageflag = (Boolean) session.getAttribute("isDuplicatePrint");
        }
        if (session.getAttribute("isborrow") != null) {
            isborrow = (Boolean) session.getAttribute("isborrow");
        }
        if (session.getAttribute("isprinthide") != null) {
            isprinthide = (Boolean) session.getAttribute("isprinthide");
        }
        if (session.getAttribute("isGST") != null) {
            isGST = (Boolean) session.getAttribute("isGST");
        }
        if (session.getAttribute("isService") != null) {
            isService = (Boolean) session.getAttribute("isService");
        }
        if (session.getAttribute("UserID") != null) {
            userid = (String) session.getAttribute("UserID");
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <!--style for menu-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" />
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="css/font-awesome.css" rel="stylesheet" type="text/css" />
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">

        <script type="text/javascript" src="js/jquery.js"></script> 
        <!--<script src="js/jquery-ui.js"></script>-->
        <link rel="stylesheet" href="css/jquery-ui.css">
        <!--script for menu-->
        <!--<script type="text/javascript" src="js/responsivemultimenu.js"></script>-->
        <script src="js/bootstrap.min.js"></script>

        <title>Home Page</title>
    </head>

    <body style="background-color: #555;">
        <jsp:include page="header.jsp"/>
        <div class="container">
            <!--  Body  -->
            <div class="container-fluid">

                <div style="margin-left: auto; margin-right: auto; margin-top: -20px; width: 100%; height: auto; background-color: antiquewhite;">
                    <div style="text-align: center;"><br><h3>Master Settings</h3></div>
                    <fieldset class="ui-widget ui-widget-content center-block" style="width: 90%;">
                        <br><br>
                        <div class="container-fluid">
                            <form method="post" name="form1" action="systempreferences">
                                <div class="form-check">
                                    <label class="form-check-label">
                                        <input type="hidden" id="userid" name="userid" value="<%=userid%>"/>
                                        <input type="checkbox" class="form-check-input" name="messageflag" id="messageflag">
                                        Message Flag
                                    </label>
                                </div>
                                <hr style="padding: 0px;margin: 0px;">
                                <div class="form-check">
                                    <label class="form-check-label">
                                        <input type="checkbox" class="form-check-input" name="duplicateprintflag" id="duplicateprintflag">
                                        Enable Duplicate Print
                                    </label>
                                </div>
                                <div class="form-check" id="printerComponent">
                                    <label class="form-check-label">
                                        <select class="form-control" name="printernm" id="printernm">
                                            <option value="">--Please Select Printer--</option>
                                            <%
                                                UserDao userDaoObj = new UserDaoImpl();
                                                JSONObject jsonList = userDaoObj.getAvailablePrinters();
                                                JSONArray jarr = jsonList.getJSONArray("data");

                                                for (int cnt = 0; cnt < jarr.length(); cnt++) {
                                                    JSONObject jobj = jarr.getJSONObject(cnt);
                                            %>
                                            <option value="<%=jobj.getString("printername")%>"><%=jobj.getString("printername")%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </label>

                                    <div class="form-check">
                                        <label class="form-check-label">

                                            <input type="checkbox" class="form-check-input" name="isborrow" id="isborrow">
                                            is Borrow Flag
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <label class="form-check-label">

                                            <input type="checkbox" class="form-check-input" name="ishide" id="ishide">
                                            is Print Hide Flag
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <label class="form-check-label">

                                            <input type="checkbox" class="form-check-input" name="isgst" id="isgst">
                                            is GST Flag
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <label class="form-check-label">                                        
                                            <input type="checkbox" class="form-check-input" name="isservice" id="isservice">
                                            is Service Flag
                                        </label>
                                    </div>

                                    <br>
                                    <input class="btn-primary" type="button" onclick="savepreferences()" name="save" value="Apply New Settings" id="save"/>
                                    <br><br>
                                    <table>
                                        <tr style="margin-bottom: 10px;">
                                            <td>
                                                <div class="form-group">
                                                    <label for="CGST" class="control-label col-sm-2" style="width:50px;">CGST: </label>
                                                    <div class="col-sm-8">
                                                        <input type="text"  class="form-control" style="width: 100px;" id="CGSTID" placeholder="(%)" name="CGST"/>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                            <td>
                                                </div>
                                                <div class="form-group">
                                                    <label for="SGST" class="control-label col-sm-2" style="width: 50px;">SGST: </label>
                                                    <div class="col-sm-8">
                                                        <input type="text"  class="form-control" style="width: 100px;" id="SGSTID" placeholder="(%)" name="SGST"/>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                    <br>
                                    <input class="btn-primary" type="button" onclick="saveGSTChanges()" name="save" value="Add GST Tax" id="save"/>
                                    <br><br>
                                    <table>
                                        <tr style="margin-bottom: 10px;">                                            
                                            <td>
                                                </div>
                                                <div class="form-group">
                                                    <label for="service" class="control-label col-sm-3" style="width: 120px;">Service Tax: </label>
                                                    <div class="col-sm-8">
                                                        <input type="text"  class="form-control" style="width: 100px;" id="servicetax" placeholder="(%)" name="servicetax"/>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                    <br>
                                    <input class="btn-primary" type="button" onclick="saveServiceChanges()" name="save" value="Add Service Tax" id="save"/>
                                    <br><br>

                                    </form>
                                </div>
                                <br><br>
                                </fieldset>
                                <br><br>
                                </div>

                                </div>
                                </div>
                                <script type="text/javascript" lang="javascript">
                                    $(document).ready(function() {
                                        $("#messageflag")[0].checked = <%=messageflag%>;
                                        $("#duplicateprintflag")[0].checked = <%=duplicatemessageflag%>;
                                        $("#isborrow")[0].checked = <%=isborrow%>;
                                        $("#ishide")[0].checked = <%=isprinthide%>;
                                        $("#isgst")[0].checked = <%=isGST%>;
                                        $("#isservice")[0].checked = <%=isService%>;
                                        //                $("#checkboxflagid").is(':checked') ? true : false;

                                        //                $("#printerComponent")[0].style.display = "none";
                                        //                $("#duplicateprintflag").on("change", function(a){
                                        //                    if(this.checked){
                                        ////                        $("#printerComponent")[0].style.display = "";
                                        //                    }
                                        //                });
                                    });
                                    $(document).ready(function() {
                                        $("#CGSTID").keydown(function(e) {
                                            var key = e.charCode || e.keyCode || 0;
                                            // allow backspace, tab, delete, enter, arrows, minus, numbers and keypad numbers ONLY
                                            // home, end, period, and numpad decimal
                                            if (key === 190 && $("#CGSTID")[0].value.indexOf(".") >= 0) {
                                                alert('Only one "." can be used.');
                                                return false;
                                            }
                                            if (key === 173 && $("#CGSTID")[0].value.indexOf("-") >= 0) {
                                                alert('Only one "-" can be used.');
                                                return false;
                                            }
                                            return (key === 8 || key === 9 || key === 13 || key === 46 || key === 110 || key === 190 ||
                                                    (key >= 35 && key <= 40) || (key >= 48 && key <= 57) || (key >= 96 && key <= 105));
                                        });

                                        $("#SGSTID").keydown(function(e) {
                                            var key = e.charCode || e.keyCode || 0;
                                            // allow backspace, tab, delete, enter, arrows, minus, numbers and keypad numbers ONLY
                                            // home, end, period, and numpad decimal
                                            if (key === 190 && $("#SGSTID")[0].value.indexOf(".") >= 0) {
                                                alert('Only one "." can be used.');
                                                return false;
                                            }
                                            if (key === 173 && $("#SGSTID")[0].value.indexOf("-") >= 0) {
                                                alert('Only one "-" can be used.');
                                                return false;
                                            }
//                                            
                                            return (key === 8 || key === 9 || key === 13 || key === 46 || key === 110 || key === 190 ||
                                                    (key >= 35 && key <= 40) || (key >= 48 && key <= 57) || (key >= 96 && key <= 105));
                                        });
                                        $("#servicetax").keydown(function(e) {
                                            var key = e.charCode || e.keyCode || 0;
                                            // allow backspace, tab, delete, enter, arrows, minus, numbers and keypad numbers ONLY
                                            // home, end, period, and numpad decimal
                                            if (key === 190 && $("#servicetax")[0].value.indexOf(".") >= 0) {
                                                alert('Only one "." can be used.');
                                                return false;
                                            }
                                            if (key === 173 && $("#servicetax")[0].value.indexOf("-") >= 0) {
                                                alert('Only one "-" can be used.');
                                                return false;
                                            }
//                                            
                                            return (key === 8 || key === 9 || key === 13 || key === 46 || key === 110 || key === 190 ||
                                                    (key >= 35 && key <= 40) || (key >= 48 && key <= 57) || (key >= 96 && key <= 105));
                                        });
                                    });
                                    
                                    
                                    function savepreferences() {
                                        var userid = $("#userid").val();
                                        var messageflag = $("#messageflag")[0].checked;
                                        var duplicateprintflag = $("#duplicateprintflag")[0].checked;
                                        var isborrow = $("#isborrow")[0].checked;
                                        var isprinthide = $("#ishide")[0].checked;
                                        var isGST = $("#isgst")[0].checked;
                                        var isService = $("#isservice")[0].checked;
                                        var printernm = "";
                                        //                var CGST = $("#CGSTID").val();
                                        //                var SGST = $("#SGSTID").val();

                                        if ($("#duplicateprintflag")[0].checked) {
                                            if ($("#printernm")[0].selectedIndex === 0) {
                                                alert("Please select Printer Name for duplicate print.");
                                                return false;
                                            } else {
                                                printernm = $("#printernm").val();
                                            }
                                        }

                                        $.ajax({
                                            url: 'systempreferences',
                                            context: document.body,
                                            method: 'POST',
                                            data: {
                                                act: 1,
                                                userid: userid,
                                                messageflag: messageflag,
                                                duplicateprintflag: duplicateprintflag,
                                                printernm: printernm,
                                                isborrow: isborrow,
                                                isprinthide: isprinthide,
                                                isGST: isGST,
                                                isService: isService

                                            },
                                            success: function(responseObj) {
                                                var responseJson = JSON.parse(responseObj);

                                                if (responseJson.success) {
                                                    alert(responseJson.message);
                                                } else {
                                                    alert(responseJson.message);
                                                }
                                            },
                                            failure: function(responseObj) {
                                                alert('Some error. Please try again.');
                                            }
                                        });
                                    }
                                    function saveGSTChanges() {

                                        var CGST = $("#CGSTID").val();
                                        var SGST = $("#SGSTID").val();

                                        if (CGST <= 100 && SGST <= 100) {

                                            $.ajax({
                                                url: 'systempreferences',
                                                context: document.body,
                                                method: 'POST',
                                                data: {
                                                    act: 2,
                                                    CGST: CGST,
                                                    SGST: SGST
                                                },
                                                success: function(responseObj) {
                                                    var responseJson = JSON.parse(responseObj);

                                                    if (responseJson.success) {
                                                        alert(responseJson.message);
                                                    } else {
                                                        alert(responseJson.message);
                                                    }
                                                    $("#CGSTID").val("");
                                                    $("#SGSTID").val("");
                                                },
                                                failure: function(responseObj) {
                                                    alert('Some error. Please try again.');
                                                }
                                            });
                                        } else {
                                            $("#CGST").val("");
                                            $("#SGST").val("");
                                            alert("CGST and SGST can't be greater than 100%. Please enter correct GST percentage(%).");
                                        }
                                    }


                                    function saveServiceChanges() {

                                        var serviceid = $("#servicetax").val();

                                        if (serviceid <= 100) {

                                            $.ajax({
                                                url: 'systempreferences',
                                                context: document.body,
                                                method: 'POST',
                                                data: {
                                                    act: 3,
                                                    serviceid: serviceid
                                                    
                                                },
                                                success: function(responseObj) {
                                                    var responseJson = JSON.parse(responseObj);

                                                    if (responseJson.success) {
                                                        alert(responseJson.message);
                                                    } else {
                                                        alert(responseJson.message);
                                                    }
                                                    $("#servicetax").val("");
                                                    
                                                },
                                                failure: function(responseObj) {
                                                    alert('Some error. Please try again.');
                                                }
                                            });
                                        } else {
                                            $("#servicetax").val("");
                                            alert("Service Tax can't be greater than 100%. Please enter correct GST percentage(%).");
                                        }
                                    }
                                </script>
                                </body>
                                </html>
