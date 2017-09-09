
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("UserName") == null) {
        response.sendRedirect("login.jsp");
    }
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
            }%>
        <style type="text/css" media="print">
            .printbutton {
                visibility: hidden;
                display: none;
            }
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

              <div><center><h3 class="lineheight">PurchaseMaterialReport</h3></center></div>
        <style>
.lineheight{line-height: 0%;}
      </style>
      
        <hr style="border-width: 2px;border-color: black;">
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;">
            <table style="width: 100%;">
                <thead>
                        <tr>
                            <th>Sr.No.</th>
                            <th>Purchase Date</th>
                            <th>Material Name </th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total Amount</th>
                            <th>Stock</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                              
                                for (int i = 0; i < jarr.length(); i++) {
                                    JSONObject orderObj = jarr.getJSONObject(i);
                                    JSONObject item = jarr.getJSONObject(i);
                                    String purchasedate = item.getString("purchasematerialdate");
                                    String materialname = item.getString("purchasematerialname");
                                    String price = item.getString("price");
                                    String quantity = item.getString("quantity");
                                    String stock = item.getString("isinstock");
                                    
                                    //String orderDate = paymentdate.getDate()+"/"+(paymentdate.getMonth()+1)+"/"+(paymentdate.getYear()+1900);
                                    double totalamount = Double.parseDouble(item.getString("totalamount"));
                                    
                        %>
                                    <tr>
                                        <td><%=i + 1%></td>
                                        <td><%=purchasedate%></td>
                                        <td><%=materialname %></td>
                                        <td><%=price %></td>
                                        <td><%=quantity%></td>
                                        <td><%=stock%></td>
                                        
                                        <td><%=totalamount%></td>
                                    </tr>
                        <%
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
%> 
       
    </body>
</html>
