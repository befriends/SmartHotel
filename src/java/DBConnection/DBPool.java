

package DBConnection;

import java.sql.Connection;
import java.sql.DriverManager;


public class DBPool {
    public final static Connection getConnection() {
        Connection conn = null;

        try {
            if(conn != null){
                return conn;
            } else{
                Class.forName("com.mysql.jdbc.Driver");  // MySQL database connection
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test1?user=root&password=toor");
                conn.setAutoCommit(false);
            }
        } 
        catch (Exception e) {
            e.printStackTrace();
        }
        return conn; 
    }
}
