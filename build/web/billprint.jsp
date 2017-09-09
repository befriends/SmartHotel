
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="DaoImpl.OrderDaoImpl"%>
<%@page import="Dao.OrderDao"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Bill Print</title>
        <script type="text/javascript" src="js/jquery.js"></script>
        <%!
            String orderid = "";
            String selectedTableName = "";
            double total = 0;
            String orderNo = "";
            int billno=0;
            String orderDate = "";
            String customerName = "";
        %>
        <%  
            OrderDao orderDaoObj = new OrderDaoImpl();
            orderid = request.getParameter("orderid");
            selectedTableName = request.getParameter("selectedTableName");
            JSONObject orderJson = orderDaoObj.getOrderDetails(orderid);
            
            double discount = Double.parseDouble(request.getParameter("disc").length()==0 ? "0" : request.getParameter("disc"));
            JSONArray orderJsonArr = null;
            if (orderJson != null && orderJson.has("success") && orderJson.has("data")) {
                orderJsonArr = orderJson.getJSONArray("data");
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
            
            $( document ).ready(function() {
              $(".printbutton").click();
            });
        </script>
    </head>
    <body style="font-size: 10px;">
        <% if (orderJsonArr.length() > 0) { %>
            <% 
                orderNo = orderJsonArr.getJSONObject(0).getString("orderno");
                long longDate = orderJsonArr.getJSONObject(0).getLong("orderdate");
                SimpleDateFormat sdm = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
                orderDate = sdm.format(new java.util.Date());
                String suborderno = orderNo.substring(3);
                billno = Integer.parseInt(suborderno);
                customerName = request.getParameter("customer");
                
            %>
        <%@ include file="printHeader.jsp"%>
        <div style="font-size: 10px; font-weight: bold;text-align: center;">Final Bill</div>
        <style>
        .mynotsoboldtitle { font-weight:normal;line-height: 0%;}
        .lineheight{line-height: 0%;}
        </style>
        <div><b><%=selectedTableName %></b> &nbsp;|&nbsp;Order No.: <%=orderNo %></div>
        <div>Date: <%=orderDate %>&nbsp;|&nbsp;Bill No.:<%=billno%></div>
        <div>Name :<%=customerName%></div>
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;font-size: 10px;">
            <hr style="border-width: 2px;border-color: black;" />
            <table style="width: 100%;">
                <thead>
                        <tr>
                            <th style="border-bottom: 1px dashed;">Sr.No.</th>
                            <th style="border-bottom: 1px dashed;text-align: left;">Menu Item</th>
                            <th style="border-bottom: 1px dashed;">QTY</th>
                            <th style="border-bottom: 1px dashed;text-align: right;">RATE</th>
                            <th style="border-bottom: 1px dashed;text-align: right;">AMT</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                              
                                            total = 0;
                                            for (int i = 0; i < orderJsonArr.length(); i++) {
                                                JSONObject item = orderJsonArr.getJSONObject(i);
                                                double rate = Double.parseDouble(item.getString("rate"));
                                                int qty = Integer.parseInt(item.getString("qty"));
                                                double subtotal = rate * qty;
                                                orderid = item.getString("orderid");

                                                total += subtotal;
                                    
                        %>
                                    <tr>
                                            <td><%=i+1 %></td>
                                            <td style="text-align: left;"><%=item.get("menuItemName")%></td>
                                            <td><%=qty%></td>
                                            <td style="text-align: right;"><%=rate%></td>
                                            <td style="text-align: right;"><%=subtotal%></td>
                                    </tr>
                        <%
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
        }
                            else {
                    %><div style="text-align: center;"><span>No records to display.</span></div><%
                        }
%>
<tr><td></td><td colspan="4" style="border-top: 1px dashed; font-weight: bold; text-align: right;">Sub Total : <%=total %></td></tr>
<%
if(discount > 0){
%> 
<tr><td></td><td colspan="4" style="border-top: 1px dashed; text-align: right;">Discount(%) : <%=discount %></td></tr>
<% } %>
<tr><td style="border-bottom: 1px dashed;">&nbsp;</td><td colspan="4" style="border-top: 1px dashed; border-bottom: 1px dashed; font-weight: bold; text-align: right;">Total : <%=total - ((total*discount)/100) %></td></tr>
                </tbody>
            </table>
        </div>
Thank You.....!! Visit Again
        </body>
</html>
