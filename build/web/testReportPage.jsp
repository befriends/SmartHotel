
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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
    <body>
        <div><center><h1>Report</h1></center></div>
        <hr style="border-width: 2px;border-color: black;">
        <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;">
            <table style="width: 100%;">
                <thead>
                <th>S. No.</th>
                <th>Date</th>
                <th>Table No.</th>
                <th>Order No.</th>
                <th>Amount</th>
                </thead>
                <tbody>
            <%
            for(int i=1; i <= 10; i++){
                %><tr>
                    <td><%=i %></td>
                    <td>12/06/2016</td>
                    <td>Table-<%=i %></td>
                    <td>Order <%=i %></td>
                    <td><%=i*100 %></td>
                  </tr>
                <%
            }
            %>
                </tbody>
            </table>
        </div>
    </body>
</html>
