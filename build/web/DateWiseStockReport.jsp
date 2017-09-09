<%@page import="java.util.Date"%>
<%@page import="java.text.DecimalFormat"%>
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
        <title>Daily Stock Report</title>
        <%
            JSONObject jobj = new JSONObject(request.getAttribute("result").toString());
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
            .lineheight{line-height: 0%;}
        </style>
        <% if (jarr.length() > 0) { %>
        <div style="text-align: right;font-size: 10px;">Date : <%=date%></div>
        <%@ include file="printHeader.jsp"%>
        <div style="font-size: 12px; font-weight: bold;text-align: center;">Daily Stock Report</div>
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;font-size: 13px;">
            <hr style="border-width: 2px;border-color: black;">
            <table style="width: 100%;">
                <thead>
                    <tr>
                        <th style="border-bottom: 1px dashed;">Sr.No.</th>
                        <th style="border-bottom: 1px dashed;">Material Name</th>
                        <th style="border-bottom: 1px dashed;">Opening Stock</th>
                        <th style="border-bottom: 1px dashed;">Purchase</th>
                        <th style="border-bottom: 1px dashed;">Issued</th>
                        <th style="border-bottom: 1px dashed;">Closing Stock Quantity</th>
                        <!--<th style="border-bottom: 1px dashed; text-align: right;">Amount</th>-->
                    </tr>
                </thead>
                <tbody>
                    <%
                        DecimalFormat twoDForm = new DecimalFormat("#0.00");
                        try {
                            grandTotal = 0;
                            for (int i = 0; i < jarr.length(); i++) {
                                JSONObject stockObj = jarr.getJSONObject(i);
                                JSONObject item = jarr.getJSONObject(i);
                                String materialName = item.getString("materialname");
                               double initialStock = Double.parseDouble(item.getString("quantity"));
                               double counterStock = Double.parseDouble(item.getString("counterquantity"));
                               double sellQuantity = Double.parseDouble(item.getString("deductionqty"));
//                                double totalAmount =0;
                                double purchaseQty = counterStock - initialStock + sellQuantity;
//                                        Double.parseDouble(item.getString("totalamount"));
//                                totalAmount= Math.round(totalAmount*100.0)/100.0;
                    %>
                    <tr>
                        <td><%=i + 1%></td>
                        <td><%=materialName%></td>
                        <td><%=twoDForm.format(initialStock)%></td>
                        <td><%=twoDForm.format(purchaseQty)%></td>
                        <td><%=twoDForm.format(sellQuantity)%></td>
                        <td><%=twoDForm.format(counterStock)%></td>
                    </tr>
                    <%
//                                grandTotal += totalAmount;
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    %>
                    <tr><td colspan="6" style="border-bottom: 1px dashed;"</td></tr>
                            <%} else {
                            %>
                <script>
                    document.getElementById("prt1").style.visibility = "hidden";
                </script><div style="text-align: center;"><span>No records to display.</span></div><%
                            }%>
                </tbody>
            </table>
            <div style="height: 20px;"></div>
    </body>
</html>