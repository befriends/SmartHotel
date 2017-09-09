
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="css/normalize.css">
        <title>Login Page</title>
    </head>
    <body>
        <div class="main_container" style="height: 600px;">

        <div>
            <h1>Login Form</h1>
            <div>
                <fieldset title="login" style="width: 50%;height: 200px;text-align: center;">
                    <form action="TableDetailController" method="Post" name="tablecount_form" style="color: orangered;">
                        Total No. Of Table : <input type="text" name="totaltable" style="color: red;"/><br>
                        <input type="submit" name="submit" value="Sign in"/><input type="button" name="cancel" value="Exit"/>
                    </form>
                </fieldset>
            </div>
            </div>
        </div>
    </body>
</html>
