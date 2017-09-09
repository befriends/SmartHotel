<%-- 
    Document   : SelectOrderDate
    Created on : 6 Sep, 2017
    Author     : sai
--%>

<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%!
    String message = "";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">        
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
         <script type="text/javascript" lang="javascript">


            $(document).ready(function() {

                $("#selectdate").datepicker({
                    dateFormat: 'dd/mm/yy',
//                    maxDate: new Date(),
                    onSelect: function() {
                        $.ajax({
                            url: "ReportController",
                            context: document.body,
                            method: "POST",
                            data: {
                                selectdate: $("#selectdate").val(),
                                act:1,
                                submodule: "datewiseorder"
                            },
                            success: function(responseObj) {
                                var response = JSON.parse(responseObj).data;
                                $("#billingdetailstable tr td").remove();
                                var billDetailsTable = $("#billingdetailstable");
                                var orderno = "", orderid = "";
                                var tablerowscount = $('#billingdetailstable').children()[1].children.length; //children()[1] - is always tbody child                           
                                for (var ind = 0; ind < response.length; ind++) {
                                    var tr = document.createElement("tr");
                                    tr.id = "row" + ind;
                                    var td1 = document.createElement("td");
                                    td1.innerHTML = ind + 1;
                                    tr.appendChild(td1);
                                    var td2 = document.createElement("td");
                                    td2.innerHTML = response[ind].orderno;
                                    td2.id = "idorderno" + ind;
                                    tr.appendChild(td2);
                                    var td3 = document.createElement("td");
                                    td3.innerHTML = response[ind].totalamount;
                                    tr.appendChild(td3);
                                    
                                    var td4 = document.createElement("td");
                                    td4.innerHTML = response[ind].orderid;
                                    td4.style = "display:none;";
                                    td4.innerHTML= response[ind].orderid;
                                    td4.id = "idorderid" + ind;
                                    tr.appendChild(td4);
                                    
                                    var td5 = document.createElement('td');
                                    td5.innerHTML = "<p class=\"btn btn-success\" onClick=\"editbill(" + ind + ")\"><span class=\"glyphicon glyphicon-pencil\"></span>&nbsp;Edit</p>";
                                    tr.appendChild(td5);
                                    
//                                                                        
                                    billDetailsTable.append(tr);
//                                    orderno = response[ind].orderno;
                                }
//                                $("#totalliter").val(totalmilk);
//                                $("#subtotal").val(totalamount);
//                                $("#tamount").val(totalamount);
//                                $("#orderno").val(orderno);
                            }
                        });
                    }

                });

            });
            function editbill(cnt) {
                var cnt;
                var orderdetails = $("#billingdetailstable tbody tr");
                if (orderdetails.length > 0) {
                    var tr = $('#billingdetailstable tbody tr[id=row' + cnt + ']');
                    var orderno = $('#billingdetailstable tbody tr[id=row' + cnt + '] td[id=idorderno' + cnt + ']').text();                    
                    var orderid = $('#billingdetailstable tbody tr[id=row' + cnt + '] td[id=idorderid' + cnt + ']').text();                    
                    window.open('EditSelectedBill.jsp?orderid=' + orderid, '_self');
                }
            }


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
                    %><div class="alert alert-success fade in">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                        <strong>Success!</strong> Indicates a successful or positive action.
                    </div><%
                    } else {
                    %><div class="alert alert-danger fade in">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                        <strong>Success!</strong> Indicates a successful or positive action.
                    </div><%
                            }
                        }
                    %>
                    <%!
                        JSONObject jobj = null;
                    %>


                    <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">Select Order Date</span>                  
                    <fieldset style="border:1px solid silver; padding:5px;">
                        <form role="form" id="billpaidform" class="form-horizontal" action="" method="post" onkeypress="myFunction()" onsubmit="return validate()">

                            <div class="form-group">
                                <label for="date" class="control-label col-sm-3" >Select Date : </label>
                                <div class="col-sm-8 text-left">
                                    <input type="text" class="date-picker"  selected="true" id="selectdate" name="selectdate" value="" placeholder="--- Select End Date ---" required="" />
                                </div>
                            </div>
                            <input type="hidden" id="orderno" placeholder="Mobile" name="orderno" value="" hidden="true" readonly="true"/>
                         
                        </form>
                    </fieldset>                     
                    <div class="container-fluid" style="height: 450px;overflow: scroll;text-align: center;">
                        <table class="table table-condensed table-bordered table-hover" style="table-layout:fixed;" id="billingdetailstable" >
                            <thead>
                                <tr class="gridrowheight">
                                    <th style="display: none;">ID</th>
                                    <th style="width: 3%;text-align: center;">Sr. No.</th>
                                    <th style="width:7%">OrderNo</th>
                                    <th style="width:7%">Amount</th>
                                    <th style="width:3%">Action</th>
                                </tr>
                            </thead>
                            <tbody style="">
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </body>
</html>
