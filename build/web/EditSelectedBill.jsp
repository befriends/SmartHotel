
<%@page import="java.text.DecimalFormat"%>
<%@page import="DaoImpl.ReportDaoImpl"%>
<%@page import="Dao.ReportDao"%>
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

    String orderJson = "";
    String tableJson = "";
    String masterJson = "";
    String orderid = "";
    String selectedTable = "";
    String selectedTableName = "";
    String isBorrow = "";
    String isPrintHide = "";
    String isGST = "";
    String isService = "";
    String orderNo ="";
    JSONObject orderJsonObj = null;
//                    JSONObject obj = null;
//                    JSONArray jarr = null;
    double sum1 = 0, CGST = 0, SGST = 0,subTotal =0,totalAmount =0,paidAmount =0,serviceTax=0,serviceTaxAmount=0,discount=0;
    DecimalFormat twoDForm = new DecimalFormat("#0.00");
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
            
            function updateRow(ind){
                var oldQty = parseInt($('#recordid'+ind)[0].children[3].textContent);
                var newQty = parseInt($('#editrecordid'+ind)[0].children[4].children[0].value);
                var qty = oldQty - newQty;
                var rate = parseInt($('#editrecordid'+ind)[0].children[5].children[0].value);
                var amount = qty * rate;
                
                alert(amount);
                
                document.getElementById('editrecordid'+ind).style.display="none";
                document.getElementById('recordid'+ind).style.display="";
                $('#recordid'+ind)[0].children[3].textContent = newQty;
            }
            
            function deleteRow(ind){
                var qty = parseInt($('#recordid'+ind)[0].children[3].textContent);
                var rate = parseInt($('#recordid'+ind)[0].children[4].textContent);
                var amount = qty * rate;
                
                alert(amount);
                
            }
            
            function calculateTotal(){
                
            }


        </script>
    </head>
    <body style="background-color: #555;">
        <jsp:include page="header.jsp"/>

        <div class="container">
            <!--  Body  -->
            <div class="container-fluid">

                <div style="margin-left: auto; margin-right: auto; width: 100%; background-color: antiquewhite;">

                    <%                                            //                    JSONObject jobj = new JSONObject(data);
                         String orderid = request.getParameter("orderid");
                        ReportDao reportDaoObj = new ReportDaoImpl();
                        JSONObject reportJSONObject = reportDaoObj.getOrderDetailList(orderid);
                        JSONArray itemarr = new JSONArray();
                        if (reportJSONObject != null && reportJSONObject.has("success") && reportJSONObject.has("data")) {
                            itemarr = reportJSONObject.getJSONArray("data");
                            CGST = reportJSONObject.optDouble("CGST",0.0);
                            SGST = reportJSONObject.optDouble("SGST",0.0);
                            serviceTax = reportJSONObject.optDouble("serviceTax",0.0);
                            subTotal = reportJSONObject.optDouble("subTotal",0.0);
                            totalAmount = reportJSONObject.optDouble("totalAmount",0.0);
                            paidAmount = reportJSONObject.optDouble("paidAmount", 0.0);
                            discount = reportJSONObject.optDouble("discount", 0.0);
                            orderNo = reportJSONObject.optString("orderNo", "");
                        }
                    %>

                    <table class="table table-bordered table-hover" tyle="table-layout:fixed;" id="tbl" >
                        <thead>
                            <tr class="">
                                <th style="display: none;">ID</th>
                                <th style="width: 7%;text-align: center;">Sr. No.</th>
                                <th style="width: 15%;">MenuItem</th>
                                <th style="width: 15%;">qty</th>
                                <th style="width: 30%;">Rate</th>
                                <th style="width: 23%;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int ind = 0;
                                for (ind = 0; ind < itemarr.length(); ind++) {
                                    JSONObject menuitemObj = itemarr.getJSONObject(ind);
                            %>
                            <tr class="info" id="editrecordid<%=ind%>" style="display:none;">
                        <form name="editrecords">

                            <td><label><%=ind + 1%></label></td>
                            <td style="display: none;">
                                <label id="orderid" style="display: none;"><%=orderid%></label>
                                <label id="submodule" style="display: none;">order</label>
                            </td>
                            <td>
                                <input type="text" name="menuitemname" value="<%=menuitemObj.get("menuItemName")%>"/>
                            </td>
                            <td>
                                <input type="text" name="menuitemname" value="<%=menuitemObj.get("qty")%>"/>
                            </td>
                            <td>
                                <input type="text" name="designation" value="<%=menuitemObj.get("rate")%>" readonly />
                            </td>
                            
                            <td>
                                <p class="btn btn-info" onClick="updateRow(<%=ind%>)"><span class="glyphicon glyphicon-save"></span>&nbsp;Save</p>
                                &nbsp;|&nbsp;
                                <p class="btn btn-default" onClick="cancel(<%=ind%>)"><span class="glyphicon glyphicon-remove"></span>&nbsp;Cancel</p>
                        </form>
                        </tr>
                        <tr class="success" id="recordid<%=ind%>">
                            <td style="display: none;">
                                <label id="employeeid" style="display: none;"><%=orderid%></label>
                                <label id="submodule" style="display: none;">employee</label>
                            </td>
                            <td><label><%=ind + 1%></label></td>
                            <td><label name="employeename"><%=menuitemObj.get("menuItemName")%></label></td>
                            <td><label name="employeename"><%=menuitemObj.get("qty")%></label></td>
                            <td><label name="rate"><%=menuitemObj.get("rate")%></label></td>
                            <td>
                                <p class="btn btn-success" onClick="showeditrecord(<%=ind%>)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;Edit</p>
                                &nbsp;|&nbsp;
                                <p class="btn btn-danger" onClick="deleteRow(<%=ind%>)"><span class="glyphicon glyphicon-trash"></span>&nbsp;Delete</p>
                        </tr>  

                        <%
                            }
                        %>
                        </tbody>
                    </table>
                                        <div class="form-group">
                        <label class="control-label col-sm-3">Total: </label>
                        <div class="col-sm-8">
                            <input type="text" id="subtotalid" class="form-control"  name="subtotal" value="<%=subTotal%>" readonly="true" />
                        </div>
                    </div><br><br>
                    <div class="form-group" style="padding-bottom: 5px;">
                        <label class="control-label col-sm-3">Discount (%): </label>
                        <div class="col-sm-8">
                            <input type="text" id="discountid" class="form-control" onblur="addDiscount()" placeholder="Discount in %" name="discount" />
                            <input type="hidden" id="discamountid" class="form-control"  name="discount" />
                        </div>
                    </div><br>
                    <div class="form-group" style="padding-bottom: 5px;">
                        <label class="control-label col-sm-3">Grand Total: </label>
                        <div class="col-sm-8">
                            <input type="text" id="grandtotalid" class="form-control"  name="grandtotal" value="<%=totalAmount%>" readonly="true" />
                        </div>
                    </div>
                            <%if(CGST > 0 && SGST > 0){%>
                        <br>
                    <div class="form-group" style="padding-bottom: 5px;">
                        <label class="control-label col-sm-3" id="cgst">CGST (<%=CGST%>%): </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" name="CGST" id="CGSTID" value="<%=twoDForm.format(CGST)%>" readonly=""/>
                        </div>
                    </div><br>
                    <div class="form-group" style="padding-bottom: 5px;">
                        <label class="control-label col-sm-3" id="sgst" >SGST (<%=SGST%>%): </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" name="SGST" id="SGSTID" value="<%=twoDForm.format(SGST)%>" readonly=""/>

                        </div>
                    </div>
                            <%}%>
                          
                             <%if(serviceTax > 0){%>
                      <br>
                    <div class="form-group" style="padding-bottom: 5px;">
                        <label class="control-label col-sm-3" id="service">Service Tax (<%=serviceTax%>%): </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" name="servicetax" id="servicetax" value="<%=twoDForm.format(serviceTaxAmount)%>" readonly=""/>
                        </div>
                    </div>
                        <%}%><br>                          
                    <div class="form-group" style="padding-bottom: 5px;">
                        <label class="control-label col-sm-3">Paid Amount: </label>
                        <div class="col-sm-8">
                            <input type="text" id="totalamountid" class="form-control"  name="totalamount" value="<%=twoDForm.format(paidAmount)%>" readonly="true" />
                        </div>
                    </div><br>
                                 
                    <br>

                    <input type="hidden" id="orderid" name="orderid" value="<%=orderid%>" />
                    <button type="button" onclick="checkkot()" target=_blank" id="printkot" class="btn btn-primary" >Generate KOT</button>&nbsp;&nbsp;
                    <button type="button" onclick="billprint()" target=_blank" id="printbill" class="btn btn-primary" >Print Bill</button>&nbsp;&nbsp;
                    <button type="button" onclick="makePayment()" target="_blank" id="proceedbill" class="btn btn-primary" >Proceed to Bill</button>
            <br>

                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="js/GridViewController.js"></script> 
</body>
</html>



