
<%@page import="java.util.Date"%>
<%@page import="java.text.DecimalFormat"%>
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
    String month = "",year = "";
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <%
            JSONObject jobj = new JSONObject(request.getAttribute("result").toString());
            JSONArray jarr = null;
            if (jobj != null && jobj.has("success") && jobj.has("data")) {
                jarr = jobj.getJSONArray("data");
                  month = jobj.getString("month");
                  year = jobj.getString("year");
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
        <div style="text-align: right; font-weight: bold; font-size: 10px;">Month & Year: <%=month%> / <%=year%></div>
        <%@ include file="printHeader.jsp"%>
        <div style="font-size: 12px; font-weight: bold;text-align: center;">Purchase Material Report</div>
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;font-size: 13px;">
            <table style="width: 100%;">
                <hr style="border-width: 2px;border-color: black;">
                <thead>
                    <tr>
                        <th style="border-bottom: 1px dashed;">Sr.No.</th>
                        <th style="border-bottom: 1px dashed;text-align: center">Day</th>
                        <th style="border-bottom: 1px dashed;text-align: left">Name </th>
                        <th style="border-bottom: 1px dashed;text-align: right;">Price</th>
                        <th style="border-bottom: 1px dashed;text-align: right;">Qty</th>
                        <th style="border-bottom: 1px dashed; text-align: right">Amt</th>
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
                                Date purchasedate = new Date(item.getLong("purchasematerialdate"));
                                String orderDate = purchasedate.getDate()+"";// + "/" + (purchasedate.getMonth() + 1) + "/" + (purchasedate.getYear() + 1900);
                                String materialname = item.getString("materialname");
                                float price = Float.parseFloat(item.getString("unitprice"));
                                Long quantity = item.getLong("quantity");
                                double totalAmount = Double.parseDouble(item.getString("totalamount"));

                    %>
                    <tr>
                        <td style="text-align: center; vertical-align: top;"><%=i + 1%></td>
                        <td style="text-align: center; vertical-align: top;"><%=orderDate%></td>
                        <td style="text-align: left; vertical-align: top;"><%=materialname%></td>
                        <td style="text-align: right; vertical-align: top;"><%=price%></td>
                        <td style="text-align: right; vertical-align: top;"><%=quantity%></td>                       
                        <td style="text-align: right;vertical-align: top;"><%=twoDForm.format(totalAmount)%></td>
                    </tr>
                    <%
                                grandTotal += totalAmount;
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    %> 
                    <tr><td colspan="6" style="border-top: 1px dashed; border-bottom: 1px dashed; font-weight: bold; text-align: right;">Total : <%=twoDForm.format(grandTotal)%></td></tr>
                <%} else {
                            %><div style="text-align: center;"><span>No records to display.</span></div><%
                            }%>
            </tbody>
            </table>                                    
            <div style="height: 20px;"></div>
    </body>
</html>
