/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Dao.StockSystemPreferencesDao;
import DaoImpl.StockSystemPreferencesDaoImpl;
import com.mysql.jdbc.StringUtils;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONObject;

/**
 *
 * @author sai
 */
@WebServlet(name = "StockSystemPreferencesController", urlPatterns = {"/systempreferences"})
public class StockSystemPreferencesController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            int act = Integer.parseInt(request.getParameter("act"));
            switch (act) {
                case 1: {

                    String messagenotificationflag = "false";
                    String isborrow = "false";
                    String isprinthide = "false";
                    String isGST = "false";
                    String userid = "";
                    String isDuplicatePrint = "false";
                    String duplicatePrinterName = "";
                    String isService = "";

                    if (!StringUtils.isNullOrEmpty(request.getParameter("messageflag"))) {
                        messagenotificationflag = request.getParameter("messageflag");
                    }

                    if (!StringUtils.isNullOrEmpty(request.getParameter("userid"))) {
                        userid = request.getParameter("userid");
                    }

                    if (!StringUtils.isNullOrEmpty(request.getParameter("duplicateprintflag"))) {
                        isDuplicatePrint = request.getParameter("duplicateprintflag");
                    }
                    if (!StringUtils.isNullOrEmpty(request.getParameter("isborrow"))) {
                        isborrow = request.getParameter("isborrow");
                    }
                    if (!StringUtils.isNullOrEmpty(request.getParameter("isprinthide"))) {
                        isprinthide = request.getParameter("isprinthide");
                    }
                    if (!StringUtils.isNullOrEmpty(request.getParameter("isGST"))) {
                        isGST = request.getParameter("isGST");
                    }

                    if (!StringUtils.isNullOrEmpty(request.getParameter("printernm"))) {
                        duplicatePrinterName = request.getParameter("printernm");
                    }
                    if (!StringUtils.isNullOrEmpty(request.getParameter("isService"))) {
                        isService = request.getParameter("isService");
                    }

                    HashMap<String, String> params = new HashMap<String, String>();
                    params.put("messagenotificationflag", messagenotificationflag);
                    params.put("userid", userid);
                    params.put("isDuplicatePrint", isDuplicatePrint);
                    params.put("duplicatePrinterName", duplicatePrinterName);
                    params.put("isborrow", isborrow);
                    params.put("isprinthide", isprinthide);
                    params.put("isGST", isGST);
                    params.put("isService", isService);

                    StockSystemPreferencesDao systemPreferencesDAO = new StockSystemPreferencesDaoImpl();

                    JSONObject responseJSONObject = systemPreferencesDAO.saveSystemPreferences(params);

                    if (responseJSONObject.getBoolean("success")) {
                        HttpSession session = request.getSession();
                        session.setAttribute("messagenotificationflag", Boolean.parseBoolean(messagenotificationflag));
                        session.setAttribute("isDuplicatePrint", Boolean.parseBoolean(isDuplicatePrint));
                        session.setAttribute("isborrow", Boolean.parseBoolean(isborrow));
                        session.setAttribute("isprinthide", Boolean.parseBoolean(isprinthide));
                        session.setAttribute("isGST", Boolean.parseBoolean(isGST));
                        session.setAttribute("isService", Boolean.parseBoolean(isService));
                    }
//            response.sendRedirect("Home.jsp?"+responseJSONObject.toString());
                    out.print(responseJSONObject.toString());
                }
                break;
                case 2: {
                    HashMap<String, String> params = new HashMap<String, String>();
                    params.put("CGST", request.getParameter("CGST"));
                    params.put("SGST", request.getParameter("SGST"));

                    StockSystemPreferencesDao systemPreferencesDAO = new StockSystemPreferencesDaoImpl();

                    JSONObject responseJSONObject = systemPreferencesDAO.saveGSTChanges(params);
                    out.print(responseJSONObject.toString());
                }
                break;
                case 3: {
                    HashMap<String, String> params = new HashMap<String, String>();
                    params.put("servicetax", request.getParameter("serviceid"));
                    StockSystemPreferencesDao systemPreferencesDAO = new StockSystemPreferencesDaoImpl();

                    JSONObject responseJSONObject = systemPreferencesDAO.saveServiceTaxChanges(params);
                    out.print(responseJSONObject.toString());
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
