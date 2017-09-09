/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Services;

import Dao.MenuItemDao;
import Dao.ReviewDao;
import DaoImpl.MenuItemDaoImpl;
import DaoImpl.ReviewDaoImpl;
import com.mysql.jdbc.StringUtils;
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
 * @author sai
 */
@WebServlet(name = "ReviewServices", urlPatterns = {"/ReviewServices"})
public class ReviewServices extends HttpServlet {

   ReviewDao reviewDaoObj = new ReviewDaoImpl();
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String resultString= "";
        JSONObject returnJSONObject = null;
        try (PrintWriter out = response.getWriter()) {
            returnJSONObject = new JSONObject();
            ReviewDao reviewDaoObj = new ReviewDaoImpl();

            try {
                int action = Integer.parseInt(request.getParameter("act"));
                String mode = request.getParameter("submodule");

                switch (action) {
                    case 1: //for get Data
                    {
                        switch (mode) {

                            case "review": {     //getCategory()
                                HashMap<String, String> params = new HashMap<String, String>();
                                String reviewList = request.getParameter("reviewjson");
                                JSONObject reviewjson = new JSONObject(reviewList);
                                params.put("customername", reviewjson.getString("customername"));
                                params.put("address", reviewjson.getString("address"));
                                params.put("mobile", reviewjson.getString("mobile"));
                                params.put("phone", StringUtils.isNullOrEmpty(reviewjson.getString("phone")) ? "" : reviewjson.getString("phone"));
                                params.put("emailid", reviewjson.getString("emailid"));
                                params.put("dob", reviewjson.getString("dob"));
                                params.put("ratingenvironment", reviewjson.getString("ratingenvironment"));
                                params.put("ratingfoodquality", reviewjson.getString("ratingfoodquality"));
                                params.put("ratingservice", reviewjson.getString("ratingservice"));
                                params.put("comment", reviewjson.getString("comment"));
                                resultString = reviewDaoObj.addReview(params);
                            }
                            break;
                        }
                    }
                    break;
                        
                    case 2: // Add or Edit 
                    {
                        switch (mode) {

                            case "review": {         //add Category()

                            }
                            break;
                        }
                    }
                    break;

                    case 3: // Delete
                    {
                        switch (mode) {

                            case "review": {         //Delete Category()
                                returnJSONObject = reviewDaoObj.getReviewList();
                            }
                            break;
                        }
                    }
                    break;
                }
                
                out.print(resultString);
                
            } catch (JSONException e) {
                
                out.print (resultString);
            }
        } catch (Exception e){
            e.printStackTrace();
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

    
   
}
