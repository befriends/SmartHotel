
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="DaoImpl.BillingPageDaoImpl"%>
<%@page import="DaoImpl.BillingPageDaoImpl"%>
<%@page import="Dao.BillingPageDao"%>
<%@page import="Dao.BillingPageDao"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("UserName") == null){
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <%!
            double sum1 = 0;
            double sum2 = 0;
        %>
        <%      HashMap<String, String> params = new HashMap<String, String>();
            BillingPageDao billDao = new BillingPageDaoImpl();
            JSONObject jobj = billDao.getBill();
            JSONArray jarr = new JSONArray();
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
        </script>
    </head>
    <body >
        <div><center><h5 class="lineheight">GaneshVishwa SOFTWARE PVT.LTD.</h5></center></div>
        <div><center><h6 class="mynotsoboldtitle">RESTAURANT</h6></center></div>
        <div><center><h6 class="mynotsoboldtitle">WAGESHWAR HEIGHTS</h6></center></div>
        <div ><center><h6 class="mynotsoboldtitle">WAGHOLI PUNE</h6></center></div>
        <div ><center><h6 class="mynotsoboldtitle">MAHARASHTRA</h6></center></div>
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
                            <th>Menu Item</th>
                            <th>Qty</th>
                            <th>Rate</th>
                            <th>Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                sum1 = 0;
                                for (int i = 0; i < jarr.length(); i++) {
                                    JSONObject orderObj = jarr.getJSONObject(i);
                                    JSONObject item = jarr.getJSONObject(i);
                                    double rate = Double.parseDouble(item.getString("rate"));
                                    double qty = Double.parseDouble(item.getString("quantity"));
                                    double subtotal = rate * qty;
                                    sum1 = sum1 + subtotal;
                        %>
                        <tr>
                            <td><%=i + 1%></td>
                            <td><%=orderObj.get("menuitemname")%></td>
                            <td><%=orderObj.get("quantity")%></td>
                            <td><%=orderObj.get("rate")%></td>
                            <td><%=subtotal%></td>
                        </tr>
                        <%
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        %> 
                    </tbody>
                </table>
            <!--                                <div  style="position:  absolute;right:0;top:100">
                                                <label >Total: </label>
                                                <div >
                                                    <input type="text" class="form"  name="customid" value="<%=sum1%>" readonly="true" />
                                                </div>
                                            </div><br><br>
                                            <div  style="position:  absolute;right:0;top:100">
                                                <label >Discount: </label>
                                                <div >
                                                    <input type="text" class="form" placeholder="Enter Discount if any" name="customid" />
                                                </div>
                                            </div><br><br>
            <%
                sum2 = sum1;
            %>
            <div  style="position:  absolute;right:0;top:100">
        <label >Grand Total: </label>
        <div class="col-sm-8">
            <input type="text" class="form"  name="customid" value="<%=sum2%>" readonly="true" />
        </div>
    </div><br><br>
    <input type="hidden" name="tabelnumber" value="" />
    <button type="submit"  style="position:  absolute;right:0;top:100" >Print </button>-->
        </div>

    </body>
</html>
