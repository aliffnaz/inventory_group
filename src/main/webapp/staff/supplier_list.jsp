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

//delete supplier
if (request.getParameter("DeleteId") != null) {
	String DeleteId = request.getParameter("DeleteId");

	PreparedStatement delete = conn.prepareStatement("delete from supplier where supplierid=?");
	delete.setString(1, DeleteId);

	ResultSet delSupp = delete.executeQuery();
}

//update supplier
if (request.getParameter("updateSupp") != null) {
	String updatename = request.getParameter("updateName");
	String updatephone = request.getParameter("updatePhone");
	String updateaddress = request.getParameter("updateAddress");
	String updateId = request.getParameter("updateId");

	PreparedStatement update = conn.prepareStatement(
	"update supplier set suppliername=?,supplierphone=?,supplieraddress=? where supplierid=?");
	update.setString(1, updatename);
	update.setString(2, updatephone);
	update.setString(3, updateaddress);
	update.setString(4, updateId);
	ResultSet updating = update.executeQuery();

}

//add supplier
if (request.getParameter("supplierID") != null) {

	String id = request.getParameter("supplierID");
	String name = request.getParameter("supplierName");
	String phone = request.getParameter("supplierPhone");
	String address = request.getParameter("supplierAddress");

	PreparedStatement check = conn.prepareStatement("select supplierid from supplier where supplierid=?");
	check.setString(1, id);
	ResultSet checking = check.executeQuery();

	if (checking.next()) {
		out.println("the id already taken by someone else");
	} else {
		PreparedStatement addSupplier = conn.prepareStatement(
		"insert into supplier(supplierid, suppliername,supplieraddress,supplierphone) values(?,?,?,?)");
		addSupplier.setString(1, id);
		addSupplier.setString(2, name);
		addSupplier.setString(3, address);
		addSupplier.setString(4, phone);
		ResultSet addSupp = addSupplier.executeQuery();
	}

}

// call list item

PreparedStatement ps = conn.prepareStatement("select * from supplier order by supplierid asc");

ResultSet execute = ps.executeQuery();
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
				data-toggle="modal" data-target="#addSupplierModal">Add
				Supplier</button>

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

							<form action="" method="post">
								<div class="form-group">
									<label for="supplierID">Supplier ID</label> <input type="text"
										class="form-control" name="supplierID" required>
								</div>

								<div class="form-group">
									<label for="supplierName">Supplier Name</label> <input
										type="text" class="form-control" name="supplierName" required>
								</div>

								<div class="form-group">
									<label for="supplierPhone">Supplier Phone</label> <input
										type="text" class="form-control" name="supplierPhone" required>
								</div>

								<div class="form-group">
									<label for="supplierAddress">Supplier Address</label> <input
										type="text" class="form-control" name="supplierAddress"
										required>
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
						<th>Supplier ID</th>
						<th>Supplier Name</th>
						<th>Supplier Phone</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<!-- Sample Table Data (Replace this with dynamic data) -->

					<%
					while (execute.next()) {
					%>
					<tr>
						<td><%=execute.getString("SUPPLIERID")%></td>
						<td><%=execute.getString("suppliername")%></td>
						<td><%=execute.getString("supplierphone")%></td>
						<td>
							<form action="" method="get">
								<button type="button" class="btn btn-primary btn-sm view-btn"
									data-toggle="modal"
									data-target="#<%=execute.getString("SUPPLIERID")%>">View</button>

								<input type="submit" class="btn btn-danger btn-sm delete-btn"
									name="deleteSupp" value="Delete"> <input type="hidden"
									value="<%=execute.getString("SUPPLIERID")%>" name="DeleteId">
							</form>

						</td>
					</tr>

					<!-- View Supplier Modal -->
					<div class="modal fade" id="<%=execute.getString("SUPPLIERID")%>"
						tabindex="-1" role="dialog" aria-labelledby="viewItemModalLabel"
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

									<form action="" method="post">
										<div class="form-group">
											<label for="supplierID">Supplier ID:</label> <input
												type="text" class="form-control"
												value="<%=execute.getString("SUPPLIERID")%>"
												placeholder="<%=execute.getString("SUPPLIERID")%>"
												name="updateID" disabled readonly>
										</div>

										<div class="form-group">
											<label for="supplierID">Supplier Name:</label> <input
												type="text" class="form-control"
												value="<%=execute.getString("SUPPLIERNAME")%>"
												placeholder="<%=execute.getString("SUPPLIERNAME")%>"
												name="updateName">
										</div>

										<div class="form-group">
											<label for="supplierID">Supplier Phone:</label> <input
												type="text" class="form-control"
												value="<%=execute.getString("SUPPLIERPHONE")%>"
												placeholder="<%=execute.getString("SUPPLIERPHONE")%>"
												name="updatePhone">
										</div>

										<div class="form-group">
											<label for="supplierID">Supplier Address :</label> <input
												type="text" class="form-control"
												value="<%=execute.getString("SUPPLIERADDRESS")%>"
												placeholder="<%=execute.getString("SUPPLIERADDRESS")%>"
												name="updateAddress">
										</div>



										<!-- End of Item Information Display -->
								</div>
								<div class="modal-footer">

									<!-- Update button -->
									<input type="submit" class="btn btn-success"
										data-toggle="modal" data-target="" value="Update"
										name="updateSupp"> <input type="hidden"
										value="<%=execute.getString("supplierid")%>" name="updateId">
									<button type="button" class="btn btn-danger"
										data-dismiss="modal">Cancel</button>


									</form>
								</div>


							</div>
						</div>
					</div>
					<%
					}
					%>

					<!-- End of Sample Table Data -->
				</tbody>
			</table>





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