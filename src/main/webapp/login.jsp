<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ page
	import="java.util.*, java.io.*, java.sql.DriverManager, java.sql.Connection, java.sql.ResultSet, java.sql.SQLException, java.sql.Statement, java.sql.PreparedStatement"%>

<%
Connection conn = null;
Class.forName("oracle.jdbc.driver.OracleDriver");
String url = "jdbc:oracle:thin:@localhost:1521:xe";
String username = "INVENTORY_502";
String password = "system";
conn = DriverManager.getConnection(url, username, password);
  
if (request.getParameter("staffid") != null) {
	String id = request.getParameter("staffid");
	PreparedStatement check = conn.prepareStatement("select * from staff where staffid=?");
	check.setString(1, id);
	ResultSet checking = check.executeQuery();

	if (checking.next()) {
		if (checking.getString("staffrole").equalsIgnoreCase("manager")) {
	response.sendRedirect("managerMenu.jsp?id=" + checking.getString("staffid"));
		} else {
	response.sendRedirect("staffMenu.jsp?id=" + checking.getString("staffid"));
		}
	} else {
		out.println("The id is invalid, please try again");
	}
} else {
	session.invalidate();
}
%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Inventory Management - Login</title>

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

	<!-- Login Form -->
	<div class="container mt-5 mt-5">
		<div class="row">
			<div class="col-3"></div>
			<div class="col-6">
				<form action="" method="post">
					<div class="card">
						<div class="card-header">Staff Login</div>
						<div class="card-body">
							<form>
								<div class="form-group">
									<label for="staffID">Staff ID</label> <input type="text"
										class="form-control" name="staffid"
										placeholder="Enter staff ID">
								</div>
								<button type="submit" class="btn btn-primary">Login</button>
							</form>
						</div>
					</div>
			</div>
			</form>


		</div>
		<div class="col-3"></div>
	</div>


	<!-- Bootstrap JS and jQuery -->
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>

</html>