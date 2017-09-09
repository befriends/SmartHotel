/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Dao.OrderDao;
import Dao.UserDao;
import DaoImpl.OrderDaoImpl;
import DaoImpl.UserDaoImpl;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.mysql.jdbc.StringUtils;
import com.sun.javafx.print.PrintHelper;
import com.sun.org.apache.xalan.internal.xsltc.compiler.util.Type;
import java.awt.print.PageFormat;
import java.awt.print.Printable;
import java.awt.print.PrinterJob;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.UUID;
import javafx.scene.control.Cell;
import javax.print.Doc;
import javax.print.DocFlavor;
import javax.print.DocPrintJob;
import javax.print.PrintException;
import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.print.SimpleDoc;
import javax.print.StreamPrintService;
import javax.print.StreamPrintServiceFactory;
import javax.print.attribute.HashPrintRequestAttributeSet;
import javax.print.attribute.PrintRequestAttributeSet;
import javax.print.attribute.standard.Sides;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.text.StyleConstants;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.printing.PDFPageable;
import org.json.*;

/**
 *
 * @author sai
 */
@WebServlet(name = "OrderController", urlPatterns = {"/OrderController"})
public class OrderController extends HttpServlet {

    OrderDao orderDaoObj = null;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String result = "", checkboxnotificationflag = "";
        HashMap<String, String> params = null;
        JSONObject responseJobj = new JSONObject();
        try {
            orderDaoObj = new OrderDaoImpl();
            int act = Integer.parseInt(request.getParameter("act"));

            switch (act) {
                case 1: {//Add Order
                    String orderList = request.getParameter("orderlistjson");
                    params = new HashMap<String, String>(1);
                    params.put("orderList", orderList);
                    responseJobj = orderDaoObj.saveOrder(params);

                    String orderno = "";
                    if (responseJobj.getBoolean("success")) {
                        orderno = responseJobj.getString("orderno");
                    }
                    params.put("orderno", orderno);

                    UserDao userDAOObj = new UserDaoImpl();
                    JSONObject masterJobj = userDAOObj.getMasterSettings();
                    JSONArray masterJarr = masterJobj.getJSONArray("data");
                    JSONObject settingsJobj = masterJarr.getJSONObject(0);
                    boolean isDuplicatePrint = false;
                    if (settingsJobj.optInt("duplicatePrint", 0) != 0) {
                        isDuplicatePrint = true;
                    }
                    String duplicatePrinterName = settingsJobj.optString("duplicatePrinterName", "");
                    if (isDuplicatePrint) {
                        params.put("orderList", orderList);
                        params.put("fileName", "duplicate_order");
                        JSONObject pdfResponseObj = generateProceedOrderPDF(params);
                        String filePath = "";
                        if (pdfResponseObj.getBoolean("success")) {
                            filePath = pdfResponseObj.getString("path");
                        }
                        DocFlavor flavor = DocFlavor.SERVICE_FORMATTED.PAGEABLE;
                        PrintRequestAttributeSet patts = new HashPrintRequestAttributeSet();
                        PrintService[] ps = PrintServiceLookup.lookupPrintServices(flavor, patts);
                        if (ps.length == 0) {
                            //                        response.getWriter().write("No Printer Found");
                        }
                        System.out.println("Available printers: " + Arrays.asList(ps));

                        PrintService myService = null;
                        for (PrintService printService : ps) {
                            if (printService.getName().equals(duplicatePrinterName)) {
                                myService = printService;
                                break;
                            }
                        }
                        if (myService == null) {
                            //                        throw new IllegalStateException("Printer not found");
                        } 
//                        else {
//                            PDDocument pdf = null;
//                            try {
//                                pdf = PDDocument.load(new File(filePath));
//                            } catch (Exception e) {
//                                System.out.print(e);
//                            }
//                            //SimpleDoc doc = new SimpleDoc (pdf, DocFlavor.INPUT_STREAM.AUTOSENSE, null);
//                            PrinterJob printJob = PrinterJob.getPrinterJob();
//                            printJob.setPrintService(myService);
//                            printJob.setPageable(new PDFPageable(pdf));
//                            printJob.print();
//                            if (pdf != null) {
//                                pdf.close();
//                            }
//                        }
                    }

                    //Split order based on printers
                    JSONObject orderListAfterSplitResponse = splitOrderOnPrinter(orderList);
                    JSONArray orderListAfterSplitJarr = orderListAfterSplitResponse.getJSONArray("data");
                    for (int ind = 0; ind < orderListAfterSplitJarr.length(); ind++) {
                        JSONObject jobj = orderListAfterSplitJarr.getJSONObject(ind);
                        String printerName = jobj.getString("printername");
                        String orderListData = jobj.toString();
                        params.put("orderList", orderListData);
                        params.put("fileName", "order_" + ind);
                        JSONObject pdfResponseObj = generateProceedOrderPDF(params);
                        String filePath = "";
                        if (pdfResponseObj.getBoolean("success")) {
                            filePath = pdfResponseObj.getString("path");
                        }
                        DocFlavor flavor = DocFlavor.SERVICE_FORMATTED.PAGEABLE;
                        PrintRequestAttributeSet patts = new HashPrintRequestAttributeSet();
                        PrintService[] ps = PrintServiceLookup.lookupPrintServices(flavor, patts);
                        if (ps.length == 0) {
                            //                        response.getWriter().write("No Printer Found");
                        }
                        System.out.println("Available printers: " + Arrays.asList(ps));

                        PrintService myService = null;
                        for (PrintService printService : ps) {
                            if (printService.getName().equals(printerName)) {
                                myService = printService;
                                break;
                            }
                        }
                        if (myService == null) {
                            //                        throw new IllegalStateException("Printer not found");
                        } else {
                            PDDocument pdf = null;
                            try {
                                pdf = PDDocument.load(new File(filePath));
                            } catch (Exception e) {
                                System.out.print(e);
                            }
                            //SimpleDoc doc = new SimpleDoc (pdf, DocFlavor.INPUT_STREAM.AUTOSENSE, null);
                            PrinterJob printJob = PrinterJob.getPrinterJob();
                            printJob.setPrintService(myService);
                            printJob.setPageable(new PDFPageable(pdf));
                            printJob.print();
                            if (pdf != null) {
                                pdf.close();
                            }
                        }
                    }
                    response.getWriter().write(responseJobj.toString());
                }
                break;
                case 2: {//Shift Order
                    params = new HashMap<String, String>();
                    params.put("bookedtableid", request.getParameter("bookedtableid"));
                    params.put("shifttableid", request.getParameter("shifttableid"));

                    responseJobj = orderDaoObj.TableShift(params);
                    response.sendRedirect("TableShift.jsp?result=" + responseJobj);
                }
                break;
                case 3: {//Delete Order

                    params = new HashMap<String, String>(3);
                    params.put("ordername", request.getParameter("ordername"));

                    result = orderDaoObj.deleteOrder(params);
                    response.sendRedirect("DeleteOrder.jsp?result=" + result);
//                    response.getWriter().write(responseJobj.toString());
                }
                break;
                case 4: {//Search Menu Item
                    params = new HashMap<String, String>(2);
                    String value = "";
                    if ((!request.getParameter("value").equals("")) && (request.getParameter("value") != null)) {
                        value = request.getParameter("value");
                    }
                    params.put("value", value);
                    responseJobj = orderDaoObj.getSearchedMenuItemList(params);
                    response.getWriter().write(responseJobj.toString());
                }
                break;
                case 5: {//Bill Payment
                    params = new HashMap<String, String>(4);
                    String orderid = request.getParameter("orderid");
                    String subtotal = request.getParameter("subtotal");
                    String discount = request.getParameter("discount");
                    String grandtotal = request.getParameter("grandtotal");
                    String paymentmode = request.getParameter("paymentmode");
                    String chequeno = request.getParameter("chequeno");
                    String customer = StringUtils.isNullOrEmpty(request.getParameter("customer")) ? "" : request.getParameter("customer");
                    if (!StringUtils.isNullOrEmpty(request.getParameter("checkboxnotificationflag"))) {
                        checkboxnotificationflag = request.getParameter("checkboxnotificationflag");
                    }
                    
                    String totalpaidamount = StringUtils.isNullOrEmpty(request.getParameter("totalpaidamount")) ? "0" : request.getParameter("totalpaidamount");
                    String CGST = StringUtils.isNullOrEmpty(request.getParameter("CGST")) ? "0" : request.getParameter("CGST");
                    String SGST = StringUtils.isNullOrEmpty(request.getParameter("SGST")) ? "0" : request.getParameter("SGST");
                    String servicetax = StringUtils.isNullOrEmpty(request.getParameter("servicetax")) ? "0" : request.getParameter("servicetax");
                    String servicetaxper = StringUtils.isNullOrEmpty(request.getParameter("servicetaxper")) ? "0" : request.getParameter("servicetaxper");
//                    checkboxnotificationflag = request.getParameter("checkboxnotificationflag");
                    params.put("orderid", orderid);
                    params.put("subtotal", subtotal);
                    params.put("discount", discount);
                    params.put("grandtotal", grandtotal);
                    params.put("customer", customer);
                    params.put("paymentmode", paymentmode);
                    params.put("chequeno", chequeno);
                    params.put("checkboxnotificationflag", checkboxnotificationflag);
                    params.put("totalpaidamount", totalpaidamount);
                    params.put("CGST", CGST);
                    params.put("SGST", SGST);
                    params.put("servicetax", servicetax);
                    params.put("servicetaxper", servicetaxper);

                    responseJobj = orderDaoObj.makeBillPayment(params);
                    //response.sendRedirect("billprint.jsp?result=" + responseJobj);
                    response.getWriter().write(responseJobj.toString());
                }
                break;
                case 6: {   //get Table Orders
                    responseJobj = new JSONObject();
                    responseJobj.put("success", false);
                    params = new HashMap<String, String>(1);
                    if (request.getParameter("selectedTable") != null && !(((String) request.getParameter("selectedTable")).trim().isEmpty())) {
                        params.put("selectedTable", request.getParameter("selectedTable"));
                        responseJobj = orderDaoObj.getOrderList(params);
                        response.getWriter().write(responseJobj.toString());
                    } else {
                        responseJobj.put("message", "table id is null or empty.");
                        response.getWriter().write(responseJobj.toString());
                    }
                }
                break;
                case 7: {//KOT
                    String orderList = request.getParameter("orderlistjson");
                    params = new HashMap<String, String>(1);
                    params.put("orderList", orderList);
                    params.put("orderno", "");
                    params.put("isKOT", "true");

                    responseJobj = new JSONObject();
                    responseJobj.put("success", true);
                    responseJobj.put("message", "KOT sent to printing.");

                    UserDao userDAOObj = new UserDaoImpl();
                    JSONObject masterJobj = userDAOObj.getMasterSettings();
                    JSONArray masterJarr = masterJobj.getJSONArray("data");
                    JSONObject settingsJobj = masterJarr.getJSONObject(0);
                    boolean isDuplicatePrint = false;
                    if (settingsJobj.optInt("duplicatePrint", 0) != 0) {
                        isDuplicatePrint = true;
                    }
                    String duplicatePrinterName = settingsJobj.optString("duplicatePrinterName", "");
                    if (isDuplicatePrint) {
                        params.put("orderList", orderList);
                        params.put("fileName", "duplicate_order");
                        JSONObject pdfResponseObj = generateProceedOrderPDF(params);
                        String filePath = "";
                        if (pdfResponseObj.getBoolean("success")) {
                            filePath = pdfResponseObj.getString("path");
                        }
                        DocFlavor flavor = DocFlavor.SERVICE_FORMATTED.PAGEABLE;
                        PrintRequestAttributeSet patts = new HashPrintRequestAttributeSet();
                        PrintService[] ps = PrintServiceLookup.lookupPrintServices(flavor, patts);
                        if (ps.length == 0) {
                            //                        response.getWriter().write("No Printer Found");
                        }
                        System.out.println("Available printers: " + Arrays.asList(ps));

                        PrintService myService = null;
                        for (PrintService printService : ps) {
                            if (printService.getName().equals(duplicatePrinterName)) {
                                myService = printService;
                                break;
                            }
                        }
                        if (myService == null) {
                            //                        throw new IllegalStateException("Printer not found");
                        } else {
                            PDDocument pdf = null;
                            try {
                                pdf = PDDocument.load(new File(filePath));
                            } catch (Exception e) {
                                System.out.print(e);
                            }
                            //SimpleDoc doc = new SimpleDoc (pdf, DocFlavor.INPUT_STREAM.AUTOSENSE, null);
                            PrinterJob printJob = PrinterJob.getPrinterJob();
                            printJob.setPrintService(myService);
                            printJob.setPageable(new PDFPageable(pdf));
                            printJob.print();
                            if (pdf != null) {
                                pdf.close();
                            }
                        }
                    }

                    //Split order based on printers
                    JSONObject orderListAfterSplitResponse = splitOrderOnPrinter(orderList);
                    JSONArray orderListAfterSplitJarr = orderListAfterSplitResponse.getJSONArray("data");
                    for (int ind = 0; ind < orderListAfterSplitJarr.length(); ind++) {
                        JSONObject jobj = orderListAfterSplitJarr.getJSONObject(ind);
                        String printerName = jobj.getString("printername");
                        String orderListData = jobj.toString();
                        params.put("orderList", orderListData);
                        params.put("fileName", "kot_" + ind);
                        JSONObject pdfResponseObj = generateOrderKOTPDF(params);
                        String filePath = "";
                        if (pdfResponseObj.getBoolean("success")) {
                            filePath = pdfResponseObj.getString("path");
                        }
                        DocFlavor flavor = DocFlavor.SERVICE_FORMATTED.PAGEABLE;
                        PrintRequestAttributeSet patts = new HashPrintRequestAttributeSet();
                        PrintService[] ps = PrintServiceLookup.lookupPrintServices(flavor, patts);
                        if (ps.length == 0) {
                            response.getWriter().write("No Printer Found");
                        }
                        System.out.println("Available printers: " + Arrays.asList(ps));

                        PrintService myService = null;
                        for (PrintService printService : ps) {
                            if (printService.getName().equals(printerName)) {
                                myService = printService;
                                break;
                            }
                        }

                        if (myService == null) {
                            response.getWriter().write("Priter Not Found");
                        } else {
                            PDDocument pdf = null;
                            try {
                                pdf = PDDocument.load(new File(filePath));
                            } catch (Exception e) {
                                System.out.print(e);
                            }
                            //SimpleDoc doc = new SimpleDoc (pdf, DocFlavor.INPUT_STREAM.AUTOSENSE, null);
                            PrinterJob printJob = PrinterJob.getPrinterJob();
                            printJob.setPrintService(myService);
                            printJob.setPageable(new PDFPageable(pdf));
                            printJob.print();
                            if (pdf != null) {
                                pdf.close();
                            }
                        }
                    }
                    response.getWriter().write(responseJobj.toString());
                }
                break;
                case 8: {//Final Bill
                    String orderList = request.getParameter("orderlistjson");
                    params = new HashMap<String, String>(1);
                    params.put("orderList", orderList);

//                    params.put("orderno", "");
//                    params.put("isKOT", "true");
                    JSONObject pdfResponseObj = generateProceedOrderFinalBillPDF(params);
                    String filePath = "";
                    if (pdfResponseObj.getBoolean("success")) {
                        filePath = pdfResponseObj.getString("path");
                    }
                    DocFlavor flavor = DocFlavor.SERVICE_FORMATTED.PAGEABLE;
                    PrintRequestAttributeSet patts = new HashPrintRequestAttributeSet();
                    PrintService[] ps = PrintServiceLookup.lookupPrintServices(flavor, patts);
                    if (ps.length == 0) {
                        response.getWriter().write("No Printer Found");
                    }
                    System.out.println("Available printers: " + Arrays.asList(ps));

                    PrintService myService = null;
                    for (PrintService printService : ps) {
                        if (printService.getName().contains("EPSON")) {
                            myService = printService;
                            break;
                        }
                    }

                    if (myService == null) {
                        response.getWriter().write("Priter Not Found");
                    } else {
                        PDDocument pdf = null;
                        try {
                            pdf = PDDocument.load(new File(filePath));
                        } catch (Exception e) {
                            System.out.print(e);
                        }
                        //SimpleDoc doc = new SimpleDoc (pdf, DocFlavor.INPUT_STREAM.AUTOSENSE, null);
                        PrinterJob printJob = PrinterJob.getPrinterJob();
                        printJob.setPrintService(myService);
                        printJob.setPageable(new PDFPageable(pdf));
                        printJob.print();
                        if (pdf != null) {
                            pdf.close();
                        }
                    }

//                    }
                }
                break;
//                case 9: {
//                    String orderNumber= request.getParameter("orderno");
//                    String tableid= request.getParameter("tableid");
//                    params = new HashMap<String, String>(1);
//                    params.put("ordernumber", orderNumber);
//                    params.put("tableid", tableid);
////                    String print = orderDaoObj.savePrint(params);
////                     JSONObject pdfResponseObj = generateProceedOrder(print);
//                }
//                break;
                case 9: {
                    params = new HashMap<String, String>(1);
                    String orderID= request.getParameter("orderid");                    
                    params.put("orderid", orderID);
                    responseJobj = orderDaoObj.UpdateEditOrder(params);
                    response.getWriter().write(responseJobj.toString());
                }
                break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public JSONObject generateProceedOrderPDF(HashMap<String, String> params) throws JSONException, FileNotFoundException, DocumentException {
        JSONObject responseJSONObj = null;
        String path = "";
        try {
            String fileName = params.get("fileName") != null ? params.get("fileName") : "order.pdf";
            responseJSONObj = new JSONObject();
            FileOutputStream file = null;
            //FileOutputStream image;
            try {
                File f = new File(fileName);
                if (!f.exists()) {
                    f.createNewFile();
                }
//                path = getClass().getResource("test.pdf").getPath();
                file = new FileOutputStream(f);
                path = f.getAbsolutePath();

            } catch (FileNotFoundException e1) {

                e1.printStackTrace();
            }

//            Document document = new Document(PageSize.A7);
            Document document = new Document();
            document.setPageSize(new Rectangle(200f, 1140f));
            PdfWriter.getInstance(document, file);

            document.setMargins(10, 10, 10, 10);
            document.open();
//            document.setPageSize(new Rectangle(80, 297));

            Font f = new Font();
            f.setSize(10);
            Paragraph title;
            if (params.containsKey("isKOT") && Boolean.parseBoolean(params.get("isKOT"))) {
                title = new Paragraph("--KOT--", f);
            } else {
                title = new Paragraph("--Proceed Order (Kitchen)--", f);
            }
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");//dd/MM/yyyy
            Date now = new Date();
            String strDate = sdfDate.format(now);
            Paragraph date = new Paragraph("Date : " + strDate, f);
            document.add(date);

            String orderno = params.get("orderno");
            JSONObject orderList = new JSONObject(params.get("orderList"));
            JSONArray orderJarr = orderList.getJSONArray("data");
            String tableid = orderList.getString("tableid");
            String tableno = orderList.getString("tableno");
            String userid = orderList.getString("userid");

            Statement st = DBConnection.DBPool.getConnection().createStatement();
            ResultSet rs = st.executeQuery("select username from userlogin where userid='" + userid + "'");
            String username = String.valueOf(userid);
            if (rs.next()) {
                username = rs.getString(1);
            }

            if (!StringUtils.isNullOrEmpty(orderno)) {
                Paragraph ordNo = new Paragraph("Order No : " + orderno, f);
                document.add(ordNo);
            }
            Paragraph tableNo = new Paragraph("Table No : " + tableno, f);
            document.add(tableNo);

            Paragraph userName = new Paragraph("Captain Name : " + username, f);
            document.add(userName);

            PdfPTable table = null;
            table = new PdfPTable(4); // 3 columns.

            PdfPCell srno = new PdfPCell(new Paragraph("No.", f));
            srno.setBorderWidthBottom(1);
            srno.setHorizontalAlignment(Element.ALIGN_CENTER);
            PdfPCell cell1 = new PdfPCell(new Paragraph("Menu", f));
            cell1.setBorderWidthBottom(1);
            PdfPCell cell2 = new PdfPCell(new Paragraph("Type", f));
            cell2.setBorderWidthBottom(1);
            PdfPCell cell3 = new PdfPCell(new Paragraph("Qty", f));
            cell3.setBorderWidthBottom(1);
            cell3.setHorizontalAlignment(Element.ALIGN_CENTER);

            float[] columnWidths = new float[]{10f, 30f, 20f, 10f};
            table.setWidths(columnWidths);

            table.addCell(srno);
            table.addCell(cell1);
            table.addCell(cell2);
            table.addCell(cell3);
            for (int cnt = 0; cnt < orderJarr.length(); cnt++) {
                String orderDetailsId = "";
                JSONObject orderJobj = orderJarr.getJSONObject(cnt);
                long menuitemid = orderJobj.getLong("menuitemid");
                st = DBConnection.DBPool.getConnection().createStatement();
                rs = st.executeQuery("select menuitemname from menuitem where menuitemid=" + menuitemid);
                String menuitemname = String.valueOf(menuitemid);
                if (rs.next()) {
                    menuitemname = rs.getString(1);
                }
                String message = orderJobj.has("message") ? orderJobj.getString("message") : "";
                int quantity = orderJobj.getInt("quantity");

                table.setWidthPercentage(100); //Width 100%
                table.setSpacingBefore(10f); //Space before table
                table.setSpacingAfter(10f); //Space after table

                PdfPCell srnocell = new PdfPCell(new Paragraph((cnt + 1) + "", f));
                srnocell.setHorizontalAlignment(Element.ALIGN_CENTER);
                PdfPCell cell11 = new PdfPCell(new Paragraph(String.valueOf(menuitemname), f));
                PdfPCell cell22 = new PdfPCell(new Paragraph(message, f));
                PdfPCell cell33 = new PdfPCell(new Paragraph(String.valueOf(quantity), f));
                cell33.setHorizontalAlignment(Element.ALIGN_CENTER);

                table.addCell(srnocell);
                table.addCell(cell11);
                table.addCell(cell22);
                table.addCell(cell33);
            }

            document.add(table);
            document.close();

            responseJSONObj.put("path", path);
            responseJSONObj.put("success", true);
        } catch (Exception e) {
            responseJSONObj.put("success", false);
            responseJSONObj.put("message", "Some error occurred.");
            e.printStackTrace();
        }

        return responseJSONObj;
    }

    public JSONObject generateProceedOrderFinalBillPDF(HashMap<String, String> params) throws JSONException, FileNotFoundException, DocumentException, SQLException {
        JSONObject responseJSONObj = null;
        String path = "",headerName="",headerAddress="";
             Connection conn = null;
    
        try {
            responseJSONObj = new JSONObject();
            FileOutputStream file = null;
            //FileOutputStream image;
            try {
                File f = new File("print.pdf");
                if (!f.exists()) {
                    f.createNewFile();
                }
//                path = getClass().getResource("test.pdf").getPath();
                file = new FileOutputStream(f);
                path = f.getAbsolutePath();

            } catch (FileNotFoundException e1) {

                e1.printStackTrace();
            }

//            Document document = new Document(PageSize.A7);
            Document document = new Document();
            document.setPageSize(new Rectangle(200f, 1140f));
            PdfWriter.getInstance(document, file);

            document.setMargins(10, 10, 10, 10);
            document.open();
//            document.setPageSize(new Rectangle(80, 297));

            Font hotelNameFont = new Font(FontFamily.TIMES_ROMAN, 10.0f, Font.BOLD, BaseColor.BLACK);
            Font hotelDetailsFont = new Font(FontFamily.TIMES_ROMAN, 8.0f, Font.NORMAL, BaseColor.BLACK);
            Font f = new Font(FontFamily.TIMES_ROMAN, 8.0f, Font.NORMAL, BaseColor.BLACK);
//            Paragraph p=new Paragraph("New PdF",f);
//            f.setSize(8);
            Paragraph title;
            Paragraph hotelName;
//            if(params.containsKey("isKOT") && Boolean.parseBoolean(params.get("isKOT"))){
//                title = new Paragraph("--KOT--", f);
//            } else{
//            Paragraph hotelDetailsLine_1 = new Paragraph("HOTEL KALYANI", hotelNameFont);
//            Paragraph hotelDetailsLine_2 = new Paragraph("VEG-NONVEG FAMILY GARDEN RESTAURANT", hotelDetailsFont);
//            Paragraph hotelDetailsLine_3 = new Paragraph("NAGAR-PUNE HIGHWAY, BORHADE MALA,", hotelDetailsFont);
//            Paragraph hotelDetailsLine_4 = new Paragraph("SHIRUR, DIST-PUNE,", hotelDetailsFont);
//            Paragraph hotelDetailsLine_5 = new Paragraph("MOB. 8805014009, 9923521010", hotelDetailsFont);

//            hotelDetailsLine_1.setLeading(10f);
//            hotelDetailsLine_2.setLeading(10f);
//            hotelDetailsLine_3.setLeading(10f);
//            hotelDetailsLine_4.setLeading(10f);
//            hotelDetailsLine_5.setLeading(10f);
//            hotelDetailsLine_1.setAlignment(Element.ALIGN_CENTER);
//            hotelDetailsLine_2.setAlignment(Element.ALIGN_CENTER);
//            hotelDetailsLine_3.setAlignment(Element.ALIGN_CENTER);
//            hotelDetailsLine_4.setAlignment(Element.ALIGN_CENTER);
//            hotelDetailsLine_5.setAlignment(Element.ALIGN_CENTER);
//            document.add(hotelDetailsLine_1);
//            document.add(hotelDetailsLine_2);
//            document.add(hotelDetailsLine_3);
//            document.add(hotelDetailsLine_4);
//            document.add(hotelDetailsLine_5);
            SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");//dd/MM/yyyy
            SimpleDateFormat sdfTime = new SimpleDateFormat("hh:mm:ss");//dd/MM/yyyy
            Date now = new Date();
            String strDate = sdfDate.format(now);
            String strTime = sdfTime.format(now);
            String orderno = params.get("orderno");
            JSONObject orderList = new JSONObject(params.get("orderList"));
            JSONArray orderJarr = orderList.getJSONArray("data");
            String tableid = orderList.getString("tableid");
            String tableno = orderList.getString("tableno");
            String userid = orderList.getString("userid");
//            String orderid = orderList.getString("orderid");
            String customerName = orderList.optString("customername");
            String checkboxnotificationflag = orderList.getString("checkboxnotificationflag");
            if (!checkboxnotificationflag.equals("1")) {

                Statement statement = DBConnection.DBPool.getConnection().createStatement();
                String sqlquery = "select printheadername,printheaderaddress from printheader";
                ResultSet result = statement.executeQuery(sqlquery);
                if (result.next()) {
                    headerName = result.getString(1);
                    headerAddress = result.getString(2);

                }

                Paragraph hotelDetailsLine_1 = new Paragraph(headerName, hotelNameFont);
                hotelDetailsLine_1.setLeading(10f);
                hotelDetailsLine_1.setAlignment(Element.ALIGN_CENTER);
                document.add(hotelDetailsLine_1);
                Paragraph hotelDetailsLine_2 = new Paragraph(headerAddress, hotelDetailsFont);
                hotelDetailsLine_2.setLeading(10f);
                hotelDetailsLine_2.setAlignment(Element.ALIGN_CENTER);
                document.add(hotelDetailsLine_2);
            }
//             Statement stmt = DBConnection.DBPool.getConnection().createStatement();
           
             conn = DBConnection.DBPool.getConnection();
             conn.setAutoCommit(false);
             Statement statement = conn.createStatement();
//             String qry = "update orderdetails set isprinted = 1 where orderid = '"+orderid+"'";
             int rr = statement.executeUpdate("update tabledetails set isreserved = 1 where tableid ='"+ tableid +"'");
               conn.commit();
            PdfPTable extraDetailsTable = null;
            extraDetailsTable = new PdfPTable(2); // 2 columns.
            extraDetailsTable.setWidths(new float[]{60f, 40f});
            extraDetailsTable.setWidthPercentage(100);
            extraDetailsTable.setSpacingAfter(0f);
            extraDetailsTable.setSpacingBefore(5f);

            PdfPCell extraDtlCell = new PdfPCell(new Paragraph(" ", f));
            if (!StringUtils.isNullOrEmpty(orderno)) {
                extraDtlCell = new PdfPCell(new Paragraph("BILL NO : " + orderno, f));
            }
            extraDtlCell.setBorder(PdfPCell.NO_BORDER);
            extraDtlCell.setPadding(1);
            extraDetailsTable.addCell(extraDtlCell);
            extraDtlCell = new PdfPCell(new Paragraph("DATE : " + strDate, f));
            extraDtlCell.setBorder(PdfPCell.NO_BORDER);
            extraDtlCell.setPadding(1);
            extraDetailsTable.addCell(extraDtlCell);
            extraDtlCell = new PdfPCell(new Paragraph("TABLE NO : " + tableno, f));
            extraDtlCell.setBorder(PdfPCell.NO_BORDER);
            extraDtlCell.setPadding(1);
            extraDetailsTable.addCell(extraDtlCell);
            extraDtlCell = new PdfPCell(new Paragraph("TIME : " + strTime, f));
            extraDtlCell.setBorder(PdfPCell.NO_BORDER);
            extraDtlCell.setPadding(1);
            extraDetailsTable.addCell(extraDtlCell);
            extraDtlCell = new PdfPCell(new Paragraph("CUSTOMER NAME : " + customerName, f));
            extraDtlCell.setBorder(PdfPCell.NO_BORDER);
            extraDtlCell.setPadding(1);
            extraDtlCell.setColspan(2);
            extraDetailsTable.addCell(extraDtlCell);
            document.add(extraDetailsTable);

            PdfPTable table = null;
            table = new PdfPTable(4); // 4 columns.

            PdfPCell cell1 = new PdfPCell(new Paragraph("ITEM NAME", f));
            cell1.setBorder(PdfPCell.NO_BORDER);
            cell1.setBorderWidthBottom(1);
            cell1.setBorderWidthTop(1);

            PdfPCell cell3 = new PdfPCell(new Paragraph("QTY", f));
            cell3.setBorder(PdfPCell.NO_BORDER);
            cell3.setBorderWidthBottom(1);
            cell3.setBorderWidthTop(1);
            cell3.setHorizontalAlignment(Element.ALIGN_CENTER);
            PdfPCell cell4 = new PdfPCell(new Paragraph("PRICE", f));
            cell4.setBorder(PdfPCell.NO_BORDER);
            cell4.setBorderWidthBottom(1);
            cell4.setBorderWidthTop(1);
            cell4.setHorizontalAlignment(Element.ALIGN_CENTER);
            PdfPCell cell5 = new PdfPCell(new Paragraph("AMOUNT", f));
            cell5.setBorder(PdfPCell.NO_BORDER);
            cell5.setBorderWidthBottom(1);
            cell5.setBorderWidthTop(1);
            cell5.setHorizontalAlignment(Element.ALIGN_RIGHT);

            float[] columnWidths = new float[]{40f, 10f, 13f, 20f};
            table.setWidths(columnWidths);

//            table.addCell(srno);
            table.addCell(cell1);
//            table.addCell(cell2);
            table.addCell(cell3);
            table.addCell(cell4);
            table.addCell(cell5);
            double total = 0, discount = 0, grandtotal = 0,totalpaidamount = 0, CGST = 0, SGST= 0 ,servicetax = 0;

            // Font settings
            Font menuItemFont = new Font(FontFamily.TIMES_ROMAN, 9.5f, Font.NORMAL, BaseColor.BLACK);

            for (int cnt = 0; cnt < orderJarr.length(); cnt++) {
//                String orderDetailsId = "";
                JSONObject orderJobj = orderJarr.getJSONObject(cnt);
                long menuitemid = orderJobj.getLong("menuitemid");
                Statement st = DBConnection.DBPool.getConnection().createStatement();
                ResultSet rs = st.executeQuery("select menuitemname from menuitem where menuitemid=" + menuitemid);
                String menuitemname = String.valueOf(menuitemid);
                if (rs.next()) {
                    menuitemname = rs.getString(1);
                }
                String message = orderJobj.has("message") ? orderJobj.getString("message") : "";
                int quantity = orderJobj.getInt("quantity");
                int rate = orderJobj.getInt("rate");
                total = orderJobj.getDouble("total");
                int amount = orderJobj.getInt("subtotal");
                String discnt = orderJobj.getString("discount").equals("") ? "0" : orderJobj.getString("discount");
//                String discnt = orderJobj.getString("discount");
                discount = Double.parseDouble(discnt);
                grandtotal = orderJobj.getDouble("grandtotal");
                totalpaidamount = orderJobj.getDouble("totalpaidamountid");
               String cgst= orderJobj.optString("CGST").equals("") ? "0" : orderJobj.optString("CGST");
               String sgst= orderJobj.optString("SGST").equals("") ? "0" : orderJobj.optString("SGST");
               String servicetaxAmt= orderJobj.optString("servicetax").equals("") ? "0" : orderJobj.optString("servicetax");
//                CGST = orderJobj.optDouble("CGST");
//                SGST = orderJobj.optDouble("SGST");
//                servicetax = orderJobj.optDouble("servicetax");
               
               CGST = Double.parseDouble(cgst);
               SGST = Double.parseDouble(sgst);
               servicetax = Double.parseDouble(servicetaxAmt);

                table.setWidthPercentage(100); //Width 100%
                table.setSpacingBefore(5f); //Space before table
                table.setSpacingAfter(0f); //Space after table

                PdfPCell cell = new PdfPCell(new Paragraph(String.valueOf(menuitemname), menuItemFont));
                cell.setPaddingLeft(2);
                cell.setPaddingRight(2);
                cell.setPaddingTop(2);
                cell.setPaddingBottom(2);
                cell.setBorder(PdfPCell.NO_BORDER);
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(String.valueOf(quantity), f));
                cell.setPaddingLeft(2);
                cell.setPaddingRight(2);
                cell.setPaddingTop(2);
                cell.setPaddingBottom(2);
                cell.setBorder(PdfPCell.NO_BORDER);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(String.valueOf(rate), f));
                cell.setPaddingLeft(2);
                cell.setPaddingRight(2);
                cell.setPaddingTop(2);
                cell.setPaddingBottom(2);
                cell.setBorder(PdfPCell.NO_BORDER);
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                table.addCell(cell);
                cell = new PdfPCell(new Paragraph(String.valueOf(amount), f));
                cell.setPaddingLeft(2);
                cell.setPaddingRight(2);
                cell.setPaddingTop(2);
                cell.setPaddingBottom(2);
                cell.setBorder(PdfPCell.NO_BORDER);
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                table.addCell(cell);

            }
            document.add(table);
            Paragraph separator = new Paragraph("---------------------------------------------");
            separator.setAlignment(Element.ALIGN_CENTER);
            separator.setLeading(0, 0.8f);
            document.add(separator);
            Paragraph SubTotal = new Paragraph("SubTotal : " + total, f);
            SubTotal.setLeading(9f);
            SubTotal.setAlignment(Element.ALIGN_RIGHT);
            document.add(SubTotal);
            if (discount > 0) {
                Paragraph disc = new Paragraph("Discount(%) : " + discount, f);
                disc.setLeading(10f);
                disc.setAlignment(Element.ALIGN_RIGHT);
                document.add(disc);
                
                Paragraph grandtotalamount = new Paragraph("GrandTotal :" + grandtotal,f);
                grandtotalamount.setLeading(10f);
                grandtotalamount.setAlignment(Element.ALIGN_RIGHT);
                document.add(grandtotalamount);
            }
            if(CGST > 0 || SGST > 0){
            Paragraph CGSTAmount = new Paragraph("CGST :" + CGST,f);
                CGSTAmount.setLeading(10f);
                CGSTAmount.setAlignment(Element.ALIGN_RIGHT);
                document.add(CGSTAmount);
                
                Paragraph SGSTAmount = new Paragraph("SGST :" + SGST,f);
                SGSTAmount.setLeading(10f);
                SGSTAmount.setAlignment(Element.ALIGN_RIGHT);
                document.add(SGSTAmount);
            }
            if(servicetax > 0){
             Paragraph servicetaxAmount = new Paragraph("Service Tax :" + servicetax,f);
                servicetaxAmount.setLeading(10f);
                servicetaxAmount.setAlignment(Element.ALIGN_RIGHT);
                document.add(servicetaxAmount);
            }
            Font totalFont = new Font(FontFamily.TIMES_ROMAN, 13.0f, Font.BOLD, BaseColor.BLACK);
            Paragraph finalTotal = new Paragraph("Total : " + totalpaidamount, totalFont);
            finalTotal.setLeading(15f);
            finalTotal.setAlignment(Element.ALIGN_RIGHT);
            document.add(finalTotal);
            document.add(separator);

            Font noteFont = new Font(FontFamily.TIMES_ROMAN, 8.0f, Font.BOLD, BaseColor.BLACK);
            Paragraph note1 = new Paragraph("GOD BLESS YOU ALL", noteFont);
            note1.setAlignment(Element.ALIGN_CENTER);
            note1.setLeading(8f);
            Paragraph note2 = new Paragraph("WISH YOU HAPPY JOURNEY", noteFont);
            note2.setAlignment(Element.ALIGN_CENTER);
            note2.setLeading(8f);
            document.add(note1);
            document.add(note2);

            document.close();

            responseJSONObj.put("path", path);
            responseJSONObj.put("success", true);
        } catch (Exception e) {
            responseJSONObj.put("success", false);
            responseJSONObj.put("message", "Some error occurred.");
            e.printStackTrace();
        }finally{
            conn.close();
        }

        return responseJSONObj;
    }

    public JSONObject generateOrderKOTPDF(HashMap<String, String> params) throws JSONException, FileNotFoundException, DocumentException {
        JSONObject responseJSONObj = null;
        String path = "";
        try {
            String fileName = params.get("fileName") != null ? params.get("fileName") + ".pdf" : "kot.pdf";
            responseJSONObj = new JSONObject();
            FileOutputStream file = null;
            try {
                File f = new File(fileName);
                if (!f.exists()) {
                    f.createNewFile();
                }
                file = new FileOutputStream(f);
                path = f.getAbsolutePath();
            } catch (FileNotFoundException e1) {
                e1.printStackTrace();
            }
            Document document = new Document();
            document.setPageSize(new Rectangle(200f, 1140f));
            PdfWriter.getInstance(document, file);

            document.setMargins(10, 10, 10, 10);
            document.open();

            Font f = new Font();
            f.setSize(10);
            Paragraph title;
            if (params.containsKey("isKOT") && Boolean.parseBoolean(params.get("isKOT"))) {
                title = new Paragraph("--KOT--", f);
            } else {
                title = new Paragraph("--Proceed Order (Kitchen)--", f);
            }
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");//dd/MM/yyyy
            Date now = new Date();
            String strDate = sdfDate.format(now);
            Paragraph date = new Paragraph("Date : " + strDate, f);
            document.add(date);

            String orderno = params.get("orderno");
            JSONObject orderList = new JSONObject(params.get("orderList"));
            JSONArray orderJarr = orderList.getJSONArray("data");
            String tableid = orderList.getString("tableid");
            String tableno = orderList.getString("tableno");
            String userid = orderList.getString("userid");

            Statement st = DBConnection.DBPool.getConnection().createStatement();
            ResultSet rs = st.executeQuery("select username from userlogin where userid='" + userid + "'");
            String username = String.valueOf(userid);
            if (rs.next()) {
                username = rs.getString(1);
            }

            if (!StringUtils.isNullOrEmpty(orderno)) {
                Paragraph ordNo = new Paragraph("Order No : " + orderno, f);
                document.add(ordNo);
            }
            Paragraph tableNo = new Paragraph("Table No : " + tableno, f);
            document.add(tableNo);

            Paragraph userName = new Paragraph("Captain Name : " + username, f);
            document.add(userName);

            PdfPTable table = null;
            table = new PdfPTable(4); // 3 columns.

            PdfPCell srno = new PdfPCell(new Paragraph("No.", f));
            srno.setBorderWidthBottom(1);
            srno.setHorizontalAlignment(Element.ALIGN_CENTER);
            PdfPCell cell1 = new PdfPCell(new Paragraph("Menu", f));
            cell1.setBorderWidthBottom(1);
            PdfPCell cell2 = new PdfPCell(new Paragraph("Type", f));
            cell2.setBorderWidthBottom(1);
            PdfPCell cell3 = new PdfPCell(new Paragraph("Qty", f));
            cell3.setBorderWidthBottom(1);
            cell3.setHorizontalAlignment(Element.ALIGN_CENTER);

            float[] columnWidths = new float[]{10f, 30f, 20f, 10f};
            table.setWidths(columnWidths);

            table.addCell(srno);
            table.addCell(cell1);
            table.addCell(cell2);
            table.addCell(cell3);
            for (int cnt = 0; cnt < orderJarr.length(); cnt++) {
                String orderDetailsId = "";
                JSONObject orderJobj = orderJarr.getJSONObject(cnt);
                long menuitemid = orderJobj.getLong("menuitemid");
                st = DBConnection.DBPool.getConnection().createStatement();
                rs = st.executeQuery("select menuitemname from menuitem where menuitemid=" + menuitemid);
                String menuitemname = String.valueOf(menuitemid);
                if (rs.next()) {
                    menuitemname = rs.getString(1);
                }
                String message = orderJobj.has("message") ? orderJobj.getString("message") : "";
                int quantity = orderJobj.getInt("quantity");

                table.setWidthPercentage(100); //Width 100%
                table.setSpacingBefore(10f); //Space before table
                table.setSpacingAfter(10f); //Space after table

                PdfPCell srnocell = new PdfPCell(new Paragraph((cnt + 1) + "", f));
                srnocell.setHorizontalAlignment(Element.ALIGN_CENTER);
                PdfPCell cell11 = new PdfPCell(new Paragraph(String.valueOf(menuitemname), f));
                PdfPCell cell22 = new PdfPCell(new Paragraph(message, f));
                PdfPCell cell33 = new PdfPCell(new Paragraph(String.valueOf(quantity), f));
                cell33.setHorizontalAlignment(Element.ALIGN_CENTER);

                table.addCell(srnocell);
                table.addCell(cell11);
                table.addCell(cell22);
                table.addCell(cell33);
            }

            document.add(table);
            document.close();

            responseJSONObj.put("path", path);
            responseJSONObj.put("success", true);
        } catch (Exception e) {
            responseJSONObj.put("success", false);
            responseJSONObj.put("message", "Some error occurred.");
            e.printStackTrace();
        }
        return responseJSONObj;
    }

    public JSONObject splitOrderOnPrinter(String orderList) {
        JSONObject respoJSONObject = new JSONObject();
        try {
            JSONObject orderListJson = new JSONObject(orderList);

            String menuitemidlist = orderListJson.getString("menuitemidlist");
            orderDaoObj = new OrderDaoImpl();
            JSONObject categoryPrinterJson = orderDaoObj.getCategoryPrinterNamesFromMenuitem(menuitemidlist);

            JSONObject menuitemPrinterJobj = categoryPrinterJson.getJSONObject("menuitemPrinterJobj");
            String printersList = categoryPrinterJson.getString("printersList");
            printersList = printersList.substring(1, printersList.length() - 1);
            String[] printers = printersList.split(",");

            JSONArray afterSplitJarr = new JSONArray();
            for (String printer : printers) {
                JSONObject tempOrderListJson = new JSONObject(orderList);
                String printerName = printer.trim();
                JSONArray orderArr = orderListJson.getJSONArray("data");
                JSONArray splitJarr = new JSONArray();
                for (int ind = 0; ind < orderArr.length(); ind++) {
                    JSONObject jobj = orderArr.getJSONObject(ind);
                    String menuitemid = jobj.getString("menuitemid");
                    if (printerName.equals(menuitemPrinterJobj.getString(menuitemid))) {
                        splitJarr.put(jobj);
                    }
                }
                tempOrderListJson.put("data", splitJarr);
                tempOrderListJson.put("printername", printerName);
                afterSplitJarr.put(tempOrderListJson);
            }

            respoJSONObject.put("data", afterSplitJarr);
            respoJSONObject.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return respoJSONObject;
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
