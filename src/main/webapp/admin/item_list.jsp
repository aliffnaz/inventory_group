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
<title>Inventory Management</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css"
	rel="stylesheet">
<link
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">
<style>
/* Custom CSS */
/* Add your custom styles here */
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
		<!-- Add Item Button -->
		<button type="button" class="btn btn-primary mb-3" data-toggle="modal"
			data-target="#addItemModal">Add Item</button>

		<!-- Data Table -->
		<table id="inventoryTable" class="table table-striped table-bordered"
			style="width: 100%">
			<thead class="thead-dark">


				<tr>
					<th>#</th>
					<th>Item Name</th>
					<th>Quantity</th>
					<th>Action</th>
				</tr>

			</thead>
			<tbody>
				<!-- Sample Table Data (Replace this with dynamic data) -->
				<%
				while (s.next()) {
				%>
				<tr>
					<td><%=s.getString("inventoryid")%></td>
					<td><%=s.getString("inventoryname")%></td>
					<td><%=s.getString("inventoryprice")%></td>
					<td>
						<button type="button" class="btn btn-primary btn-sm view-btn"
							data-toggle="modal" data-target="#viewItemModal">View</button>
						<button type="button" class="btn btn-danger btn-sm delete-btn">Delete</button>
					</td>
				</tr>
				<%
				}
				%>
				<tr>
					<td>2</td>
					<td>Product B</td>
					<td>15</td>
					<td>
						<button type="button" class="btn btn-primary btn-sm view-btn"
							data-toggle="modal" data-target="#viewItemModal">View</button>
						<button type="button" class="btn btn-danger btn-sm delete-btn">Delete</button>
					</td>
				</tr>
				<!-- End of Sample Table Data -->
			</tbody>
		</table>

		<!-- Add Item Modal -->
		<div class="modal fade" id="addItemModal" tabindex="-1" role="dialog"
			aria-labelledby="addItemModalLabel" aria-hidden="true">
			<!-- Modal content goes here -->
		</div>

		<!-- View Item Modal -->
		<div class="modal fade" id="viewItemModal" tabindex="-1" role="dialog"
			aria-labelledby="viewItemModalLabel" aria-hidden="true">
			<!-- Modal content goes here -->
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="viewItemModalLabel">Item
							Information</h5>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<!-- Item Information Display (Replace this with your actual item information) -->
						<p>
							Item Name: <span id="itemName"></span>
						</p>
						<p>
							Quantity: <span id="itemQuantity"></span>
						</p>
						<!-- End of Item Information Display -->
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-dismiss="modal">Back</button>
						<button type="button" class="btn btn-primary">Update</button>
					</div>
				</div>
			</div>
		</div>

		<!-- Bootstrap JS and jQuery -->
		<script
			src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
		<script
			src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
		<script
			src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap4.min.js"></script>
		<script
			src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

		<!-- DataTables Initialization Script -->
		<script>
			$(document).ready(function() {
				$('#inventoryTable').DataTable();
			});
		</script>
	</div>

</body>

</html>