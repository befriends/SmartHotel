
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
%>
<%
    if(session.getAttribute("UserName") == null){
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>User</title>
    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
<!--    style for menu
    <link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>
    <script type="text/javascript" src="js/jquery.js"></script> 
    script for menu
    <script type="text/javascript" src="js/responsivemultimenu.js"></script>-->
    <script src="js/jquery.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/jquery.min.js"></script>
    <!--<script type="text/javascript" src="js/calendar.js"></script>-->
     <link href = "css/jquery-ui.css"rel = "stylesheet">
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
                    alert(" Expense Date may not be blank");
                    return false;
                } else if (document.getElementById("materialnm").options[document.getElementById("materialnm").selectedIndex].value == "") {
                    alert("plz select Material Name");
                    return false;
                }else if (document.getElementById("quantity").value == "") {
                    alert("Quantity may not be blank.");
                    return false;
                }
        }
         function resetform(){
        document.getElementById("orderform").reset();
    }
    function loadSubCategory() {
        var d = document.getElementById("qty").value;
        document.setElementById("orderform.valueOf(quantity1)").value==d;
       
        return false;
    }
    
      $(document).ready(function()
            {
                $("#demo").datepicker({
                    dateFormat: 'dd/mm/yy'
                });
            });
    
    

// $('#materialname').multiselect();
 
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
                            params.put("submodule", "expence"); // Database Table Name
                            params.put("columnname", "expenceid"); // Database Column Name
                            CommonDao commonDaoObj = new CommonDaoImpl();
                            String id = commonDaoObj.generateNextID(params);

                            PurchaseMaterialDao purchasematerialDAOObj = new PurchaseMaterialDaoImpl();
                            
                            JSONObject jsonList = purchasematerialDAOObj.getMaterialList();
                        %>
                        <%!
                            JSONObject jobj = null;
                        %>


                        <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Expense Material Entry</span>

                        <div>
                            <fieldset style="border:1px solid silver; padding:5px;">
                                <form role="form" id="orderform" class="form-horizontal" action="PurchaseMaterialController" method="post" onkeypress="myFunction()" onsubmit="return validate()">

                                    <div class="form-group">
                                        <label for="purchasematerialid" class="control-label col-sm-3">Expense Material ID: </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="userid" name="customid" value="<%=id%>" readonly="true" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="purchasematerialdate" class="control-label col-sm-3">Expense date</label>
                                        <div class="col-sm-8">
                                            <input class="date-picker" type="text" placeholder="Enter Purchase Date" name="datepicker1" value="" id="demo" required=""/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="materialnm"class="control-label col-sm-3">Material Name:</label>
                                        <div class="col-sm-8">
                                            <select class="form-control" id="materialnm" placeholder="Select Material Name"  name="materialid" autofocus="" onchange="loadSubCategory();" required="">
                                                <option value="">--- Select Material ---</option>
                                                <%
                                                    JSONArray jarr = jsonList.getJSONArray("data");
                                                        String qty="";

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
                                    
<!--                                    <div class="form-group">
                                        <label for="quantity" class="control-label col-sm-3">Available Quantity : </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control"  id="quantity1" placeholder="Quantity " name="quantity1"required=""/>
                                        </div>
                                    </div>-->
                                    
                                    <div class="form-group">
                                        <label for="quantity" class="control-label col-sm-3">Quantity : </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="quantity" placeholder="Enter Quantity " name="quantity" required=""/>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group"> 
                                        <div class="col-sm-offset-2 col-sm-5">
                                            <button type="submit" name="submit" value="Add" class="btn btn-default">Add Expence Material</button>
                                            <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location='home.jsp'">Cancel</button>
                                            <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                        </div>
                                    </div>
                                    <input type="hidden" name="act" value="1" />
                                    <input type="hidden" name="submodule" value="expencematerial" />


                                </form>
                            </fieldset>
<!--                            <table class="table table-bordered table-hover">
                                <thead>
                                    <tr class="danger">
                                        <th style="display: none;">ID</th>
                                        <th>Purchase date</th>
                                        <th>Material Name</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Total Amount</th>
                                        <th>Description</th>
                                        <th>IsInStock</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%  String userList = purchasematerialDAOObj.getPurchaseMaterialList();
                                        JSONArray userarr = new JSONArray(userList);
                                        int cnt = 0;
                                        while (cnt < userarr.length()) {
                                            JSONObject obj = userarr.getJSONObject(cnt);
                                    %>
                                <form id="form<%=cnt%>" name="form<%=cnt%>" action="" method="POST">
                                    <tr class="success">
                                        <td style="display: none;">
                                            <input type="hidden" name="purchasematerialid" value="<%=obj.getLong("purchasematerialid")%>" readonly />
                                            <input type="hidden" name="submodule" value="purchasematerial" readonly />
                                        </td>
                                        <td>
                                            <input type="text" name="purchasematerialdate" hidden="true" value="<%=obj.get("purchasematerialdate")%>" readonly /><%=obj.get("purchasematerialdate")%>
                                        </td>

                                        <td>
                                            <input type="text" name="purchasematerialname" hidden="true" value="<%=obj.get("purchasematerialname")%>" readonly /><%=obj.get("purchasematerialname")%>
                                        </td>

                                        <td>
                                            <input type="text" name="price" hidden="true" value="<%=obj.get("price")%>" readonly /><%=obj.get("price")%>
                                        </td>

                                        <td>
                                            <input type="text" name="quantity" hidden="true" value="<%=obj.get("quantity")%>" readonly /><%=obj.get("quantity")%>
                                        </td>
                                        <td>
                                            <input type="text" name="totalamount" hidden="true" value="<%=obj.get("totalamount")%>" readonly /><%=obj.get("totalamount")%>
                                        </td>
                                        <td>
                                            <input type="text" name="desription" hidden="true" value="<%=obj.get("desription")%>" readonly /><%=obj.get("desription")%>
                                        </td>
                                        <td>
                                            <input type="text" name="isinstock" hidden="true" value="<%=obj.get("isinstock")%>" readonly /><%=obj.get("isinstock")%>
                                        </td>
                                        <td>
                                            <a href="#" class="btn btn-info btn-sm" onclick="submitUpdateForm(<%=cnt%>);">
                                                <span class="glyphicon glyphicon-pencil"></span> Update
                                            </a> 

                                            <a href="#" class="btn btn-danger btn-sm" onclick="submitDeleteForm(<%=cnt%>);">
                                                <span class="glyphicon glyphicon-remove"></span> Delete
                                            </a>

                                        </td>
                                    </tr>
                                </form>
                                <%
                                        cnt++;
                                    }
                                %>
                                </tbody>
                            </table>-->
                        </div>

                    </div>
                </div>
            </div>
                </body>
                </html>
