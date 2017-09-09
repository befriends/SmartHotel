
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
    String date = "",dateText="";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Daily Order Report</title>
        <%
            JSONObject jobj = new JSONObject(request.getAttribute("result").toString());
            JSONArray jarr = null;
            if (jobj != null && jobj.has("success") && jobj.has("data")) {
                jarr = jobj.getJSONArray("data");
                date = jobj.getString("date");
                dateText = jobj.getString("printdate");
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
        <div style="text-align: right;font-size: 10px;">Print Date : <%=dateText%></div>
        <div style="text-align: right;font-size: 10px;font-weight: bold">Selected Date : <%=date%></div>
        <%@ include file="printHeader.jsp"%>
        <div style="font-size: 12px; font-weight: bold;text-align: center;">Daily Order Report</div>
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;font-size: 13px;">
            <hr style="border-width: 2px;border-color: black;">
            <table style="width: 100%;">
                <thead>
                    <tr>
                        <th style="border-bottom: 1px dashed;">Sr.No.</th>
                        <th style="border-bottom: 1px dashed;">Order No</th>
                        <th style="border-bottom: 1px dashed;">Table</th>
                        <th style="border-bottom: 1px dashed; text-align: right;">Amount</th>
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
                                String orderNo = item.getString("orderno");
                                String tableName = item.getString("tablename");
                                double totalAmount = Double.parseDouble(item.getString("totalamount"));
                                totalAmount= Math.round(totalAmount*100.0)/100.0;
                    %>
                    <tr>
                        <td><%=i + 1%></td>
                        <td><%=orderNo%></td>
                        <td><%=tableName%></td>
                        <td style="text-align: right;"><%=twoDForm.format(totalAmount)%></td>
                    </tr>
                    <%
                                grandTotal += totalAmount;
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    %>
                    <tr><td colspan="4" style="border-top: 1px dashed; border-bottom: 1px dashed; font-weight: bold; text-align: right;">Total : <%=twoDForm.format(grandTotal)%></td></tr>
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
