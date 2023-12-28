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

//ADD STAFF
if (request.getParameter("invId") != null) {
	String id = request.getParameter("invId");
	String name = request.getParameter("invName");
	String price = request.getParameter("invPrice");
	String brand = request.getParameter("invBrand");
	String balance = request.getParameter("invBalance");
	String invcat = request.getParameter("invCat");

	PreparedStatement inventoryAdd = conn.prepareStatement(
	"insert into inventory(inventoryid,inventoryname,inventoryprice,inventorybrand,inventorybalance, inventorytype) values(?,?,?,?,?,?)");
	inventoryAdd.setString(1, id);
	inventoryAdd.setString(2, name);
	inventoryAdd.setString(3, price);
	inventoryAdd.setString(4, brand);
	inventoryAdd.setString(5, balance);
	inventoryAdd.setString(6, invcat);
	ResultSet addInventory = inventoryAdd.executeQuery();

	if (request.getParameter("invCat") == "F") {

		String foodcat = request.getParameter("foodCat");
		String store = request.getParameter("foodStore");
		String expdate = request.getParameter("foodExp");
		String table = "food";
		String values = "(?,?,?)";
		String attribute = "(category,storecondition,expdate)";
		PreparedStatement tableAdd = conn.prepareStatement("insert into" + table + attribute + " values" + values);

		tableAdd.setString(1, foodcat);
		tableAdd.setString(2, store);
		tableAdd.setString(3, expdate);
		ResultSet addTableInventoryCategory = tableAdd.executeQuery();

	} else if (request.getParameter("invCat") == "S") {
		String statcat = request.getParameter("stationeryCat");
		String type = request.getParameter("stationeryType");
		String table = "stationery";
		String values = "(?,?)";
		String attribute = "(category,stationerytype)";
		PreparedStatement tableAdd = conn.prepareStatement("insert into" + table + attribute + " values" + values);
		tableAdd.setString(1, statcat);
		tableAdd.setString(2, type);
		ResultSet addTableInventoryCategory = tableAdd.executeQuery();

	} else if (request.getParameter("invCat") == "P") {
		String personalcat = request.getParameter("personalCat");
		String liquid = request.getParameter("personaLiquid");
		String expdate = request.getParameter("personalExp");
		String table = "personalcare";
		String values = "(?,?,?)";
		String attribute = "(category,liquid,expdate)";
		PreparedStatement tableAdd = conn.prepareStatement("insert into" + table + attribute + " values" + values);

		tableAdd.setString(1, personalcat);
		tableAdd.setString(2, liquid);
		tableAdd.setString(3, expdate);
		ResultSet addTableInventoryCategory = tableAdd.executeQuery();
	}

}

//UPDATE STAFF
// if (request.getParameter("UpdateStaff") != null) {
// 	System.out.println("masuk");
// 	String UpdStaffName = request.getParameter("Ustaffname");
// 	String UpdStaffIC = request.getParameter("Ustaffic");
// 	String UpdStaffPhone = request.getParameter("Ustaffphone");
// 	String UpdStaffRole = request.getParameter("Ustaffrole");
// 	String UpdStaffAge = request.getParameter("Ustaffage");
// 	String UpdStaffId = request.getParameter("Ustaffid");
// 	System.out.println(UpdStaffId);

// 	PreparedStatement upd = conn.prepareStatement(
// 	"update staff set staffname=?, staffphone=?, staffrole=?, staffage=?, staffic=? where staffid=?");
// 	upd.setString(1, UpdStaffName);
// 	upd.setString(2, UpdStaffPhone);
// 	upd.setString(3, UpdStaffRole);
// 	upd.setString(4, UpdStaffAge);
// 	upd.setString(5, UpdStaffIC);
// 	upd.setString(6, UpdStaffId);
// 	ResultSet UpdStaff = upd.executeQuery();
// }

//DELETE STAFF
// if (request.getParameter("DeleteId") != null) {
// 	String deleteId = request.getParameter("DeleteId");
// 	PreparedStatement deleteQuery = conn.prepareStatement("delete from staff where staffid=?");
// 	deleteQuery.setString(1, deleteId);
// 	ResultSet deleteStaff = deleteQuery.executeQuery();

// }

//LIST STAFF
String query = "select * from inventory";
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
<style>
/* Custom CSS */
/* Add your custom styles here */
</style>
<script type="text/javascript">
	function showInput(selectedValue) {
		var inputF = document.getElementById("inputF");
		var inputP = document.getElementById("inputP");
		var inputS = document.getElementById("inputS");

		if (selectedValue === "F") {
			inputF.style.display = "block";
			inputP.style.display = "none";
			inputS.style.display = "none";
		} else if (selectedValue === "P") {
			inputF.style.display = "none";
			inputP.style.display = "block";
			inputS.style.display = "none";
		} else if (selectedValue === "S") {
			inputF.style.display = "none";
			inputP.style.display = "none";
			inputS.style.display = "block";
		} else {
			inputF.style.display = "none";
			inputP.style.display = "none";
			inputS.style.display = "none";
		}
	}
</script>
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

			<!-- Add Item Button -->
			<button type="button" class="btn btn-primary mb-3 col-2"
				data-toggle="modal" data-target="#addItemModal">Add Item</button>





			<!-- Data Table -->
			<table id="inventoryTable" class="table table-striped table-bordered"
				style="width: 100%">
				<thead class="thead-dark">


					<tr>
						<th>#</th>
						<th>Id</th>
						<th>Name</th>
						<th>Price</th>
						<th>Type</th>
						<th>Brand</th>
						<th>Balance</th>
						<th>Action</th>
					</tr>

				</thead>
				<tbody>
					<!-- Sample Table Data (Replace this with dynamic data) -->
					<%
					while (execute.next()) {
						int i = 1;
					%>
					<tr>
						<td>
							<%
							out.println(i);
							%>
						</td>
						<td><%=execute.getString("inventoryid")%></td>
						<td><%=execute.getString("inventoryname")%></td>
						<td><%=execute.getString("inventoryprice")%></td>
						<td><%=execute.getString("inventorytype")%></td>
						<td><%=execute.getString("inventorybrand")%></td>
						<td><%=execute.getString("inventorybalance")%></td>
						<td>


							<button type="button" class="btn btn-primary btn-sm view-btn"
								data-toggle="modal"
								data-target="#viewItemModal<%=execute.getString("inventoryid")%>">View</button>
							<button type="button" class="btn btn-danger btn-sm delete-btn">Delete</button>
						</td>
					</tr>

					<!-- View Item Modal -->
					<div class="modal fade"
						id="viewItemModal<%=execute.getString("inventoryid")%>"
						tabindex="-1" role="dialog" aria-labelledby="viewItemModalLabel"
						aria-hidden="true">
						<!-- Modal content goes here -->
						<div class="modal-dialog" role="document">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title" id="viewItemModalLabel">Inventory
										Information</h5>
									<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
								<div class="modal-body">
									<!-- Item Information Display (Replace this with your actual item information) -->
									<div class="modal-body">

										<form>

											<div class="form-group">
												<label>Inventory ID</label> <input type="text"
													class="form-control" id=""
													value="<%=execute.getString("inventoryid")%>" readonly>
											</div>

											<div class="form-group">
												<label>Inventory Name</label> <input type="text"
													class="form-control" id=""
													value="<%=execute.getString("inventoryname")%>">
											</div>

											<div class="form-group">
												<label>Inventory Price</label> <input type="text"
													class="form-control" id=""
													value="<%=execute.getString("inventoryprice")%>">
											</div>

											<div class="form-group">
												<label>Inventory Type</label> <input type="text"
													class="form-control" id=""
													value="<%=execute.getString("inventorytype")%>">
											</div>

											<div class="form-group">
												<label>Inventory Brand</label> <input type="text"
													class="form-control" id=""
													value="<%=execute.getString("inventorybrand")%>">
											</div>

											<div class="form-group">
												<label>Inventory Balance</label> <input type="text"
													class="form-control" id=""
													value="<%=execute.getString("inventorybalance")%>">
											</div>

											<!-- Other editable fields -->

											<button type="submit" class="btn btn-primary">Update
												Item</button>

										</form>

									</div>
									<!-- End of Item Information Display -->
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary"
										data-dismiss="modal">Back</button>
									<!-- Update button -->
									<button type="button" class="btn btn-primary btn-sm"
										data-toggle="modal" data-target="#updateItemModal">
										Update</button>
									<!-- Update Staff Modal -->




								</div>
							</div>
						</div>
					</div>

					<%
					i++;
					}
					%>
					<!-- End of Sample Table Data -->
				</tbody>
			</table>

		</div>

	</div>

	<!-- Add Item Modal -->
	<div class="modal fade" id="addItemModal" tabindex="-1" role="dialog"
		aria-labelledby="addItemModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">


				<div class="modal-header" class="container mt-4">
					<h5 class="modal-title" id="addItemModalLabel">Add New Item</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>

				<div class="modal-body">

					<form action="" method="post">
						<div class="form-group">
							<label>Inventory ID</label> <input type="text"
								class="form-control" id="" name="invId">
						</div>

						<div class="form-group">
							<label>Inventory Name</label> <input type="text"
								class="form-control" id="" name="invName">
						</div>

						<div class="form-group">
							<label>Inventory Price</label> <input type="text"
								class="form-control" id="" name="invPrice">
						</div>

						<div class="form-group">
							<label>Inventory Brand</label> <input type="text"
								class="form-control" id="" name="invBrand">
						</div>

						<div class="form-group">
							<label>Inventory Balance</label> <input type="text"
								class="form-control" id="" name="invBalance">
						</div>
						<div class="form-group">
							<label>Category</label> <select id="dropdown"
								class="form-control" onchange="showInput(this.value)"
								name="invCat">
								<option value="">Select an option</option>
								<option value="F">Food</option>
								<option value="P">Personal Care</option>
								<option value="S">Stationery</option>
							</select> <br>
						</div>

						<div class="form-group">
							<div id="inputF" style="display: none;">
								<%-- Inventory ID<input type="text" class="form-control" name=""> --%>
								<br> Category<input type="text" class="form-control"
									name="foodCat"> <br> Store Condition<input
									type="text" class="form-control" name="foodStore"> <br>
								Expired Date<input type="date" class="form-control"
									name="foodExp"> <br>
							</div>


							<div class="form-group">
								<div id="inputP" style="display: none;">
									<%-- Inventory ID <input type="text" class="form-control" name=""> --%>
									<br> Category <input type="text" class="form-control"
										name="personalCat"> <br> Liquid <input
										type="text" class="form-control" name="personalLiquid">
									<br> Expired Date <input type="date" class="form-control"
										name="personalExp"> <br>
								</div>


								<div class="form-group">
									<div id="inputS" style="display: none;">
										<%-- Inventory ID<input type="text" class="form-control" name=""> --%>
										<br> Category<input type="text" class="form-control"
											name="stationeryCat"> <br> Stationery Type<input
											type="text" class="form-control" name="stationeryType">
										<br>
									</div>


									<!-- Other input fields -->

									<button type="submit" class="btn btn-primary">Submit</button>
					</form>
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

</body>

</html>

