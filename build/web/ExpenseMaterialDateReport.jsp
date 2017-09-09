

<%@page import="java.util.Date"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONObject"%>
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
        <%             JSONObject jobj = new JSONObject(request.getParameter("result"));
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
                    "value='Print'/>");

        </script>

    </head>
    <body>         
        <style>
            .mynotsoboldtitle { font-weight:normal;line-height: 0%;}
            .lineheight{line-height: 0%;}
        </style>
        <% if (jarr.length() > 0) { %>
        <div style="text-align: right;font-size: 10px;">Date : <%=date%></div>
        <%@ include file="printHeader.jsp"%>
        <div style="font-size: 12px; font-weight: bold;text-align: center;">Expense Material Report</div>
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;font-size: 13px;">
            <table style="width: 100%;">
                <hr style="border-width: 2px;border-color: black;">
                <thead>
                    <tr>
                        <th style="border-bottom: 1px dashed;">Sr.No.</th>
                        <th style="border-bottom: 1px dashed;text-align: left">Name </th>                            
                        <th style="border-bottom: 1px dashed">Quantity</th>

                    </tr>
                </thead>
                <tbody>
                    <%
                        try {

                            for (int i = 0; i < jarr.length(); i++) {
                                JSONObject orderObj = jarr.getJSONObject(i);
                                JSONObject item = jarr.getJSONObject(i);

                                Date purchasedate = new Date(item.getLong("expencedate"));
                                String orderDate = purchasedate.getDate() + "/" + (purchasedate.getMonth() + 1) + "/" + (purchasedate.getYear() + 1900);
                                String materialname = item.getString("materialname");
                                Long quantity = item.getLong("quantity");
                    %>
                    <tr>
                        <td><%=i + 1%></td>
                        <td style="text-align: left"><%=materialname%></td>                                       
                        <td><%=quantity%></td>

                    </tr>
                    <%

                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    %> 
                    <tr><td colspan="6" style="border-bottom: 1px dashed;"></td></tr>
                    <%} else {
                            %><div style="text-align: center;"><span>No records to display.</span></div><%
                            }%>
                    
                </tbody>
            </table>
                            <div style="height: 20px;"></div>
                    </body>
                    </html>