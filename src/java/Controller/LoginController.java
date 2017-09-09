// Hello world

package Controller;

import DBConnection.DBPool;
import Dao.LoginDao;
import Dao.UserDao;
import DaoImpl.LoginDaoImpl;
import DaoImpl.UserDaoImpl;
import com.mysql.jdbc.StringUtils;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@WebServlet(name = "validateLogin", urlPatterns = {"/validateLogin"})
public class LoginController extends HttpServlet {

    LoginDao loginDaoObj = null;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            doService(request, response);
        } catch (JSONException e) {
            e.printStackTrace();
        } catch (SQLException ex) {
            Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void doService(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, JSONException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        String userName = "", pwd = "";
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            userName = request.getParameter("uname");
            pwd = request.getParameter("password");
            if (request.getParameter("isAndroid") != null) {
                JSONObject resultJSONObject = validLogin(userName, pwd);
                response.getWriter().print(resultJSONObject);
            } else {
                JSONObject resultJSONObject = validLogin(userName, pwd);
                if((resultJSONObject != null && resultJSONObject.has("conn")&& resultJSONObject.getBoolean("conn"))|| (resultJSONObject.getBoolean("success"))){
                if (resultJSONObject != null && resultJSONObject.has("success") && resultJSONObject.getBoolean("success")) {
                    HttpSession session = request.getSession();
                    session.setAttribute("UserName", userName);
                    session.setAttribute("UserID", resultJSONObject.get("userid"));
                    session.setAttribute("roleid", resultJSONObject.optInt("roleid", 2));
                    session.setMaxInactiveInterval(1200);
                    
                    String summarymsgsentdate = resultJSONObject.optString("summarymsgsentdate", "");
                    //Send Summary Message to main admin
                    if(resultJSONObject.optInt("roleid", 2) == 1 && !StringUtils.isNullOrEmpty(summarymsgsentdate)){
                        boolean msgStatus = loginDaoObj.sendSummaryMessage(resultJSONObject.getString("userid"), summarymsgsentdate);
                    }
                    UserDao userDaoObj = new UserDaoImpl();
                    userDaoObj.backupdb();
                    
                    resultJSONObject = loginDaoObj.initialStock();
                    request.getRequestDispatcher("home.jsp").include(request, response);
//                    response.sendRedirect("home.jsp");
                } else {
                    response.sendRedirect("login.jsp?invalidflag=true");
//                    out.println("<h1>Username or Password is wrong. Please try again.</h1>");
                }
                }else{
                     response.sendRedirect("login.jsp?invalidflag=false");
                }
            }
        }
    } 

    public JSONObject validLogin(String user, String pwd) throws JSONException {
        JSONObject loginJSONObject = new JSONObject();
        try {
            loginJSONObject.put("success", false);
            loginDaoObj = new LoginDaoImpl();
            loginJSONObject = loginDaoObj.validLogin(user, pwd);
        } catch (Exception e) {
            loginJSONObject.put("conn", false);
            e.printStackTrace();
        }
        return loginJSONObject;
    }
}
