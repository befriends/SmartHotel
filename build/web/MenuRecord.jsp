
<%@page import="java.util.HashMap"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%@page import="DaoImpl.MenuItemDaoImpl"%>
<%@page import="Dao.MenuItemDao"%>
<%@page import="Controller.MenuItemController"%>
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
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="css/normalize.css">
        <title>Menu Record</title>
    </head>
    <body>
        <div class="container">
                
                    <center>
                    <img src="images/header.jpg" class="img-rounded" width="80%" height="100px">
                    </center>>
                         <div style="margin-left: auto; margin-right: auto; width: 80%; background-color: antiquewhite;">
                        <%
                            if (request.getParameter("result") != "" && request.getParameter("result") != null) {
                                JSONObject jobj = new JSONObject(request.getParameter("result"));
                                message = jobj.getString("message");
                                if (jobj.getBoolean("success")) {
                        %>
                        <span style="width: 100%;margin-top: auto;margin-left: auto;margin-right: auto;"><h3 style="color: crimson;"><%=message%></h3></span><br /><%
                        } else {
                            %><span style="width: 100%;margin-left: auto;margin-right: auto;"><h3 style="color: red;"><%=message%></h3></span><br /><%
                                    }
                                }

                                HashMap<String, String> params = new HashMap<String, String>();
                                params.put("submodule", "subcategory"); // Database Table Name
                                params.put("columnname", "subcategoryid"); // Database Column Name
                                CommonDao commonDaoObj = new CommonDaoImpl();
                                String id = commonDaoObj.generateNextID(params);

                                MenuItemDao menuItemDaoObj = new MenuItemDaoImpl();

                                JSONObject jsonList = menuItemDaoObj.getCategoryList();

                            %>
                            <%!
                                JSONObject jobj = null;
                            %>
                        <%
                                JSONObject subCategoryList = menuItemDaoObj.getSubCategoryList();
                                JSONArray itemarr = subCategoryList.getJSONArray("data");
                                if (subCategoryList != null && subCategoryList.has("success") && subCategoryList.has("data")) {
                                    itemarr = subCategoryList.getJSONArray("data");
                                }
                            %>
        <div class="main_container" style="height: 800px;">
            <div id="SmartHotel" style=" width: 100%;height: 1 0%;"></div>
                <table class="table table-condensed table-bordered table-hover"style="table-layout:fixed;" id="tbl" >
                    <thead>
                        <tr class="danger">
                            <th style="display: none;">ID</th>
                            <th>Sr. No.</th>
                            <th>Menu Item</th>
                            <th>Sub Menu</th>
                            <th>Rates</th>
                        </tr>
                    </thead>
                <tbody>
                    <%
                        int cnt = 0;
                        for (cnt = 0; cnt < itemarr.length(); cnt++) {
                        JSONObject subcategoryObj = itemarr.getJSONObject(cnt);
                    %>
                            <tr class="info"id="editrecordid<%=cnt%>" style="display:none;">
                                <form name="editrecords">
                                    <td style="display: none;">
                                        <label id="categoryid" style="display: none;"><%=subcategoryObj.getLong("categoryid")%></label>
                                        <label id="submodule" style="display: none;">subcategory</label>
                                    </td>
                                    <td><label><%=cnt + 1%></label></td>
                                    <td><input type="text" name="categoryname" value="<%=subcategoryObj.get("categoryname")%>"/></td>
                                    
                                    <td style="display: none;">
                                        <label id="subcategoryid" style="display: none;"><%=subcategoryObj.getLong("subcategoryid")%></label>
                                        <label id="submodule" style="display: none;">Sub category</label>
                                    </td>
                                    <td><input type="text" name="subcategoryname" value="<%=subcategoryObj.get("subcategoryname")%>"/></td>
                                    
                                    <td>
                                        <p class="btn btn-info" onClick="updaterecord(<%=cnt%>)"><span class="glyphicon glyphicon-save"></span>&nbsp;Save</p>
                                        &nbsp;|&nbsp;
                                        <p class="btn btn-default" onClick="cancel(<%=cnt%>)"><span class="glyphicon glyphicon-remove"></span>&nbsp;Cancel</p>
                                </form>
                                </tr>
                                <tr class="success" id="recordid<%=cnt%>">
                                    <td style="display: none;">
                                        <label id="categoryid" style="display: none;"><%=subcategoryObj.getLong("categoryid")%></label>
                                        <label id="submodule" style="display: none;">category</label>
                                    </td>
                                    <td><label><%=cnt + 1%></label></td>
                                    <td><label name="categoryname"><%=subcategoryObj.get("categoryname")%></label></td>
                                    <td style="display: none;">
                                        <label id="subcategoryid" style="display: none;"><%=subcategoryObj.getLong("subcategoryid")%></label>
                                        <label id="submodule" style="display: none;">subcategory</label>
                                    </td>

                                    <td><label name="subcategoryname"><%=subcategoryObj.get("subcategoryname")%></label></td>
                                    <td>
                                        <p class="btn btn-success" onClick="showeditrecord(<%=cnt%>)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;Edit</p>
                                        &nbsp;|&nbsp;
                                        <p class="btn btn-danger" onClick="deleterecord(<%=cnt%>)"><span class="glyphicon glyphicon-trash"></span>&nbsp;Delete</p>
                                </tr>
                                <%
                                    }
                                %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="container-fluid">
                </div>

            </div>
        </div>
    </body>
</html>
