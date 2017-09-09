/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Dao;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author sai
 */
public interface OrderDao {
    
    public JSONObject getSearchedMenuItemList(HashMap<String, String> params) throws JSONException, SQLException;
    
    public JSONObject saveOrder(HashMap<String, String> params) throws JSONException, SQLException;
    
    public JSONObject saveOrderDetails(HashMap<String, String> params) throws JSONException, SQLException;
    
    public JSONObject getOrderList(HashMap<String, String> params) throws JSONException, SQLException;
    
    public JSONObject getOrderDetails(String orderID) throws JSONException, SQLException;
    
    public JSONObject makeBillPayment(HashMap<String, String> params) throws JSONException, SQLException;
    
    public void deductStock(String orderid,long today) throws JSONException, SQLException;
    
    public JSONObject generateNextOrderID() throws JSONException, SQLException;
    
    public String deleteOrder(HashMap<String, String> params) throws JSONException, SQLException;

    public JSONObject TableShift(HashMap<String, String> params) throws JSONException, SQLException;
    
    public JSONObject getCategoryPrinterNamesFromMenuitem(String menuitemidlist) throws JSONException, SQLException;
    
//    public String savePrint(HashMap<String, String> params) throws JSONException, SQLException;
    public JSONObject UpdateEditOrder(HashMap<String, String> params) throws JSONException, SQLException;
    

}
