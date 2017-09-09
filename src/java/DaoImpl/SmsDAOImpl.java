/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DaoImpl;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import org.json.JSONObject;
import sun.net.util.IPAddressUtil;

/**
 *
 * @author sai
 */
public class SmsDAOImpl {

    public boolean sendSMS(String recipientNo, String message) {
        JSONObject respoJSONObject = null;
        boolean isMessageSent = false;
        try {
            respoJSONObject = new JSONObject();
            String charset = "UTF-8";  // Or in Java 7 and later, use the constant: java.nio.charset.StandardCharsets.UTF_8.name()
//            String recipient = "9637620901";
//            String message = " Greetings from SmartDairy! Have a nice day!";
            String userid = "SAIRAM-T";
            String password = "SAI2016";

            String requestUrl = "http://www.eazy2sms.in/SMS.aspx";

            String params = String.format("Userid=%s&Password=%s&Mobile=%s&Message=%s&Type=%s&TempId=%s&AspxAutoDetectCookieSupport=%s",
                    URLEncoder.encode(userid, charset),
                    URLEncoder.encode(password, charset),
                    URLEncoder.encode(recipientNo, charset),
                    URLEncoder.encode(message, charset),
                    URLEncoder.encode("1", charset),
                    URLEncoder.encode("82958", charset),
                    URLEncoder.encode("1", charset));
            URL url = new URL(requestUrl + "?" + params);

            try {
                HttpURLConnection uc = (HttpURLConnection) url.openConnection();
                uc.setConnectTimeout(10000);
                System.out.println(uc.getResponseMessage());
                isMessageSent = uc.getResponseMessage().equals("OK") ? true : false;
                uc.disconnect();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }

        return isMessageSent;
    }
}
