package Dao;

import java.io.IOException;
import java.util.HashMap;
import org.json.JSONException;
import java.sql.SQLException;
import org.json.JSONObject;

public interface ReportDao {

    public String dateSales(HashMap<String, String> params) throws JSONException, SQLException;

    public String paymentDate(HashMap<String, String> params) throws JSONException, SQLException;

    public String monthlysales(HashMap<String, String> params) throws JSONException, SQLException;

    public String yearsales(HashMap<String, String> params) throws JSONException, SQLException;

    public String TableDateReport(HashMap<String, String> params) throws JSONException, SQLException;

    public String paymentEmployee(HashMap<String, String> params) throws JSONException, SQLException;

    public String DateAllTableReport(HashMap<String, String> params) throws JSONException, SQLException;

    public String DateWiseKOTReport(HashMap<String, String> params) throws JSONException, SQLException;

//    public String purchaseDate(HashMap<String, String> params) throws JSONException;
//    public String purchaseMonth(HashMap<String, String> params) throws JSONException;
//    public String purchaseYear(HashMap<String, String> params) throws JSONException;
    public String purchaseMaterial(HashMap<String, String> params) throws JSONException, SQLException;

    public String monthlyPurchase(HashMap<String, String> params) throws JSONException, SQLException;

    public String yearlyPurchase(HashMap<String, String> params) throws JSONException, SQLException;

    public String purchaseName(HashMap<String, String> params) throws JSONException, SQLException;

    public String stockName(HashMap<String, String> params) throws JSONException, SQLException;

    public String monthylcancel(HashMap<String, String> params) throws JSONException, SQLException;

    public String expenceMaterial(HashMap<String, String> params) throws JSONException, SQLException;

    public String monthlyExpense(HashMap<String, String> params) throws JSONException, SQLException;

    public String expenceName(HashMap<String, String> params) throws JSONException, SQLException;

    public String borrowDate(HashMap<String, String> params) throws JSONException, SQLException;

    public String monthlyBorrow(HashMap<String, String> params) throws JSONException, SQLException;

    public String DateWiseStock(HashMap<String, String> params) throws JSONException, SQLException;

    public String getDateWisePaymentModeReport(HashMap<String, String> params) throws JSONException, SQLException;

    public String dailyMenuitemRecordList(HashMap<String, String> params) throws JSONException, SQLException;

    public String monthlyAmountDetails(HashMap<String, String> params) throws JSONException, SQLException;

    public String DateWiseMenuitemRecordList(HashMap<String, String> params) throws JSONException, SQLException;
    
    public String CategoryAndDateWiseMenuItemList(HashMap<String, String> params) throws JSONException, SQLException;
    
        public JSONObject UpdateRows() throws JSONException, SQLException;
        
        public JSONObject UpdateTotalAmountRows() throws JSONException, SQLException;

    public String TwoDateWiseMenuitemRecordList(HashMap<String, String> params) throws JSONException, SQLException;
    
    public String TwoCategoryAndDateWiseMenuItemList(HashMap<String, String> params) throws JSONException, SQLException;
    
    public JSONObject getDateWiseOrderDetails(String selectDate) throws JSONException, IOException,SQLException;
    
    public JSONObject getOrderDetailList(String orderid) throws JSONException, SQLException;
}
