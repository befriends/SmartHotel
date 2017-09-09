package Dao;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import org.json.JSONException;
import org.json.JSONObject;

public interface UserDao {

    public String addUser(HashMap<String, String> params)throws SQLException;

    public String addEmployee(HashMap<String, String> params)throws SQLException;
    
    public String addCustomer(HashMap<String, String> params)throws SQLException;
   
    public String updateUser(HashMap<String, String> params)throws SQLException;
    
    public String updateEmployee(HashMap<String, String> params)throws SQLException;

    public String deleteUser(String id)throws SQLException;

    public String getUserList() throws SQLException;

    public JSONObject getEmployeeList() throws JSONException, IOException, SQLException;
    
    public String getCustomerList() throws SQLException;
    
    public JSONObject getEmployeeJsonList() throws JSONException, IOException, SQLException;
    
    public JSONObject getEmployeeJsonList1(String designation) throws JSONException, IOException, SQLException;
    
    public String deleteEmployee(String id)throws SQLException;
    
    public JSONObject backupdb()throws SQLException, JSONException;

    public JSONObject getAvailablePrinters()throws SQLException, JSONException;

    public JSONObject getMasterSettings()throws SQLException, JSONException;
    
}
