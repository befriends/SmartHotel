/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Dao.BillingPageDao;
import DaoImpl.BillingPageDaoImpl;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

/**
 *
 * @author Swapnil
 */
@WebServlet(name = "BillingPageController", urlPatterns = {"/BillingPageController"})
public class BillingPageController extends HttpServlet{
    
    
   BillingPageDao bpdao = null;
   
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out=response.getWriter();
        String result = "";
        Boolean booleanResult = false;
        JSONObject jobj = null;
        
        try {
            jobj = new JSONObject();
            bpdao = new BillingPageDaoImpl();
 
           int act = Integer.parseInt(request.getParameter("act"));
            String submodule = request.getParameter("submodule");
 
            switch (act) {
                case 1: { // Add Methods
                     
                    switch (submodule) {
                        
                        case "BillingPage": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("discount", request.getParameter("discount"));
                            params.put("discountreason", request.getParameter("discountreason"));
                            params.put("total", request.getParameter("total"));
                            params.put("orderid", request.getParameter("orderid"));
                            
                            
                            result = bpdao.Discount(params);
                            response.sendRedirect("BillingPage.jsp?result=" + result);
                        }
                        break;
                    }
                }
                break;
            
               
            }

        } catch (Exception e) {

        }

    }
    
}
