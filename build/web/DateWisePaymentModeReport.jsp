
<%@page import="com.mysql.jdbc.StringUtils"%>
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
        <title>Daily Order Report</title>
        <%
            String resultData = request.getParameter("result");
            JSONObject jobj = new JSONObject(resultData);
            String reportTitle = "";
            int paymentmode = StringUtils.isNullOrEmpty(request.getParameter("paymentmode")) ? 1 : Integer.parseInt(request.getParameter("paymentmode"));
            if(paymentmode == 1){
                reportTitle = "CASH";
            } else if(paymentmode == 2){
                reportTitle = "CARD";
            } else if(paymentmode == 3){
                reportTitle = "CHEQUE";
            } else{
                reportTitle = "CASH";
            }
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
        <div style="font-size: 12px; font-weight: bold;text-align: center;"><%=reportTitle %> Payment Mode - Date Wise Report</div>
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;font-size: 13px;">
            <hr style="border-width: 2px;border-color: black;">
            <table style="width: 100%;">
                <thead>
                    <tr>
                        <th style="border-bottom: 1px dashed;">Sr.No.</th>
                        <th style="border-bottom: 1px dashed;">Order No</th>
                        <th style="border-bottom: 1px dashed;">Table</th>
                        <% if(paymentmode == 3){ %>
                        <th style="border-bottom: 1px dashed;">Cheque No</th>
                        <%} %>
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
                                String chequeno = item.getString("chequeno");
                                double totalAmount = Double.parseDouble(item.getString("totalamount"));
                                totalAmount= Math.round(totalAmount*100.0)/100.0;
                    %>
                    <tr>
                        <td><%=i + 1%></td>
                        <td><%=orderNo%></td>
                        <td><%=tableName%></td>
                        <% if(paymentmode == 3){ %>
                        <td><%=chequeno%></td>
                        <% } %>
                        <td style="text-align: right;"><%=twoDForm.format(totalAmount)%></td>
                    </tr>
                    <%
                                grandTotal += totalAmount;
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    %>
                    <tr><td colspan="<% if(paymentmode == 3){ %>5<%} else{%>4<%}%>" style="border-top: 1px dashed; border-bottom: 1px dashed; font-weight: bold; text-align: right;">Total : <%=twoDForm.format(grandTotal)%></td></tr>
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
