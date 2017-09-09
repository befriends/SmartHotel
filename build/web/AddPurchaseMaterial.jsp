
<%@page import="DaoImpl.PurchaseMaterialDaoImpl"%>
<%@page import="Dao.PurchaseMaterialDao"%>
<%@page import="Dao.PurchaseMaterialDao"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String message = "";
    boolean messageflag= false;
%>
<%
    if (session.getAttribute("UserName") == null) {
        response.sendRedirect("login.jsp");
    }else{
        if(session.getAttribute("messagenotificationflag") != null){
        messageflag = (Boolean) session.getAttribute("messagenotificationflag");
        
    }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Purchase Material</title>
        <script type="text/javascript" src="js/jquery.js"></script> 
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <!--style for menu-->
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
        <!--script for menu-->
        <!--<script type="text/javascript" src="js/responsivemultimenu.js"></script>-->
        <script type="text/javascript" src="js/bootstrap.min.js"></script>
        <!--<script type="text/javascript" src="js/calendar.js"></script>-->
        <link href = "css/jquery-ui.css"
         rel = "stylesheet">
      <script src = "js/jquery.js"></script>
      <script src = "js/jquery-ui.js"></script>
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
            function myFunction() {
                var d = new Date();
                d.setDate();
                document.getElementById("demo").innerHTML = d;
            }
            function validate() {

                if (document.getElementById("demo").value == "") {
                    alert(" Purchase Date may not be blank");
                    return false;
                } else if (document.getElementById("materialnm").options[document.getElementById("materialnm").selectedIndex].value == "") {
                    alert("plz select Material Name");
                    return false;
                } else if (document.getElementById("price").value == "") {
                    alert("price may not be blank.");
                    return false;
                }

                else if (document.getElementById("quantity").value == "") {
                    alert("Quantity may not be blank.");
                    return false;
                }
                else if (document.getElementById("totalamount").value == "") {
                    alert("Total Amount may not be blank.");
                    return false;
                }
            }
            function resetform() {
                document.getElementById("orderform").reset();
            }
             $(document).ready(function()
            {
                $("#demo").datepicker({
                    dateFormat: 'dd/mm/yy'
                });
            });
            
//            $(document).ready(function() {
//
//                $("#quantity").keyup(function() {
//                    var p = parseInt($("#price").val());
//                    var q = parseInt($("#quantity").val());
//                    var d = parseInt($("#discount").val());
////             var a=parseInt(a)/parseInt(b);
//                    var a = p - (d / 100) * p;
//                    var tot = a * q;
//                    //var final= cal.toFixed(2);
//
//                    $("#totalamount").val(tot);
//                });
//
//
//            });
            
            $(document).ready(function(){
                $("#quantity").change(function() {
                    if($("#quantity").val() !== "0" && $("#quantity").val() !== ""){
                        var price = parseInt($("#price").val());
                        var qty = parseInt($("#quantity").val());
                        var discount = parseInt($("#discount").val());
                        var priceAfterDisc = 0;
                        var subtotal = qty * price;
                        if($("#percentage")[0].checked){
                            priceAfterDisc = subtotal - (subtotal * (discount / 100));
                        } else if($("#rupees")[0].checked){
                            priceAfterDisc = subtotal - discount;
                        }

                        $("#totalamount").val(priceAfterDisc);
                    }
                });
                $("#rupees").change(function() {
                    $("#quantity").change();
                });
                $("#percentage").change(function() {
                    $("#quantity").change();
                });
                $("#discount").change(function() {
                    if($("#discount").val() === ""){
                        $("#discount").val("0");
                    }
                    $("#quantity").change();
                });
                $("#price").change(function() {
                    if($("#price").val() === ""){
                        $("#price").val("0");
                    }
                    $("#quantity").change();
                });
            });
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

                        HashMap<String, String> params = new HashMap<String, String>();
                        params.put("submodule", "purchasematerial"); // Database Table Name
                        params.put("columnname", "purchasematerialid"); // Database Column Name
                        CommonDao commonDaoObj = new CommonDaoImpl();
                        String id = commonDaoObj.generateNextID(params);

                        PurchaseMaterialDao purchasematerialDAOObj = new PurchaseMaterialDaoImpl();

                        JSONObject jsonList = purchasematerialDAOObj.getMaterialList();
                    %>
                    <%!
                        JSONObject jobj = null;
                    %>


                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Purchase Material Entry</span>

                    <div>
                        <fieldset style="border:1px solid silver; padding:5px;">
                            <form role="form" id="orderform" class="form-horizontal" action="PurchaseMaterialController" method="post" onkeypress="myFunction()" onsubmit="return validate()">

                                <div class="form-group">
                                    <label for="purchasematerialid" class="control-label col-sm-3">Purchase Material ID: </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="userid" name="customid" value="<%=id%>" readonly="true" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="purchasematerialdate" class="control-label col-sm-3">Purchase date</label>
                                    <div class="col-sm-8">
                                        <input class="date-picker" type="text" placeholder="Enter Purchase Date" name="datepicker1" value="" id="demo" required=""/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="materialnm"class="control-label col-sm-3">Material Name:</label>
                                    <div class="col-sm-8">
                                        <select class="form-control" id="materialnm" placeholder="Select Material Name"  name="materialid" autofocus="" required="">
                                            <option value=""> Select Material</option>
                                            <%
                                                JSONArray jarr = jsonList.getJSONArray("data");

                                                for (int cnt = 0; cnt < jarr.length(); cnt++) {
                                                    jobj = jarr.getJSONObject(cnt);

                                            %>
                                            <option value="<%=jobj.getLong("materialid")%>"><%=jobj.getString("materialname")%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="price" class="control-label col-sm-3">Unit Price: </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="price" placeholder="Enter price per unit" name="price" value="0" required=""/>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="select" class="control-label col-sm-3" > Select : </label>
                                    <div class="col-sm-8">
                                        <div class="radio-inline">
                                            <label><input type="radio" class="form-control" id="percentage"  name="discountype" checked="true"/>Percentage</label>
                                        </div>
                                        <div class="radio-inline">
                                            <label><input type="radio" class="form-control" id="rupees" name="discountype" />Rupees</label>
                                        </div>
<!--                                                                                    <div class="radio-inline">
                                                                                        <label><input type="radio" class="form-control" id="gender" name="gender" value="o"/>Other</label>
                                                                                    </div>-->
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="discount" class="control-label col-sm-3">Discount: </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="discount" placeholder="Enter Total Discount" name="discount" value="0" required=""/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="quantity" class="control-label col-sm-3">Quantity : </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="quantity" placeholder="Enter Quantity " name="quantity" value="0" required=""/>
                                    </div>
                                </div>


                                <div class="form-group">
                                    <label for="totalamount" class="control-label col-sm-3">Amount: </label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="totalamount" placeholder="Enter Total Amount" name="totalamount" value="0" required="" readonly="true"/>
                                    </div>
                                </div>
                                        <input type="hidden" id="message" placeholder="" name="messageflag" value="<%=messageflag%>" hidden="true" readonly="true"/>

                                <div class="form-group"> 
                                    <div class="col-sm-offset-3 col-sm-5">
                                        <button type="submit" name="submit" value="Add" class="btn btn-default">Add</button>
                                        <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                        <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                    </div>
                                </div>
                                <input type="hidden" name="act" value="1" />
                                <input type="hidden" name="submodule" value="purchasematerial" />


                            </form>
                        </fieldset>
                        
                    </div>

                </div>
            </div>

    </body>
</html>
