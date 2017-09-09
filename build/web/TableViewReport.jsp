
<%@page import="DaoImpl.TableDaoImpl"%>
<%@page import="Dao.TableDao"%>
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
            String orderJson = "";
            String tableJson = "";
            double sum1 = 0;
            double sum2 = 0;
        %>
        <%      HashMap<String, String> params = new HashMap<String, String>();
            TableDao tableDaoObj = new TableDaoImpl();
            tableJson = tableDaoObj.getAllTableList().toString(); //getting Order list
            JSONObject tableJsonObj = new JSONObject(tableJson);
            JSONArray tableJsonArr = tableJsonObj.getJSONArray("data");
            int tableSize = tableJsonObj.getInt("totalCount");

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
                    "value='Print This Page'/>");
        </script>
    </head>
    <body >
        <div><center><h5 class="lineheight">Table View</h5></center></div>

        
        <hr style="border-width: 2px;border-color: black;">
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;">
            <%
                for (int cnt = 0; cnt < tableSize; cnt++) {
                    String tableid = tableJsonArr.getJSONObject(cnt).getString("tableid");
                    String tablename = tableJsonArr.getJSONObject(cnt).getString("tablename");
            %>
            <%
                }
            %>
            <table style="width: 100%;">
                <thead>
                        <tr>
                            <th>Sr.No.</th>
                            <th>Table</th>
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
                                   
                        %>
                        <tr>
                            <td><%=i + 1%></td>
                            <td><%=orderObj.get("tablename")%></td>
                           
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
