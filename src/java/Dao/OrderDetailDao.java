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
public interface OrderDetailDao {
    public String addOrderDetail(HashMap<String ,String> params)throws SQLException;
    public String getOrderList() throws SQLException;
    public String UpdateOrderDetail(HashMap<String ,String>params)throws SQLException;
    public String DeleteOrderDetail(String id)throws SQLException;
    public JSONObject getOrderList11() throws JSONException, IOException, SQLException;
    
}
