
<%@@page import="java.sql.DriverManager, java.sql.Connection";
 %>
<%
Connection conn = null;
String url = "jdbc:oracle:thin:@localhost:1521:xe";
String username = "INVENTORY_502";
String password = "system";
 conn = DriverManager.getConnection(url, username, password);
%>
