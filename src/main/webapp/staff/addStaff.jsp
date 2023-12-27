<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ page
	import="java.util.*, java.io.*, java.sql.DriverManager, java.sql.Connection, java.sql.ResultSet, java.sql.SQLException, java.sql.Statement, java.sql.PreparedStatement"%>

<%
Connection conn = null;

String id = request.getParameter("staffID");
String name = request.getParameter("staffName");
String ic = request.getParameter("staffIC");
String phone = request.getParameter("staffPhone");
String role = request.getParameter("staffRole");
String age = request.getParameter("staffAge");

out.println(id);
if (id != null) {
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String username = "INVENTORY_502";
	String password = "system";
	 conn = DriverManager.getConnection(url, username, password);
	//Statement stmt = Conn.createStatement();
	//String query = "insert into staff values(id,name,ic,phone,role,age,'password')";
	//ResultSet s = stmt.executeQuery(query);

	PreparedStatement ps = conn.prepareStatement(
	"insert into staff(staffID,staffIC,staffPhone,staffRole,staffAge,password) values(?,?,?,?,?,?)");
	ps.setString(1, id);
	ps.setString(2, ic);
	ps.setString(3, phone);
	ps.setString(4, role);
	ps.setString(5, age);
	ps.setString(6, "password");
	ResultSet execute = ps.executeQuery();
	
	if (execute == null) {
		out.println("not working man");
	}
}
%>