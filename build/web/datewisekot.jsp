<%-- 
    Document   : DateWiseKOT
    Created on : 13 Nov, 2016, 4:58:34 PM
    Author     : vishwas
--%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("UserName") == null) {
        response.sendRedirect("login.jsp");
    }
%>
<%!
    double grandTotal = 0;
    String date = "";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <%
            JSONObject jobj = new JSONObject(request.getParameter("result"));
            JSONArray jarr = null;
            if (jobj != null && jobj.has("success") && jobj.has("data")) {
                jarr = jobj.getJSONArray("data");
                date = jobj.getString("date");
            }%>
        <style type="text/css" media="print">
            .printbutton {
                visibility: hidden;
                display: none;
            }

            @page { margin: 0.5cm }
        </style>
        <script>
            document.write("<input type='button' " +
                    "onClick='window.print()' " +
                    "class='printbutton' " +
                    "value='Print'" +
                    "id='prt1'/>");
        </script> 
    </head>
    <body>

        <style>
            .mynotsoboldtitle { font-weight:normal;line-height: 0%;}
            .lineheight{line-height: 0%;display: inline;}
        </style>
        <% if (jarr.length() > 0) {%>
        <div style="text-align: right;font-size: 10px;">Date : <%=date%></div>
        <%@ include file="printHeader.jsp"%>
        <div style="font-size: 12px; font-weight: bold;text-align: center;">Daily KOT Report</div>
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;font-size: 13px;">
            <hr style="border-width: 2px;border-color: black;">
            <table style="width: 100%;">
                <thead>
                    <tr>
                        <th style="border-bottom: 1px dashed;">Sr.No.</th>
                        <th style="border-bottom: 1px dashed;">User Name </th>
                        <th style="border-bottom: 1px dashed;">Menu Item </th>
                        <th style="border-bottom: 1px dashed;">Quantity </th>
                    </tr>
                </thead>
                <tbody>
                    <%
                         DecimalFormat twoDForm = new DecimalFormat("#0.00"); 
                        try {
                            grandTotal = 0;
                            for (int i = 0; i < jarr.length(); i++) {
                                JSONObject orderObj = jarr.getJSONObject(i);
                                JSONObject item = jarr.getJSONObject(i);
                                String userName = item.getString("username");
                                String menuName = item.getString("menuitemid");
                                String totalQuantity = item.getString("quantity");
                    %>
                    <tr>
                        <td><%=i + 1%></td>
                        <td><%=userName%></td>
                        <td><%=menuName%></td>
                        <td><%=totalQuantity%></td>
                    </tr>
                    <%
                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                    %>
                            <%} else { %>
                <script>
                    document.getElementById("prt1").style.visibility = "hidden";
                </script>
                <div style="text-align: center;"><span>No records found to display.</span></div><%
                    }%> 
                </tbody>
            </table>
            <div style="height: 20px;"></div>
    </body>
</html>
