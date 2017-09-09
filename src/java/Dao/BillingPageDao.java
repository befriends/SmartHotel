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
 * @author Swapnil
 */
public interface BillingPageDao {
    public String Discount(HashMap<String ,String> params)throws SQLException;
    public JSONObject getBill() throws JSONException, IOException, SQLException;
    
}
