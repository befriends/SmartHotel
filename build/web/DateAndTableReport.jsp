
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.Date"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                    "value='Print'/>");
        </script>    </head>
    <body>
       
        <div><center><h5 class="lineheight">GANESHVISHWA SOFTWARE</h5></center></div>
        <div><center><h6 class="mynotsoboldtitle">RESTAURANT</h6></center></div>
        <div><center><h6 class="mynotsoboldtitle">WAGESHWAR HEIGHTS</h6></center></div>
        <div ><center><h6 class="mynotsoboldtitle">WAGHOLI PUNE</h6></center></div>
        <div ><center><h6 class="mynotsoboldtitle">MAHARASHTRA</h6></center></div>
        <div><center><h3 class="lineheight">Table Date Sales Reports</h3></center></div>
        <style>
            .mynotsoboldtitle { font-weight:normal;line-height: 0%;}
            .lineheight{line-height: 0%;}
        </style>
        <hr style="border-width: 2px;border-color: black;">
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;">
            <table style="width: 100%;">
                <thead>
                    <tr>
                       <th>Sr.No.</th>
                        <th>Order No </th>
                        <th>Total Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {

                            for (int i = 0; i < jarr.length(); i++) {
                                JSONObject orderObj = jarr.getJSONObject(i);
                               JSONObject item = jarr.getJSONObject(i);
                               String orderNo = item.getString("orderno"); 
                               double totalAmount = Double.parseDouble(item.getString("totalamount"));

                    %>
                    <tr>
                        <td><%=i + 1%></td>
                        <td><%=orderNo%></td>
                        <td><%=totalAmount%></td>
                    </tr>
                    <%
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    %> 
</body>
</html>
