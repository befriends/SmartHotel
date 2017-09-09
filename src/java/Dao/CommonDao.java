package Dao;

import java.sql.SQLException;
import java.util.HashMap;
import org.json.JSONException;
import org.json.JSONObject;

public interface CommonDao {

    public String generateNextID(HashMap<String, String> params);

    public JSONObject printHeder() throws JSONException, SQLException;
}
