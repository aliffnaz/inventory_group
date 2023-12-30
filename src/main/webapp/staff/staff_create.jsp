<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.*, java.io.*,java.sql.PreparedStatement, java.sql.DriverManager, java.sql.ResultSet, java.sql.Connection, java.sql.SQLException, java.sql.Statement"%>

<%
Connection conn = null;

String id = request.getParameter("staffID");
String name = request.getParameter("staffName");
String ic = request.getParameter("staffIC");
String phone = request.getParameter("staffPhone");
String role = request.getParameter("staffRole");
String age = request.getParameter("staffAge");

//out.println(id);
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


<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register Staff</title>

<!-- Bootstrap CSS -->
<link
	href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css"
	rel="stylesheet">
<link
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">


</head>

<body>

	<!-- Navbar -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container">
			<a class="navbar-brand" href="#">Inventory Management</a>
		</div>
	</nav>

	<!-- Page Content -->
	<div class="container mt-4">

		<h2>Register New Staff</h2>

		<!-- Register Form -->
		<form action="" method="post">
			<div class="form-group">
				<label>Staff ID</label> <input type="text" class="form-control"
					name="staffID">
			</div>

			<div class="form-group">
				<label>Staff Name</label> <input type="text" class="form-control"
					name="staffName">
			</div>

			<div class="form-group">
				<label>Staff IC</label> <input type="text" class="form-control"
					name="staffIC">
			</div>

			<div class="form-group">
				<label>Staff Phone</label> <input type="text" class="form-control"
					name="staffPhone">
			</div>

			<div class="form-group">
				<label>Staff Role</label> <input type="text" class="form-control"
					name="staffRole">
			</div>

			<div class="form-group">
				<label>Staff Age</label> <input type="text" class="form-control"
					name="staffAge">
			</div>

			<!-- Other input fields -->

			<button type="submit" class="btn btn-primary">Register</button>
		</form>

	</div>

	<!-- Bootstrap JS and jQuery -->
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
	<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

</body>

</html>