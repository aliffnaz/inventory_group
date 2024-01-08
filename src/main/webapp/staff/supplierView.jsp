`<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
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

String UserID = (String) session.getAttribute("sessionID");

if (UserID == null) {
	response.sendRedirect("../login.jsp");
} else {

	PreparedStatement CurrentUser = conn.prepareStatement("select * from staff where staffid=?");
	CurrentUser.setString(1, UserID);
	ResultSet UserSession = CurrentUser.executeQuery();
	UserSession.next();
	out.println("welcome sir, " + UserSession.getString("staffname"));
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

							<button type="button" class="btn btn-primary btn-sm view-btn"
								data-toggle="modal"
								data-target="#view<%=execute.getString("SUPPLIERID")%>">View</button>

							<!-- View Supplier Modal -->
							<div class="modal fade"
								id="view<%=execute.getString("SUPPLIERID")%>" tabindex="-1"
								role="dialog" aria-labelledby="viewItemModalLabel"
								aria-hidden="true">
								<!-- Modal content goes here -->
								<div class="modal-dialog" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h5 class="modal-title" id="viewItemModalLabel">Supplier
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
										
											</form>
										</div>


									</div>
								</div>
				



						</td>
					</tr>


					<%
					}
					%>

					<!-- End of Sample Table Data -->
				</tbody>
			</table>

			<div class="row">
				<div class="col"></div>
				<div class="col text-center">
					<a href="../managerMenu.jsp" class="btn btn-warning m-4">Back</a>

				</div>
				<div class="col"></div>
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
		
</body>

</html>