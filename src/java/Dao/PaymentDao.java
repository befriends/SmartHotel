
package Dao;

import java.sql.SQLException;
import java.util.HashMap;

public interface PaymentDao {
        
    public String savePayment(HashMap<String, String> params)throws SQLException;
}
