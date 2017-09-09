
<%@page import="DaoImpl.PurchaseMaterialDaoImpl"%>
<%@page import="Dao.PurchaseMaterialDao"%>
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
    if(session.getAttribute("UserName") == null){
        response.sendRedirect("login.jsp");
    }
    if(session.getAttribute("UserID") != null){
        userID = session.getAttribute("UserID").toString();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MenuItem Composition</title>
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
        <link rel="stylesheet" href="css/jquery-ui.css">
          <!--<script src="https://code.jquery.com/jquery-1.12.4.js"></script>-->
  <script src="js/jquery-ui.js"></script>        
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
        <script type="text/javascript" lang="javascript">
            
             $(document).ready(function() {
//                jQuery.extend(jQuery.expr[':'], {
//                    focusable: function(el, index, selector) {
//                        return $(el).is('a, button, :input, [tabindex]');
//                    }
//                });

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
                            <strong><%=message %></strong>
                        </div><%
                        } else {
                        %><div class="alert alert-danger fade in">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                            <strong><%=message %></strong>
                        </div><%
                                }
                            }
                    %>
                    <%!
                        JSONObject jobj = null;                                             
                    %>
                        <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Product Composition </span>
                        <div>
                            <fieldset style="border:1px solid silver; padding:5px;">
                                <form id="menuitemform" role="form" class="form-horizontal" autocomplete="off" name="menuitemform">
                                <div class="form-group">
                                  <label for="menuitem" class="control-label col-sm-3">Menu Item : </label>
                                  <div class="col-sm-8">
                                      <input id="menuitem" type="text" class="form-control" name="menuitem" onblur="selectmenuitem()" placeholder="Enter Menu Item" required="">
                                      <input type="hidden" class="form-control" id="menuitemid" name="menuitemid" readonly="true" required="true"/>
                                  </div>
                                </div>
                                </form>
                                <form id="compositionform" role="form" class="form-horizontal" name="compositionform" action="OrderController" method="post">
                                    <div class="form-group">
                                        <label for="materialnm"class="control-label col-sm-3">Material Name : </label>
                                        <div class="col-sm-8">
                                            <select class="form-control" id="materialnm" placeholder="Select Material Name"  name="materialid" autofocus="" required="">
                                                <option value=""> Select Material</option>
                                                <%
                                                    PurchaseMaterialDao purchasematerialDAOObj = new PurchaseMaterialDaoImpl();
                                                    JSONObject jsonList = purchasematerialDAOObj.getMaterialList();
                                                    JSONArray jarr = jsonList.getJSONArray("data");

                                                    for (int cnt = 0; cnt < jarr.length(); cnt++) {
                                                        jobj = jarr.getJSONObject(cnt);

                                                %>
                                                <option value="<%=jobj.getLong("materialid")%>"><%=jobj.getString("materialname")%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            <label class="text-center col-sm-12" style="font-size: 10px;"><i>(<b>Note</b>: You can only select 3 materials for composition.)</i></label>    
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="quantity" class="control-label col-sm-3">Quantity : </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="quantity" value="" placeholder="0.00" name="quantity" required=""/>
                                        </div>
                                    </div>
                                    <div class="form-group"> 
                                        <div class="col-sm-offset-2 col-sm-5">
                                            <button type="button" name="submit" onclick="addtolist()" value="Add" class="btn btn-default" >Add to List</button>
                                            <!--<button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>-->
                                        </div>
                                    </div>
                                    <input type="hidden" name="act" value="1" />
                                </form>
                            </fieldset>
                
                <table class="table table-condensed table-bordered table-hover" id="compositionlist" style="table-layout:fixed;" id="tbl">
		<thead>
                <tr class="">
                <th style="display: none;">Menu Item ID</th>
                <th style="width: 7%;">S. No.</th>
                <th style="width: 63%;">Material</th>
                <th style="width: 10%;">Qty</th>
                <th style="width: 20%;">Action</th>
                </tr>
                </thead>
                
                <tbody style="">
                
		</tbody>
	</table>
                                
                        </div>
                        <div style="text-align: center;padding-bottom: 2%;">
                            <button type="button" name="submit" value="Submit" onclick="proceedcomposition()" class="btn btn-info">Save Composition</button>
                            <a href="_self"><button type="button" name="cancel" value="Cancel" class="btn btn-default">Cancel</button></a>
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
    $( document ).ready(function() {
        //getting menuitems list
        $.ajax({
        url: "OrderController?act=4&value=", // act=4 => action 4 is for getting record from DB.
        context: document.body,
        success: function(responseObj) {
            menuitemstore = responseObj;
            var menuitemjarr = JSON.parse(menuitemstore).data;
            var menuitemlist = [];
            
            for(var c = 0; c < menuitemjarr.length; c++){
                var menuitemjobj = menuitemjarr[c];
                var tempVal = menuitemjobj.menuitemname;
                menuitemlist[c] = tempVal;
            }
            
            $( "#menuitem" ).autocomplete({
              source: menuitemlist,
              minLength: 0
            }).focus(function(){     
                $(this).autocomplete("search");
            });
        }
        });

    });

    function selectmenuitem(rec){
        var menuitemjarr = JSON.parse(menuitemstore).data;
        var selectedMenuName = $('#menuitem').val();
        var isMenuitemSelected = false;
        for(var cnt = 0; cnt < menuitemjarr.length; cnt++){
            var menuitemjobj = menuitemjarr[cnt];
            var menuname = menuitemjobj.menuitemname;
            if(menuname === selectedMenuName){
                $('#menuitemid').val(menuitemjobj.menuitemid);
                isMenuitemSelected = true;
            }
        }
        
        if(isMenuitemSelected){
            loadcompositiongrid(selectedMenuName, $('#menuitemid').val());
        }
    }
    
    function loadcompositiongrid(selectedMenuName, selectedMenuId){
        
        $.ajax({
            url: "PurchaseMaterialController",
            context: document.body,
            method: "POST",
            data:{
                act: 4,
                submodule: "composition",
                menuname : selectedMenuName,
                menuid : selectedMenuId
            },
            success: function(responseObj) {
                var response = JSON.parse(responseObj);
                var data = response.data;
                
                for(var row = 0; row < data.length; row++){
                    var materialid = data[row].materialid;
                    var materialname = data[row].materialname;
                    var quantity = data[row].quantity;

                    var trEle = document.createElement('tr');
                    trEle.className="success";
                    trEle.id="row"+row;

                    var tdEle1 = document.createElement('td'); //MaterialID
                    tdEle1.innerHTML=materialid;
                    tdEle1.id="idmaterial"+row;
                    tdEle1.style="display:none;";
                    trEle.appendChild(tdEle1);

                    var tdEle2 = document.createElement('td'); //Sr.No.
                    tdEle2.innerHTML=row+1;
                    trEle.appendChild(tdEle2);

                    var tdEle3 = document.createElement('td'); //Material Name
                    tdEle3.innerHTML=materialname;
                    trEle.appendChild(tdEle3);

                    var tdEle4 = document.createElement('td'); //Quantity
                    tdEle4.innerHTML=parseFloat(quantity).toFixed(2);
                    tdEle4.id="idquantity"+row;
                    trEle.appendChild(tdEle4);

                    var tdEle5 = document.createElement('td');
                    tdEle5.innerHTML="<p class=\"btn btn-danger\" onClick=\"cancelrecord("+row+")\"><span class=\"glyphicon glyphicon-trash\"></span>&nbsp;Delete</p>";
                    trEle.appendChild(tdEle5);

                    $('#compositionlist').append(trEle);
                }
                
                if(data.length === 0){
                    $('#compositionlist tbody').html("");
                }
            }
        });
        
    }

    function addtolist(){
        var materialid = $('#materialnm :selected').val();
        var materialname = $('#materialnm :selected').text();
        
        var quantity = $('#quantity').val();
        var tablerowscount = $('#compositionlist').children()[1].children.length; //children()[1] - is always tbody child
        
        var isValidForm = true;
        var validationMsg = "";
        if(materialid === "" || materialname === ""){
            isValidForm = false;
            validationMsg = "Please select Material first.";
            $('#materialnm').focus();
        } else if(quantity === "" || parseFloat(quantity) <= 0){
            isValidForm = false;
            validationMsg = "Please enter quantity first. Quantity can not be empty or zero(0) or negative";
            $('#quantity').val("");
            $('#quantity').focus();
        }
        
        if($('#compositionlist tbody tr').length === 3){
            alert("You can't add more than 3 materials for composition.");
            return false;
        }
        
        if(isValidForm){
            var trEle = document.createElement('tr');
            trEle.className="success";
            trEle.id="row"+tablerowscount;

            var tdEle1 = document.createElement('td'); //MaterialID
            tdEle1.innerHTML=materialid;
            tdEle1.id="idmaterial"+tablerowscount;
            tdEle1.style="display:none;";
            trEle.appendChild(tdEle1);

            var tdEle2 = document.createElement('td'); //Sr.No.
            tdEle2.innerHTML=parseInt(tablerowscount)+1;
            trEle.appendChild(tdEle2);

            var tdEle3 = document.createElement('td'); //Material Name
            tdEle3.innerHTML=materialname;
            trEle.appendChild(tdEle3);

            var tdEle4 = document.createElement('td'); //Quantity
            tdEle4.innerHTML=parseFloat(quantity).toFixed(2);
            tdEle4.id="idquantity"+tablerowscount;
            trEle.appendChild(tdEle4);

            var tdEle5 = document.createElement('td');
    //        tdEle8.innerHTML="<p class=\"btn btn-info\" onClick=\"showeditrecord("+tablerowscount+")\"><span class=\"glyphicon glyphicon-pencil\"></span>&nbsp;Edit</p>\n\<p class=\"btn btn-danger\" onClick=\"cancelrecord("+tablerowscount+")\"><span class=\"glyphicon glyphicon-trash\"></span>&nbsp;Delete</p>";
            tdEle5.innerHTML="<p class=\"btn btn-danger\" onClick=\"cancelrecord("+tablerowscount+")\"><span class=\"glyphicon glyphicon-trash\"></span>&nbsp;Delete</p>";
            trEle.appendChild(tdEle5);

            $('#compositionlist').append(trEle);

//            document.getElementById("compositionform").reset(); // Resetform
            resetform();
            $('#material').focus();
        } else{
            alert(validationMsg);
        }
    }
    
    function cancelrecord(recordno){
//        alert(recordno);
        $('#compositionlist tbody tr#row'+recordno).remove();
    }
    
//    function resetform(){
//        document.getElementById("compositionform").reset();
//        $('#materialid').val("");
//        $('#materialnm').focus();
//        //document.getElementById(compositionform.material).autofocus;
//        //document.forms['tablefrm'].elements['material'].focus();
//
//    }
    
    function proceedcomposition(){
        var compositiontable = $('#compositionlist tbody tr');
        var cnt;
        var jsonarr = [];
        
//        if(compositiontable.length > 0){
            for(cnt=0; cnt<compositiontable.length ;cnt++){
                var rowno = $('#compositionlist tbody tr')[cnt].id.replace("row","");
                var materialid = $('#compositionlist tbody tr[id=row'+rowno+'] td[id=idmaterial'+rowno+']').text();
                var quantity = $('#compositionlist tbody tr[id=row'+rowno+'] td[id=idquantity'+rowno+']').text();

//                if(materialid !== ""){
                    var jsonobj = {};
                    jsonobj["materialid"] = materialid;
                    jsonobj["quantity"] = quantity;
                    jsonarr.push(jsonobj);
//                }
            }
            var compositionjsonlist = {};
            compositionjsonlist ["data"] = jsonarr;
            compositionjsonlist ["userid"] = "<%=userID%>";
            if($('#menuitemid').val() === ""){
                alert("Please select Menuitem for save composition.");
                return false;
            }
            compositionjsonlist ["menuitemid"] = $('#menuitemid').val();
            var menuitem = $('#menuitem').val();
            compositionjsonlist ["menuitem"] = menuitem;

            $.ajax({
                url: "PurchaseMaterialController",
                context: document.body,
                method: "POST",
                data:{
                    act: 1, // act=1 => action 1 is for saving order to DB.
                    submodule: "composition",
                    compositionlistjson : JSON.stringify(compositionjsonlist)
                },
                success: function(responseObj) {
                    alert('Composition updated successfully.');
                    location.reload();
                }
            });
//        } else{
//            alert("Composition list is empty. Please add material's to composition list.");
//        }
    }
</script>
<script type="text/javascript" src="js/GridViewController.js"></script>     
    </body>
</html>
