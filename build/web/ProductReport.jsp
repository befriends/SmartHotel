
<%@page import="DaoImpl.ProductReportDaoImpl"%>
<%@page import="Dao.ProductReportDao"%>
<%@page import="org.json.JSONArray"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String message = "";
    JSONObject jobj=null;
    
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
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="css/normalize.css">

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript" lang="javascript"> 
         function submitDeleteForm(cnt) {
           var r = confirm('Are you sure want to delete');
             if(r == true)
             {
                var f = "form" + cnt;
                document.getElementById(f).action = "ProductReportController?act=2";
                document.getElementById(f).submit();
                } else
                {
                    return false;
                }
            }
            function isNumber(event) {
                var key = (event.which) ? event.which : event.keycode;
                if (key >= 48 && key <= 57)
                    return true;
                return false;
            }

        </script>

        <title>Product Report</title>
    </head>
    <body>
        <div class="order" style="height: 600px;">
           
            <div class="container-fluid" style="margin-top:s20px ">
                 <h1>Product Report</h1>
        <div class="main_div">
            
            <% if (request.getParameter("result") != "" && request.getParameter("result") != null) {
                    jobj = new JSONObject(request.getParameter("result"));
                    message = jobj.getString("message");
                    if (jobj.getBoolean("success")) {
            %> 
            <div class="alert alert-success fade in">
                <a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a>
                <strong>Success!</strong><h5><%=message%></h5>
            </div>
            <% } else {%>
            <span style="width: 100%;margin-left: auto;margin-right: auto;"><h3 style="color: crimson;"><%=message%></h3></span>  
                <% }
                    }
                    HashMap<String, String> hm = new HashMap<String, String>();
                    hm.put("submodule", "ProductReport");
                    hm.put("columnname", "itemid");

                    CommonDao comDao = new CommonDaoImpl();
                    String id = comDao.generateNextID(hm);
                    ProductReportDao prDao = new ProductReportDaoImpl();

                %>

           <span class="label label-primary center-block" style="height:30px;font-size:20px;font-weight:bolder;vertical-align:middle; border-radius:8px; ">Product Report</span>
            <fieldset style="border:2px solid #985f0d; border-radius:7px;  padding:5px;">
                <form role="form" class="form-horizontal" action="ProductReportController" method="post">
                    <div class="form-group">
                        <label for="itemid" class="control-label col-sm-2">Item ID: </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="itemid" name="itemid" value="<%=id%>" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="itemnm" class="control-label col-sm-2">Item Name: </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="itemnm" placeholder="Enter Item Name" name="itemname"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="itemprc" class="control-label col-sm-2">Item Price: </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="itemprc" placeholder="Enter Item Price" name="itemprice" onkeypress="return isNumber(event)"/>
                        </div>
                    </div>

                    <div class="form-group"> 
                        <div class="col-sm-offset-2 col-sm-8">
                            <button type="submit" name="submit" value="Add" class="btn btn-primary">Add Item</button>
                            <a href="home.jsp"><button type="button" name="cancel" value="Cancel" class="btn btn-primary col-sm-offset-1">Cancel</button></a>

                        </div>
                    </div>
                    <input type="hidden" name="act" value="1" />
                    <input type="hidden" name="submodule" value="ProductReport" />
                </form>
            </fieldset>
                         </div>
            <table class="table table-bordered table-hover">
                <thead>

                    <tr class="danger">
                        <th>ITEM_ID</th>
                        <th>ITEM_Name</th>
                        <th>ITEM_PRICE</th> 
                        <th>Action</th>
                    </tr>
                </thead>
                

                    <%  String ProductReportList = prDao.getProductReportList();
                        JSONArray pdarr = new JSONArray(ProductReportList);
                        int cnt = 0;
                        while (cnt < pdarr.length()) {
                            JSONObject obj = pdarr.getJSONObject(cnt);

                    %>
                    <tr class="success">
                  <form id="form<%=cnt%>" name="form<%=cnt%>" action="" method="POST">
                    <td>
                        <input type="hidden" name="itemid" value="<%=obj.get("itemid")%>" readonly /><%=obj.get("itemid")%>
                        <input type="hidden" name="submodule" value="ProductReport" readonly />
                    </td>
                    <td>
                        <input type="text" name="itemname" hidden="true" value="<%=obj.get("itemname")%>" readonly /><%=obj.get("itemname")%>
                    </td>
                    <td>
                        <input type="text" name="itemprice" hidden="true" value="<%=obj.get("itemprice")%>" readonly /><%=obj.get("itemprice")%>
                    </td>

                    <td>
                        
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
            </table>        

       
            </div>
        </div>
    </body>
</html>
