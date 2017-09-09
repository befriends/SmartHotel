<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="DaoImpl.CommonDaoImpl"%>
<%@page import="Dao.CommonDao"%>
<%
CommonDao commonDAOObj = new CommonDaoImpl();
JSONObject printHederJSONObject = commonDAOObj.printHeder();
JSONArray itemarr = new JSONArray();
String name = "";
String address = "";
if (printHederJSONObject != null && printHederJSONObject.has("success") && printHederJSONObject.has("data")) {
    itemarr = printHederJSONObject.getJSONArray("data");
   
    name = itemarr.getJSONObject(0).optString("printheadername", "");
    address = itemarr.getJSONObject(0).optString("printheaderaddress", "");
}%>
<div style="font-size: 15px; font-weight: bold;text-align: center;"><%=name %></div>
<div style="font-size: 12px; text-align: center;"><%=address %></div>