/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Controller;

import Dao.ReportDao;
import DaoImpl.ReportDaoImpl;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

/**
 *
 * @author vishwas
 */
@WebServlet(name = "ReportController", urlPatterns = {"/ReportController"})
public class ReportController extends HttpServlet {
ReportDao recDao = new ReportDaoImpl();

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         String result = "";
        Boolean booleanResult = false;
        JSONObject jobj = null;
        try {
            jobj = new JSONObject();
            ReportDao recDao = new ReportDaoImpl();

            int act = Integer.parseInt(request.getParameter("act"));
            String submodule = request.getParameter("submodule");
            switch (act) {
                case 1: { // Add Methods
                    switch (submodule) {
//                        case "datewise": {
//                            HashMap<String, String> params = new HashMap<String, String>();
//                            String datestring= (null == request.getParameter("datepicker1") ? "" : request.getParameter("datepicker1"));
//                            if(datestring.length()==0){
//                                DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
//                                Date date = new Date();
//                                datestring = dateFormat.format(date);
//                                //params.put("datepicker1", request.getParameter("datepicker1").length()>0 ? request.getParameter("datepicker1"): new Date());
//                            }
//                            params.put("datepicker1", datestring);
//                            result = recDao.dateSales(params);
////                            response.sendRedirect("DateWiseReport.jsp?result=" + result);
//                            request.setAttribute("result", result);
//                            RequestDispatcher rd = request.getRequestDispatcher("DateWiseReport.jsp");
//                            rd.forward(request, response);
//                        }
//                        break;
                        case "datewise": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String datestring = (null == request.getParameter("datepicker1") ? "" : request.getParameter("datepicker1"));
                            String hourDiff = (null == request.getParameter("hourdiff") ? "" : request.getParameter("hourdiff"));
                            String isDateOnly = (null == request.getParameter("isDateOnly") ? "" : request.getParameter("isDateOnly"));
                            if (datestring.length() == 0) {
                                DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                Date date = new Date();
                                datestring = dateFormat.format(date);
                                //params.put("datepicker1", request.getParameter("datepicker1").length()>0 ? request.getParameter("datepicker1"): new Date());
                            }
                            params.put("datepicker1", datestring);
                            params.put("hourDiff", hourDiff);
                            params.put("isDateOnly", isDateOnly);
                            result = recDao.dateSales(params);
//                            response.sendRedirect("DateWiseReport.jsp?result=" + result);
                            request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("DateWiseReport.jsp");
                            rd.forward(request, response);
                        }
                        break;
                        case "monthlysales": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("month", request.getParameter("month"));
                            params.put("year", request.getParameter("year"));
                            result = recDao.monthlysales(params);
//                            response.sendRedirect("MonthlySalesReport.jsp?result=" + result);
                             request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("MonthlySalesReport.jsp");
                            rd.forward(request, response);
                            }
                            break;
                        case "yearlysales": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("year", request.getParameter("year"));
                            result = recDao.yearsales(params);
                            
                            response.sendRedirect("YearlySalesReport.jsp?result=" + result);
                        }
                        break;
                        case "tabledate": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("tableno", request.getParameter("tableno"));
                            params.put("datepicker", request.getParameter("datepicker"));
                            result = recDao.TableDateReport(params);
//                            response.sendRedirect("DateAndTableReport.jsp?result=" + result);
                            request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("DateAndTableReport.jsp");
                            rd.forward(request, response);

                        }
                        break;
                        case "dateandalltable": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("datepicker1", request.getParameter("datepicker1"));
                            result = recDao.DateAllTableReport(params);
//                            response.sendRedirect("DateAllTableSalesReport.jsp?result=" + result);
                            request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("DateAllTableSalesReport.jsp");
                            rd.forward(request, response);

                        }
                        break;
                        case "paymentdate": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("datepicker1", request.getParameter("datepicker1"));
                            result = recDao.paymentDate(params);
//                            response.sendRedirect("PaymentDateReport.jsp?result=" + result);
                            request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("PaymentDateReport.jsp");
                            rd.forward(request, response);
                        }
                        break;
                        case "paymentemployee": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("employeeid", request.getParameter("employeeid"));
                            result = recDao.paymentEmployee(params);
                            response.sendRedirect("PaymentEmployeeReport.jsp?result=" + result);

                        }
//                        case "purchasedate": {
//                            HashMap<String, String> params = new HashMap<String, String>();
//                            params.put("datepicker1", request.getParameter("datepicker1"));
//                            result = recDao.purchaseDate(params);
//                            response.sendRedirect("PurchaseDateReport.jsp?result=" + result);
//
//                        }
//                        break;
//                        case "purchasemonth": {
//                            HashMap<String, String> params = new HashMap<String, String>();
//                            params.put("datepicker1", request.getParameter("datepicker1"));
//                            result = recDao.purchaseMonth(params);
//                            response.sendRedirect("PurchaseMonthReport.jsp?result=" + result);
//
//                        }
//                        break;
//                        case "purchaseyear": {
//                            HashMap<String, String> params = new HashMap<String, String>();
//                            params.put("datepicker1", request.getParameter("datepicker1"));
//                            result = recDao.purchaseYear(params);
//                            response.sendRedirect("PurchaseYearReport.jsp?result=" + result);
//
//                        }
//                        break;
                            case "purchasedate": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("datepicker1", request.getParameter("datepicker1"));
                            result = recDao.purchaseMaterial(params);
//                            response.sendRedirect("PurchaseMaterialDateReport.jsp?result=" + result);
                            request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("PurchaseMaterialDateReport.jsp");
                            rd.forward(request, response);

                        }
                        break;
                         case "monthlypurchase": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("month", request.getParameter("month"));
                            params.put("year", request.getParameter("year"));
                            result = recDao.monthlyPurchase(params);
//                            response.sendRedirect("PurchaseMaterialMonthReport.jsp?result=" + result);
                             request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("PurchaseMaterialMonthReport.jsp");
                            rd.forward(request, response);
                            }
                            break;
                              case "yearlypurchase": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("year", request.getParameter("year"));
                            result = recDao.yearlyPurchase(params);
                            response.sendRedirect("PurchaseMaterialYearReport.jsp?result=" + result);
                        }
                        break;
                           
                            case "purchasematerial": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("materialid", request.getParameter("materialid"));
                            result = recDao.purchaseName(params);
//                            response.sendRedirect("PurchaseMaterialNameReport.jsp?result=" + result);
                             request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("PurchaseMaterialNameReport.jsp");
                            rd.forward(request, response);
                        }
                        break;
                                case "stockmaterial": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("materialid", request.getParameter("materialid"));
                            result = recDao.stockName(params);
                            response.sendRedirect("MaterialStockNameReport.jsp?result=" + result);
                        }
                        break;
                          case "monthlycancel": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("month", request.getParameter("month"));
                            params.put("year", request.getParameter("year"));
                            result = recDao.monthylcancel(params);
//                            response.sendRedirect("CancelOrderDetailsReport.jsp?result=" + result);
                             request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("CancelOrderDetailsReport.jsp");
                            rd.forward(request, response);
                            }
                            break;          
                        case "expensedate": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("datepicker1", request.getParameter("datepicker1"));
                            result = recDao.expenceMaterial(params);
                            response.sendRedirect("ExpenseMaterialDateReport.jsp?result=" + result);

                        }
                        break; 
                            case "monthlyexpense": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("month", request.getParameter("month"));
                            params.put("year", request.getParameter("year"));
                            result = recDao.monthlyExpense(params);
                            response.sendRedirect("ExpenseMaterialMonthReport.jsp?result=" + result);
                            }
                            break;
                                case "expensematerial": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("materialid", request.getParameter("materialid"));
                            result = recDao.expenceName(params);
                            response.sendRedirect("ExpenseMaterialNameReport.jsp?result=" + result);
                        }
                        break;
                        case "kotdetails": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("datepicker1", request.getParameter("datepicker1"));
                            result = recDao.DateWiseKOTReport(params);
//                            response.sendRedirect("DateWiseKOT.jsp?result=" + result);
                             request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("DateWiseKOT.jsp");
                            rd.forward(request, response);
                            }
                        break;
                             case "dailyborrow": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String datestring= (null == request.getParameter("datepicker1") ? "" : request.getParameter("datepicker1"));
                            if(datestring.length()==0){
                            DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                Date date = new Date();
                                datestring = dateFormat.format(date);
                            }
                            params.put("borrowdate", datestring);
                            result = recDao.borrowDate(params);
//                            response.sendRedirect("dailyBorrowReport.jsp?result=" + result);
                             request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("dailyBorrowReport.jsp");
                            rd.forward(request, response);
                        }
                        break;
                             case "monthlyborrow": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("month", request.getParameter("month"));
                            params.put("year", request.getParameter("year"));
                            result = recDao.monthlyBorrow(params);
//                            response.sendRedirect("BorrowMonthWiseReport.jsp?result=" + result);
                            request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("BorrowMonthWiseReport.jsp");
                            rd.forward(request, response);
                            }
                            break;
                                  case "datewisestock": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String datestring= (null == request.getParameter("datepicker") ? "" : request.getParameter("datepicker"));
                            if(datestring.length()==0){
                            DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                Date date = new Date();
                               datestring = dateFormat.format(date);
                            }
                            params.put("stockdate", datestring);
                            result = recDao.DateWiseStock(params);
//                            response.sendRedirect("DateWiseStockReport.jsp?result=" + result);
                            request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("DateWiseStockReport.jsp");
                            rd.forward(request, response);
                        }
                        break;
                        case "paymentmode" :{
                            HashMap<String, String> params = new HashMap<String, String>();
                            String datestring = (null == request.getParameter("datepicker1") ? "" : request.getParameter("datepicker1"));
                            String paymentmode = (null == request.getParameter("paymentmode") ? "" : request.getParameter("paymentmode"));
                            if(datestring.length()==0){
                                DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                Date date = new Date();
                                datestring = dateFormat.format(date);
                                //params.put("datepicker1", request.getParameter("datepicker1").length()>0 ? request.getParameter("datepicker1"): new Date());
                            }
                            params.put("selecteddate", datestring);
                            params.put("paymentmode", paymentmode);
                            result = recDao.getDateWisePaymentModeReport(params);
                            response.sendRedirect("DateWisePaymentModeReport.jsp?paymentmode="+paymentmode+"&selecteddate="+datestring+"&result=" + result);
                        }
                        break;
                             case "datewisemenuitem": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String datestring= (null == request.getParameter("datepicker1") ? "" : request.getParameter("datepicker1"));
                            if(datestring.length()==0){
                                DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                Date date = new Date();
                                datestring = dateFormat.format(date);
                                //params.put("datepicker1", request.getParameter("datepicker1").length()>0 ? request.getParameter("datepicker1"): new Date());
                            }
                            params.put("datepicker1", datestring);
                            result = recDao.dailyMenuitemRecordList(params);
//                            response.sendRedirect("DailyMenuItemOrderReport.jsp?result=" + result);
                             request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("DailyMenuItemOrderReport.jsp");
                            rd.forward(request, response);
                        }
                        break;
                                 case "monthlyamountdetails": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            params.put("month", request.getParameter("month"));
                            params.put("year", request.getParameter("year"));
                            result = recDao.monthlyAmountDetails(params);
//                            response.sendRedirect("MonthlyAmountDetailsReport.jsp?result=" + result);
                             request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("MonthlyAmountDetailsReport.jsp");
                            rd.forward(request, response);
                            }
                            break;
                                     case "datewisemenuitemrecord": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String datestring= (null == request.getParameter("datepicker1") ? "" : request.getParameter("datepicker1"));
                            if(datestring.length()==0){
                                DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                Date date = new Date();
                                datestring = dateFormat.format(date);
                                //params.put("datepicker1", request.getParameter("datepicker1").length()>0 ? request.getParameter("datepicker1"): new Date());
                            }
                            params.put("datepicker1", datestring);
                            result = recDao.DateWiseMenuitemRecordList(params);
//                            response.sendRedirect("DateWiseMenuItemOrderReport.jsp?result=" + result);
                             request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("DateWiseMenuItemOrderReport.jsp");
                            rd.forward(request, response);
                        }
                        break;
                           case "categorydatewise": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String categoryName = (null == request.getParameter("categoryid") ? "" : request.getParameter("categoryid"));
                            String datestring = (null == request.getParameter("datepicker1") ? "" : request.getParameter("datepicker1"));
                            String hourDiff = (null == request.getParameter("hourdiff") ? "" : request.getParameter("hourdiff"));
                            if (datestring.length() == 0) {
                                DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                Date date = new Date();
                                datestring = dateFormat.format(date);
                            }
                            params.put("categoryName", categoryName);
                            params.put("datepicker1", datestring);
                            params.put("hourDiff", hourDiff);
                            result = recDao.CategoryAndDateWiseMenuItemList(params);
                            request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("DateWiseMenuItemOrderReport.jsp");
                            rd.forward(request, response);
                        }
                        break;
                           case "categorytwodatewise": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String categoryName = (null == request.getParameter("categoryid") ? "" : request.getParameter("categoryid"));
                            String subCategoryName = (null == request.getParameter("subcategoryid") ? "" : request.getParameter("subcategoryid"));
                            String datestring = (null == request.getParameter("datepicker1") ? "" : request.getParameter("datepicker1"));
                            String todatestring = (null == request.getParameter("todate") ? "" : request.getParameter("todate"));
                            String hourDiff = (null == request.getParameter("hourdiff") ? "" : request.getParameter("hourdiff"));
                            if (datestring.length() == 0) {
                                DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                Date date = new Date();
                                datestring = dateFormat.format(date);
                            }
                            params.put("categoryName", categoryName);
                            params.put("subCategoryName", subCategoryName);
                            params.put("datepicker1", datestring);
                            params.put("todate", todatestring);
                            params.put("hourDiff", hourDiff);
                            result = recDao.TwoCategoryAndDateWiseMenuItemList(params);
                            request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("TwoDateWiseMenuItemReport.jsp");
                            rd.forward(request, response);
                        }
                        break;
                                 case "twodatewisemenuitemrecord": {
                            HashMap<String, String> params = new HashMap<String, String>();
                            String datestring= (null == request.getParameter("datepicker1") ? "" : request.getParameter("datepicker1"));
                            String todatestring= (null == request.getParameter("todate") ? "" : request.getParameter("todate"));
                            if(datestring.length()==0){
                                DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                Date date = new Date();
                                datestring = dateFormat.format(date);
                                //params.put("datepicker1", request.getParameter("datepicker1").length()>0 ? request.getParameter("datepicker1"): new Date());
                            }
                            params.put("datepicker1", datestring);
                            params.put("menuitemname", request.getParameter("menuitem"));
                            params.put("menuitemid", request.getParameter("menuitemid"));
                            params.put("todate", todatestring);
                            result = recDao.TwoDateWiseMenuitemRecordList(params);
//                            response.sendRedirect("DateWiseMenuItemOrderReport.jsp?result=" + result);
                             request.setAttribute("result", result);
                            RequestDispatcher rd = request.getRequestDispatcher("TwoDateWiseMenuItemReport.jsp");
                            rd.forward(request, response);
                        }
                        break;
                                     case "datewiseorder": {
                                          JSONObject responseJsonObj = new JSONObject();
                            String selectDate = request.getParameter("selectdate");
//                            String endDate = request.getParameter("enddate");
//                            String customerId = request.getParameter("customernameid");
                            responseJsonObj = recDao.getDateWiseOrderDetails(selectDate);
                            response.getWriter().write(responseJsonObj.toString());
                        }
                               
                }
                break;
            }
        }
        } catch (Exception e) {

    }
    }
    
        // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
    