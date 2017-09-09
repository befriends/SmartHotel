/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Dao.ProductReportDao;
import DaoImpl.ProductReportDaoImpl;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Swapnil
 */
@WebServlet(name = "ProductReportController", urlPatterns = {"/ProductReportController"})
public class ProductReportController extends HttpServlet{
   
    

   ProductReportDao produDaoObj = null;
   
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out=response.getWriter();
        String result = "";
        Boolean booleanResult = false;
        JSONObject jobj = null;
        
        try {
            jobj = new JSONObject();
            produDaoObj = new ProductReportDaoImpl();
 
           int act = Integer.parseInt(request.getParameter("act"));
            String submodule = request.getParameter("submodule");
 
            switch (act) {
                case 1: { // Add Methods
                     
                    switch (submodule) {
                        
                        case "ProductReport": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("itemid", request.getParameter("itemid"));
                            params.put("itemname", request.getParameter("itemname"));
                            params.put("itemprice", request.getParameter("itemprice"));
                            result = produDaoObj.addProductReport(params);
                            response.sendRedirect("ProductReport.jsp?result=" + result);
                        }
                        break;
                    }
                }
                break;
                
                case 2: { // Delete Methods
                     
                    switch (submodule) {
                        
                        case "ProductReport": {
                            
                            String id = request.getParameter("itemid");
                            result = produDaoObj.DeleteProductReport(id);
                            response.sendRedirect("ProductReport.jsp?result=" + result);
                           
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

    