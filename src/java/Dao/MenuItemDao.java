/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Dao;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author vishwas
 */
public interface MenuItemDao {
    
    public String addCategory(HashMap<String, String> params)throws SQLException;
    
    public String addSubCategory(HashMap<String,String> params)throws SQLException;
    
    public String addMenuItem(HashMap<String, String> params)throws SQLException;
    
    public String addMessage(HashMap<String, String> params)throws SQLException;
    
    public JSONObject getCategoryList() throws JSONException, IOException, SQLException;
    
    public JSONObject getSubCategoryList() throws JSONException, IOException, SQLException;
    
    public JSONObject getSubCategoryListJson(String categoryid) throws Exception;
    
    public JSONObject getMenuItemList() throws JSONException,IOException, SQLException;
    
    public JSONObject getMessageListJson() throws JSONException,IOException, SQLException;
    
    public JSONArray getMenuItemDetailsList() throws SQLException;
    
    public JSONObject getMessageList() throws JSONException, IOException, SQLException;
    
    public JSONObject getMessageTypeByCategory(String menuitemid) throws Exception;
        
    public String updateCategory(HashMap<String, String> params)throws SQLException;
    
    public String updateSubCategory(HashMap<String, String> params)throws SQLException;
    
    public String updateMenuItem(HashMap<String, String> params)throws SQLException;
    
    public String updateMessage(HashMap<String, String> params)throws SQLException;
    
    public String outOfStoke(HashMap<String, String> params)throws SQLException;
    
    public String deleteMenuItem(String id)throws SQLException;
    
    public String deleteCategory(String id)throws SQLException;
    
    public String deleteSubCategory(String id)throws SQLException;
    
    public String deleteMessage(String id)throws SQLException;
    
    public String listOfMenuItemList() throws SQLException;
    
    public String setSpecialMenuItem(HashMap<String, String> params)throws SQLException, JSONException;
    
    public String getSpecialMenuItemList()throws SQLException, JSONException;
         
    public String setCategoryPrinter(HashMap<String, String> params)throws SQLException, JSONException;

}
