<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ page
	import="java.util.*, java.io.*, java.sql.DriverManager, java.sql.Connection, java.sql.ResultSet, java.sql.SQLException, java.sql.Statement, java.sql.PreparedStatement"%>

<%
Connection conn = null;

String id = request.getParameter("staffID");
String ic = request.getParameter("staffIC");
String phone = request.getParameter("staffPhone");
String role = request.getParameter("staffRole");
String age = request.getParameter("staffAge");

if (id != null) {
	//Class.forName("oracle.jdbc.driver.OracleDriver");
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

		<div class="card card-body">
			<!-- Register Supplier Button -->
			<button type="button" class="btn btn-primary mb-3 col-2"
				data-toggle="modal" data-target="#addSupplierModal">
				Add Supplier</button>

			<!-- Register Supplier Modal -->
			<div class="modal fade" id="addSupplierModal" tabindex="-1"
				role="dialog" aria-labelledby="addSupplierModalLabel"
				aria-hidden="true">
				<div class="modal-dialog" role="document">
					<div class="modal-content">

						<div class="modal-header">
							<h5 class="modal-title" id="addSupplierModalLabel">Register
								New Supplier</h5>
							<button type="button" class="close" data-dismiss="modal"
								aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>

						<div class="modal-body">

							<form>
								<div class="form-group">
									<label for="supplierID">Supplier ID</label> <input type="text"
										class="form-control" id="supplierID" required>
								</div>

								<div class="form-group">
									<label for="supplierName">Supplier Name</label> <input
										type="text" class="form-control" id="supplierName" required>
								</div>

								<div class="form-group">
									<label for="supplierPhone">Supplier Phone</label> <input
										type="text" class="form-control" id="supplierPhone" required>
								</div>

								<button type="submit" class="btn btn-primary">Submit</button>
							</form>

						</div>

					</div>
				</div>
			</div>

			<!-- Data Table -->
			<table id="inventoryTable" class="table table-striped table-bordered"
				style="width: 100%">
				<thead class="thead-dark">
					<tr>
						<th>#</th>
						<th>Supplier ID</th>
						<th>Supplier Name</th>
						<th>Supplier Phone</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<!-- Sample Table Data (Replace this with dynamic data) -->
					<tr>
						<td>1</td>
						<td>SP01</td>
						<td>Man</td>
						<td>0102345678</td>
						<td>
							<button type="button" class="btn btn-primary btn-sm view-btn"
								data-toggle="modal" data-target="#viewItemModal">View</button>
							<button type="button" class="btn btn-danger btn-sm delete-btn">Delete</button>
						</td>
					</tr>
					<tr>
						<td>2</td>
						<td>SP02</td>
						<td>Jamal</td>
						<td>0112345678</td>
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
			<div class="modal fade" id="viewItemModal" tabindex="-1"
				role="dialog" aria-labelledby="viewItemModalLabel"
				aria-hidden="true">
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
								Supplier ID: <span id="supplierID"></span>
							</p>
							<p>
								Supplier Name: <span id="supplierName"></span>
							</p>
							<p>
								Supplier Phone: <span id="supplierPhone"></span>
							</p>
							<!-- End of Item Information Display -->
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-dismiss="modal">Back</button>
							<!-- Update button -->
							<button type="button" class="btn btn-primary btn-sm"
								data-toggle="modal" data-target="#updateSupplierModal">
								Update</button>

							<!-- Update Supplier Modal -->
							<div class="modal fade" id="updateSupplierModal" tabindex="-1"
								role="dialog" aria-labelledby="updateSupplierModalLabel"
								aria-hidden="true">
								<div class="modal-dialog" role="document">
									<div class="modal-content">

										<div class="modal-header">
											<h5 class="modal-title" id="updateSupplierModalLabel">Update
												Supplier Details</h5>
											<button type="button" class="close" data-dismiss="modal"
												aria-label="Close">
												<span aria-hidden="true">&times;</span>
											</button>
										</div>

										<div class="modal-body">

											<form>

												<div class="form-group">
													<label for="supplierID">Supplier ID</label> <input
														type="text" class="form-control" id="supplierID"
														value="SP01" disabled>
												</div>

												<div class="form-group">
													<label for="supplierName">Supplier Name</label> <input
														type="text" class="form-control" id="supplierName"
														value="Man">
												</div>

												<div class="form-group">
													<label for="supplierPhone">Supplier Phone</label> <input
														type="text" class="form-control" id="supplierPhone"
														value="0102345678">
												</div>

												<button type="submit" class="btn btn-primary">Update
													Supplier</button>

											</form>

										</div>

									</div>
								</div>
							</div>
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
	</div>
</body>

</html>
