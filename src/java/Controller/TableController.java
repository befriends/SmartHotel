/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Controller;

import Dao.TableDao;
import DaoImpl.TableDaoImpl;
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
 * @author sai
 */
@WebServlet(name = "TableController", urlPatterns = {"/TableController"})
public class TableController extends HttpServlet {

    TableDao tableDaoObj = null;
    String result = "";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HashMap<String, String> params = null;
        JSONObject responseJobj = null;
        try {
            tableDaoObj = new TableDaoImpl();
            int act = Integer.parseInt(request.getParameter("act"));
            
            switch (act) {
                case 1: {
                        params = new HashMap<String, String>();
                        params.put("tableid", request.getParameter("tableid"));
                        params.put("tablename", request.getParameter("tablename"));
                        params.put("tableno", request.getParameter("tableno"));
                        result = tableDaoObj.addTable(params);
                        response.sendRedirect("AddTable.jsp?result="+result);
                    
                }
                break;
                case 2: {
                    
                }
                break;
                case 3: {
                    
                }
                break;
                case 4: {
                    responseJobj = tableDaoObj.getAllTableList();
                    response.getWriter().write(responseJobj.toString());
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
