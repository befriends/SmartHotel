package Controller;

import Dao.MenuItemDao;
import Dao.PaymentDao;
import DaoImpl.PaymentDaoImpl;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet(name = "PaymentController", urlPatterns = {"/PaymentController"})
public class PaymentController extends HttpServlet {

    PaymentDao paymentDAOObj = null;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         
        String result = "";
        Boolean booleanResult = false;
        JSONObject jobj = null;
        try {
            jobj = new JSONObject();
            paymentDAOObj = new PaymentDaoImpl();
            
            int act = Integer.parseInt(request.getParameter("act"));
 
            
            switch (act) {
                case 1: { // Save Methods

                    HashMap<String, String> params = new HashMap<String, String>();
                    params.put("employeeid", request.getParameter("employeeid"));
                    params.put("customid", request.getParameter("customid"));
                    params.put("designation", request.getParameter("designation"));
                    params.put("modeofpayment", request.getParameter("modeofpayment"));
                    params.put("paymentamount", request.getParameter("paymentamount"));
                    params.put("datepicker1", request.getParameter("datepicker1"));
                    result = paymentDAOObj.savePayment(params);
                    response.sendRedirect("MakePayment.jsp?result=" + result);
                }
                break;
        }
        }
        catch (Exception e) {

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
