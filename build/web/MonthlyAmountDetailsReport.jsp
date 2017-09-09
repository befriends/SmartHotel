
<%@page import="java.util.Iterator"%>
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
    String month = "",year="";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <%
            JSONObject jobj = new JSONObject(request.getAttribute("result").toString());
            JSONObject dataJobj = new JSONObject();
            JSONArray jarr = null;
            if (jobj != null && jobj.has("success") && jobj.has("data")) {
                jarr = jobj.getJSONArray("data");
                dataJobj = jarr.getJSONObject(0);
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
                    "value='Print'"+
                    "id='prt1'/>");

        </script>
    </head>
    <body>
        <style>
            .mynotsoboldtitle { font-weight:normal;line-height: 0%;}
            .lineheight{line-height: 0%;}
        </style>
        <% if (dataJobj.length() > 0) { %>

        <div style="text-align: right;font-size: 10px;">Month / Year : <%=month%> / <%=year%></div>
        <%@ include file="printHeader.jsp"%>
        <div style="font-size: 12px; font-weight: bold;text-align: center;">Monthly Audit Report</div>
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;font-size: 12px;">
            <table style="width: 100%;">
                <hr style="border-width: 2px;border-color: black;">
                <thead>
                    <tr>
                        <th style="border-bottom: 1px dashed;">Sr.No.</th>
                        <th style="border-bottom: 1px dashed; text-align: right;">Date</th>
                        <th style="border-bottom: 1px dashed; text-align: right;">Order Amount</th>
                        <th style="border-bottom: 1px dashed; text-align: right;">Purchase Amount</th>
                        <th style="border-bottom: 1px dashed; text-align: right;">Payment Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    DecimalFormat twoDForm = new DecimalFormat("#0.00");
                    grandTotal = 0;
                    double orderGrandTotal = 0, purchaseGrandTotal = 0, paymentGrandTotal = 0;
                    try {
                        long cnt = 0;

                        String orderDate = "", purchaseDate = "", paymentDate = "";
                        double orderTotalAmount = 0, purchaseTotalAmount = 0, paymentTotalAmount = 0;
                        Iterator ite = dataJobj.keys();
                        while (ite.hasNext()) {
                            cnt++;
                            String key = (String) ite.next();

                            JSONObject orderObj = dataJobj.getJSONObject(key);
                            Date orderdt = new Date(orderObj.getLong("orderdate"));
                            orderDate = orderdt.getDate() + "/" + (orderdt.getMonth() + 1) + "/" + (orderdt.getYear() + 1900);
                            orderTotalAmount = Double.parseDouble(orderObj.getString("ordertotalamount"));
                            orderTotalAmount = Math.round(orderTotalAmount * 100.0) / 100.0;
                            orderGrandTotal += orderTotalAmount;
                            
                            Date purchasematerialdate = new Date(orderObj.getLong("purchasematerialdate"));
                            purchaseDate = purchasematerialdate.getDate() + "/" + (purchasematerialdate.getMonth() + 1) + "/" + (purchasematerialdate.getYear() + 1900);
                            purchaseTotalAmount = Double.parseDouble(orderObj.getString("purchasetotalamount"));
                            purchaseTotalAmount = Math.round(purchaseTotalAmount * 100.0) / 100.0;
                            purchaseGrandTotal += purchaseTotalAmount;
                            
                            Date paymentdate = new Date(orderObj.getLong("paymentdate"));
                            paymentDate = paymentdate.getDate() + "/" + (paymentdate.getMonth() + 1) + "/" + (paymentdate.getYear() + 1900);
                            paymentTotalAmount = Double.parseDouble(orderObj.getString("paymentamount"));
                            paymentTotalAmount = Math.round(paymentTotalAmount * 100.0) / 100.0;
                            paymentGrandTotal += paymentTotalAmount;
                    %>
                    <tr>
                        <td><%=cnt%></td>
                        <td style="text-align: right;"><%=orderDate%></td>
                        <td style="text-align: right;"><%=twoDForm.format(orderTotalAmount)%></td>
                        <td style="text-align: right;"><%=twoDForm.format(purchaseTotalAmount)%></td>
                        <td style="text-align: right;"><%=twoDForm.format(paymentTotalAmount)%></td>
                    </tr>
                    <%
//                                grandTotal += orderTotalAmount;
//                                grandTotal += purchaseTotalAmount;
//                                grandTotal += paymentTotalAmount;
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    %>
                    <tr>
                        <td style="border-top: 1px dashed; border-bottom: 1px dashed; font-weight: bold; text-align: right;"></td>
                        <td style="border-top: 1px dashed; border-bottom: 1px dashed; font-weight: bold; text-align: right;"></td>
                        <td style="border-top: 1px dashed; border-bottom: 1px dashed; font-weight: bold; text-align: right;"><%=twoDForm.format(orderGrandTotal)%></td>
                        <td style="border-top: 1px dashed; border-bottom: 1px dashed; font-weight: bold; text-align: right;"><%=twoDForm.format(purchaseGrandTotal)%></td>
                        <td style="border-top: 1px dashed; border-bottom: 1px dashed; font-weight: bold; text-align: right;"><%=twoDForm.format(paymentGrandTotal)%></td>
                    </tr>
                    <%  } else {
                    %>
                <script>
                    document.getElementById("prt1").style.visibility = "hidden";
                </script>
                <div style="text-align: center;"><span>No records found to display.</span></div><%
                    }
                %>
                </tbody>
            </table>
            <div style="height: 20px;"></div>
    </body>
</html>
