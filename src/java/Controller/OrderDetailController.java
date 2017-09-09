/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Dao.OrderDetailDao;
import DaoImpl.OrderDetailDaoImpl;
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
@WebServlet(name = "OrderDetailController", urlPatterns = {"/OrderDetailController"})
public class OrderDetailController extends HttpServlet{
    
    
   OrderDetailDao orderDaoObj = null;
   
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out=response.getWriter();
        String result = "";
        Boolean booleanResult = false;
        JSONObject jobj = null;
        
        try {
            jobj = new JSONObject();
            orderDaoObj = new OrderDetailDaoImpl();
 
           int act = Integer.parseInt(request.getParameter("act"));
            String submodule = request.getParameter("submodule");
 
            switch (act) {
                case 1: { // Add Methods
                     
                    switch (submodule) {
                        
                        case "OrderDetail": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("orderid", request.getParameter("orderid"));
                            params.put("menuitem", request.getParameter("menuitem"));
                            params.put("quantity", request.getParameter("quantity"));
                            params.put("comment", request.getParameter("comment"));
                            params.put("tableno", request.getParameter("tableno"));
                                                        
                            result = orderDaoObj.addOrderDetail(params);
                            response.sendRedirect("OrderDetail.jsp?result=" + result);
                        }
                        break;
                    }
                }
                break;
                 case 2: { // Update Methods
                     
                    switch (submodule) {
                        
                        case "OrderDetail": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("orderid", request.getParameter("orderid"));
                            params.put("menuitem", request.getParameter("menuitem"));
                            params.put("amount", request.getParameter("amount"));
                            params.put("paidamount", request.getParameter("paidamount"));
                            params.put("reason", request.getParameter("reason"));
                            params.put("tableno", request.getParameter("tableno"));                         
                            result = orderDaoObj.UpdateOrderDetail(params);
                            response.sendRedirect("OrderDetail.jsp?result=" + result);
                        }
                        break;
                    }
                }
                break;
                
                case 3: { // Delete Methods
                     
                    switch (submodule) {
                        
                        case "OrderDetail": {
                            
                            String id = request.getParameter("orderid");
                            result = orderDaoObj.DeleteOrderDetail(id);
                            response.sendRedirect("OrderDetail.jsp?result=" + result);
                           
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
