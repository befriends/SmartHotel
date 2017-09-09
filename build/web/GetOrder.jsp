
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
        <title>Get Order</title>
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <!--style for menu-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->

        <!--script for menu-->
        <script type="text/javascript" src="js/responsivemultimenu.js"></script>

        <script type="text/javascript" src="js/jquery.js"></script> 
        <!--script for menu-->
        <script type="text/javascript" src="js/responsivemultimenu.js"></script>

        <script src="js/bootstrap.min.js"></script>
        <script src="js/commonFunctions.js"></script>
        <link rel="stylesheet" href="css/jquery-ui.css">
        <!--<script src="https://code.jquery.com/jquery-1.12.4.js"></script>-->
        <script src="js/jquery-ui.js"></script>
        <!--  <script>
          $( function() {
            var availableTags = [
              "ActionScript",
              "AppleScript",
              "Asp",
              "BASIC",
              "C",
              "C++",
              "Clojure",
              "COBOL",
              "ColdFusion",
              "Erlang",
              "Fortran",
              "Groovy",
              "Haskell",
              "Java",
              "JavaScript",
              "Lisp",
              "Perl",
              "PHP",
              "Python",
              "Ruby",
              "Scala",
              "Scheme"
            ];
            $( "#tags" ).autocomplete({
              source: availableTags
            });
          } );
          </script>-->
        <script type="text/javascript" lang="javascript">
            $(document).ready(function() {
//                jQuery.extend(jQuery.expr[':'], {
//                    focusable: function(el, index, selector) {
//                        return $(el).is('a, button, :input, [tabindex]');
//                    }
//                });

                $(document).keyup(function(e) {
                    switch (e.which) {
                        case 45 :
                            {//Insert
                                var ans = confirm("Do you want to Proceed Order?");
                                if (ans) {
                                    $("#proceedorder").click();
                                }
                            }
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
            <!--  Header  -->
            <div class="container-fluid">
                <!--<img src="images/header.jpg" class="img-rounded" width="100%" height="100px">-->
            </div>

            <!--  Body  -->
            <div class="container-fluid">

                <div style="margin-left: auto; margin-right: auto; width: 100%; background-color: antiquewhite;">
                    <%
                        if (request.getParameter("result") != "" && request.getParameter("result") != null) {
                            JSONObject jobj = new JSONObject(request.getParameter("result"));
                            message = jobj.getString("message");
                            if (jobj.getBoolean("success")) {
                    %><div class="alert alert-success fade in">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                        <strong><%=message%></strong>
                    </div><%
                    } else {
                    %><div class="alert alert-danger fade in">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                        <strong><%=message%></strong>
                    </div><%
                            }
                        }

                        HashMap<String, String> params = new HashMap<String, String>();
                        MenuItemDao menuItemDaoObj = new MenuItemDaoImpl();
                        JSONObject jsonList = menuItemDaoObj.getMessageList();
                    %>
                    <%!
                        JSONObject jobj = null;
                    %>
                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Get Order </span>
                    <div>
                        <fieldset style="border:1px solid silver; padding:5px;">
                            <form id="tableform" role="form" class="form-horizontal" autocomplete="off" name="tablefrm">
                                <div class="form-group">
                                    <label for="tableno" class="control-label col-sm-2">Table : </label>
                                    <div class="col-sm-8">
                                        <select name="tableno" id="tableno" style="width: 250px;" class="from-control selectpicker" autofocus="true" required="">
                                            <option>--Select Table--</option>
                                        </select>
                                    </div>
                                </div>
<!--                                <div class="form-group">
                                    <label for="menuitem" class="control-label col-sm-2">Table : </label>
                                    <div class="col-sm-8">
                                        <input id="tableno" type="text" class="form-control" name="tableno" onblur="selecttablename()"  placeholder="Select Table" required="">
                                        <input type="hidden" class="form-control" id="tableid" name="tableid" readonly="true" required="true"/>
                                    </div>
                                </div>-->
                            </form>
                            <form id="orderform" role="form" class="form-horizontal" name="orderfrm" action="OrderController" method="post">
                                <div class="form-group">
                                    <label for="customid" class="control-label col-sm-2">Custom ID : </label>
                                    <div class="col-sm-8">
                                        <input id="customid" type="text" class="form-control" style="width: 250px;" name="customid" onblur="selectcustomid()" placeholder="Enter Custome ID" required="">
                                        <!--<input type="hidden" class="form-control" id="menuitemid" name="menuitemid" readonly="true" required="true"/>-->
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="menuitem" class="control-label col-sm-2">Menu Item : </label>
                                    <div class="col-sm-8">
                                        <input id="menuitem" type="text" class="form-control" style="width: 250px;"  name="menuitem" onblur="selectmenuitem()" onkeyup="searchmenu()" placeholder="Enter Menu Item" required="" keyup="searchmenu()">
                                        <input type="hidden" class="form-control" id="menuitemid" name="menuitemid" readonly="true" required="true"/>
                                    </div>
                                </div>
                                <!--                                    <div class="form-group">
                                                                        <label for="menuitem" class="control-label col-sm-2">Menu Item : </label>
                                                                        <div class="col-sm-8">
                                                                            <input type="hidden" class="form-control" id="menuitemid" name="menuitemid" readonly="true"/>
                                                                            <input type="text" class="form-control" id="menuitem" onkeyup="getsortedmenuitems()" onblur="removelist()" name="menuitem" placeholder="Enter Menu Item" required=""/>
                                                                            <div id="menuitemlist"></div>
                                                                        </div>
                                                                    </div>-->
                                <div class="form-group">
                                    <label for="message" class="control-label col-sm-2">Message : </label>
                                    <div class="col-sm-8">
                                        <select class="form-control" id="messageid" style="width: 250px;" name="messageid" required="">
                                            <option>---Select Message---</option>
                                            <%
//                                                    JSONArray jarr = jsonList.getJSONArray("data");
//                                                    for (int cnt = 0; cnt < jarr.length(); cnt++) {
//                                                        jobj = jarr.getJSONObject(cnt);
//                                                %>
                                            <%
                                                //}
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="quantity" class="control-label col-sm-2">Quantity : </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" style="width: 250px;" id="quantity" value="1" placeholder="Qty" name="quantity" required=""/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="rate" class="control-label col-sm-2">Rate : </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" style="width: 250px;" id="rate" name="rate" readonly="true" placeholder="0.0" required=""/>
                                    </div>
                                </div>

                                <div class="form-group"> 
                                    <div class="col-sm-offset-2 col-sm-5">
                                        <button type="button" name="submit" onclick="addtolist()" value="Add" class="btn btn-default" >Add to List</button>
                                        <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                    </div>
                                </div>
                                <input type="hidden" name="act" value="1" />
                            </form>
                        </fieldset>

                        <table class="table table-condensed table-bordered table-hover" id="ordertablelist" style="table-layout:fixed;" id="tbl">
                            <thead>
                                <tr class="">
                                    <th style="display: none;">Menu Item ID</th>
                                    <th style="width: 7%;">S. No.</th>
                                    <th style="width: 23%;">Menu Item</th>
                                    <th style="width: 10%;">Message</th>
                                    <th style="width: 10%;">Qty</th>
                                    <th style="width: 15%;">Rate</th>
                                    <th style="width: 15%;">Sub-Total</th>
                                    <th style="width: 20%;">Action</th>
                                </tr>
                            </thead>

                            <tbody style="">

                            </tbody>
                        </table>

                    </div>
                    <div style="text-align: center;padding-bottom: 2%;">
                        <button type="button" name="submit" value="Submit" id="proceedorder" onclick="proceedorder()" accesskey="z" class="btn btn-info">Proceed Order</button>
                        <a href="GetOrder.jsp"><button type="button" name="cancel" value="Cancel" class="btn btn-default">Cancel Order</button></a>
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

                //getting tables
                $.ajax({
                    url: "TableController?act=4&value=", // act=4 => action 4 is for getting record from DB.
                    context: document.body,
                    success: function(responseObj) {
                        tablestore = responseObj;
                        var tablejarr = JSON.parse(tablestore).data;
                        var tableEle = $('#tableno');                        
                        for (var c = 0; c < tablejarr.length; c++) {
                            var tablejobj = tablejarr[c];
                            var tableid = tablejobj.tableid;
                            var tableno = tablejobj.tableno;
                            var tablename = tablejobj.tablename;
                            var isbooked = tablejobj.isbooked;
                            var isreserved = tablejobj.isreserved;
                            

                            //                if(isbooked === 0){
                            var optionEle = document.createElement('option');
                            optionEle.value = tableid;
                            optionEle.isbooked = isbooked;
                            //                optionEle.textContent = tablename+" ("+tableno+")";
                            optionEle.textContent = tablename;

                            tableEle.append(optionEle);
                            //                }
                        }
                       
                    }
                });

                $("#quantity").keydown(function(e)
                {
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
            //
            //    function getsortedmenuitems(){
            //        var menuitemjarr = JSON.parse(menuitemstore).data;
            //        
            //        var itemListEle = $('#menuitemlist');
            //        itemListEle.empty();
            //        if(menuitemjarr.length>0){
            //            itemListEle.css('display','block');
            //        }
            //        var c;
            //        for(c = 0; c < menuitemjarr.length; c++){
            //            var menuitemjobj = menuitemjarr[c];
            //            var value = $('#menuitem').val().toLowerCase();
            //            var tempVal = menuitemjobj.menuitemname.toLowerCase();
            //            if(tempVal.contains(value)){
            //                var divEle = document.createElement('div');
            //                divEle.className="menuitemli";
            //                divEle.id="menuitemli"+c;
            //                divEle.value=menuitemjobj.menuitemid;
            //                divEle.innerHTML="<item>"+menuitemjobj.menuitemname+"</item><br><itemrate style=\"font-size:9px;\">Rate: <rate>"+menuitemjobj.rate+"</rate> Rs.</itemrate>";
            //                divEle.addEventListener('mousedown', selectmenuitem, false);
            //                itemListEle.append(divEle);
            //            }
            //        }
            //    }

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
                $('#menuitem').val("");
                $('#customid').val("");
            }

            function removelist() {
                $('#menuitemlist').css('display', 'none');
            }

            function addtolist() {
                var menuitemid = $('#menuitemid').val();
                var menuitem = $('#menuitem').val();
                var message = $('#messageid')[0].selectedIndex === 0 ? "" : $('#messageid')[0].selectedOptions[0].innerHTML;

                var quantity = $('#quantity').val();
                if (quantity.trim().indexOf(" ") >= 0) {
                    alert('Space not allows in quantity field.');
                    $('#quantity').val('1');
                    $('#quantity').focus();
                    return false;
                }
                var rate = $('#rate').val();
                var tablerowscount = $('#ordertablelist').children()[1].children.length; //children()[1] - is always tbody child

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

                    var tdEle4 = document.createElement('td'); //Message
                    tdEle4.innerHTML = message;
                    tdEle4.id = "idmessage" + tablerowscount;
                    trEle.appendChild(tdEle4);

                    var tdEle5 = document.createElement('td'); //Quantity
                    tdEle5.innerHTML = quantity;
                    tdEle5.id = "idquantity" + tablerowscount;
                    trEle.appendChild(tdEle5);

                    var tdEle6 = document.createElement('td'); //Rate
                    tdEle6.innerHTML = rate;
                    tdEle6.id = "idrate" + tablerowscount;
                    trEle.appendChild(tdEle6);

                    var tdEle7 = document.createElement('td'); //Sub Total
                    tdEle7.id = "idsubtotal" + tablerowscount;
                    tdEle7.innerHTML = (parseFloat(rate) * parseFloat(quantity));
                    trEle.appendChild(tdEle7);

                    var tdEle8 = document.createElement('td');
                    //        tdEle8.innerHTML="<p class=\"btn btn-info\" onClick=\"showeditrecord("+tablerowscount+")\"><span class=\"glyphicon glyphicon-pencil\"></span>&nbsp;Edit</p>\n\<p class=\"btn btn-danger\" onClick=\"cancelrecord("+tablerowscount+")\"><span class=\"glyphicon glyphicon-trash\"></span>&nbsp;Delete</p>";
                    tdEle8.innerHTML = "<p class=\"btn btn-danger\" onClick=\"cancelrecord(" + tablerowscount + ")\"><span class=\"glyphicon glyphicon-trash\"></span>&nbsp;Delete</p>";
                    trEle.appendChild(tdEle8);

                    $('#ordertablelist').append(trEle);

                    //            document.getElementById("orderform").reset(); // Resetform
                    resetform();
                    $('#menuitem').focus();
                } else {
                    alert(validationMsg);
                }
            }

            function cancelrecord(recordno) {
                //        alert(recordno);
                $('#ordertablelist tbody tr#row' + recordno).remove();
            }

            function resetform() {
                document.getElementById("orderform").reset();
                $('#menuitemid').val("");
                $('#menuitem').focus();
                //document.getElementById(orderform.menuitem).autofocus;
                //document.forms['tablefrm'].elements['menuitem'].focus();

            }

            function proceedorder() {
                var ordertable = $('#ordertablelist tbody tr');
                var cnt;
                var menuitemidlist = "";
                var jsonarr = [];

                if (ordertable.length > 0) {
                    for (cnt = 0; cnt < ordertable.length; cnt++) {
                        var trEle = $('#ordertablelist tbody tr[id=row' + cnt + ']');
                        var menuitemid = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idmenuitem' + cnt + ']').text();
                        var message = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idmessage' + cnt + ']').text();
                        var quantity = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idquantity' + cnt + ']').text();
                        var rate = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idrate' + cnt + ']').text();
                        var subtotal = $('#ordertablelist tbody tr[id=row' + cnt + '] td[id=idsubtotal' + cnt + ']').text();

                        var jsonobj = {};
                        jsonobj["menuitemid"] = menuitemid;
                        jsonobj["message"] = message;
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
                     if ($('#tableno :selected')[0].index === 0) {
                        alert("Please select table for proceed order.");
                        return false;
                    }
                    orderjsonlist ["tableid"] = $('#tableno :selected').val();
                    var tno = $('#tableno :selected').text();
                    //            orderjsonlist ["tableno"] = tno.substr(tno.length-7,6);
                    orderjsonlist ["tableno"] = tno;
                    var status = $('#tableno :selected')[0].isbooked;

                    var isbooked = false;
                    if (status === 1) {
                        isbooked = true;
                    }

                    $.ajax({
                        url: "OrderController",
                        context: document.body,
                        method: "POST",
                        data: {
                            act: 1, // act=1 => action 1 is for saving order to DB.
                            isbooked: isbooked,
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
        </script>
        <script type="text/javascript" src="js/GridViewController.js"></script>     
    </body>
</html>
