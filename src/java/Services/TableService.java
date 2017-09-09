package Services;


import Dao.OrderDao;
import Dao.TableDao;
import DaoImpl.OrderDaoImpl;
import DaoImpl.TableDaoImpl;
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
import org.json.JSONException;
import org.json.JSONObject;

@WebServlet(name = "TableService", urlPatterns = {"/TableService"})
public class TableService extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {

        response.setContentType("text/html;charset=UTF-8");
        JSONObject returnJSONObject = null;
        try (PrintWriter out = response.getWriter()) {

            returnJSONObject = new JSONObject();

            TableDao tableDaoImpl = new TableDaoImpl();
            
            OrderDao orderObj = new OrderDaoImpl();
        try {

                int action = Integer.parseInt(request.getParameter("action"));

                int mode = Integer.parseInt(request.getParameter("mode"));

                switch (action) {
                    case 1: //for get Data
                    {
                        switch (mode) {

                            case 1: {     //getActiveTable()
                                HashMap<String, String> params = new HashMap<String, String>();
                                params.put("mode", request.getParameter("mode"));
                                returnJSONObject = tableDaoImpl.getTableList(params);
                            }
                            break;

//                            case 2: {    //getBookedTable
//                                 HashMap<String, String> params = new HashMap<String, String>();
//                                params.put("mode", request.getParameter("mode"));
//                                returnJSONObject = tableDaoImpl.getTableList(params);
//                            }
//                            break;
//
//                            case 3: {    //getResevedTable()
//                                 HashMap<String, String> params = new HashMap<String, String>();
//                                params.put("mode", request.getParameter("mode"));
//                                returnJSONObject = tableDaoImpl.getTableList(params);
//                            }
//                            break;
                        }
                    }
                    break;

                    case 2:  
                    {
                        switch (mode) {

                            case 1: {  // get Current Table Order
                                HashMap<String, String> params = new HashMap<String, String>();
                                params.put("tableid", request.getParameter("tableid"));
                                returnJSONObject = orderObj.getOrderList(params);

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

                    case 3: 
                    {
                        switch (mode) {

                            case 1: {        

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
            }}

} 
     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(TableService.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(TableService.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
