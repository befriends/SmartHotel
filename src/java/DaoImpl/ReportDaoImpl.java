package DaoImpl;

import DBConnection.DBPool;
import Dao.ReportDao;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ReportDaoImpl implements ReportDao {

    Connection conn = null;

//    @Override
//    public String dateSales(HashMap<String, String> params) throws JSONException, SQLException{
//
//        JSONObject respoJSONObject = new JSONObject();
//        JSONObject jobj = null;
//        JSONArray jarr = new JSONArray();
//        String date = "", datepicker2 = "";
//        try {
//            date = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
//            //datepicker2 = StringUtils.isNotEmpty(params.get("datepicker2")) ? params.get("datepicker2") : "";
//
//            String fromyear = date.substring(date.lastIndexOf("/") + 1);
//            String frommonth = date.substring(date.indexOf("/") + 1, date.lastIndexOf("/"));
//            String fromday = date.substring(0, date.indexOf("/"));
//            //String toyear = datepicker2.substring(datepicker2.lastIndexOf("/") + 1);
//            // String tomonth = datepicker2.substring(datepicker2.indexOf("/") + 1, datepicker2.lastIndexOf("/"));
//            //String today = datepicker2.substring(0, datepicker2.indexOf("/"));
//
//            long fromDateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
//            //long toDateInLong = new Date(toyear + "/" + tomonth + "/" + today).getTime();
//
//            conn = DBPool.getConnection();
//
//            // PreparedStatement pst = null;
//            Statement st = conn.createStatement();
//            ResultSet rs = st.executeQuery("select o.orderid,o.orderno,o.orderdate,o.totalamount,t.tablename from ordertable o ,tableordermapping tom,tabledetails t where o.orderdate =" + fromDateInLong + " and o.orderid=tom.orderid and tom.tableid=t.tableid and iscomplete=1 and isdeleted=0 order by orderno");
//
//            while (rs.next()) {
//                jobj = new JSONObject();
//                jobj.put("orderid", rs.getString(1));
//                jobj.put("orderno", rs.getString(2));
//                jobj.put("orderdate", rs.getLong(3));
//                jobj.put("totalamount", rs.getDouble(4));
//                jobj.put("tablename", rs.getString(5));
//
//                jarr.put(jobj);
//            }
//            respoJSONObject.put("date", date);
//            respoJSONObject.put("data", jarr);
//            respoJSONObject.put("success", true);
//        } catch (Exception e) {
//            respoJSONObject.put("data", "");
//            respoJSONObject.put("success", false);
//            e.printStackTrace();
//        } finally{
//            conn.close();
//        }
//        return respoJSONObject.toString();
//    }
    @Override
    public String dateSales(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String date = "", datepicker2 = "";
        try {
            date = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
            String hourDiff = StringUtils.isNotEmpty(params.get("hourDiff")) ? params.get("hourDiff") : "0";
            String isDateOnly = StringUtils.isNotEmpty(params.get("isDateOnly")) ? params.get("isDateOnly") : "false";

            String fromyear = date.substring(date.lastIndexOf("/") + 1);
            String frommonth = date.substring(date.indexOf("/") + 1, date.lastIndexOf("/"));
            String fromday = date.substring(0, date.indexOf("/"));

            long fromDateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
            Calendar cal = Calendar.getInstance();
            cal.setTimeInMillis(fromDateInLong);
            cal.add(Calendar.HOUR, Integer.parseInt(hourDiff));
            fromDateInLong = cal.getTimeInMillis();
            cal.add(Calendar.DATE, 1);
            long toDateInLong = cal.getTimeInMillis();
            conn = DBPool.getConnection();
//               long val = 1346524199000l;
            Date datelong = new Date();
//        SimpleDateFormat df2 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
            String dateText = dateFormat.format(datelong);
//        System.out.println(dateText);

            // PreparedStatement pst = null;
            Statement st = conn.createStatement();
            String sqlQuery = "";
            if (Boolean.toString(true).equals(isDateOnly)) {
                sqlQuery = "select o.orderid,o.orderno,o.billdate,o.totalpaidamount,t.tablename from ordertable o ,tableordermapping tom,tabledetails t where o.billdate = " + fromDateInLong + " and o.orderid=tom.orderid and tom.tableid=t.tableid and iscomplete=1 and isdeleted=0 order by orderno";
            } else {
                sqlQuery = "select o.orderid,o.orderno,o.billdate,o.totalpaidamount,t.tablename from ordertable o ,tableordermapping tom,tabledetails t where o.billdatetime between " + fromDateInLong + " and " + toDateInLong + " and o.orderid=tom.orderid and tom.tableid=t.tableid and iscomplete=1 and isdeleted=0 order by orderno";
            }
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("orderid", rs.getString(1));
                jobj.put("orderno", rs.getString(2));
                jobj.put("orderdate", rs.getLong(3));
                jobj.put("totalamount", rs.getDouble(4));
                jobj.put("tablename", rs.getString(5));

                jarr.put(jobj);
            }
            respoJSONObject.put("date", date);
            respoJSONObject.put("printdate", dateText);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String monthlysales(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String month = "", year = "";
        try {

            month = StringUtils.isNotEmpty(params.get("month")) ? params.get("month") : "";
            year = StringUtils.isNotEmpty(params.get("year")) ? params.get("year") : "";
            String firstday = "01";
            String lastday = "";
            switch (month) {
                case "1":
                    lastday = "31";
                    break;
                case "2":
                    lastday = "28";
                    break;
                case "3":
                    lastday = "31";
                    break;
                case "4":
                    lastday = "30";
                    break;
                case "5":
                    lastday = "31";
                    break;
                case "6":
                    lastday = "30";
                    break;
                case "7":
                    lastday = "31";
                    break;
                case "8":
                    lastday = "31";
                    break;
                case "9":
                    lastday = "30";
                    break;
                case "10":
                    lastday = "31";
                    break;
                case "11":
                    lastday = "30";
                    break;
                case "12":
                    lastday = "31";
                    break;
            }
            long fromDateInLong = new Date(year + "/" + month + "/" + firstday).getTime();
            long toDateInLong = new Date(year + "/" + month + "/" + lastday).getTime();
            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select distinct billdate ,sum(totalpaidamount) as 'totalamount'from ordertable where billdate BETWEEN " + fromDateInLong + "  AND  " + toDateInLong + " AND isdeleted=0 AND iscomplete=1 group by billdate order by billdate asc");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("orderdate", rs.getLong(1));
                jobj.put("totalamount", rs.getDouble(2));
                jarr.put(jobj);
            }

            respoJSONObject.put("month", month);
            respoJSONObject.put("year", year);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String yearsales(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String year = "";
        try {

            year = StringUtils.isNotEmpty(params.get("year")) ? params.get("year") : "";
            String firstmonth = "1", lastmonth = "12", firstday = "1", lastday = "31";

            long fromDateInLong = new Date(year + "/" + firstmonth + "/" + firstday).getTime();
            long toDateInLong = new Date(year + "/" + lastmonth + "/" + lastday).getTime();

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select distinct billdate ,sum(totalpaidamount) as 'totalamount'from ordertable where billdate BETWEEN " + fromDateInLong + "  AND  " + toDateInLong + " AND isdeleted=0 group by billdate order by billdate");

            double janTotalAmount = 0, febTotalAmount = 0, marchTotalAmount = 0, aprilTotalAmount = 0, mayTotalAmount = 0;
            double juneTotalAmount = 0, julyTotalAmount = 0, augustTotalAmount = 0, sepTotalAmount = 0, octTotalAmount = 0;
            double novTotalAmount = 0, decTotalAmount = 0;
            while (rs.next()) {
                Date orderdt = new Date(rs.getLong(1));
                int month = orderdt.getMonth() + 1;
                switch (month) {
                    case 1:
                        janTotalAmount += rs.getDouble(2);
                        break;
                    case 2:
                        febTotalAmount += rs.getDouble(2);
                        break;
                    case 3:
                        marchTotalAmount += rs.getDouble(2);
                        break;
                    case 4:
                        aprilTotalAmount += rs.getDouble(2);
                        break;
                    case 5:
                        mayTotalAmount += rs.getDouble(2);
                        break;
                    case 6:
                        juneTotalAmount += rs.getDouble(2);
                        break;
                    case 7:
                        julyTotalAmount += rs.getDouble(2);
                        break;
                    case 8:
                        augustTotalAmount += rs.getDouble(2);
                        break;
                    case 9:
                        sepTotalAmount += rs.getDouble(2);
                        break;
                    case 10:
                        octTotalAmount += rs.getDouble(2);
                        break;
                    case 11:
                        novTotalAmount += rs.getDouble(2);
                        break;
                    case 12:
                        decTotalAmount += rs.getDouble(2);
                        break;
                }
            }
            jobj = new JSONObject();
            jobj.put("month", "January");
            jobj.put("monthamount", janTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "February");
            jobj.put("monthamount", febTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "March");
            jobj.put("monthamount", marchTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "April ");
            jobj.put("monthamount", aprilTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "May");
            jobj.put("monthamount", mayTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "June");
            jobj.put("monthamount", juneTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "July ");
            jobj.put("monthamount", julyTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "August");
            jobj.put("monthamount", augustTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "September ");
            jobj.put("monthamount", sepTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "Octomber");
            jobj.put("monthamount", octTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "November ");
            jobj.put("monthamount", novTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "December ");
            jobj.put("monthamount", decTotalAmount);
            jarr.put(jobj);

            respoJSONObject.put("year", year);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String TableDateReport(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String Tableno = "", Date = "";
        try {
            Tableno = StringUtils.isNotEmpty(params.get("tableno")) ? params.get("tableno") : "";
            Date = StringUtils.isNotEmpty(params.get("datepicker")) ? params.get("datepicker") : "";
            String year = Date.substring(Date.lastIndexOf("/") + 1);
            String month = Date.substring(Date.indexOf("/") + 1, Date.lastIndexOf("/"));
            String day = Date.substring(0, Date.indexOf("/"));
            long DateInLong = new Date(year + "/" + month + "/" + day).getTime();

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select td.orderno,td.totalpaidamount from ordertable td where orderid in(select od.orderid from orderdetails od where od.tableno='" + Tableno + "' and td.orderdate=" + DateInLong + "and td.isdeleted =0 and td.iscomplete=1 order by orderdate)");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("orderno", rs.getString(1));
                jobj.put("totalamount", rs.getDouble(2));
                jarr.put(jobj);
            }

            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String DateAllTableReport(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String Tableno = "", date = "";
        try {
            date = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
            String year = date.substring(date.lastIndexOf("/") + 1);
            String month = date.substring(date.indexOf("/") + 1, date.lastIndexOf("/"));
            String day = date.substring(0, date.indexOf("/"));
            long DateInLong = new Date(year + "/" + month + "/" + day).getTime();

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
//            ResultSet rs = st.executeQuery("select td.orderno,td.totalamount from ordertable td where orderid in(select od.orderid from orderdetails od where td.orderdate=" + DateInLong + ")");
            ResultSet rs = st.executeQuery("select distinct(tom.tableid), td.tablename, sum(ot.totalpaidamount),ot.billdate,count(ot.orderno) from ordertable ot, tableordermapping tom, tabledetails td where tom.tableid=td.tableid and ot.orderid=tom.orderid and ot.billdate=" + DateInLong + " and ot.iscomplete=1 and ot.isdeleted=0 group by(tom.tableid) order by(td.tableno)");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("tableid", rs.getString(1));
                jobj.put("tablename", rs.getString(2));
                jobj.put("totalamount", rs.getDouble(3));
                jobj.put("orderdate", rs.getLong(4));
                jobj.put("orderno", rs.getLong(5));
                jarr.put(jobj);
            }

            respoJSONObject.put("date", date);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String DateWiseKOTReport(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String Tableno = "", date = "";
        try {
            date = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
            String year = date.substring(date.lastIndexOf("/") + 1);
            String month = date.substring(date.indexOf("/") + 1, date.lastIndexOf("/"));
            String day = date.substring(0, date.indexOf("/"));
            long DateInLong = new Date(year + "/" + month + "/" + day).getTime();

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
//            ResultSet rs = st.executeQuery("select td.orderno,td.totalamount from ordertable td where orderid in(select od.orderid from orderdetails od where td.orderdate=" + DateInLong + ")");
            ResultSet rs = st.executeQuery("select distinct(m.menuitemname), sum(od.quantity),ot.orderdate,ot.userid,u.username from ordertable ot,orderdetails od,menuitem m,userlogin u where m.menuitemid=od.menuitemid and ot.orderid=od.orderid and ot.orderdate=" + DateInLong + " and ot.iscomplete=1 and ot.isdeleted=0 and ot.userid=u.userid group by(od.menuitemid) order by(ot.orderdate)");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("menuitemid", rs.getString(1));
                jobj.put("quantity", rs.getString(2));
                jobj.put("date", rs.getDouble(3));
                jobj.put("userid", rs.getString(4));
                jobj.put("username", rs.getString(5));
                jarr.put(jobj);
            }

            respoJSONObject.put("date", date);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String paymentDate(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String dateofpayment = "";
        try {
            dateofpayment = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
//            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
//	    String dateInString = dateofpayment;
//            java.util.Date date = formatter.parse(dateInString);
//            java.sql.Date sqlDate = new java.sql.Date(date.getTime());
            String fromyear = dateofpayment.substring(dateofpayment.lastIndexOf("/") + 1);
            String frommonth = dateofpayment.substring(dateofpayment.indexOf("/") + 1, dateofpayment.lastIndexOf("/"));
            String fromday = dateofpayment.substring(0, dateofpayment.indexOf("/"));

            long fromDateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select p.paymentid,p.employeeid,e.employeename,p.modeofpayment,p.paymentamount,p.paymentdate,p.designation from payment p,employee e where  p.paymentdate ='" + fromDateInLong + "' and p.employeeid=e.employeeid order by e.employeename");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("paymentid", rs.getString(1));
                jobj.put("employeeid", rs.getString(2));
                jobj.put("employeename", rs.getString(3));
                jobj.put("modeofpayment", rs.getLong(4));
                jobj.put("paymentamount", rs.getFloat(5));
                jobj.put("paymentdate", rs.getLong(6));
                jobj.put("designation", rs.getString(7));

                jarr.put(jobj);
            }

            respoJSONObject.put("dateofpayment", dateofpayment);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String paymentEmployee(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String employeeid = "", employeeName = "", designation = "";
        try {
            employeeid = StringUtils.isNotEmpty(params.get("employeeid")) ? params.get("employeeid") : "";

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select p.paymentid,p.employeeid,e.employeename,p.modeofpayment,p.paymentamount,p.paymentdate,p.designation from payment p,employee e where  p.employeeid =" + employeeid + " and p.employeeid=e.employeeid order by e.employeename");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("paymentid", rs.getString(1));
                jobj.put("employeeid", rs.getString(2));
                jobj.put("employeename", rs.getString(3));
                employeeName = rs.getString(3);
                jobj.put("modeofpayment", rs.getLong(4));
                jobj.put("paymentamount", rs.getFloat(5));
                jobj.put("paymentdate", rs.getLong(6));
                jobj.put("designation", rs.getString(7));
                designation = rs.getString(7);

                jarr.put(jobj);
            }

            respoJSONObject.put("employeeName", employeeName);
            respoJSONObject.put("designation", designation);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

//    @Override
//    public String purchaseDate(HashMap<String, String> params) throws JSONException {
//
//        JSONObject respoJSONObject = new JSONObject();
//        JSONObject jobj = null;
//        JSONArray jarr = new JSONArray();
//        String datepicker1 = "",dateof="";
//        try {
//            datepicker1 = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
//            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
//	    String dateInString = datepicker1;
//            java.util.Date date = formatter.parse(dateInString);
//            java.sql.Date sqlDate = new java.sql.Date(date.getTime());
//            
//            
//            conn = DBPool.getConnection();
//
//            Statement st = conn.createStatement();
//            ResultSet rs = st.executeQuery("select purchasematerialid,purchasematerialname,price,desription,isinstock,customid,quantity,totalamount,purchasematerialdate from purchasematerial where purchasematerialdate ='"+sqlDate+"'");
//
//            while (rs.next()) {
//                jobj = new JSONObject();
//               jobj.put("purchasematerialid", rs.getLong(1));
//                jobj.put("purchasematerialname", rs.getString(2));
//                jobj.put("price", rs.getFloat(3));
//                jobj.put("desription", rs.getString(4));
//                jobj.put("isinstock", rs.getString(5));
//                jobj.put("customid", rs.getString(6));
//                jobj.put("quantity", rs.getLong(7));
//                jobj.put("totalamount", rs.getFloat(8));
//                jobj.put("purchasematerialdate", rs.getDate(9));
//                jarr.put(jobj);
//            }
//
//            respoJSONObject.put("data", jarr);
//            respoJSONObject.put("success", true);
//        } catch (Exception e) {
//            respoJSONObject.put("data", "");
//            respoJSONObject.put("success", false);
//            e.printStackTrace();
//        }
//        return respoJSONObject.toString();
//    }
//    @Override
//    public String purchaseMonth(HashMap<String, String> params) throws JSONException {
//
//        JSONObject respoJSONObject = new JSONObject();
//        JSONObject jobj = null;
//        JSONArray jarr = new JSONArray();
//        String datepicker1 = "",dateof="";
//        try {
//            datepicker1 = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
//            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
//	    String dateInString = datepicker1;
//            java.util.Date date = formatter.parse(dateInString);
//            java.sql.Date sqlDate = new java.sql.Date(date.getTime());
//            
//            
//            conn = DBPool.getConnection();
//
//            Statement st = conn.createStatement();
//            ResultSet rs = st.executeQuery("select purchasematerialid,purchasematerialname,price,desription,isinstock,customid,quantity,totalamount,purchasematerialdate from purchasematerial where purchasematerialdate ='"+sqlDate+"'");
//
//            while (rs.next()) {
//                jobj = new JSONObject();
//               jobj.put("purchasematerialid", rs.getLong(1));
//                jobj.put("purchasematerialname", rs.getString(2));
//                jobj.put("price", rs.getFloat(3));
//                jobj.put("desription", rs.getString(4));
//                jobj.put("isinstock", rs.getString(5));
//                jobj.put("customid", rs.getString(6));
//                jobj.put("quantity", rs.getLong(7));
//                jobj.put("totalamount", rs.getFloat(8));
//                jobj.put("purchasematerialdate", rs.getDate(9));
//                jarr.put(jobj);
//            }
//
//            respoJSONObject.put("data", jarr);
//            respoJSONObject.put("success", true);
//        } catch (Exception e) {
//            respoJSONObject.put("data", "");
//            respoJSONObject.put("success", false);
//            e.printStackTrace();
//        }
//        return respoJSONObject.toString();
//    }
    @Override
    public String purchaseMaterial(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String date = "";
        try {
            date = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
            String fromyear = date.substring(date.lastIndexOf("/") + 1);
            String frommonth = date.substring(date.indexOf("/") + 1, date.lastIndexOf("/"));
            String fromday = date.substring(0, date.indexOf("/"));
            long fromDateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select p.purchasematerialid,p.materialid,p.unitprice,p.customid,p.quantity,p.totalamount,p.purchasematerialdate , m.materialname  from purchasematerial p,materialstock m where p.purchasematerialdate ='" + fromDateInLong + "'and p.materialid=m.materialid order by p.purchasematerialdate");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("purchasematerialid", rs.getLong(1));
                jobj.put("materialid", rs.getString(2));
                jobj.put("unitprice", rs.getFloat(3));
                jobj.put("customid", rs.getString(4));
                jobj.put("quantity", rs.getLong(5));
                jobj.put("totalamount", rs.getFloat(6));
                jobj.put("purchasematerialdate", rs.getLong(7));
                jobj.put("materialname", rs.getString(8));
                jarr.put(jobj);
            }

            respoJSONObject.put("date", date);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String monthlyPurchase(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String month = "", year = "";
        try {

            month = StringUtils.isNotEmpty(params.get("month")) ? params.get("month") : "";
            year = StringUtils.isNotEmpty(params.get("year")) ? params.get("year") : "";

            String firstday = "01";
            String lastday = "";
            
            switch (month) {
                case "1":
                    lastday = "31";
                    break;
                case "2":
                    lastday = "28";
                    break;
                case "3":
                    lastday = "31";
                    break;
                case "4":
                    lastday = "30";
                    break;
                case "5":
                    lastday = "31";
                    break;
                case "6":
                    lastday = "30";
                    break;
                case "7":
                    lastday = "31";
                    break;
                case "8":
                    lastday = "31";
                    break;
                case "9":
                    lastday = "30";
                    break;
                case "10":
                    lastday = "31";
                    break;
                case "11":
                    lastday = "30";
                    break;
                case "12":
                    lastday = "31";
                    break;
            }
            long fromDateInLong = new Date(year + "/" + month + "/" + firstday).getTime();
            long toDateInLong = new Date(year + "/" + month + "/" + lastday).getTime();

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select p.purchasematerialid,p.materialid,p.unitprice,p.customid,p.quantity,p.totalamount,p.purchasematerialdate , m.materialname  from purchasematerial p,materialstock m where p.purchasematerialdate BETWEEN '" + fromDateInLong + "'  AND  '" + toDateInLong + "' and p.materialid=m.materialid order by p.purchasematerialdate");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("purchasematerialid", rs.getLong(1));
                jobj.put("materialid", rs.getString(2));
                jobj.put("unitprice", rs.getFloat(3));
                jobj.put("customid", rs.getString(4));
                jobj.put("quantity", rs.getLong(5));
                jobj.put("totalamount", rs.getFloat(6));
                jobj.put("purchasematerialdate", rs.getLong(7));
                jobj.put("materialname", rs.getString(8));
                jarr.put(jobj);
            }

            respoJSONObject.put("month", month);
            respoJSONObject.put("year", year);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String yearlyPurchase(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String year = "";
        try {

            year = StringUtils.isNotEmpty(params.get("year")) ? params.get("year") : "";

            String firstmonth = "01", lastmonth = "12", firstday = "1", lastday = "31";

            long fromDateInLong = new Date(year + "/" + firstmonth + "/" + firstday).getTime();
            long toDateInLong = new Date(year + "/" + lastmonth + "/" + lastday).getTime();

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select distinct purchasematerialdate ,sum(totalamount) as 'totalamount'from purchasematerial where purchasematerialdate BETWEEN '" + fromDateInLong + "'  AND  '" + toDateInLong + "'  group by purchasematerialdate order by p.purchasematerialdate");

            double janTotalAmount = 0, febTotalAmount = 0, marchTotalAmount = 0, aprilTotalAmount = 0, mayTotalAmount = 0;
            double juneTotalAmount = 0, julyTotalAmount = 0, augustTotalAmount = 0, sepTotalAmount = 0, octTotalAmount = 0;
            double novTotalAmount = 0, decTotalAmount = 0;
            while (rs.next()) {
                Date orderdt = new Date(rs.getLong(1));
                int month = orderdt.getMonth() + 1;
                switch (month) {
                    case 1:
                        janTotalAmount += rs.getDouble(2);
                        break;
                    case 2:
                        febTotalAmount += rs.getDouble(2);
                        break;
                    case 3:
                        marchTotalAmount += rs.getDouble(2);
                        break;
                    case 4:
                        aprilTotalAmount += rs.getDouble(2);
                        break;
                    case 5:
                        mayTotalAmount += rs.getDouble(2);
                        break;
                    case 6:
                        juneTotalAmount += rs.getDouble(2);
                        break;
                    case 7:
                        julyTotalAmount += rs.getDouble(2);
                        break;
                    case 8:
                        augustTotalAmount += rs.getDouble(2);
                        break;
                    case 9:
                        sepTotalAmount += rs.getDouble(2);
                        break;
                    case 10:
                        octTotalAmount += rs.getDouble(2);
                        break;
                    case 11:
                        novTotalAmount += rs.getDouble(2);
                        break;
                    case 12:
                        decTotalAmount += rs.getDouble(2);
                        break;
                }
            }
            jobj = new JSONObject();
            jobj.put("month", "January");
            jobj.put("monthamount", janTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "February");
            jobj.put("monthamount", febTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "March");
            jobj.put("monthamount", marchTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "April ");
            jobj.put("monthamount", aprilTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "May");
            jobj.put("monthamount", mayTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "June");
            jobj.put("monthamount", juneTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "July ");
            jobj.put("monthamount", julyTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "August");
            jobj.put("monthamount", augustTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "September ");
            jobj.put("monthamount", sepTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "Octomber");
            jobj.put("monthamount", octTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "November ");
            jobj.put("monthamount", novTotalAmount);
            jarr.put(jobj);
            jobj = new JSONObject();
            jobj.put("month", "December ");
            jobj.put("monthamount", decTotalAmount);
            jarr.put(jobj);

            respoJSONObject.put("year", year);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String purchaseName(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String materialId = "";
        try {

            materialId = StringUtils.isNotEmpty(params.get("materialid")) ? params.get("materialid") : "";

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select p.purchasematerialid,p.materialid,p.unitprice,p.customid,p.quantity,p.totalamount,p.purchasematerialdate , m.materialname  from purchasematerial p,materialstock m where  p.materialid ='" + materialId + "' and p.materialid=m.materialid order by m.materialname");

            String materialName = "";
            while (rs.next()) {
                jobj = new JSONObject();

                jobj.put("purchasematerialid", rs.getLong(1));
                jobj.put("materialid", rs.getString(2));
                jobj.put("unitprice", rs.getFloat(3));
                jobj.put("customid", rs.getString(4));
                jobj.put("quantity", rs.getLong(5));
                jobj.put("totalamount", rs.getFloat(6));
                jobj.put("purchasematerialdate", rs.getLong(7));
                jobj.put("materialname", rs.getString(8));
                materialName = rs.getString(8);
                jarr.put(jobj);
            }
            respoJSONObject.put("materialName", materialName);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String stockName(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String materialName = "";
        try {

            materialName = StringUtils.isNotEmpty(params.get("materialid")) ? params.get("materialid") : "";

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select materialname,quantity from materialstock where materialname ='" + materialName + "'order by materialname");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("materialname", rs.getString(1));
                jobj.put("quantity", rs.getLong(2));

                jarr.put(jobj);
            }

            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

//    @Override
//    public String purchaseYear(HashMap<String, String> params) throws JSONException {
//
//        JSONObject respoJSONObject = new JSONObject();
//        JSONObject jobj = null;
//        JSONArray jarr = new JSONArray();
//        String datepicker1 = "",dateof="";
//        try {
//            datepicker1 = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
//            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
//	    String dateInString = datepicker1;
//            java.util.Date date = formatter.parse(dateInString);
//            java.sql.Date sqlDate = new java.sql.Date(date.getTime());
//            
//            
//            conn = DBPool.getConnection();
//
//            Statement st = conn.createStatement();
//            ResultSet rs = st.executeQuery("select purchasematerialid,purchasematerialname,price,desription,isinstock,customid,quantity,totalamount,purchasematerialdate from purchasematerial where purchasematerialdate ='"+sqlDate+"'");
//
//            while (rs.next()) {
//                jobj = new JSONObject();
//               jobj.put("purchasematerialid", rs.getLong(1));
//                jobj.put("purchasematerialname", rs.getString(2));
//                jobj.put("price", rs.getFloat(3));
//                jobj.put("desription", rs.getString(4));
//                jobj.put("isinstock", rs.getString(5));
//                jobj.put("customid", rs.getString(6));
//                jobj.put("quantity", rs.getLong(7));
//                jobj.put("totalamount", rs.getFloat(8));
//                jobj.put("purchasematerialdate", rs.getDate(9));
//                jarr.put(jobj);
//            }
//
//            respoJSONObject.put("data", jarr);
//            respoJSONObject.put("success", true);
//        } catch (Exception e) {
//            respoJSONObject.put("data", "");
//            respoJSONObject.put("success", false);
//            e.printStackTrace();
//        }
//        return respoJSONObject.toString();
//    }
    @Override
    public String monthylcancel(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String month = "", year = "";
        try {

            month = StringUtils.isNotEmpty(params.get("month")) ? params.get("month") : "";
            year = StringUtils.isNotEmpty(params.get("year")) ? params.get("year") : "";

            String firstday = "01";
            String lastday = "";
            switch (month) {
                case "1":
                    lastday = "31";
                    break;
                case "2":
                    lastday = "28";
                    break;
                case "3":
                    lastday = "31";
                    break;
                case "4":
                    lastday = "30";
                    break;
                case "5":
                    lastday = "31";
                    break;
                case "6":
                    lastday = "30";
                    break;
                case "7":
                    lastday = "31";
                    break;
                case "8":
                    lastday = "31";
                    break;
                case "9":
                    lastday = "30";
                    break;
                case "10":
                    lastday = "31";
                    break;
                case "11":
                    lastday = "30";
                    break;
                case "12":
                    lastday = "31";
                    break;
            }
            
            long fromDateInLong = new Date(year + "/" + month + "/" + firstday).getTime();
            long toDateInLong = new Date(year + "/" + month + "/" + lastday).getTime();

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select co.tableno,co.quantity,co.rate,o.orderdate,u.username,m.menuitemname,o.totalpaidamount from cancelorderdetails co,ordertable o,menuitem m,userlogin u where o.orderdate BETWEEN '" + fromDateInLong + "'  AND  '" + toDateInLong + "' and o.orderid=co.orderid and m.menuitemid=co.menuitemid and co.userid=u.userid order by orderdate");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("tableno", rs.getString(1));
                jobj.put("quantity", rs.getInt(2));
                jobj.put("rate", rs.getFloat(3));
                jobj.put("orderdate", rs.getLong(4));
                jobj.put("username", rs.getString(5));
                jobj.put("menuitemname", rs.getString(6));
                jobj.put("totalamount", rs.getDouble(7));

//                jobj.put("orderid", rs.getString(7));
//                jobj.put("menuItemId", rs.getInt(8));
                jarr.put(jobj);
            }

            respoJSONObject.put("month", month);
            respoJSONObject.put("year", year);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String expenceMaterial(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String date = "";
        try {
            date = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
            String fromyear = date.substring(date.lastIndexOf("/") + 1);
            String frommonth = date.substring(date.indexOf("/") + 1, date.lastIndexOf("/"));
            String fromday = date.substring(0, date.indexOf("/"));
            long fromDateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select e.expenceid,e.materialid,e.customid,e.quantity,e.expencedate , m.materialname  from expence e,materialstock m where e.expencedate ='" + fromDateInLong + "'and e.materialid=m.materialid order by expencedate");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("expenceid", rs.getLong(1));
                jobj.put("materialid", rs.getString(2));
                jobj.put("customid", rs.getString(3));
                jobj.put("quantity", rs.getLong(4));
                jobj.put("expencedate", rs.getLong(5));
                jobj.put("materialname", rs.getString(6));
                jarr.put(jobj);
            }

            respoJSONObject.put("date", date);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String monthlyExpense(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String month = "", year = "";
        try {

            month = StringUtils.isNotEmpty(params.get("month")) ? params.get("month") : "";
            year = StringUtils.isNotEmpty(params.get("year")) ? params.get("year") : "";

            String firstday = "01";
            String lastday = "";
            switch (month) {
                case "1":
                    lastday = "31";
                    break;
                case "2":
                    lastday = "28";
                    break;
                case "3":
                    lastday = "31";
                    break;
                case "4":
                    lastday = "30";
                    break;
                case "5":
                    lastday = "31";
                    break;
                case "6":
                    lastday = "30";
                    break;
                case "7":
                    lastday = "31";
                    break;
                case "8":
                    lastday = "31";
                    break;
                case "9":
                    lastday = "30";
                    break;
                case "10":
                    lastday = "31";
                    break;
                case "11":
                    lastday = "30";
                    break;
                case "12":
                    lastday = "31";
                    break;
            }
            
            long fromDateInLong = new Date(year + "/" + month + "/" + firstday).getTime();
            long toDateInLong = new Date(year + "/" + month + "/" + lastday).getTime();

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select e.expenceid,e.materialid,e.customid,e.quantity,e.expencedate , m.materialname  from expence e,materialstock m where e.expencedate BETWEEN '" + fromDateInLong + "'  AND  '" + toDateInLong + "' and e.materialid=m.materialid order by expencedate");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("expenceid", rs.getLong(1));
                jobj.put("materialid", rs.getString(2));
                jobj.put("customid", rs.getString(3));
                jobj.put("quantity", rs.getLong(4));
                jobj.put("expencedate", rs.getLong(5));
                jobj.put("materialname", rs.getString(6));
                jarr.put(jobj);
            }

            respoJSONObject.put("month", month);
            respoJSONObject.put("year", year);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String expenceName(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String materialId = "";
        try {

            materialId = StringUtils.isNotEmpty(params.get("materialid")) ? params.get("materialid") : "";

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select e.expenceid,e.materialid,e.customid,e.quantity,e.expencedate , m.materialname  from expence e,materialstock m where m.materialname ='" + materialId + "' and e.materialid=m.materialid order by expencedate");
            String materialName = "";
            while (rs.next()) {
                jobj = new JSONObject();

                jobj.put("expenceid", rs.getLong(1));
                jobj.put("materialid", rs.getString(2));
                jobj.put("customid", rs.getString(3));
                jobj.put("quantity", rs.getLong(4));
                jobj.put("expencedate", rs.getLong(5));
                jobj.put("materialname", rs.getString(6));
                materialName = rs.getString(6);
                jarr.put(jobj);
            }

            respoJSONObject.put("materialName", materialName);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String borrowDate(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String currentate = "", datepicker2 = "";
        try {
            currentate = StringUtils.isNotEmpty(params.get("borrowdate")) ? params.get("borrowdate") : "";

            String year = currentate.substring(currentate.lastIndexOf("/") + 1);
            String month = currentate.substring(currentate.indexOf("/") + 1, currentate.lastIndexOf("/"));
            String day = currentate.substring(0, currentate.indexOf("/"));

            long todayDateInLong = new Date(year + "/" + month + "/" + day).getTime();

            conn = DBPool.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select customerborrowingsid,customername,customerborrowingsdate,totalpaidamount from customerborrowings where customerborrowingsdate =" + todayDateInLong + " order by customerborrowingsdate");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("customerborrowingsid", rs.getString(1));
                jobj.put("customername", rs.getString(2));
                jobj.put("customerborrowingsdate", rs.getLong(3));
                jobj.put("grandtotal", rs.getDouble(4));

                jarr.put(jobj);
            }
            respoJSONObject.put("date", currentate);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String monthlyBorrow(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String month = "", year = "";
        try {

            month = StringUtils.isNotEmpty(params.get("month")) ? params.get("month") : "";
            year = StringUtils.isNotEmpty(params.get("year")) ? params.get("year") : "";
            String firstday = "01";
            String lastday = "";
            switch (month) {
                case "1":
                    lastday = "31";
                    break;
                case "2":
                    lastday = "28";
                    break;
                case "3":
                    lastday = "31";
                    break;
                case "4":
                    lastday = "30";
                    break;
                case "5":
                    lastday = "31";
                    break;
                case "6":
                    lastday = "30";
                    break;
                case "7":
                    lastday = "31";
                    break;
                case "8":
                    lastday = "31";
                    break;
                case "9":
                    lastday = "30";
                    break;
                case "10":
                    lastday = "31";
                    break;
                case "11":
                    lastday = "30";
                    break;
                case "12":
                    lastday = "31";
                    break;
            }
            
            long fromDateInLong = new Date(year + "/" + month + "/" + firstday).getTime();
            long toDateInLong = new Date(year + "/" + month + "/" + lastday).getTime();
            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select distinct customerborrowingsdate ,sum(totalpaidamount) as 'grandtotal'from customerborrowings where customerborrowingsdate BETWEEN " + fromDateInLong + "  AND  " + toDateInLong + " group by customerborrowingsdate order by customerborrowingsdate");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("customerborrowingsdate", rs.getLong(1));
                jobj.put("grandtotal", rs.getDouble(2));
                jarr.put(jobj);
            }

            respoJSONObject.put("month", month);
            respoJSONObject.put("year", year);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String DateWiseStock(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String date = "", datepicker2 = "";
        try {
            date = StringUtils.isNotEmpty(params.get("stockdate")) ? params.get("stockdate") : "";
            //datepicker2 = StringUtils.isNotEmpty(params.get("datepicker2")) ? params.get("datepicker2") : "";

            String fromyear = date.substring(date.lastIndexOf("/") + 1);
            String frommonth = date.substring(date.indexOf("/") + 1, date.lastIndexOf("/"));
            String fromday = date.substring(0, date.indexOf("/"));
            //String toyear = datepicker2.substring(datepicker2.lastIndexOf("/") + 1);
            // String tomonth = datepicker2.substring(datepicker2.indexOf("/") + 1, datepicker2.lastIndexOf("/"));
            //String today = datepicker2.substring(0, datepicker2.indexOf("/"));

            long DateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
            //long toDateInLong = new Date(toyear + "/" + tomonth + "/" + today).getTime();

            conn = DBPool.getConnection();

            // PreparedStatement pst = null;
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select s.materialid,s.materialname,s.quantity,s.initialstockdate,ms.quantity from initialstock s,materialstock ms where s.initialstockdate =" + DateInLong + " and s.materialid= ms.materialid order by s.materialname ");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("materialid", rs.getString(1));
                jobj.put("materialname", rs.getString(2));
                jobj.put("quantity", rs.getDouble(3));
                jobj.put("initialstockdate", rs.getLong(4));
                jobj.put("counterquantity", rs.getDouble(5));
                jobj.put("deductionqty", 0);

                jarr.put(jobj);
            }

            rs = st.executeQuery("select materialid, deductionquantity from orderdeductionmaterialstock where deductiondate=" + DateInLong);
            while (rs.next()) {
                String materialid = String.valueOf(rs.getLong("materialid"));
                double deductqty = rs.getDouble("deductionquantity");
                for (int ind = 0; ind < jarr.length(); ind++) {
                    jobj = jarr.getJSONObject(ind);
                    if (materialid.equals(jobj.getString("materialid"))) {
                        jobj.put("deductionqty", deductqty);
                        jarr.put(ind, jobj);
                    }
                }
            }

            respoJSONObject.put("date", date);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String getDateWisePaymentModeReport(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String selectedDate = "";
        try {
            int paymentmode = StringUtils.isNotEmpty(params.get("paymentmode")) ? Integer.parseInt(params.get("paymentmode")) : 1;
            selectedDate = StringUtils.isNotEmpty(params.get("selecteddate")) ? params.get("selecteddate") : "";

//            String fromyear = date.substring(date.lastIndexOf("/") + 1);
//            String frommonth = date.substring(date.indexOf("/") + 1, date.lastIndexOf("/"));
//            String fromday = date.substring(0, date.indexOf("/"));
//
//            long DateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
            SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
            Date date = (Date) formatter.parse(selectedDate.replaceAll("/", "-"));
            long DateInLong = date.getTime();

            conn = DBPool.getConnection();

            // PreparedStatement pst = null;
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select o.orderno,o.totalpaidamount,o.chequeno,o.paymentmode,t.tablename from ordertable o, tableordermapping tom,tabledetails t where o.orderdate =" + DateInLong + " and o.orderid=tom.orderid and tom.tableid=t.tableid and iscomplete=1 and o.paymentmode=" + paymentmode + " and isdeleted=0 order by orderno");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("orderno", rs.getString(1));
                jobj.put("totalamount", rs.getDouble(2));
                jobj.put("chequeno", rs.getString(3));
                jobj.put("tablename", rs.getString(5));

                jarr.put(jobj);
            }

            respoJSONObject.put("date", selectedDate);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String dailyMenuitemRecordList(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String orderDate = "";
        try {

            orderDate = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";

            String fromyear = orderDate.substring(orderDate.lastIndexOf("/") + 1);
            String frommonth = orderDate.substring(orderDate.indexOf("/") + 1, orderDate.lastIndexOf("/"));
            String fromday = orderDate.substring(0, orderDate.indexOf("/"));

            long fromDateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();

            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select co.tableno,co.quantity,co.rate,o.orderdate,u.username,m.menuitemname,o.totalpaidamount from orderdetails co,ordertable o,menuitem m,userlogin u where o.orderdate = '" + fromDateInLong + "' and o.orderid=co.orderid and m.menuitemid=co.menuitemid and co.userid=u.userid order by orderdate");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("tableno", rs.getString(1));
                jobj.put("quantity", rs.getInt(2));
                jobj.put("rate", rs.getFloat(3));
                jobj.put("orderdate", rs.getLong(4));
                jobj.put("username", rs.getString(5));
                jobj.put("menuitemname", rs.getString(6));
                jobj.put("totalamount", rs.getDouble(7));

//                jobj.put("orderid", rs.getString(7));
//                jobj.put("menuItemId", rs.getInt(8));
                jarr.put(jobj);
            }

            respoJSONObject.put("date", orderDate);
//            respoJSONObject.put("year", year);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String monthlyAmountDetails(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONObject dataJobj = new JSONObject();
        JSONArray jarr = new JSONArray();
        ResultSet rs = null;
        String month = "", year = "";
        try {

            month = StringUtils.isNotEmpty(params.get("month")) ? params.get("month") : "";
            year = StringUtils.isNotEmpty(params.get("year")) ? params.get("year") : "";
            String firstday = "01";
            String lastday = "";
            switch (month) {
                case "1":
                    lastday = "31";
                    break;
                case "2":
                    lastday = "28";
                    break;
                case "3":
                    lastday = "31";
                    break;
                case "4":
                    lastday = "30";
                    break;
                case "5":
                    lastday = "31";
                    break;
                case "6":
                    lastday = "30";
                    break;
                case "7":
                    lastday = "31";
                    break;
                case "8":
                    lastday = "31";
                    break;
                case "9":
                    lastday = "30";
                    break;
                case "10":
                    lastday = "31";
                    break;
                case "11":
                    lastday = "30";
                    break;
                case "12":
                    lastday = "31";
                    break;
            }
            
            long fromDateInLong = new Date(year + "/" + month + "/" + firstday).getTime();
            long toDateInLong = new Date(year + "/" + month + "/" + lastday).getTime();
            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            rs = st.executeQuery("SELECT billdate, sum(totalpaidamount) AS totalamount FROM ordertable where billdate between " + fromDateInLong + " and " + toDateInLong + " GROUP BY billdate ORDER BY orderdate");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("orderdate", rs.getLong(1));
                jobj.put("ordertotalamount", rs.getDouble(2));
                jobj.put("purchasematerialdate", rs.getLong(1));
                jobj.put("purchasetotalamount", 0);
                jobj.put("paymentdate", rs.getLong(1));
                jobj.put("paymentamount", 0);
                dataJobj.put(String.valueOf(rs.getLong(1)), jobj);
            }
            rs = st.executeQuery("SELECT purchasematerialdate, sum(totalamount) AS totalamount FROM purchasematerial where purchasematerialdate between " + fromDateInLong + " and " + toDateInLong + " GROUP BY purchasematerialdate ORDER BY purchasematerialdate");

            while (rs.next()) {
                String dateStr = String.valueOf(rs.getLong(1));
                jobj = new JSONObject();
                if (dataJobj.has(dateStr)) {
                    jobj = dataJobj.getJSONObject(dateStr);
                    jobj.put("purchasematerialdate", rs.getLong(1));
                    jobj.put("purchasetotalamount", rs.getDouble(2));
                } else {
                    jobj.put("orderdate", rs.getLong(1));
                    jobj.put("ordertotalamount", 0);
                    jobj.put("purchasematerialdate", rs.getLong(1));
                    jobj.put("purchasetotalamount", rs.getDouble(2));
                    jobj.put("paymentdate", rs.getLong(1));
                    jobj.put("paymentamount", 0);
                }
                dataJobj.put(dateStr, jobj);
            }
            rs = st.executeQuery("SELECT paymentdate, sum(paymentamount) AS totalamount FROM payment where paymentdate between " + fromDateInLong + " and " + toDateInLong + " GROUP BY paymentdate ORDER BY paymentdate");

            while (rs.next()) {
                String dateStr = String.valueOf(rs.getLong(1));
                jobj = new JSONObject();
                if (dataJobj.has(dateStr)) {
                    jobj = dataJobj.getJSONObject(dateStr);
                    jobj.put("paymentdate", rs.getLong(1));
                    jobj.put("paymentamount", rs.getDouble(2));
                } else {
                    jobj.put("orderdate", rs.getLong(1));
                    jobj.put("ordertotalamount", 0);
                    jobj.put("purchasematerialdate", rs.getLong(1));
                    jobj.put("purchasetotalamount", 0);
                    jobj.put("paymentdate", rs.getLong(1));
                    jobj.put("paymentamount", rs.getDouble(2));
                }
                dataJobj.put(dateStr, jobj);
            }

            jarr.put(dataJobj);
            respoJSONObject.put("month", month);
            respoJSONObject.put("year", year);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String DateWiseMenuitemRecordList(HashMap<String, String> params) throws JSONException, SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        Statement st = null;
        ResultSet rs = null;
        String orderDate = "", toDate = "", menuitemName = "", menuitemId = "";
        double totalamount = 0,subtotal= 0,totalpaidamount= 0;
        try {

            orderDate = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
//            toDate = StringUtils.isNotEmpty(params.get("todate")) ? params.get("todate") : "";
            menuitemName = StringUtils.isNotEmpty(params.get("menuitemname")) ? params.get("menuitemname") : "";
            menuitemId = StringUtils.isNotEmpty(params.get("menuitemid")) ? params.get("menuitemid") : "";

            String fromyear = orderDate.substring(orderDate.lastIndexOf("/") + 1);
            String frommonth = orderDate.substring(orderDate.indexOf("/") + 1, orderDate.lastIndexOf("/"));
            String fromday = orderDate.substring(0, orderDate.indexOf("/"));

            long fromDateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();

            conn = DBPool.getConnection();
            st = conn.createStatement();

            rs = st.executeQuery("select co.rate,o.billdate,m.menuitemname, sum(quantity) from orderdetails co,ordertable o,menuitem m where o.billdate =" + fromDateInLong + " and o.orderid=co.orderid and iscomplete =1 and m.menuitemid=co.menuitemid group by m.menuitemname,o.billdate order by m.menuitemname");

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("rate", rs.getDouble(1));
                jobj.put("orderdate", rs.getLong(2));
                jobj.put("menuitemname", rs.getString(3));
                jobj.put("quantity", rs.getInt(4));
//                jobj.put("discount", rs.getDouble(5));

                jarr.put(jobj);
            }
            rs = st.executeQuery("SELECT sum(totalamount),sum(subtotal),sum(totalpaidamount) FROM ordertable where billdate =" + fromDateInLong + "");

            while (rs.next()) {
                jobj = new JSONObject();
                totalamount = rs.getDouble(1);
                subtotal = rs.getDouble(2);
                totalpaidamount = rs.getDouble(3);
            }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    respoJSONObject.put("date", orderDate);
            respoJSONObject.put("totalamount", totalamount);
            respoJSONObject.put("subtotal", subtotal);
            respoJSONObject.put("totalpaidamount", totalpaidamount);
//            respoJSONObject.put("year", year);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);

        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String CategoryAndDateWiseMenuItemList(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        ResultSet rs = null;
        String date = "", categoryName = "", todate = "";
        try {
            categoryName = StringUtils.isNotEmpty(params.get("categoryName")) ? params.get("categoryName") : "";
            date = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
            todate = StringUtils.isNotEmpty(params.get("todate")) ? params.get("todate") : "";
            String hourDiff = StringUtils.isNotEmpty(params.get("hourDiff")) ? params.get("hourDiff") : "0";

            String fromyear = date.substring(date.lastIndexOf("/") + 1);
            String frommonth = date.substring(date.indexOf("/") + 1, date.lastIndexOf("/"));
            String fromday = date.substring(0, date.indexOf("/"));

            long fromDateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
            Calendar cal = Calendar.getInstance();
            cal.setTimeInMillis(fromDateInLong);
            cal.add(Calendar.HOUR, Integer.parseInt(hourDiff));
            fromDateInLong = cal.getTimeInMillis();
            cal.add(Calendar.DATE, 1);
            long toDateInLong = cal.getTimeInMillis();
            conn = DBPool.getConnection();

            // PreparedStatement pst = null;
            Statement st = conn.createStatement();
//            ResultSet rs = st.executeQuery("select o.orderid,o.orderno,o.orderdate,o.totalamount,t.tablename from ordertable o ,tableordermapping tom,tabledetails t where o.orderdatetime between "+fromDateInLong+" and "+ toDateInLong+" and o.orderid=tom.orderid and tom.tableid=t.tableid and iscomplete=1 and isdeleted=0 order by orderno");

            rs = st.executeQuery("select co.rate,o.billdate,m.menuitemname, sum(quantity) from orderdetails co,ordertable o,menuitem m where o.billdatetime between " + fromDateInLong + " and " + toDateInLong + " and o.orderid=co.orderid and m.menuitemid=co.menuitemid and m.categoryid=" + categoryName + " group by m.menuitemname,o.orderdate order by m.menuitemname");
            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("rate", rs.getDouble(1));
                jobj.put("orderdate", rs.getLong(2));
                jobj.put("menuitemname", rs.getString(3));
                jobj.put("quantity", rs.getInt(4));
//                    jobj.put("discount", rs.getDouble(5));

                jarr.put(jobj);
            }
            respoJSONObject.put("date", date);
            respoJSONObject.put("totalamount", 0);
            respoJSONObject.put("subtotal", 0);
            respoJSONObject.put("totalpaidamount", 0);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);

        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public JSONObject UpdateRows() throws JSONException, SQLException {

        Connection conn = null;
        try {
            conn = DBConnection.DBPool.getConnection();
//            conn.setAutoCommit(false);
            String sqlQuery = "select orderid,orderdate,orderdatetime,orderno from ordertable";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                String orderid = rs.getString(1);
                long orderdate = rs.getLong(2);
                long orderdatetime = rs.getLong(3);
                String orderno = rs.getString(4);

                sqlQuery = "update ordertable set billdate=" + orderdate + ",billdatetime=" + orderdatetime + " where orderid='" + orderid + "'";
                int re = conn.createStatement().executeUpdate(sqlQuery);

            }

            conn.commit();
        } catch (Exception e) {
            conn.rollback();
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return null;
    }
    @Override
    public JSONObject UpdateTotalAmountRows() throws JSONException, SQLException {

        Connection conn = null;
        try {
            conn = DBConnection.DBPool.getConnection();
//            conn.setAutoCommit(false);
            String sqlQuery = "select orderid,totalamount from ordertable";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                String orderid = rs.getString(1);
                double totalamount = rs.getDouble(2);
                

                sqlQuery = "update ordertable set totalpaidamount=" + totalamount + " where orderid='" + orderid + "'";
                int re = conn.createStatement().executeUpdate(sqlQuery);

            }

            conn.commit();
        } catch (Exception e) {
            conn.rollback();
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return null;
    }

    @Override
    public String TwoDateWiseMenuitemRecordList(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        Statement st = null;
        ResultSet rs = null;
        String orderDate = "", toDate = "", menuitemName = "", menuitemId = "";
        double totalamount = 0;
        try {

            orderDate = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
            toDate = StringUtils.isNotEmpty(params.get("todate")) ? params.get("todate") : "";
            menuitemName = StringUtils.isNotEmpty(params.get("menuitemname")) ? params.get("menuitemname") : "";
            menuitemId = StringUtils.isNotEmpty(params.get("menuitemid")) ? params.get("menuitemid") : "";

            String fromyear = orderDate.substring(orderDate.lastIndexOf("/") + 1);
            String frommonth = orderDate.substring(orderDate.indexOf("/") + 1, orderDate.lastIndexOf("/"));
            String fromday = orderDate.substring(0, orderDate.indexOf("/"));

            long fromDateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();

            conn = DBPool.getConnection();
            st = conn.createStatement();

            if (!toDate.equals("") && (!menuitemId.equals(""))) {
                String toyear = toDate.substring(toDate.lastIndexOf("/") + 1);
                String tomonth = toDate.substring(toDate.indexOf("/") + 1, toDate.lastIndexOf("/"));
                String today = toDate.substring(0, toDate.indexOf("/"));

                long toDateInLong = new Date(toyear + "/" + tomonth + "/" + today).getTime();

                rs = st.executeQuery("select co.rate,o.billdate,m.menuitemname, sum(quantity),m.menuitemid from orderdetails co,ordertable o,menuitem m where o.billdate between " + fromDateInLong + " and " + toDateInLong + " and o.orderid=co.orderid and o.iscomplete =1 and m.menuitemid=co.menuitemid and m.menuitemid = " + menuitemId + " group by m.menuitemname order by m.menuitemname");

                while (rs.next()) {
                    jobj = new JSONObject();
                    jobj.put("rate", rs.getDouble(1));
                    jobj.put("orderdate", rs.getLong(2));
                    jobj.put("menuitemname", rs.getString(3));
                    jobj.put("quantity", rs.getInt(4));
//                    jobj.put("discount", rs.getDouble(5));
                    jobj.put("menuitemid", rs.getString(5));

                    jarr.put(jobj);
                }

                respoJSONObject.put("date", orderDate);
//            respoJSONObject.put("year", year);
                respoJSONObject.put("data", jarr);
                respoJSONObject.put("success", true);
            }
            if (!toDate.equals("") && (menuitemId.equals(""))) {
                String toyear = toDate.substring(toDate.lastIndexOf("/") + 1);
                String tomonth = toDate.substring(toDate.indexOf("/") + 1, toDate.lastIndexOf("/"));
                String today = toDate.substring(0, toDate.indexOf("/"));

                long toDateInLong = new Date(toyear + "/" + tomonth + "/" + today).getTime();

                rs = st.executeQuery("select co.rate,o.billdate,m.menuitemname, sum(quantity) from orderdetails co,ordertable o,menuitem m where o.billdate between " + fromDateInLong + " and " + toDateInLong + " and o.orderid=co.orderid and o.iscomplete =1 and m.menuitemid=co.menuitemid group by m.menuitemname order by m.menuitemname");

                while (rs.next()) {
                    jobj = new JSONObject();
                    jobj.put("rate", rs.getDouble(1));
                    jobj.put("orderdate", rs.getLong(2));
                    jobj.put("menuitemname", rs.getString(3));
                    jobj.put("quantity", rs.getInt(4));
//                    jobj.put("discount", rs.getDouble(5));

                    jarr.put(jobj);
                }

                respoJSONObject.put("date", orderDate);
//            respoJSONObject.put("year", year);
                respoJSONObject.put("data", jarr);
                respoJSONObject.put("success", true);
            }
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }

    @Override
    public String TwoCategoryAndDateWiseMenuItemList(HashMap<String, String> params) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        ResultSet rs = null;
        String date = "", categoryName = "", todate = "", subCategoryName = "";
        try {
            categoryName = StringUtils.isNotEmpty(params.get("categoryName")) ? params.get("categoryName") : "";
            subCategoryName = StringUtils.isNotEmpty(params.get("subCategoryName")) ? params.get("subCategoryName") : "";
            date = StringUtils.isNotEmpty(params.get("datepicker1")) ? params.get("datepicker1") : "";
            todate = StringUtils.isNotEmpty(params.get("todate")) ? params.get("todate") : "";
            String hourDiff = StringUtils.isNotEmpty(params.get("hourDiff")) ? params.get("hourDiff") : "0";

            String fromyear = date.substring(date.lastIndexOf("/") + 1);
            String frommonth = date.substring(date.indexOf("/") + 1, date.lastIndexOf("/"));
            String fromday = date.substring(0, date.indexOf("/"));

            long fromDateInLong = new Date(fromyear + "/" + frommonth + "/" + fromday).getTime();
            Calendar cal = Calendar.getInstance();
            cal.setTimeInMillis(fromDateInLong);
            cal.add(Calendar.HOUR, Integer.parseInt(hourDiff));
            fromDateInLong = cal.getTimeInMillis();
            cal.add(Calendar.DATE, 1);
            long toDateInLong = cal.getTimeInMillis();
            conn = DBPool.getConnection();

            // PreparedStatement pst = null;
            Statement st = conn.createStatement();
//            ResultSet rs = st.executeQuery("select o.orderid,o.orderno,o.orderdate,o.totalamount,t.tablename from ordertable o ,tableordermapping tom,tabledetails t where o.orderdatetime between "+fromDateInLong+" and "+ toDateInLong+" and o.orderid=tom.orderid and tom.tableid=t.tableid and iscomplete=1 and isdeleted=0 order by orderno");                         
            String toyear = todate.substring(todate.lastIndexOf("/") + 1);
            String tomonth = todate.substring(todate.indexOf("/") + 1, todate.lastIndexOf("/"));
            String today = todate.substring(0, todate.indexOf("/"));

            long twoDateInLong = new Date(toyear + "/" + tomonth + "/" + today).getTime();
            cal = Calendar.getInstance();
            cal.setTimeInMillis(twoDateInLong);
            cal.add(Calendar.HOUR, Integer.parseInt(hourDiff));
            twoDateInLong = cal.getTimeInMillis();
            cal.add(Calendar.DATE, 1);
            long toDiffDateInLong = cal.getTimeInMillis();

            if (!categoryName.equals("") && (!subCategoryName.equals(""))) {
                rs = st.executeQuery("select co.rate,o.billdate,m.menuitemname, sum(quantity) from orderdetails co,ordertable o,menuitem m where o.billdatetime between " + fromDateInLong + " and " + toDiffDateInLong + " and o.orderid=co.orderid and m.menuitemid=co.menuitemid and m.categoryid=" + categoryName + " and m.subcategoryid=" + subCategoryName + " group by m.menuitemname order by m.menuitemname");
                while (rs.next()) {
                    jobj = new JSONObject();
                    jobj.put("rate", rs.getDouble(1));
                    jobj.put("orderdate", rs.getLong(2));
                    jobj.put("menuitemname", rs.getString(3));
                    jobj.put("quantity", rs.getInt(4));
//                    jobj.put("discount", rs.getDouble(5));

                    jarr.put(jobj);
                }
                respoJSONObject.put("date", date);
                respoJSONObject.put("data", jarr);
                respoJSONObject.put("success", true);
            }
            if (!categoryName.equals("") && (subCategoryName.equals(""))) {
                rs = st.executeQuery("select co.rate,o.billdate,m.menuitemname, sum(quantity) from orderdetails co,ordertable o,menuitem m where o.billdatetime between " + fromDateInLong + " and " + toDiffDateInLong + " and o.orderid=co.orderid and m.menuitemid=co.menuitemid and m.categoryid=" + categoryName + " group by m.menuitemname order by m.menuitemname");
                while (rs.next()) {
                    jobj = new JSONObject();
                    jobj.put("rate", rs.getDouble(1));
                    jobj.put("orderdate", rs.getLong(2));
                    jobj.put("menuitemname", rs.getString(3));
                    jobj.put("quantity", rs.getInt(4));
//                    jobj.put("discount", rs.getDouble(5));

                    jarr.put(jobj);
                }
                respoJSONObject.put("date", date);
                respoJSONObject.put("data", jarr);
                respoJSONObject.put("success", true);
            }

        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject.toString();
    }
    
    @Override
     public JSONObject getDateWiseOrderDetails(String selectDate) throws JSONException, IOException,SQLException {

        JSONObject respoJSONObject = new JSONObject();
        JSONObject jobj = null;
        JSONArray jarr = new JSONArray();
        String date = "", datepicker2 = "";
        try {
            JSONObject returnJSONObject = new JSONObject();

        

        String year = selectDate.substring(selectDate.lastIndexOf("/") + 1);
        String month = selectDate.substring(selectDate.indexOf("/") + 1, selectDate.lastIndexOf("/"));
        String day = selectDate.substring(0, selectDate.indexOf("/"));
        
         long startDateInLong = new Date(year + "/" + month + "/" + day).getTime();
           
            conn = DBPool.getConnection();

            Statement st = conn.createStatement();
            String sqlQuery = "";
            if (selectDate.equals("")) {
                
            } else {
                sqlQuery = "select o.orderid,o.orderno,o.billdate,o.totalpaidamount,t.tablename from ordertable o ,tableordermapping tom,tabledetails t where o.billdate = " + startDateInLong + " and o.orderid=tom.orderid and tom.tableid=t.tableid and iscomplete=1 and isdeleted=0 order by orderno";
            }
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                jobj = new JSONObject();
                jobj.put("orderid", rs.getString(1));
                jobj.put("orderno", rs.getString(2));
                jobj.put("orderdate", rs.getLong(3));
                jobj.put("totalamount", rs.getDouble(4));
                jobj.put("tablename", rs.getString(5));

                jarr.put(jobj);
            }
            respoJSONObject.put("date", date);

            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("data", "");
            respoJSONObject.put("success", false);
            e.printStackTrace();
        } finally {
            conn.close();
        }
        return respoJSONObject;
    }

     
     @Override
    public JSONObject getOrderDetailList(String orderid) throws JSONException, SQLException {
        JSONObject respoJSONObject = new JSONObject();
        JSONArray jarr = new JSONArray();
        Connection conn = null;
        double CGST =0,SGST =0,serviceTax=0;
        try {
            conn = DBConnection.DBPool.getConnection();

            
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select od.menuitemid as 'menuitemid', mi.menuitemname as 'menuitemname', od.quantity as 'qty', od.rate as 'rate', "
                    + "ot.orderno as 'orderno', ot.subtotal as 'subtotal', ot.totalamount as 'totalamount',ot.totalpaidamount as 'paidamount',ot.servicetaxperamount as 'servicetax',ot.CGST as 'cgst',ot.SGST as 'sgst',ot.discount as 'discount' "
                    + "from orderdetails od, ordertable ot, menuitem mi where mi.menuitemid=od.menuitemid and "
                    + "ot.orderid='"+orderid+"' and od.orderid='"+orderid+"' and od.quantity > 0");

            String orderno = "";
            double totalAmount = 0.0, tax = 0.0, discount = 0.0, subtotal = 0.0,paidAmount=0.0;
            while (rs.next()) {
                JSONObject jobj = new JSONObject();
                jobj.put("menuItemId", rs.getInt("menuitemid"));
                jobj.put("menuItemName", rs.getString("menuitemname"));
                jobj.put("qty", rs.getInt("qty"));
                jobj.put("rate", rs.getDouble("rate"));
                orderno = rs.getString("orderno");
                subtotal = rs.getDouble("subtotal");
                totalAmount = rs.getDouble("totalamount");
                CGST = rs.getDouble("cgst");
                SGST = rs.getDouble("sgst");
                serviceTax = rs.getDouble("servicetax");
                paidAmount = rs.getDouble("paidamount");
                discount = rs.getDouble("discount");
                
//                jobj.put("isprinted", rs.getString(7));

                jarr.put(jobj);
            }
          
            respoJSONObject.put("CGST", CGST);
            respoJSONObject.put("SGST", SGST);
            respoJSONObject.put("serviceTax", serviceTax);
            respoJSONObject.put("orderNo", orderno);
            respoJSONObject.put("subTotal", subtotal);
            respoJSONObject.put("totalAmount", totalAmount);
            respoJSONObject.put("paidAmount", paidAmount);
            respoJSONObject.put("discount", discount);
            respoJSONObject.put("orderId", orderid);
            respoJSONObject.put("data", jarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            respoJSONObject.put("success", false);
            respoJSONObject.put("message", "Some error occurred.");
            e.printStackTrace();
        } finally {
            conn.close();
        }

        return respoJSONObject;
    }

}
