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
public interface PurchaseMaterialDao {
    
    public String addPurchaseMaterial(HashMap<String, String> params)throws SQLException;
    
    public String getPurchaseMaterialList() throws SQLException;
    
    public JSONObject getPurchaseList() throws JSONException, IOException, SQLException;
    
    public JSONObject getQuantityListJson(String categoryid) throws Exception;

    public JSONObject getMaterialList() throws JSONException, IOException, SQLException;
    
    public String addMaterialStock(HashMap<String, String> params)throws SQLException;
    
    public String addExpenceMaterial(HashMap<String, String> params)throws SQLException;
     
    public JSONObject getStockList() throws JSONException, IOException,SQLException;
   
    public String addComposition(HashMap<String, String> params) throws JSONException, IOException, SQLException;
    
    public String getCompositionDetails(HashMap<String, String> params) throws JSONException, IOException, SQLException;
    
    public JSONObject stockMaterialDetailsList() throws JSONException, IOException, SQLException;
    
     public String addCounterMaterialStock(HashMap<String, String> params)throws SQLException;
}
