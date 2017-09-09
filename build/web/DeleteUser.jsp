

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Delete User</title>
    </head>
    <body>
        <div>
            <h1>User Form</h1><br>
            <center>
                <c:forEach var="fname" items="${Userlist}">
                    <SELECT name=StaffType> 
                        <OPTION value="${fname}"> Select User </OPTION>
                    </SELECT>
                </c:forEach>
                <input type="submit" value="next">
            </center>

        </div>
    </body>
</html>
