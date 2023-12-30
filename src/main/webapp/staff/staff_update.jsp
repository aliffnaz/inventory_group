<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.*, java.io.*, java.sql.DriverManager, java.sql.ResultSet, java.sql.Connection, java.sql.SQLException, java.sql.Statement"%>

<%
Connection conn = null;
try {
	// Load Oracle JDBC driver
	Class.forName("oracle.jdbc.driver.OracleDriver");

	// Establish connection (replace with your database URL, username, and password)
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String username = "INVENTORY_502";
	String password = "system";
	conn = DriverManager.getConnection(url, username, password);

	// Check if connection is successful
	if (conn != null) {
		System.out.println("Successfully connected to Oracle Database");
	}
} catch (ClassNotFoundException | SQLException e) {
	// Handle exceptions
	System.out.println("Error: " + e.getMessage());
	e.printStackTrace(); // Output full stack trace for debugging
}
String url = "jdbc:oracle:thin:@localhost:1521:xe";
String username = "INVENTORY_502";
String password = "system";
Connection Conn = DriverManager.getConnection(url, username, password);
Statement stmt = Conn.createStatement();
String query = "select * from inventory";
ResultSet s = stmt.executeQuery(query);
%>


<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Update Staff</title>

<!-- Bootstrap CSS -->
<link
	href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css"
	rel="stylesheet">
<link
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">

<style>
/* Custom CSS */
</style>

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
		<div class="card card-body m-auto mb-4 col-9">
			<h2 class="mb-3">Update Staff</h2>

			<!-- Update Staff Form -->
			<form>
				<div class="form-group">
					<label>Staff ID</label> <input type="text" class="form-control"
						id="staffID">
				</div>

				<div class="form-group">
					<label>Staff Name</label> <input type="text" class="form-control"
						id="staffName">
				</div>

				<div class="form-group">
					<label>Staff IC</label> <input type="text" class="form-control"
						id="staffIC">
				</div>

				<div class="form-group">
					<label>Staff Phone</label> <input type="text" class="form-control"
						id="staffPhone">
				</div>

				<div class="form-group">
					<label>Staff Role</label> <input type="text" class="form-control"
						id="staffRole">
				</div>

				<div class="form-group">
					<label>Staff Age</label> <input type="text" class="form-control"
						id="staffAge">
				</div>

				<!-- Other input fields -->

				<button type="submit" class="btn btn-primary">Update</button>
			</form>
		</div>

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
