
package Controller;

import Dao.PurchaseMaterialDao;
import Dao.UserDao;
import DaoImpl.PurchaseMaterialDaoImpl;
import DaoImpl.UserDaoImpl;
import com.mysql.jdbc.StringUtils;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet(name = "PurchaseMaterialController", urlPatterns = {"/PurchaseMaterialController"})
public class PurchaseMaterialController extends HttpServlet {
    PurchaseMaterialDao purchasematerialDAOObj = new PurchaseMaterialDaoImpl();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String result = "",messageflag="false";
        Boolean booleanResult = false;
        JSONObject jobj = null;
        try {
            jobj = new JSONObject();
            purchasematerialDAOObj = new PurchaseMaterialDaoImpl();

            int act = Integer.parseInt(request.getParameter("act"));
            String submodule = request.getParameter("submodule");

            switch (act) {
                case 1: { // Add Methods
                    switch (submodule) {
                        case "materialstock": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("customid", request.getParameter("customid"));
                            params.put("purchasematerialname", request.getParameter("purchasematerialname"));
                            params.put("quantity", request.getParameter("quantity"));
                            result = purchasematerialDAOObj.addMaterialStock(params);
                            response.sendRedirect("AddMaterialStock.jsp?result=" + result);
                        }
                        break;
                        case "purchasematerial": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("customid", request.getParameter("customid")); 
                            params.put("materialid", request.getParameter("materialid"));
                            params.put("price", request.getParameter("price"));
                            params.put("quantity", request.getParameter("quantity"));
                            params.put("totalamount", request.getParameter("totalamount"));
                             if( !StringUtils.isNullOrEmpty(request.getParameter("messageflag")) ){
                                  messageflag = request.getParameter("messageflag");
                            params.put("messageflag", messageflag);
            }

                            params.put("datepicker1", request.getParameter("datepicker1"));
                            result = purchasematerialDAOObj.addPurchaseMaterial(params);
                            response.sendRedirect("AddPurchaseMaterial.jsp?result=" + result);
                        }
                        break;
                        case "expencematerial": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("customid", request.getParameter("customid")); 
                            params.put("materialid", request.getParameter("materialid"));
                            params.put("quantity", request.getParameter("quantity"));
                            params.put("datepicker1", request.getParameter("datepicker1"));
                            result = purchasematerialDAOObj.addExpenceMaterial(params);
                            response.sendRedirect("AddExpenceMaterial.jsp?result=" + result);
                        }
                        break;
                        case "composition": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("compositionlistjson", request.getParameter("compositionlistjson")); 
                            result = purchasematerialDAOObj.addComposition(params);
                            response.sendRedirect("MenuItemComposition.jsp?result=" + result);
                        }
                        break;
                            case "countermaterialstock": {
                            HashMap<String, String> params = new HashMap<String, String>();                            
                            params.put("materialname", request.getParameter("materialname"));
                            params.put("quantity", request.getParameter("quantity"));
                            result = purchasematerialDAOObj.addCounterMaterialStock(params);
                            response.sendRedirect("CounterSellStock.jsp?result=" + result);
                        }
                        break;
                    }
                }
                break;
                case 2: { // Edit/Update Methods
                    switch (submodule) {
                        case "user": {
//                            HashMap<String, String> params = new HashMap<String, String>();
//                            params.put("userid", request.getParameter("userid"));
//                            params.put("username", request.getParameter("username"));
//                            params.put("password", request.getParameter("password"));
//                            params.put("fullname", request.getParameter("fullname"));
//                            params.put("address", request.getParameter("address"));
//                            params.put("mobile", request.getParameter("mobile"));
//                            params.put("gender", request.getParameter("gender"));
//                            result = purchasematerialDAOObj.updateUser(params);
//                            response.sendRedirect("AddUser.jsp?result=" + result);

                        }
                        break;
                    }
                }
                break;
                case 3: { // Delete Methods
                    switch (submodule) {
                        case "user": {
//                            HashMap<String, String> params = new HashMap<String, String>();
//                            String id = request.getParameter("userid");
//                            result = purchasematerialDAOObj.deleteUser(id);
//                            response.sendRedirect("AddUser.jsp?result=" + result);
                        }
                        break;

                    }
                }
                case 4:{// Get Methods
                    switch (submodule) {
                        case "user": {
//                            HashMap<String, String> params = new HashMap<String, String>();
//                            String id = request.getParameter("userid");
//                            result = purchasematerialDAOObj.deleteUser(id);
//                            response.sendRedirect("AddUser.jsp?result=" + result);
                        }
                        break;
                        case "purchasematerial": {
                            JSONObject responseJsonObj = new JSONObject();
                            HashMap<String, String> params = new HashMap<String, String>();
                            result = purchasematerialDAOObj.getPurchaseMaterialList();
//                          response.sendRedirect("AddSubCategory.jsp?result=" + result);
                            response.sendRedirect("AddPurchaseMaterial.jsp?result=" + result);
                        }
                        break;
                        case "composition": {
                            JSONObject responseJsonObj = new JSONObject();
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("menuitemname", request.getParameter("menuname"));
                            params.put("menuitemid", request.getParameter("menuid"));
                            result = purchasematerialDAOObj.getCompositionDetails(params);
                            response.getWriter().write(result);
                        }
                        break;
                    }
                
                }
                break;
                case 5:{// Get Methods
                     switch (submodule) {
                        case "user": {
                            JSONObject responseJsonObj = new JSONObject();
                            HashMap<String, String> params = new HashMap<String, String>();
                            String materialid = request.getParameter("materialid").toString();
                            responseJsonObj = purchasematerialDAOObj.getQuantityListJson(materialid);
//                            response.sendRedirect("AddSubCategory.jsp?result=" + result);
                            response.getWriter().write(responseJsonObj.toString());
                        }
                        break;

                    }
                   
                  }
                break;
            }

        } catch (Exception e) {

        }

    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

  @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
