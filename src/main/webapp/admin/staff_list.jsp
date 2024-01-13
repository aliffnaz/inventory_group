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
boolean addSuccess = false;
boolean updateSuccess = false;
boolean deleteSuccess = false;

String UserID = (String) session.getAttribute("sessionID");

if (UserID == null) {
	response.sendRedirect("../login.jsp");
} else {

	PreparedStatement CurrentUser = conn.prepareStatement("select * from staff where staffid=?");
	CurrentUser.setString(1, UserID);
	ResultSet UserSession = CurrentUser.executeQuery();
	UserSession.next();
	//out.println("welcome sir, " + UserSession.getString("staffname"));
}

//ADD STAFF
if (request.getParameter("staffID") != null) {

	String id = request.getParameter("staffID");
	String name = request.getParameter("staffName");
	String ic = request.getParameter("staffIC");
	String phone = request.getParameter("staffPhone");
	String role = request.getParameter("staffRole");
	String age = request.getParameter("staffAge");

	PreparedStatement checking = conn.prepareStatement("select * from staff where staffid=?");
	checking.setString(1, id);
	ResultSet check = checking.executeQuery();
	if (check.next()) {
		out.println("the staff id is already in the list !");

	} else {

		PreparedStatement staffAdd = conn.prepareStatement(
		"insert into staff(staffID,staffIC,staffPhone,staffRole,staffAge,staffname) values(?,?,?,?,?,?)");
		staffAdd.setString(1, id);
		staffAdd.setString(2, ic);
		staffAdd.setString(3, phone);
		staffAdd.setString(4, role);
		staffAdd.setString(5, age);
		staffAdd.setString(6, name);
		ResultSet addStaff = staffAdd.executeQuery();

		if (addStaff == null) {
	out.println("not working man");
		}
	}
	addSuccess = true;
}

//UPDATE STAFF
if (request.getParameter("UpdateStaff") != null) {
	System.out.println("masuk");
	String UpdStaffName = request.getParameter("Ustaffname");
	String UpdStaffIC = request.getParameter("Ustaffic");
	String UpdStaffPhone = request.getParameter("Ustaffphone");
	String UpdStaffRole = request.getParameter("Ustaffrole");
	String UpdStaffAge = request.getParameter("Ustaffage");
	String UpdStaffId = request.getParameter("Ustaffid");
	System.out.println(UpdStaffId);

	PreparedStatement upd = conn.prepareStatement(
	"update staff set staffname=?, staffphone=?, staffrole=?, staffage=?, staffic=? where staffid=?");
	upd.setString(1, UpdStaffName);
	upd.setString(2, UpdStaffPhone);
	upd.setString(3, UpdStaffRole);
	upd.setString(4, UpdStaffAge);
	upd.setString(5, UpdStaffIC);
	upd.setString(6, UpdStaffId);
	ResultSet UpdStaff = upd.executeQuery();

	updateSuccess = true;
}

//DELETE STAFF
if (request.getParameter("DeleteId") != null) {
	String deleteId = request.getParameter("DeleteId");
	PreparedStatement deleteQuery = conn.prepareStatement("delete from staff where staffid=?");
	deleteQuery.setString(1, deleteId);
	ResultSet deleteStaff = deleteQuery.executeQuery();

	deleteSuccess = true;

}

//LIST STAFF
String query = "select * from staff";
PreparedStatement list = conn.prepareStatement(query);
ResultSet execute = list.executeQuery();
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

	
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>



	<!-- Navbar -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container">
			<a class="navbar-brand" href="../managerMenu.jsp">Staff List</a>
		</div>
	</nav>

	<%
	if (addSuccess) {
		// if color red : alert-success tukar jadi alert-danger
	%>
	<div class="alert alert-success alert-dismissible fade show"
		role="alert">
		<strong>Supplier Added !</strong> The supplier added into list
		<button type="button" class="close" data-dismiss="alert"
			aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
	</div>
	<%
	} 
	%>

	<%
	if (updateSuccess) {
		// if color red : alert-success tukar jadi alert-danger
	%>
	<div class="alert alert-success alert-dismissible fade show"
		role="alert">
		<strong>Supplier Updated !</strong> The supplier list below was updated
		<button type="button" class="close" data-dismiss="alert"
			aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
	</div>

	<%
	} 
	%>

	<%
	if (deleteSuccess) {
		// if color red : alert-success tukar jadi alert-danger
	%>
	<div class="alert alert-success alert-dismissible fade show"
		role="alert">
		<strong>Supplier Deleted !</strong> The supplier list below was deleted
		<button type="button" class="close" data-dismiss="alert"
			aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
	</div>
	<%
	}
	%>


	<!-- Page Content -->
	<div class="container mt-4 mb-4">

		<div class="card card-body">

			<!-- Register Staff Button -->
			<button type="button" class="btn btn-primary mb-3 col-1"
				data-toggle="modal" data-target="#addStaffModal">Register</button>

			<!-- Register Staff Modal -->
			<div class="modal fade" id="addStaffModal" tabindex="-1"
				role="dialog" aria-labelledby="addStaffModalLabel"
				aria-hidden="true">
				<div class="modal-dialog" role="document">
					<div class="modal-content">


						<div class="modal-header" class="container mt-4">
							<h5 class="modal-title" id="addStaffModalLabel">Register New
								Staff</h5>
							<button type="button" class="close" data-dismiss="modal"
								aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>

						<div class="modal-body p-3">

							<form action="" method="post">
								<div class="form-group">
									<label>Staff ID</label> <input type="text" class="form-control"
										name="staffID">
								</div>

								<div class="form-group">
									<label>Staff Name</label> <input type="text"
										class="form-control" name="staffName">
								</div>

								<div class="form-group">
									<label>Staff IC</label> <input type="text" class="form-control"
										name="staffIC">
								</div>

								<div class="form-group">
									<label>Staff Phone</label> <input type="text"
										class="form-control" name="staffPhone">
								</div>

								<div class="form-group">
									<label>Staff Role</label> <input type="text"
										class="form-control" name="staffRole">
								</div>

								<div class="form-group">
									<label>Staff Age</label> <input type="text"
										class="form-control" name="staffAge">
								</div>

								<!-- Other input fields -->

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
						<th>Staff ID</th>
						<th>Staff Name</th>
						<th>Staff IC</th>
						<th>Staff Phone</th>
						<th>Staff Role</th>
						<th>Staff Age</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<!-- Sample Table Data (Replace this with dynamic data) -->
					<%
					while (execute.next()) {
					%>
					<tr>
						<td><%=execute.getString("staffid")%></td>
						<td><%=execute.getString("staffname")%></td>
						<td><%=execute.getString("staffic")%></td>
						<td><%=execute.getString("staffphone")%></td>
						<td><%=execute.getString("staffrole")%></td>
						<td><%=execute.getString("staffage")%></td>
						<td>
							<!-- VIEW SECTION -->
							<button type="button" class="btn btn-primary btn-sm"
								data-toggle="modal"
								data-target="#updateStaffModal<%=execute.getString("staffid")%>">
								View</button> <!-- Update Staff Modal -->

							<div class="modal fade"
								id="updateStaffModal<%=execute.getString("staffid")%>"
								tabindex="-1" role="dialog"
								aria-labelledby="updateStaffModalLabel" aria-hidden="true">
								<div class="modal-dialog" role="document">
									<div class="modal-content">

										<div class="modal-header">
											<h5 class="modal-title" id="updateStaffModalLabel">Update
												Staff Details</h5>
											<button type="button" class="close" data-dismiss="modal"
												aria-label="Close">
												<span aria-hidden="true">&times;</span>
											</button>
										</div>

										<div class="modal-body">

											<form action="" method="post">

												<div class="form-group">
													<label>Staff ID</label> <input type="text"
														class="form-control" name="Ustaffid"
														value="<%=execute.getString("staffid")%>"
														placeholder="<%=execute.getString("staffid")%>" readonly>
												</div>

												<div class="form-group">
													<label>Staff Name</label> <input type="text"
														class="form-control" name="Ustaffname"
														value="<%=execute.getString("staffname")%>"
														placeholder="<%=execute.getString("staffname")%>">
												</div>

												<div class="form-group">
													<label>Staff IC</label> <input type="text"
														class="form-control" name="Ustaffic"
														value="<%=execute.getString("staffic")%>"
														placeholder="<%=execute.getString("staffic")%>">
												</div>

												<div class="form-group">
													<label>Staff Phone</label> <input type="text"
														class="form-control" name="Ustaffphone"
														value="<%=execute.getString("staffphone")%>"
														placeholder="<%=execute.getString("staffphone")%>">
												</div>

												<div class="form-group">
													<label>Staff Role</label> <input type="text"
														class="form-control" name="Ustaffrole"
														value="<%=execute.getString("staffrole")%>"
														placeholder="<%=execute.getString("staffrole")%>">
												</div>

												<div class="form-group">
													<label>Staff Age</label> <input type="text"
														class="form-control" name="Ustaffage"
														value="<%=execute.getString("staffage")%>"
														placeholder="<%=execute.getString("staffage")%>">
												</div>

												<!-- Other editable fields -->
												<input type="hidden" name="UpdateStaff" value="update">
												<input type="submit" class="btn btn-primary"
													name="updatebtn" value="Update">

											</form>

										</div>

									</div>
								</div>
							</div> <!-- END VIEW SECTION --> <!-- DELETE SECTION -->
							<button type="button" class="btn btn-danger btn-sm"
								data-toggle="modal"
								data-target="#deleteModal<%=execute.getString("staffid")%>">Delete</button>

							<div class="modal fade"
								id="deleteModal<%=execute.getString("staffid")%>" tabindex="-1"
								role="dialog" aria-labelledby="deleteModalLabel"
								aria-hidden="true">
								<div class="modal-dialog" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h5 class="modal-title" id="deleteModalLabel">Confirm
												Deletion</h5>
											<button type="button" class="close" data-dismiss="modal"
												aria-label="Close">
												<span aria-hidden="true">&times;</span>
											</button>
										</div>
										<div class="modal-body">Are you sure you want to delete
											this Staff?</div>
										<div class="modal-footer">
											<form action="" method="get">

												<input type="hidden"
													value="<%=execute.getString("staffid")%>" name="DeleteId">
												<input type="submit" class="btn btn-danger delete-btn"
													name="deleteSupp" value="Delete">

												<button type="button" class="btn btn-secondary"
													data-dismiss="modal">Cancel</button>




											</form>
										</div>
									</div>
								</div>
							</div> <script>
								function deleteItem() {
									// Perform deletion logic here
									// This is where you would delete the item using JavaScript, AJAX, or any backend logic
									// For demonstration purposes, an alert is shown
									alert("Item deleted!");

									// Close the modal after deletion
									$('#deleteModal').modal('hide');
								}
							</script> <!-- END DELETE SECTION -->
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
					<a href="../managerMenu.jsp" class="btn btn-warning m-4"> <i
						class="bi bi-arrow-left-circle"></i> Back
					</a>
				</div>
				<div class="col"></div>
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
