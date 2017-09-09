package Controller;

import DBConnection.DBPool;
import Dao.UserDao;
import DaoImpl.MenuItemDaoImpl;
import DaoImpl.UserDaoImpl;
import java.io.IOException;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "UserController", urlPatterns = {"/UserController"})
public class UserController extends HttpServlet {

    UserDao userDAOObj = new UserDaoImpl();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String result = "";
        Boolean booleanResult = false;
        JSONObject jobj = null;
        try {
            jobj = new JSONObject();
            userDAOObj = new UserDaoImpl();

            int act = Integer.parseInt(request.getParameter("act"));
            String submodule = request.getParameter("submodule");

            switch (act) {
                case 1: { // Add Methods
                    switch (submodule) {
                        case "user": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("username", request.getParameter("username"));
                            params.put("fullname", request.getParameter("fullname"));
                            params.put("password", request.getParameter("password"));
                            params.put("address", request.getParameter("address"));
                            params.put("mobile", request.getParameter("mobile"));
                            params.put("gender", request.getParameter("gender"));
                            params.put("datepicker", request.getParameter("datepicker"));
                            result = userDAOObj.addUser(params);
                            response.sendRedirect("AddUser.jsp?result=" + result);

                        }
                        break;
                        case "employee": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("customid", request.getParameter("customid"));
                            params.put("employeename", request.getParameter("employeename"));
                            params.put("designation", request.getParameter("designation"));
                            params.put("address", request.getParameter("address"));
                            params.put("mobile", request.getParameter("mobile"));
                            params.put("gender", request.getParameter("gender"));
                            params.put("dob", request.getParameter("dob"));
                            params.put("hiredate", request.getParameter("hiredate"));
                            result = userDAOObj.addEmployee(params);
                            response.sendRedirect("AddEmployeeDetails.jsp?result=" + result);
                        }
                        break;
                        case "customer": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("customid", request.getParameter("customid"));
                            params.put("customername", request.getParameter("customername"));
                            params.put("address", request.getParameter("address"));
                            params.put("mobile", request.getParameter("mobile"));
                            result = userDAOObj.addCustomer(params);
                            response.sendRedirect("CustomerDetails.jsp?result=" + result);
                        }
                        break;
                    }
                }
                break;
                case 2: { // Edit/Update Methods
                    switch (submodule) {
                        case "user": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("userid", request.getParameter("userid"));//long toDateInLong = new Date(toyear + "//long toDateInLong = new Date(toyear + "/" + tomonth + "/" + today).getTime();/" + tomonth + "/" + today).getTime();
                            params.put("username", request.getParameter("username"));
                            params.put("password", request.getParameter("password"));
                            params.put("fullname", request.getParameter("fullname"));
                            params.put("address", request.getParameter("address"));
                            params.put("mobile", request.getParameter("mobile"));
                            params.put("gender", request.getParameter("gender"));
                            result = userDAOObj.updateUser(params);
                            response.sendRedirect("AddUser.jsp?result=" + result);

                        }
                        break;
                        case "employee": {
                            String extraParams = request.getParameter("extraParams");
                            JSONArray jsonArr = new JSONObject(extraParams).getJSONArray("data");
                            JSONObject jsonObj = jsonArr.getJSONObject(0);
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("employeeid", jsonObj.getString("employeeid"));
                            params.put("employeename", jsonObj.getString("employeename"));
                            params.put("designation", jsonObj.getString("designation"));
                            params.put("address", jsonObj.getString("address"));
                            params.put("mobile", jsonObj.getString("mobile"));
                            params.put("gender", jsonObj.getString("gender"));
                            params.put("dob", jsonObj.getString("dob"));
                            params.put("hiredate", jsonObj.getString("hiredate"));
                            result = userDAOObj.updateEmployee(params);
//                            response.sendRedirect("AddCategory.jsp?result=" + result);
                            response.getWriter().write(result);
                        }
                        break;
                    }
                }
                break;
                case 3: { // Delete Methods
                    switch (submodule) {
                        case "user": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String id = request.getParameter("userid");
                            result = userDAOObj.deleteUser(id);
                            response.sendRedirect("AddUser.jsp?result=" + result);
                        }
                        break;
                        case "employee": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String id = request.getParameter("id").toString();
                            result = userDAOObj.deleteEmployee(id);
                            response.getWriter().write(result);
                        }
                        break;

                    }
                }
                break;
                case 4: {
                    switch (submodule) {
//                        case "category": {
////                            HashMap<String, String> params = new HashMap<String, String>();
////                            String id = request.getParameter("id").toString();
////                            result = menuItemDAOObj.deleteCategory(id);
////                            response.sendRedirect("AddCategory.jsp?result=" + result);
//                            }
//                        break;
                        case "employee": {
                            JSONObject responseJsonObj = new JSONObject();
                            HashMap<String, String> params = new HashMap<String, String>();
                            String designation = request.getParameter("designation");
                            responseJsonObj = userDAOObj.getEmployeeJsonList1(designation);
//                            response.sendRedirect("AddSubCategory.jsp?result=" + result);
                            response.getWriter().write(responseJsonObj.toString());
                        }
//                        break;
////                        case "menuitem": {
//                            HashMap<String, String> params = new HashMap<String, String>();
//                            String id = request.getParameter("id").toString();
//                            result = menuItemDAOObj.deleteMenuItem(id);
//                            response.sendRedirect("AddMenuItem.jsp?result=" + result);
//                        }
//                        break;
                    }
                }
                break;
                case 5 : { // for DB backup request
                    switch (submodule) {
                        case "dbbackup" : {
                            JSONObject responseObject = userDAOObj.backupdb();
                            String message = "";
                            if(responseObject.getBoolean("success")){
                                message = responseObject.getString("successMessage");
                            } else{
                                message = responseObject.getString("failureMessage");
                            }
                            response.sendRedirect("home.jsp?success="+responseObject.getBoolean("success")+"&message=" + message);
                        }
                        break;
                    }
                }
                break;
            }

        } catch (Exception e) {

        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

//    public Boolean saveUser(String custName, String custAdd, int custMobno,String gender) {
//        boolean result = false;
//        HashMap<String, String> params = new HashMap<String, String>();
//        try {
//
//            params.put("name", custName);
//            params.put("address", custAdd);
//            params.put("mobile", custMobno);
//            params.put("gender",gender);
//            result = custDaoObj.saveUser(params);
//        } catch (Exception e) {
//
//        }
//        return result;
//    }
//    public Boolean updateUser(String Name, String Addr, int Mobno,String gender) {
//        boolean result = false;
//        HashMap<String, String> params = new HashMap<String, String>();
//        try {
//
//            params.put("name", Name);
//            params.put("address", Addr);
//            params.put("mobile", Mobno);
//            params.put("gender",gender);
//            result = custDaoObj.updateUser(params);
//        } catch (Exception e) {
//
//        }
//        return result;
//    }
//
//    public Boolean deleteUser(String userName) {
//        boolean result = false;
//        HashMap<String, String> params = new HashMap<String, String>();
//        try {
//            params.put("name", userName);
//            result = custDaoObj.deleteUser(params);
//
//        } catch (Exception e) {
//
//        }
//        return result;
//
//    }
//}

