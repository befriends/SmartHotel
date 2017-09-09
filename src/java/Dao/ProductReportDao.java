/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Dao;

import java.sql.SQLException;
import java.util.HashMap;

/**
 *
 * @author Swapnil
 */
public interface ProductReportDao {
    
    public String addProductReport(HashMap<String,String> params) throws SQLException;
    public String getProductReportList() throws SQLException;
    public String DeleteProductReport(String id) throws SQLException;
    
}
