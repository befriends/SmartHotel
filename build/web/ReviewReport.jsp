<%-- 
    Document   : ReviewReport
    Created on : 19 Oct, 2016, 11:14:46 AM
    Author     : sai
--%>

<%@page import="java.text.Format"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="DaoImpl.ReviewDaoImpl"%>
<%@page import="Dao.ReviewDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%!
    double grandTotal = 0;
    String date = "";
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Review Report</title>

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
    <%
        JSONObject jobj = null;
        JSONArray jarr = null;

    %>
    <%
                    ReviewDao reviewObj = new ReviewDaoImpl();
                    JSONObject jsonList = reviewObj.getReviewList();
                    jarr = jsonList.getJSONArray("data");
                %>
    <body>
        <style>
            .mynotsoboldtitle { font-weight:normal;line-height: 0%;}
            .lineheight{line-height: 0%;}
        </style>
<% if (jarr.length() > 0) { %>
        <!--<div style="text-align: right;font-size: 10px;">Date : <%=date%></div>-->
        <%@ include file="printHeader.jsp"%>
        <div style="font-size: 12px; font-weight: bold;text-align: center;">Review Report</div>
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;font-size: 13px;">
            <hr style="border-width: 2px;border-color: black;">
            <table style="width: 100%;">
                <thead>
                    <tr>
                        <th style="border-bottom: 1px dashed;">Sr.No.</th>
                        <th style="border-bottom: 1px dashed;">Customer Name</th>
                        <th style="border-bottom: 1px dashed;">Address</th>
                        <th style="border-bottom: 1px dashed;">Mobile</th>
                        <th style="border-bottom: 1px dashed;">Phone</th>
                        <th style="border-bottom: 1px dashed;">Email Id</th>
                        <th style="border-bottom: 1px dashed;">DateOfBirth</th>
                        <th style="border-bottom: 1px dashed;">Foodquality</th>
                        <th style="border-bottom: 1px dashed;">Service</th>
                        <th style="border-bottom: 1px dashed;">Environment</th>
                        <th style="border-bottom: 1px dashed;">Comment</th>
                        <!--<th style="border-bottom: 1px dashed; text-align: right;">Amount</th>-->
                    </tr>
                </thead>
                
                <%
                    try {

                        for (int cnt = 0; cnt < jarr.length(); cnt++) {
                            jobj = jarr.getJSONObject(cnt);
                            String name1 = jobj.getString("name");
                            String address1 = jobj.getString("address");
                            String mobile = jobj.getString("mobile");
                            String phone = jobj.getString("phone");
                            String emailid = jobj.getString("email");
                            long dob = jobj.getLong("dob");
                            String foodquality = jobj.getString("foodquality");
                            String service = jobj.getString("service");
                            String environment = jobj.getString("environment");
                            String comment = jobj.getString("comment");

        //                                                                long val = 1346524199000l;
                            Date date = new Date(dob);
                            SimpleDateFormat df2 = new SimpleDateFormat("dd/MM/yyyy");
                            String dateText = df2.format(date);
        //        System.out.println(dateText);

        //Format formatter = new SimpleDateFormat("yyyy-MM-dd ");
        //String s = formatter.format(date);

                %>
                <tr>
                    <td><%=cnt + 1%></td>
                    <td><%=name1%></td>
                    <td><%=address1%></td>
                    <td><%=mobile%></td>
                    <td><%=phone%></td>
                    <td><%=emailid%></td>
                    <td><%=dateText%></td>
                    <td><%=foodquality%></td>
                    <td><%=service%></td>
                    <td><%=environment%></td>
                    <td><%=comment%></td>
                </tr>

                <%

                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } 
                %>
                <%} else {
                            %>
                <script>
                    document.getElementById("prt1").style.visibility = "hidden";
                </script><div style="text-align: center;"><span>No records to display.</span></div>
                <%}%>
                </tbody>
            </table>
                </body>
                </html>

