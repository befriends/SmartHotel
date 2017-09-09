

package Dao;

import java.io.IOException;
import java.sql.SQLException;
import org.json.JSONException;
import org.json.JSONObject;


public interface LoginDao {
    
        public JSONObject validLogin(String username, String password) throws JSONException,IOException, SQLException;
        
        public JSONObject initialStock() throws JSONException, SQLException;
        
        public boolean sendSummaryMessage(String userID, String summarymsgsentdate) throws JSONException, SQLException;
    
}
