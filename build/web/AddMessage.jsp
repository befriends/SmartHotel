
<%@page import="DaoImpl.MenuItemDaoImpl"%>
<%@page import="Dao.MenuItemDao"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String message = "",status="";
    int value=0;
%>
     <script src="js/jquery.min.js"></script>
<script type="text/javascript" lang="javascript">
//    
//        function myFunction() {
//        var d = new Date();
//        d.setDate();
//        document.getElementById("demo").innerHTML = d;
//    }
    function validate() {
                if (document.getElementById("purchasematerialname").value == "") {
                    alert("Material name may not be blank");
                    return false;
                }else if (document.getElementById("quantity").value == "") {
                    alert("Quantity name may not be blank");
                    return false;
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

</script>
<%
    if(session.getAttribute("UserName") == null){
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Message</title>
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <!--style for menu-->
        <!--<link rel="stylesheet" href="css/responsivemultimenu.css" type="text/css"/>-->
        <link href="css/menubarcustomcss.css" rel="stylesheet" type="text/css" /><script src="js/jquery-ui.js"></script><link rel="stylesheet" href="css/jquery-ui.css">
        <script type="text/javascript" src="js/jquery.js"></script> 
        <!--script for menu-->
        <script type="text/javascript" src="js/responsivemultimenu.js"></script>
        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>

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
                            params.put("submodule", "message"); // Database Table Name
                            params.put("columnname", "messageid"); // Database Column Name
                            CommonDao commonDaoObj = new CommonDaoImpl();
                            String id = commonDaoObj.generateNextID(params);

                            MenuItemDao menuitemDAOObj = new MenuItemDaoImpl();
                            
                            JSONObject jsonList = menuitemDAOObj.getCategoryList();

                        %>
                        <%!
                            JSONObject jobj = null;
                        %>


                        <span class="label label-info center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle;">New Message Entry</span>

                        <div>
                            <fieldset style="border:1px solid silver; padding:5px;">
                                <form role="form" id="orderform" class="form-horizontal" action="MenuItemController" method="post" onkeypress="myFunction()" onsubmit="return validate()">

<!--                                    <div class="form-group">
                                        <label for="messageid" class="control-label col-sm-2">Message ID: </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="messageid" name="customid" value="<%//=id%>" readonly="true" />
                                        </div>
                                    </div>-->
                                    <div class="form-group">
                                        <label for="categorynm"class="control-label col-sm-2">Category Name:</label>
                                        <div class="col-sm-8">
                                            <select class="form-control" id="categorynm" placeholder="Select Category Name" name="categoryid" autofocus="true" required="">
                                                <option value="">--Please Select Category--</option>
                                                <%
                                                    JSONArray jarr = jsonList.getJSONArray("data");

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
                                        <label for="message" class="control-label col-sm-2">Message </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="message" placeholder="Enter Message" name="message" autofocus="true" required=""/>
                                        </div>
                                    </div>
                                        <div class="form-group"> 
                                        <div class="col-sm-offset-2 col-sm-5">
                                            <button type="submit" name="submit" value="Add" class="btn btn-default">Add Message</button>
                                             <button type="button" name="cancel" value="Cancel" class="btn btn-default col-sm-offset-1" onClick="window.location = 'home.jsp'">Cancel</button>
                                        <button type="button" name="cancel" onclick="resetform()" value="Cancel" class="btn btn-default col-sm-offset-1">Reset</button>
                                        </div>
                                    </div>
                                    <input type="hidden" name="act" value="1" />
                                    <input type="hidden" name="submodule" value="message" />
                                </form>
                            </fieldset>
                                        <% 
                    JSONObject messageJSONObject = menuitemDAOObj.getMessageList();
                    JSONArray itemarr = new JSONArray();
                    if (messageJSONObject != null && messageJSONObject.has("success") && messageJSONObject.has("data")) {
                        itemarr = messageJSONObject.getJSONArray("data");
                }%>
                            <table class="table table-bordered table-hover">
                                <thead>
                                    <tr class="">
                                        <th style="display: none;">ID</th>
                                        <th style="width: 10%;text-align: center;">Sr. No.</th>
                                        <th style="width: 20%;">Category</th>                                                                        
                                        <th style="width: 25%;">Message</th>                                                                        
                                        <th style="width: 10%; text-align: center;">Active(Y/N)</th> 
                                        <th style="width: 20%; text-align: center;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    
                                    <%
                                        int cnt = 0;
                                        for (cnt = 0; cnt < itemarr.length(); cnt++) {
                                            JSONObject messageObj = itemarr.getJSONObject(cnt);
                                            value = messageObj.getInt("isactive");
                                            if(value==0)
                                            {
                                               status="N";
                                           }else
                                           {
                                               status="Y";
                                           }
                                            
                                            
                                    %>
                                <tr class="info" id="editrecordid<%=cnt%>" style="display:none;">
                                <form name="editrecords">
                                    <td style="display: none;">
                                        <label id="messageid" style="display: none;"><%=messageObj.getString("messageid")%></label>
                                        <label id="submodule" style="display: none;">message</label>
                                    </td>
                                    <td style="text-align: center;"><label><%=cnt + 1%></label></td>
                                    <td>
                                        <input type="text" name="categoryname" hidden="true" value="<%=messageObj.get("categoryname")%>" readonly /><%=messageObj.get("categoryname")%>
                                    </td>

                                    <td>
                                        <input type="text" name="messagetype" hidden="true" value="<%=messageObj.get("messagetype")%>" readonly /><%=messageObj.get("messagetype")%>
                                    </td>

                                    <td >
                                        <input type="text" style="width:100px;" name="isactive" value="<%=status%>"/>
                                    </td>
                                    <td>
                                        <p class="btn btn-info" onClick="updaterecord(<%=cnt%>)"><span class="glyphicon glyphicon-save"></span>&nbsp;Save</p>
                                        &nbsp;|&nbsp;
                                        <p class="btn btn-default" onClick="cancel(<%=cnt%>)"><span class="glyphicon glyphicon-remove"></span>&nbsp;Cancel</p>
                                </form>
                                       
                                    </tr>
                                <tr class="success" id="recordid<%=cnt%>">
                                    
                                <td style="display: none;">
                                    <label id="messageid" style="display: none;"><%=messageObj.getString("messageid")%></label>
                                    <label id="submodule" style="display: none;">message</label>
                                </td>
                                <td style="text-align: center;"><label><%=cnt + 1%></label></td>
                                
                                <td><label type="text" name="categoryname"><%=messageObj.get("categoryname")%></label></td>
                                
                                <td><label type="text" name="messagetype"><%=messageObj.get("messagetype")%></label></td>
                                
                                <td style="text-align: center;">
                                    <label type="text" name="isactive" readonly ><%=status%></label>
                                </td>
                                                           

                                <td style="text-align: center;">
                                    <p class="btn btn-success" onClick="showeditrecord(<%=cnt%>)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;Edit</p>
                                    &nbsp;|&nbsp;
                                    <p class="btn btn-danger" onClick="deleterecord(<%=cnt%>)"><span class="glyphicon glyphicon-trash"></span>&nbsp;Delete</p>
                            </tr> 
                                <%
                                  
                                    }
                                %>
                                </tbody>
                            </table>
                                </form>
                        </div>

                    </div>
                </div>
                                
                    </div>
                </div>

                    <script type="text/javascript" src="js/GridViewController.js"></script> 
                </body>
                </html>
