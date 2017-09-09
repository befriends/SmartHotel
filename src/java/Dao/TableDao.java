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
 * @author vishwas
 */
public interface TableDao {
    
    public String addTable(HashMap<String, String> params)throws SQLException;
    
    public String addTotalcountOfTable(int count)throws SQLException;
    
    public JSONObject getAllTableList() throws JSONException, IOException , SQLException;

    public JSONObject getAllActiveTableList() throws JSONException, IOException, SQLException;
    
    public JSONObject getTableList(HashMap<String, String> params) throws JSONException, SQLException;
              
    public JSONObject getFreeTable() throws JSONException, IOException, SQLException;
    
    public JSONObject getMasterSeting() throws JSONException, IOException, SQLException;
}
