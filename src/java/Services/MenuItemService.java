
package Services;

import Controller.MenuItemController;
import Controller.UserController;
import Dao.MenuItemDao;
import DaoImpl.MenuItemDaoImpl;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


@WebServlet(name = "MenuItemService", urlPatterns = {"/MenuItemService"})
public class MenuItemService extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        JSONObject returnJSONObject = null;
        try (PrintWriter out = response.getWriter()) {

            returnJSONObject = new JSONObject();

            MenuItemDao menuItemDaoImpl = new MenuItemDaoImpl();

            try {

                int action = Integer.parseInt(request.getParameter("action"));

                int mode = Integer.parseInt(request.getParameter("mode"));

                switch (action) {
                    case 1: //for get Data
                    {
                        switch (mode) {

                            case 1: {     //getCategory()
                                returnJSONObject = menuItemDaoImpl.getCategoryList();
                            }
                            break;

                            case 2: {      //getSubcategory()
                                returnJSONObject = menuItemDaoImpl.getSubCategoryList();

                            }
                            break;

                            case 3: {
                                returnJSONObject = menuItemDaoImpl.getMenuItemList();
                            }
                            break;
                            case 4: {
                                returnJSONObject = menuItemDaoImpl.getMessageListJson();
                            }
                            break;
                        }
                    }
                    break;

                    case 2: // Add or Edit 
                    {
                        switch (mode) {

                            case 1: {         //add Category()

                            }
                            break;

                            case 2: {

                            }
                            break;

                            case 3: {

                            }
                            break;
                        }
                    }
                    break;

                    case 3: // Delete
                    {
                        switch (mode) {

                            case 1: {         //Delete Category()

                            }
                            break;

                            case 2: {

                            }
                            break;

                            case 3: {

                            }
                            break;
                        }
                    }
                    break;
                }
                
                out.print (returnJSONObject);
                
            } catch (JSONException e) {
                
                out.print (returnJSONObject);
            } catch (SQLException ex) {
                Logger.getLogger(MenuItemService.class.getName()).log(Level.SEVERE, null, ex);
            }
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
