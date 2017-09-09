
<%@page import="java.text.DecimalFormat"%>
<%@page import="Dao.TableDao"%>
<%@page import="DaoImpl.TableDaoImpl"%>
<%@page import="Dao.OrderDao"%>
<%@page import="DaoImpl.OrderDaoImpl"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%!
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
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <!--<meta http-equiv="refresh" content="30" />-->
    <title>Table Dashboard</title>
    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <!--style for menu-->
    <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
    <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.js"></script> 
    <!--script for menu-->
    <script type="text/javascript" src="js/responsivemultimenu.js"></script>
    <script type="text/javascript" src="js/css-pop.js"></script>
    <link rel="stylesheet" href="css/jquery-ui.css">
    <script src="js/jquery-ui.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/shortcuts.js"></script>

    <style type="text/css">
        #blanket {
            background-color:#111;
            opacity: 0.65;
            *background:none;
            position:absolute;
            z-index: 9001;
            top:0px;
            left:0px;
            width:100%;
        }

        #popUpGetOrder {
            position:absolute;
            background:url(pop-back.jpg) no-repeat;
            width:auto;
            height:auto;
            border:0px solid #000;
            padding: 5px;
            border-radius: 5px;
            z-index: 9002;
        }

        .ui-autocomplete {
            min-height: 0px;
            max-height: 150px;
            overflow-y: scroll;
            overflow-x: hidden;
            z-index: 2147483647;
        }
    </style>
</head>
<%!
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
    JSONObject orderJsonObj = null;
//                    JSONObject obj = null;
//                    JSONArray jarr = null;
    double sum1 = 0, CGST = 0, SGST = 0,CGSTAmount =0,SGSTAmount =0,totalGST =0,serviceTax=0,serviceTaxAmount=0;
%>
<%
//    response.setIntHeader("Refresh", 20);
    DecimalFormat twoDForm = new DecimalFormat("#0.00");
    try {
        selectedTable = request.getParameter("selectedtableid") == null ? "" : request.getParameter("selectedtableid");
        selectedTableName = request.getParameter("selectedtablename") == null ? "" : request.getParameter("selectedtablename");

        TableDao tableDaoObj = new TableDaoImpl();
        tableJson = tableDaoObj.getAllActiveTableList().toString(); //getting Order list
        JSONObject tableJsonObj = new JSONObject(tableJson);
        JSONArray tableJsonArr = tableJsonObj.getJSONArray("data");
        int tableSize = tableJsonObj.getInt("totalCount");
        OrderDao orderDaoObj = new OrderDaoImpl();
        HashMap<String, String> params = new HashMap<String, String>();
        if (selectedTable.length() == 0 && tableSize > 0) {
            params.put("selectedTable", tableJsonArr.getJSONObject(0).getString("tableid"));
            selectedTable = tableJsonArr.getJSONObject(0).getString("tableid");
            selectedTableName = tableJsonArr.getJSONObject(0).getString("tablename");
        } else if (tableSize > 0) {
            params.put("selectedTable", selectedTable);
        }
        JSONArray orderJsonArr = new JSONArray();
        if (tableSize > 0) {
            orderJson = orderDaoObj.getOrderList(params).toString(); //getting Order list
//                        orderJson = "{\"data\":[{\"menuItemId\":\"1\",\"menuItemName\":\"1\",\"qty\":1,\"rate\":100,\"comment\":\"\"},{\"menuItemId\":\"2\",\"menuItemName\":\"2\",\"qty\":2,\"rate\":200,\"comment\":\"\"},{\"menuItemId\":\"3\",\"menuItemName\":\"3\",\"qty\":5,\"rate\":150,\"comment\":\"\"},{\"menuItemId\":\"4\",\"menuItemName\":\"4\",\"qty\":1,\"rate\":100,\"comment\":\"\"},{\"menuItemId\":\"5\",\"menuItemName\":\"5\",\"qty\":6,\"rate\":100,\"comment\":\"\"}],\"success\":true,\"totalCount\":5,\"subTotal\":1950,\"table\":5}";

            orderid = selectedTable;
            orderJsonObj = new JSONObject(orderJson);
            orderJsonArr = orderJsonObj.getJSONArray("data");
            CGST = orderJsonObj.getDouble("CGST");
            SGST = orderJsonObj.getDouble("SGST");
            serviceTax = orderJsonObj.getDouble("serviceTax");
        }
        
        masterJson = tableDaoObj.getMasterSeting().toString(); //getting Order list
        JSONObject masterJsonObj = new JSONObject(masterJson);
        JSONArray masterJsonArr = masterJsonObj.getJSONArray("data");
        
        isBorrow = masterJsonArr.getJSONObject(0).getString("isborrow");
        isPrintHide = masterJsonArr.getJSONObject(0).getString("isprinthide");
        isGST = masterJsonArr.getJSONObject(0).getString("isGST");
        isService = masterJsonArr.getJSONObject(0).getString("isService");
%>
<body style="background-color: #555;" onload="startRefresh(20000)">

    <jsp:include page="header.jsp"/>  
    <div class="container">
        <!--  Body  -->
        <div class="container-fluid">

            <!-- Show pop-up for get order - START -->
            <div id="blanket" style="display:none"></div>
            <div id="popUpGetOrder" style="display: none;background-color: #E0FFFF;width: 50%;">
                <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">
                    <text id="lableid" style="color: #d9534f; text-shadow: orange 2px 1px 1px, blue -1px 2px 0px;"></text>&nbsp;Order
                </span>
                <br>
                <form id="orderform" name="orderform" role="form" class="form-horizontal" autocomplete="off">
                    <div class="form-group">
                        <label for="customid" class="control-label col-sm-3">Custom ID : </label>
                        <div class="col-sm-9">
                            <input id="customid" type="text" class="form-control" style="width: 40%;" name="customid" onblur="selectcustomid()" placeholder="Enter Custom ID" required="">
                            <!--<input type="hidden" class="form-control" id="menuitemid" name="menuitemid" readonly="true" required="true"/>-->
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="menuitem" class="control-label col-sm-3">Menu Item : </label>
                        <div class="col-sm-9">
                            <input id="menuitem" type="text" class="form-control" style="width: 60%;" name="menuitem" onblur="selectmenuitem()" placeholder="Enter Menu Item" onkeyup="searchmenu()" required="">
                            <input type="hidden" class="form-control" id="menuitemid" name="menuitemid" readonly="true" required="true"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="quantity" class="control-label col-sm-3">Quantity : </label>
                        <div class="col-sm-9">
                            <input type="text" name="quantity" id="quantity" style="width: 20%;" required=""/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="rate" class="control-label col-sm-3">Rate : </label>
                        <div class="col-sm-9">
                            <input type="text" name="rate" id="rate" style="width: 40%;" disabled="disabled" required=""/>
                        </div>
                    </div>
                    <div class="form-group"> 
                        <div class="col-sm-offset-2 col-sm-5">
                            <button type="button" name="submit" onclick="addtolist()" value="Add" class="btn btn-default" >Add to List</button>
                            <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                        </div>
                    </div>
                    <table class="table table-condensed table-bordered table-hover" id="orderdetailtablelist" style="table-layout:fixed;" id="tbl">
                        <thead>
                            <tr class="">
                                <th style="display: none;">Menu Item ID</th>
                                <th style="width: 4%;">S. No.</th>
                                <th style="width: 10%;">Menu Item</th>
                                <!--<th style="display: none;">Message</th>-->
                                <th style="width: 5%;">Qty</th>
                                <th style="width: 5%;">Rate</th>
                                <th style="width: 6%">Sub-Total</th>
                                <th style="width: 6%;">Action</th>
                            </tr>
                        </thead>

                        <tbody style="">

                        </tbody>
                    </table>
                    <div class="text-center">
                        <input type="hidden" name="tableid" id="tableid" required=""/>
                        <input type="hidden" name="tableno" id="tableno" required=""/>
                        <input type="hidden" name="act" id="act" value="1"/>
                        <button type="button" name="proceed" onclick="addorder()" accesskey="z" class="btn btn-info">Proceed</button>
                        <button type="button" name="cancel" onclick="closePopUpGetOrderWindow('popUpGetOrder')" accesskey="x" class="btn btn-danger">Cancel</button>
                    </div>
                </form>
            </div>
            <!-- Show pop-up for get order - END -->
            <!--  Body  -->
            <div class="col-lg-12" >
                <div class="container col-sm-2 tablelist" id="myScrollspy" style="padding:10px;background-color:#8B0000;height:550px;overflow-y: scroll;" data-spy="scroll" data-target="#myScrollspy" data-offset="20">
                    <%
                        for (int cnt = 0; cnt < tableSize; cnt++) {
                            String tableid = tableJsonArr.getJSONObject(cnt).getString("tableid");
                            String tablename = tableJsonArr.getJSONObject(cnt).getString("tablename");
                            String tableno = tableJsonArr.getJSONObject(cnt).getString("tableno");
                            String isreserved = tableJsonArr.getJSONObject(cnt).getString("isreserved");
                    %>
                    <div class="container-fluid" style="padding: 5px;" index="<%=cnt + 1%>" active="<% if (selectedTable.equals(tableid)) {%>true<%} else {%>false<%}%>">
                        <form name="form<%=cnt + 1%>" action="TableDashboard.jsp">
                            <input type="hidden" name="selectedtableid" value="<%=tableid%>" />
                            <input type="hidden" name="selectedtablename" value="<%=tablename%>" />
                            <%if (isreserved.equals("0")) {%>
                            <button type="submit" class="btn btn-primary <% if (selectedTable.equals(tableid)) {%>active<%}%>" ><%=tablename%> <span class="badge"></span></button>
                                <%} else {%>
                            <button type="submit" class="btn btn-success <% if (selectedTable.equals(tableid)) {%>active<%}%>" ><%=tablename%> <span class="badge"></span></button>
                                <%}%>
                            <button type="button" class="btn btn-warning btn-xs" onclick="showPopUpGetOrderWindow('popUpGetOrder', '<%=tableid%>', '<%=tableno%>')" >
                                <span class="glyphicon glyphicon-plus" style="vertical-align: middle;text-align: center;"></span>
                            </button>
                        </form>
                    </div>
                    <%
                        }
                    %>
                </div>
                <div class="container-fluid col-sm-10" style="padding:10px;background-color: #E0FFFF;height:550px;overflow-y: scroll;">
                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;"><%=selectedTableName%></span>
                    <table class="table table-bordered table-hover" id="ordertablelist">
                        <thead>
                            <tr class="">
                                <th class="col-md-1 text-center">Sr. No.</th>
                                <th class="col-md-3" style="display: none;">Menu ID</th>
                                <th class="col-md-3">Menu Item</th>
                                <th class="col-md-3">Comment</th>
                                <th class="col-md-1 text-right">Qty</th>
                                <th class="col-md-2 text-right">Rate</th>
                                <th class="col-md-2 text-right">Sub-Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%

                                sum1 = 0;
                                totalGST = 0;
                                for (int i = 0; i < orderJsonArr.length(); i++) {
                                    JSONObject item = orderJsonArr.getJSONObject(i);
                                    double rate = Double.parseDouble(item.getString("rate"));
                                    double qty = Double.parseDouble(item.getString("qty"));
                                    double subtotal = rate * qty;
                                    orderid = item.getString("orderid");

                                    sum1 = sum1 + subtotal;
                                     if(isGST.equals("1")){
                                     CGSTAmount = (sum1 * (CGST / 100));
                                     SGSTAmount = (sum1 * (SGST / 100));
                                     }
                                     if(isService.equals("1")){
                                     serviceTaxAmount = (sum1 * (serviceTax / 100));
                                     }
                                     totalGST = sum1 +(CGSTAmount + SGSTAmount) + serviceTaxAmount;
                            %>
                            <tr class="success" id="row<%=i%>">
                                <td class="text-center"><%=i + 1%></td>
                                <td id="idmenuitem<%=i%>" style="display: none;"><%=item.get("menuItemId")%></td>
                                <td><%=item.get("menuItemName")%></td>
                                <td id="idmessage<%=i%>"><%=item.get("comment")%></td>
                                <td id="idquantity<%=i%>" class="text-right"><%=qty%></td>
                                <td id="idrate<%=i%>" class="text-right"><%=rate%></td>
                                <td id="idsubtotal<%=i%>"class="text-right"><%=subtotal%></td>


                            </tr>
                            <%
                                    }
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                            %> 
                        </tbody>
                    </table>
                        
                    <div class="form-group">
                        <label class="control-label col-sm-3">Total: </label>
                        <div class="col-sm-8">
                            <input type="text" id="subtotalid" class="form-control"  name="subtotal" value="<%=sum1%>" readonly="true" />
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
                            <input type="text" id="grandtotalid" class="form-control"  name="grandtotal" value="<%=sum1%>" readonly="true" />
                        </div>
                    </div>
                            <%if(isGST.equals("1")){%>
                        <br>
                    <div class="form-group" style="padding-bottom: 5px;">
                        <label class="control-label col-sm-3" id="cgst">CGST (<%=CGST%>%): </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" name="CGST" id="CGSTID" value="<%=twoDForm.format(CGSTAmount)%>" readonly=""/>
                            <input type="hidden" name="" id="cgstid" value="<%=CGST%>" />
                        </div>
                    </div><br>
                    <div class="form-group" style="padding-bottom: 5px;">
                        <label class="control-label col-sm-3" id="sgst" >SGST (<%=SGST%>%): </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" name="SGST" id="SGSTID" value="<%=twoDForm.format(SGSTAmount)%>" readonly=""/>
                            <input type="hidden" name="" id="sgstid" value="<%=SGST%>"/>

                        </div>
                    </div>
                            <%}%>
                          
                             <%if(isService.equals("1")){%>
                      <br>
                    <div class="form-group" style="padding-bottom: 5px;">
                        <label class="control-label col-sm-3" id="service">Service Tax (<%=serviceTax%>%): </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" name="servicetax" id="servicetax" value="<%=twoDForm.format(serviceTaxAmount)%>" readonly=""/>
                            <input type="hidden" name="" id="serviceid" value="<%=serviceTax%>"/>
                        </div>
                    </div>
                        <%}%><br>                          
                    <div class="form-group" style="padding-bottom: 5px;">
                        <label class="control-label col-sm-3">Paid Amount: </label>
                        <div class="col-sm-8">
                            <input type="text" id="totalamountid" class="form-control"  name="totalamount" value="<%=twoDForm.format(totalGST)%>" readonly="true" />
                        </div>
                    </div><br>
                    <div class="form-group" style="padding-bottom: 0px;">
                        <label class="control-label col-sm-3">Payment Mode: </label>
                        <div class="col-sm-8">
                            <select class="form-control" name="paymentmode" id="paymentmode">
                                <option value="1" selected="selected">CASH</option>
                                <option value="2">CARD</option>
                                <option value="3">CHEQUE</option>
                            </select>
                        </div>
                    </div><br>
                    <div class="form-group" id="chequedetail" style="display: none;">
                        <label class="control-label col-sm-3">Cheque No.: </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" placeholder="Enter Cheque no." name="chequeno" id="chequenoid" required=""/>
                        </div><br>
                    </div>
                    <%if(isBorrow.equals("1")){%>
                    <table>
                        <tr>
                            <td>
                    <div class="form-group" style="padding-bottom: 3px;">
                        <label class="control-label col-sm-3" style="width: 75%;">Is Borrow : </label>
                        <div class="col-sm-1" style="text-align: left;">
                            <input type="checkbox" class="form-control" id="checkboxflagid" name="messageflag"/>
                        </div>
                    </div>
                            </td>
                            <td>
                    <!--<input type="checkbox" id="checkboxflagid" name="messageflag"/>-->
                    <div class="form-group">
                        <label class="control-label col-sm-3" style="width: 50%;text-align: right">Customer Name: </label>
                         <div class="col-sm-8">
                             <input type="text" id="customerid" class="form-control" style="width: 100%;" name="customername"/>
                        </div>
                    </div>
                            </td>
                            <%}%>
                            <%if(isPrintHide.equals("1")){%>
                            <td>
                    <div class="form-group">
                        <label class="control-label col-sm-3" style="width: 80%;">Hide Name : </label>
                        <div class="col-sm-1" style="text-align: left;">
                            <input type="checkbox" class="form-control" id="hidenamecheckboxflagid" name="messageflag"/>
                        </div>
                    </div>
                            </td></tr>
                        <%}%>
                    </table>
                    <br>

                    <input type="hidden" id="orderid" name="orderid" value="<%=orderid%>" />
                    <button type="button" onclick="checkkot()" target=_blank" id="printkot" class="btn btn-primary" >Generate KOT</button>&nbsp;&nbsp;
                    <button type="button" onclick="billprint()" target=_blank" id="printbill" class="btn btn-primary" >Print Bill</button>&nbsp;&nbsp;
                    <button type="button" onclick="makePayment()" target="_blank" id="proceedbill" class="btn btn-primary" >Proceed to Bill</button>
                    <br><br>
                </div>
            </div>
            <!--Body End-->
        </div>
    </div>
    <script type="text/javascript">
        var menuitemstore = "";
        var refreshTimeout;

        /** Function to refresh the page at specified interval. **/
        function startRefresh(refreshPeriod) {
            refreshTimeout = setTimeout("window.location.reload();", refreshPeriod);
            window.location.hash = 'start';
        }

        /** Function to stop refreshing the page. **/
        function stopRefresh() {
            clearTimeout(refreshTimeout);
            window.location.hash = 'stop';
        }

        $(document).ready(function() {
            $(document).keyup(function(e) {
                switch (e.which) {
                    case 33 :
                        {//PageUp
                            $("#printkot").click();
                        }
                        break;
                    case 34 :
                        {//PageDn
                            $("#printbill").click();
                        }
                        break;
                    case 35 :
                        {//End
                            var currentTable = $("#myScrollspy div[active='true']")[0];
                            var currenctIndex = currentTable.getAttribute("index");
                            var newIndex = parseInt(currenctIndex) + 1;
                            if (newIndex > $("#myScrollspy")[0].children.length) {
                                newIndex = 1;
                            }
                            var nextTable = $("#myScrollspy div[index='" + newIndex + "']")[0];
                            nextTable.children[0][2].click();
                        }
                        break;
                    case 36 :
                        {//Home
                            var currentTable = $("#myScrollspy div[active='true']")[0];
                            var currenctIndex = currentTable.getAttribute("index");
                            var newIndex = parseInt(currenctIndex) - 1;
                            if (newIndex === 0) {
                                newIndex = $("#myScrollspy")[0].children.length;
                            }
                            var nextTable = $("#myScrollspy div[index='" + newIndex + "']")[0];
                            nextTable.children[0][2].click();
                        }
                        break;
                    case 46 :
                        {//Delete
                            var ans = confirm("Do you want to Make Final Bill?");
                            if (ans) {
                                $("#proceedbill").click();
                            }
                        }
                    case 69 :
                        {//e
                        $.ajax({
                        url: "OrderController",
                        context: document.body,
                        method: "POST",
                        data: {
                            act: 9, // act=9 => action 9 is for update non edited.
                            orderid: $("#orderid").val()                            
                        },
                        success: function(responseObj) {                            
                        }
                    });
                            
                        }
                }
            });
            $("#chequedetail").hide();
            $("#paymentmode").on("change", function() {
                if ($("#paymentmode").val() === "3") {
                    $("#chequedetail").show();
                } else {
                    $("#chequedetail").hide();
                }
            });

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
            // Number field validation on key press
            $("#quantity").keydown(function(e) {
                var key = e.charCode || e.keyCode || 0;
                // allow backspace, tab, delete, enter, arrows, minus, numbers and keypad numbers ONLY
                // home, end, period, and numpad decimal
                if (key === 190 && $("#quantity")[0].value.indexOf(".") >= 0) {
                    alert('Only one "." can be used.');
                    return false;
                }
                if (key === 173 && $("#quantity")[0].value.indexOf("-") >= 0) {
                    alert('Only one "-" can be used.');
                    return false;
                }
                return (key === 8 || key === 9 || key === 13 || key === 46 || key === 110 || key === 173 || key === 190 ||
                        (key >= 35 && key <= 40) || (key >= 48 && key <= 57) || (key >= 96 && key <= 105));
            });
        });

        function showPopUpGetOrderWindow(popupDivName, tableid, tableno) {
            $("#tableid").val(tableid);
            $("#tableno").val(tableno);
            stopRefresh();
            $("#lableid").text(tableno);
            popup(popupDivName);
        }

        function closePopUpGetOrderWindow(popupDivName) {
            $("#tableid").val("");
            $("#tableno").val("");
            popup(popupDivName);
            startRefresh(20000);
        }

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
                    $('#rate').val(menuitemjobj.rate);
                    $('#customid').val(menuitemjobj.customid);

                    var parentComboId = 'menuitemid';
                    var childComboId = 'messageid';
                    var url = 'MenuItemController';
                    var submodule = 'messagetype';
                    loadComboValues(parentComboId, childComboId, url, submodule);
                    return false;
                }
            }
            $('#menuitemid').val("");
            $('#menuitem').val("");
            $('#customid').val("");
        }

        function selectcustomid(rec) {
            var menuitemjarr = JSON.parse(menuitemstore).data;
//                var selectedMenuName = $('#menuitem').val();
            var selectedCustomID = $('#customid').val();
            for (var cnt = 0; cnt < menuitemjarr.length; cnt++) {
                var menuitemjobj = menuitemjarr[cnt];
//                    var menuname = menuitemjobj.menuitemname;
                var customID = menuitemjobj.customid;
                if (customID === selectedCustomID) {
                    $('#menuitemid').val(menuitemjobj.menuitemid);
                    $('#menuitem').val(menuitemjobj.menuitemname);
                    $('#rate').val(menuitemjobj.rate);
//                        $('#customid').val(menuitemjobj.customid);

                    var parentComboId = 'menuitemid';
                    var childComboId = 'messageid';
                    var url = 'MenuItemController';
                    var submodule = 'messagetype';
                    loadComboValues(parentComboId, childComboId, url, submodule);
                    return false;
                }
            }
            $('#menuitemid').val("");
            $('#menuitem').val("");
            $('#customid').val("");
        }

        function proceedorder() {
            var menuitemid = $('#menuitemid').val();
            var message = "";
            var quantity = $('#quantity').val();
            var rate = $('#rate').val();
            if (menuitemid === "") {
                alert("Select MenuItem first.");
                $('#menuitemid').focus();
                return false;
            } else if (quantity === "" || quantity === "0") {
                alert("Quantity can't be blank or zero (0).");
                $('#quantity').val("");
                $('#quantity').focus();
                return false;
            } else if (rate === "") {
                alert("Rate can't be blank.");
                $('#rate').focus();
                return false;
            }

            if (confirm('Proceed Order for selected MenuItem?')) {
                var menuitemidlist = "";
                var jsonarr = [];

                var subtotal = parseFloat(quantity) * parseFloat(rate);

                var jsonobj = {};
                jsonobj["menuitemid"] = menuitemid;
                jsonobj["message"] = message;
                jsonobj["quantity"] = quantity;
                jsonobj["rate"] = rate;
                jsonobj["subtotal"] = subtotal;

                jsonarr.push(jsonobj);
                menuitemidlist = menuitemid;
                var orderjsonlist = {};
                orderjsonlist ["data"] = jsonarr;
                orderjsonlist ["menuitemidlist"] = menuitemidlist;
                orderjsonlist ["userid"] = "<%=userID%>";
                orderjsonlist ["tableid"] = $('#tableid').val();
                orderjsonlist ["tableno"] = $('#tableno').val();

                $.ajax({
                    url: "OrderController",
                    context: document.body,
                    method: "POST",
                    data: {
                        act: 1, // act=1 => action 1 is for saving order to DB.
                        isbooked: true,
                        orderlistjson: JSON.stringify(orderjsonlist)
                    },
                    success: function(responseObj) {
                        var isSuccess = JSON.parse(responseObj).success;
                        if (isSuccess) {
                            var message = JSON.parse(responseObj).message;
                            alert(message);
                            location.reload();
                        } else {
                            var errormessage = JSON.parse(responseObj).errormessage;
                            alert(errormessage);
                        }
                    }
                });
            }
        }
        function addorder() {
            var ordertable = $('#orderdetailtablelist tbody tr');
            var cnt;
            var menuitemidlist = "";
            var jsonarr = [];

            if (ordertable.length > 0) {
                for (cnt = 0; cnt < ordertable.length; cnt++) {
                    var trEle = $('#orderdetailtablelist tbody tr[id=row' + cnt + ']');
                    var menuitemid = $('#orderdetailtablelist tbody tr[id=row' + cnt + '] td[id=idmenuitem' + cnt + ']').text();
//                    var message = $('#orderdetailtablelist tbody tr[id=row' + cnt + '] td[id=idmessage' + cnt + ']').text();
                    var quantity = $('#orderdetailtablelist tbody tr[id=row' + cnt + '] td[id=idquantity' + cnt + ']').text();
                    var rate = $('#orderdetailtablelist tbody tr[id=row' + cnt + '] td[id=idrate' + cnt + ']').text();
                    var subtotal = $('#orderdetailtablelist tbody tr[id=row' + cnt + '] td[id=idsubtotal' + cnt + ']').text();

                    var jsonobj = {};
                    jsonobj["menuitemid"] = menuitemid;
//                    jsonobj["message"] = message;
                    jsonobj["quantity"] = quantity;
                    jsonobj["rate"] = rate;
                    jsonobj["subtotal"] = subtotal;

                    jsonarr.push(jsonobj);
                    menuitemidlist += menuitemid + ",";
                }
                menuitemidlist = menuitemidlist.substr(0, menuitemidlist.length - 1);
                var orderjsonlist = {};
                orderjsonlist ["data"] = jsonarr;
                orderjsonlist ["menuitemidlist"] = menuitemidlist;
                orderjsonlist ["userid"] = "<%=userID%>";

                orderjsonlist ["tableid"] = $('#tableid').val();
                orderjsonlist ["tableno"] = $('#tableno').val();


                $.ajax({
                    url: "OrderController",
                    context: document.body,
                    method: "POST",
                    data: {
                        act: 1, // act=1 => action 1 is for saving order to DB.
                        isbooked: true,
                        orderlistjson: JSON.stringify(orderjsonlist)
                    },
                    success: function(responseObj) {
                        var isSuccess = JSON.parse(responseObj).success;
                        if (isSuccess) {
                            var message = JSON.parse(responseObj).message;
                            alert(message);
                            location.reload();
                        } else {
                            var errormessage = JSON.parse(responseObj).errormessage;
                            alert(errormessage);
                        }
                        //                    alert('Order proceeded.....');
                    }
                });
            } else {
                alert("Order list is empty. Please add menu's to order list.");
            }
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

        function addDiscount() {
            var discount = $("#discountid").val();

            if (discount !== "") {
                var subTotal = parseFloat($("#subtotalid").val());
                var discAmount = parseFloat(discount);
                if (discAmount <= 100) {
                    var disAmount =((subTotal * discAmount) / 100);
                    $("#grandtotalid").val(subTotal - disAmount);
                    $("#discamountid").val(disAmount);
                    GST();
                    ServiceTax();
                } else {
                    $("#discountid").val("");
                    alert("Discount can't be greater than 100%. Please enter correct discount percentage(%).");
                }
            }
        }
        function GST(){
            var cgst = parseFloat($("#cgstid").val());
            var sgst =parseFloat($("#sgstid").val());
            var grandtotal = parseFloat($("#grandtotalid").val());
            if(cgst > 0 && sgst > 0){
            var cgstamount =  ( grandtotal * (cgst/100));
            var sgstamount = (grandtotal *(sgst/100));
            var totalamount = grandtotal +(cgstamount + sgstamount);
            $("#totalamountid").val((totalamount).toFixed(2));
            $("#CGSTID").val((cgstamount).toFixed(2));
            $("#SGSTID").val((sgstamount).toFixed(2));
        }else{
            $("#totalamountid").val(grandtotal);
        }
        }
        function ServiceTax(){
            var servicetax = parseFloat($("#serviceid").val());
            var grandtotal = parseFloat($("#grandtotalid").val());
             var cgst = parseFloat($("#cgstid").val());
            var sgst =parseFloat($("#sgstid").val());
            if(servicetax > 0){
            if(cgst > 0 && sgst > 0){    
                var cgstamount =  ( grandtotal * (cgst/100));
            var sgstamount = (grandtotal *(sgst/100));
            var servicetaxamount =  ( grandtotal * (servicetax/100));
            var totalamount = grandtotal +(cgstamount + sgstamount)+ servicetaxamount;
            $("#totalamountid").val((totalamount).toFixed(2));
            $("#CGSTID").val((cgstamount).toFixed(2));
            $("#SGSTID").val((sgstamount).toFixed(2));
             $("#servicetax").val((servicetaxamount).toFixed(2));
        }else{
            var servicetaxamount =  ( grandtotal * (servicetax/100));
            var totalamount = grandtotal + servicetaxamount;
            $("#totalamountid").val((totalamount).toFixed(2));
            $("#servicetax").val((servicetaxamount).toFixed(2));
        }
        }
    }

        function makePayment() {
            var orderid = $("#orderid").val();
            var subTotal = $("#subtotalid").val();
            var discount = $("#discountid").val();
            var grandTotal = $("#grandtotalid").val();
            var customerName = $("#customerid").val();
            var paymentMode = $("#paymentmode").val();
            var chequeNo = $("#chequenoid").val();
            var checkboxnotificationflag = $("#checkboxflagid").is(':checked') ? 1 : 0;
            var totalpaidamount = $("#totalamountid").val();
            var CGSTID = $("#CGSTID").val();
            var SGSTID = $("#SGSTID").val();
            var servicetax = $("#servicetax").val();
            var servicetaxper = $("#serviceid").val();

            if (paymentMode === "3" && chequeNo.trim() === "") {
                alert("Please enter Cheque No. before proceed to bill.");
                return false;
            }

            if ($('#ordertablelist tbody tr').length > 0) {
                if ((checkboxnotificationflag == '1' && customerName !== "") || (checkboxnotificationflag == '0' && customerName == "") || (customerName !== ""))
                {
                    $.ajax({
                        url: "OrderController",
                        context: document.body,
                        method: "POST",
                        data: {
                            act: 5, // act=5 => action 5 is for make bill payment.
                            orderid: orderid,
                            subtotal: subTotal,
                            discount: discount,
                            grandtotal: grandTotal,
                            customer: customerName,
                            paymentmode: paymentMode,
                            chequeno: chequeNo,
                            totalpaidamount:totalpaidamount,
                            CGST:CGSTID,
                            SGST:SGSTID,
                            servicetax:servicetax,
                            servicetaxper:servicetaxper,
                            checkboxnotificationflag: checkboxnotificationflag

                        },
                        success: function(responseObj) {
                            alert('Bill Paid.');
                            //                                var tempJson = <%//=orderJson %>
                            //                                var ordJson = JSON.stringify(tempJson);
                            //                                window.open('billprint.jsp?orderid="'+orderid+'"&selectedTableName=<%//=selectedTableName %>&disc='+discount, '_blank');
                            //                                var orderid = $("#orderid").val();
                            $("#subtotalid").val("");
                            $("#discountid").val("");
                            $("#grandtotalid").val("");
                            $("#customerid").val("");
                            $("#checkboxflagid").val("");
                            $("#paymentmode").val("1");
                            $("#chequenoid").val("");
                            $("#totalamountid").val("");
                            $("#CGSTID").val("");
                            $("#SGSTID").val("");
                            $("#cgstid").val("");
                            $("#sgstid").val("");
                            $("#servicetax").val("");
                            $("#serviceid").val("");
                            $("#service").val("");
                            $("#cgst").val("");
                            $("#sgst").val("");
//                        location.reload(true);
//                        window.history.pushState(null, null, window.location.pathname);
                            window.open(window.location.pathname, '_self');
                        }
                    });
                } else {

                    alert("Please Enter Customer Name")
                }
            }
        }
//        function printbill() {
//            if ($('#ordertablelist tbody tr').length > 0) {
//                var orderid = $("#orderid").val();
//                var discount = $("#discountid").val();
//                var customer = $("#customerid").val();
//                window.open('billprint.jsp?orderid="' + orderid + '"&customer="' + customer + '"&selectedTableName=<%=selectedTableName%>&disc=' + discount, '_blank');
//            }
//        }
        function checkkot() {
            var ordertable = $('#ordertablelist tbody tr');
            var cnt;
            var jsonarr = [];
            var menuitemidlist = "";

            if (ordertable.length > 0) {
                for (cnt = 0; cnt < ordertable.length; cnt++) {
                    var trEle = $('#ordertablelist tbody tr[id=row' + cnt + ']');
                    var menuitemid = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idmenuitem' + cnt + ']').text();
                    var message = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idmessage' + cnt + ']').text();
                    var quantity = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idquantity' + cnt + ']').text();

                    var jsonobj = {};
                    jsonobj["menuitemid"] = menuitemid;
                    jsonobj["message"] = message;
                    jsonobj["quantity"] = quantity;

                    jsonarr.push(jsonobj);
                    menuitemidlist += menuitemid + ",";
                }
                menuitemidlist = menuitemidlist.substr(0, menuitemidlist.length - 1);
                var orderjsonlist = {};
                orderjsonlist ["data"] = jsonarr;
                orderjsonlist ["menuitemidlist"] = menuitemidlist;
                orderjsonlist ["userid"] = "<%=userID%>";
                orderjsonlist ["tableid"] = "<%=selectedTable%>";
                orderjsonlist ["tableno"] = "<%=selectedTableName%>";

                $.ajax({
                    url: "OrderController",
                    context: document.body,
                    method: "POST",
                    data: {
                        act: 7,
                        isbooked: true,
                        orderlistjson: JSON.stringify(orderjsonlist)
                    },
                    success: function(responseObj) {
                        alert("KOT Print Proceeded.");
//                                    var isSuccess = JSON.parse(responseObj).success;
//                                    if(isSuccess){
//                                        var message = JSON.parse(responseObj).message;
//                                        alert(message);
//                                        location.reload();
//                                    } else{
//                                        var errormessage = JSON.parse(responseObj).errormessage;
//                                        alert(errormessage);
//                                    }
                        //                    alert('Order proceeded.....');
                    }
                });
            } else {
                alert("Order list is empty.");
            }
        }
        function billprint() {
            var ordertable = $('#ordertablelist tbody tr');
            var cnt;
            var jsonarr = [];

            if (ordertable.length > 0) {
                for (cnt = 0; cnt < ordertable.length; cnt++) {
                    var trEle = $('#ordertablelist tbody tr[id=row' + cnt + ']');
                    var menuitemid = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idmenuitem' + cnt + ']').text();
                    var message = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idmessage' + cnt + ']').text();
                    var quantity = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idquantity' + cnt + ']').text();
                    var rate = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idrate' + cnt + ']').text();
                    var subtotal = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idsubtotal' + cnt + ']').text();
                    var total = $("#subtotalid").val();
                    var discount = $("#discountid").val();
                    var grandtotal = $("#grandtotalid").val();
                    var customername = $("#customerid").val();
                    var checkboxnotificationflag = $("#hidenamecheckboxflagid").is(':checked') ? 1 : 0;
                    var totalpaidamount = $("#totalamountid").val();
                    var CGST = $("#CGSTID").val();
                    var SGST = $("#SGSTID").val();
                    var servicetax = $("#servicetax").val();

                    var jsonobj = {};
                    jsonobj["menuitemid"] = menuitemid;
                    jsonobj["message"] = message;
                    jsonobj["quantity"] = quantity;
                    jsonobj["rate"] = rate;
                    jsonobj["subtotal"] = subtotal;
                    jsonobj["total"] = total;
                    jsonobj["discount"] = discount;
                    jsonobj["grandtotal"] = grandtotal;
                    jsonobj["totalpaidamountid"] = totalpaidamount;
                    jsonobj["CGST"] = CGST;
                    jsonobj["SGST"] = SGST;
                    jsonobj["servicetax"] = servicetax;


                    jsonarr.push(jsonobj);
                }
                var orderjsonlist = {};
                orderjsonlist ["data"] = jsonarr;
                orderjsonlist ["userid"] = "<%=userID%>";
                orderjsonlist ["tableid"] = "<%=selectedTable%>";
                orderjsonlist ["tableno"] = "<%=selectedTableName%>";
//                orderjsonlist["orderid"] = orderid;
                orderjsonlist["customername"] = customername;
                orderjsonlist["checkboxnotificationflag"] = checkboxnotificationflag;

                $.ajax({
                    url: "OrderController",
                    context: document.body,
                    method: "POST",
                    data: {
                        act: 8,
                        isbooked: true,
                        orderlistjson: JSON.stringify(orderjsonlist)
                    },
                    success: function(responseObj) {
                        alert("Print proceeded.....");
//                                    var isSuccess = JSON.parse(responseObj).success;
//                                    if(isSuccess){
//                                        var message = JSON.parse(responseObj).message;
//                                        alert(message);
//                                        location.reload();
//                                    } else{
//                                        var errormessage = JSON.parse(responseObj).errormessage;
//                                        alert(errormessage);
//                                    }
//                                            alert('Order proceeded.....');
                    }
                });
            } else {
                alert("Order list is empty.");
            }
        }

//        function showOrderPopUp(){
//            $("#order_popup").;
//        }

        function addtolist() {
            var menuitemid = $('#menuitemid').val();
            var menuitem = $('#menuitem').val();
//            var message = $('#messageid')[0].selectedIndex === 0 ? "" : $('#messageid')[0].selectedOptions[0].innerHTML;

            var quantity = $('#quantity').val();
            if (quantity.trim().indexOf(" ") >= 0) {
                alert('Space not allows in quantity field.');
                $('#quantity').val('1');
                $('#quantity').focus();
                return false;
            }
            var rate = $('#rate').val();
            var tablerowscount = $('#orderdetailtablelist').children()[1].children.length; //children()[1] - is always tbody child

            var isValidForm = true;
            var validationMsg = "";
            if (menuitemid === "" || menuitem === "") {
                isValidForm = false;
                validationMsg = "Please select MenuItem first.";
                $('#menuitem').focus();
            } else if (quantity === "" || quantity === "0") {
                isValidForm = false;
                validationMsg = "Please enter quantity first. Quantity can not be empty or zero(0)";
                $('#quantity').val("");
                $('#quantity').focus();
            }

            if (isValidForm) {
                var trEle = document.createElement('tr');
                trEle.className = "success";
                trEle.id = "row" + tablerowscount;

                var tdEle1 = document.createElement('td'); //MenuItemID
                tdEle1.innerHTML = menuitemid;
                tdEle1.id = "idmenuitem" + tablerowscount;
                tdEle1.style = "display:none;";
                trEle.appendChild(tdEle1);

                var tdEle2 = document.createElement('td'); //Sr.No.
                tdEle2.innerHTML = parseInt(tablerowscount) + 1;
                trEle.appendChild(tdEle2);

                var tdEle3 = document.createElement('td'); //MenuItem Name
                tdEle3.innerHTML = menuitem;
                trEle.appendChild(tdEle3);

//                var tdEle4 = document.createElement('td'); //Message
//                tdEle4.innerHTML = message;
//                tdEle4.id = "idmessage" + tablerowscount;
//                trEle.appendChild(tdEle4);

                var tdEle4 = document.createElement('td'); //Quantity
                tdEle4.innerHTML = quantity;
                tdEle4.id = "idquantity" + tablerowscount;
                trEle.appendChild(tdEle4);

                var tdEle5 = document.createElement('td'); //Rate
                tdEle5.innerHTML = rate;
                tdEle5.id = "idrate" + tablerowscount;
                trEle.appendChild(tdEle5);

                var tdEle6 = document.createElement('td'); //Sub Total
                tdEle6.id = "idsubtotal" + tablerowscount;
                tdEle1.style = "display:none;";
                tdEle6.innerHTML = (parseFloat(rate) * parseFloat(quantity));
                trEle.appendChild(tdEle6);

                var tdEle7 = document.createElement('td');
                //        tdEle8.innerHTML="<p class=\"btn btn-info\" onClick=\"showeditrecord("+tablerowscount+")\"><span class=\"glyphicon glyphicon-pencil\"></span>&nbsp;Edit</p>\n\<p class=\"btn btn-danger\" onClick=\"cancelrecord("+tablerowscount+")\"><span class=\"glyphicon glyphicon-trash\"></span>&nbsp;Delete</p>";
                tdEle7.innerHTML = "<p class=\"btn btn-danger\" onClick=\"cancelrecord(" + tablerowscount + ")\"><span class=\"glyphicon glyphicon-trash\"></span>&nbsp;Delete</p>";
                trEle.appendChild(tdEle7);

                $('#orderdetailtablelist').append(trEle);

                //            document.getElementById("orderform").reset(); // Resetform
                resetform();
                $('#menuitem').focus();
            } else {
                alert(validationMsg);
            }
        }

        function cancelrecord(recordno) {
            //        alert(recordno);
            $('#orderdetailtablelist tbody tr#row' + recordno).remove();
        }
        function resetform() {
            document.getElementById("orderform").reset();
            $('#menuitemid').val("");
            $('#menuitem').focus();
            //document.getElementById(orderform.menuitem).autofocus;
            //document.forms['tablefrm'].elements['menuitem'].focus();

        }
    </script>
</body>
</html>
