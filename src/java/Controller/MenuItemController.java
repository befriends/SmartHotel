/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Dao.MenuItemDao;
import DaoImpl.MenuItemDaoImpl;
import com.mysql.jdbc.StringUtils;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author vishwas
 */
@WebServlet(name = "MenuItemController", urlPatterns = {"/MenuItemController"})
public class MenuItemController extends HttpServlet {

    MenuItemDao menuItemDAOObj = null;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String result = "";
        Boolean booleanResult = false;
        JSONObject jobj = null;
        try {
            jobj = new JSONObject();
            menuItemDAOObj = new MenuItemDaoImpl();
            
            int act = Integer.parseInt(request.getParameter("act"));
            String submodule = request.getParameter("submodule");
            
            switch (act) {
                case 1: { // Add Methods
                    switch (submodule) {
                        case "category": {
                                HashMap<String, String> params = new HashMap<String, String>();
                                params.put("customid", request.getParameter("customid"));
                                params.put("categoryname", request.getParameter("categoryname"));
                                result = menuItemDAOObj.addCategory(params);     
                                response.sendRedirect("AddCategory.jsp?result="+result);
                            }
                            break;
                        case "subcategory": {
                                HashMap<String,String> params = new HashMap<String,String>();
                                params.put("customid", request.getParameter("customid"));
                                params.put("categoryid", request.getParameter("categoryid"));
                                params.put("subcategoryname", request.getParameter("subcategoryname"));
                                result = menuItemDAOObj.addSubCategory(params);     
                                response.sendRedirect("AddSubCategory.jsp?result="+result);
                            }
                            break;
                        case "menuitem": {
                                HashMap<String,String> params = new HashMap<String,String>();
                                params.put("customid", request.getParameter("customid"));
                                params.put("categoryid", request.getParameter("categoryid"));
                                params.put("subcategoryid", request.getParameter("subcategoryid"));
                                params.put("itemName", request.getParameter("itemName"));
                                params.put("rate", request.getParameter("rate"));
                                result = menuItemDAOObj.addMenuItem(params);     
                                response.sendRedirect("AddMenuItem.jsp?result="+result);

                            }
                            break;
                        case "message": {
                                HashMap<String,String> params = new HashMap<String,String>();
                                //params.put("customid", request.getParameter("customid"));
                                params.put("categoryid", request.getParameter("categoryid"));
                                params.put("messageid", request.getParameter("messageid"));
                                params.put("message", request.getParameter("message"));
                                result = menuItemDAOObj.addMessage(params);     
                                response.sendRedirect("AddMessage.jsp?result="+result);

                            }
                            break;
                        case "specialmenu": {
                                HashMap<String,String> params = new HashMap<String,String>();
                                params.put("menuitemid", request.getParameter("menuitemid"));
                                String isspecial = "0";
                                if(!StringUtils.isNullOrEmpty(request.getParameter("isspecial"))){
                                    isspecial = request.getParameter("isspecial").equals("on") ? "1" : "0";
                                }
                                params.put("isspecial", isspecial);
                                result = menuItemDAOObj.setSpecialMenuItem(params);
                                response.sendRedirect("SetSpecialMenuItem.jsp?result="+result);
                            }
                            break;
                        case "printer": {
                                HashMap<String,String> params = new HashMap<String,String>();
                                String []arr = request.getParameterValues("categoryid");
                                String categoryid = "";
                                for (String arr1 : arr) {
                                    categoryid += arr1 + ",";
                                }
                                if(arr.length > 0){
                                    categoryid = categoryid.substring(0, categoryid.length()-1);
                                }
                                params.put("categoryid", categoryid);
                                params.put("printername", request.getParameter("printernm"));
                                result = menuItemDAOObj.setCategoryPrinter(params);
                                response.sendRedirect("SetCategoryPrinter.jsp?result="+result);
                            }
                            break;
                    }
                }
                break;
                case 2: { // Edit/Update Methods
                    switch (submodule) {
                        case "category": {
                            String extraParams = request.getParameter("extraParams");
                            JSONArray jsonArr = new JSONObject(extraParams).getJSONArray("data");
                            JSONObject jsonObj = jsonArr.getJSONObject(0);
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("categoryid", jsonObj.getString("categoryid"));
                            params.put("categoryname", jsonObj.getString("categoryname"));
                            result = menuItemDAOObj.updateCategory(params);
//                            response.sendRedirect("AddCategory.jsp?result=" + result);
                            response.getWriter().write(result);
                        }
                        break;
                        case "subcategory": {
                            String extraParams = request.getParameter("extraParams");
                            JSONArray jsonArr = new JSONObject(extraParams).getJSONArray("data");
                            JSONObject jsonObj = jsonArr.getJSONObject(0);
                            
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("subcategoryid", jsonObj.getString("subcategoryid"));
                            params.put("subcategoryname", jsonObj.getString("subcategoryname"));
                            result = menuItemDAOObj.updateSubCategory(params);
                         //   response.sendRedirect("AddSubCategory.jsp?result=" + result);
                            response.getWriter().write(result);

                        }
                        break;
                        case "menuitem": {
                            String extraParams = request.getParameter("extraParams");
                            JSONArray jsonArr = new JSONObject(extraParams).getJSONArray("data");
                            JSONObject jsonObj = jsonArr.getJSONObject(0);
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("menuitemid", jsonObj.getString("menuitemid"));
                            params.put("menuitemname", jsonObj.getString("menuitemname"));
                            params.put("rate", jsonObj.getString("rate"));
                            result = menuItemDAOObj.updateMenuItem(params);
                           // response.sendRedirect("AddMenuItem.jsp?result=" + result);
                            response.getWriter().write(result);

                        }
                        break;
                            case "message": {
                            String extraParams = request.getParameter("extraParams");
                            JSONArray jsonArr = new JSONObject(extraParams).getJSONArray("data");
                            JSONObject jsonObj = jsonArr.getJSONObject(0);
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("messageid", jsonObj.getString("messageid"));
                            params.put("isactive", jsonObj.getString("isactive"));
                            result = menuItemDAOObj.updateMessage(params);
                           // response.sendRedirect("AddMenuItem.jsp?result=" + result);
                            response.getWriter().write(result);

                        }
                        break;  
                    }
                }
                break;
                case 3: { // Delete Methods
                    switch (submodule) {
                        case "category": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String id = request.getParameter("id").toString();
                            result = menuItemDAOObj.deleteCategory(id);
                            response.getWriter().write(result);
                            }
                        break;
                        case "subcategory": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String id = request.getParameter("id").toString();
                            result = menuItemDAOObj.deleteSubCategory(id);
                            response.getWriter().write(result);
                        }
                        break;
                        case "menuitem": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String id = request.getParameter("id").toString();
                            result = menuItemDAOObj.deleteMenuItem(id);
                            response.getWriter().write(result);
                        }
                        break;
                             case "message": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String id = request.getParameter("id").toString();
                            result = menuItemDAOObj.deleteMessage(id);
                            response.getWriter().write(result);
                            }
                        break;
                    }
                }
                break;
                case 4:{
                    switch (submodule) {
                        case "category": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String id = request.getParameter("id").toString();
                            result = menuItemDAOObj.deleteCategory(id);
                            response.sendRedirect("AddCategory.jsp?result=" + result);
                            }
                        break;
                        case "subcategory": {
                            JSONObject responseJsonObj = new JSONObject();
                            HashMap<String, String> params = new HashMap<String, String>();
                            String categoryid = request.getParameter("categoryid").toString();
                            responseJsonObj = menuItemDAOObj.getSubCategoryListJson(categoryid);
//                            response.sendRedirect("AddSubCategory.jsp?result=" + result);
                            response.getWriter().write(responseJsonObj.toString());
                        }
                        break;
                        case "menuitem": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String id = request.getParameter("id").toString();
                            result = menuItemDAOObj.deleteMenuItem(id);
                            response.sendRedirect("AddMenuItem.jsp?result=" + result);
                        }
                        break;
                        case "messagetype": {
                            JSONObject responseJsonObj = new JSONObject();
                            HashMap<String, String> params = new HashMap<String, String>();
                            String menuitemid = request.getParameter("menuitemid").toString();
                            responseJsonObj = menuItemDAOObj.getMessageTypeByCategory(menuitemid);
//                            response.sendRedirect("AddSubCategory.jsp?result=" + result);
                            response.getWriter().write(responseJsonObj.toString());
                        }
                        break;
                    }
                }
                break;
            }
            
            
        } catch (Exception e) {
            System.out.println(e);
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
