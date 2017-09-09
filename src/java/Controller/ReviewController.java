/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Controller;

import Dao.ReviewDao;
import Dao.UserDao;
import DaoImpl.ReviewDaoImpl;
import DaoImpl.UserDaoImpl;
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
 * @author sai
 */
@WebServlet(name = "ReviewController", urlPatterns = {"/ReviewController"})
public class ReviewController extends HttpServlet {
   
   ReviewDao reviewDaoObj = new ReviewDaoImpl();
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         String result = "";
        Boolean booleanResult = false;
        JSONObject jobj = null;
        HashMap<String, String> params = null;
        JSONObject responseJobj = null;
        try {
            jobj = new JSONObject();
            reviewDaoObj = new ReviewDaoImpl();

            int act = Integer.parseInt(request.getParameter("act"));
            String submodule = request.getParameter("submodule");

            switch (act) {
                case 1: { // Add Methods
                    switch (submodule) {
                        case "review": {
                            params = new HashMap<String, String>();
                            params.put("customername", request.getParameter("customername"));
                            params.put("address", request.getParameter("address"));
                            params.put("mobile", request.getParameter("mobile"));
                            params.put("phone", request.getParameter("phone"));
                            params.put("emailid", request.getParameter("emailid"));
                            params.put("dob", request.getParameter("dob"));
                            params.put("ratingenvironment", request.getParameter("ratingenvironment"));
                            params.put("ratingfoodquality", request.getParameter("ratingfoodquality"));
                            params.put("ratingservice", request.getParameter("ratingservice"));
                            params.put("comment", request.getParameter("comment"));
                            result = reviewDaoObj.addReview(params);
                            response.sendRedirect("Review.jsp?result=" + result);
                        }
                        break;
                    }
//                    String reviewList = request.getParameter("reviewjson");
//                    params = new HashMap<String, String>(1);
//                    params.put("reviewList", reviewList);
//                    responseJobj = reviewDaoObj.saveReview(params);
                }
                break;
                case 2: { // Edit/Update Methods
                    switch (submodule) {
                        case "review": {
//                            params = new HashMap<String, String>();
//                            params.put("customername", request.getParameter("customername"));
//                            params.put("address", request.getParameter("address"));
//                            params.put("mobile", request.getParameter("mobile"));
//                            params.put("phone", request.getParameter("phone"));
//                            params.put("emailid", request.getParameter("emailid"));
//                            params.put("dob", request.getParameter("dob"));
//                            params.put("rating", request.getParameter("rating"));
//                            params.put("rating1", request.getParameter("rating1"));
//                            params.put("rating2", request.getParameter("rating2"));
//                            params.put("comment", request.getParameter("comment"));
//                            result = reviewDaoObj.addReview(params);
//                            response.sendRedirect("Review.jsp?result=" + result);
                        }
                        break;
                       
                    }
                }
                break;
                case 3: { // Delete Methods
                    switch (submodule) {
                        

                    }
                }
                break;
                case 4:{
                    switch (submodule) {
//                        
                        
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
