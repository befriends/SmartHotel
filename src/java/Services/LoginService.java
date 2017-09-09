

package Services;

import Controller.LoginController;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import javax.servlet.http.HttpServlet;
import org.json.JSONException;
import org.json.JSONObject;

@WebServlet(name ="LoginService", urlPatterns = {"/loginService"})
public class LoginService extends HttpServlet{

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            processRequest(req, resp);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException,JSONException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
         
            LoginController loginUserCntObj = new LoginController();
             if (request.getParameter("isAndroid") != null) {
                JSONObject resultJSONObject = loginUserCntObj.validLogin(request.getParameter("username"), request.getParameter("password"));
                response.getWriter().print(resultJSONObject);
            } else {
                JSONObject resultJSONObject = loginUserCntObj.validLogin(request.getParameter("username"), request.getParameter("password"));
                if (resultJSONObject != null && resultJSONObject.has("success") && resultJSONObject.getBoolean("success")) {
                    response.sendRedirect("home.jsp");
                } else {
                    out.println("<h1>Username or Password is wrong. Please try again.</h1>");
                }
            }
        }
    }
    
}
