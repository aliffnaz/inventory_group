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

//ADD INVENTORY
if (request.getParameter("invId") != null) {
	String id = request.getParameter("invId");
	String name = request.getParameter("invName");
	float price = Float.parseFloat(request.getParameter("invPrice"));
	String brand = request.getParameter("invBrand");
	int balance = Integer.parseInt(request.getParameter("invBalance"));
	String invcat = request.getParameter("invCat");

	PreparedStatement inventoryAdd = conn.prepareStatement(
	"insert into inventory(inventoryid,inventoryname,inventoryprice,inventorybrand,inventorybalance, inventorytype) values(?,?,?,?,?,?)");
	inventoryAdd.setString(1, id);
	inventoryAdd.setString(2, name);
	inventoryAdd.setFloat(3, price);
	inventoryAdd.setString(4, brand);
	inventoryAdd.setInt(5, balance);
	inventoryAdd.setString(6, invcat);
	ResultSet addInventory = inventoryAdd.executeQuery();

	if (invcat != null && invcat.equalsIgnoreCase("F")) {

		String foodcat = request.getParameter("foodCat");
		String store = request.getParameter("foodStore");
		String expdate = request.getParameter("foodExp");

		PreparedStatement tableAdd = conn
		.prepareStatement("insert into food(inventoryid, category, storecondition, expdate) values(?,?,?,?)");
		tableAdd.setString(1, id);
		tableAdd.setString(2, foodcat);
		tableAdd.setString(3, store);
		tableAdd.setString(4, expdate);
		ResultSet addTableInventoryCategory = tableAdd.executeQuery();
		System.out.println("success id = " + id);

	} else if (invcat != null && invcat.equalsIgnoreCase("S")) {
		String statcat = request.getParameter("stationeryCat");
		String type = request.getParameter("stationeryType");
		PreparedStatement tableAdd = conn
		.prepareStatement("insert into stationery(inventoryid, category, stationerytype) values(?,?,?)");
		tableAdd.setString(1, id);
		tableAdd.setString(2, statcat);
		tableAdd.setString(3, type);
		ResultSet addTableInventoryCategory = tableAdd.executeQuery();
		System.out.println("success id = " + id);

	} else if (invcat != null && invcat.equalsIgnoreCase("P")) {
		String personalcat = request.getParameter("personalCat");
		String liquid = request.getParameter("personalLiquid");
		String expdate = request.getParameter("personalExp");

		PreparedStatement tableAdd = conn
		.prepareStatement("insert into personalcare(inventoryid,category,liquid,expdate) values(?,?,?,?)");
		tableAdd.setString(1, id);
		tableAdd.setString(2, personalcat);
		tableAdd.setString(3, liquid);
		tableAdd.setString(4, expdate);
		ResultSet addTableInventoryCategory = tableAdd.executeQuery();
		System.out.println("success id = " + id);
	}

}

//UPDATE INVENTORY
if (request.getParameter("updId") != null) {
	String updName = request.getParameter("updName");
	String updPrice = request.getParameter("updPrice");
	String updBrand = request.getParameter("updBrand");
	String updBalance = request.getParameter("updBalance");
	String updId = request.getParameter("updId");
	// String UpdStaffId = request.getParameter("Ustaffid");
	System.out.println(updId);

	PreparedStatement upd = conn.prepareStatement(
	"update inventory set inventoryname=?, inventoryprice=?, inventorybrand=?, inventorybalance=? where inventoryid=?");
	upd.setString(1, updName);
	upd.setString(2, updPrice);
	upd.setString(3, updBrand);
	upd.setString(4, updBalance);
	upd.setString(5, updId);
	ResultSet updInv = upd.executeQuery();

	if (request.getParameter("updType") != null && request.getParameter("updType").equalsIgnoreCase("f")) {

		String updCat = request.getParameter("updfoodcategory");
		String updCondition = request.getParameter("updcondition");
		String updExp = request.getParameter("updexpdate");

		PreparedStatement updFood = conn.prepareStatement(
		"update food set category=?, storecondition=?, expdate=? where inventoryid=?");
		updFood.setString(1, updCat);
		updFood.setString(2, updCondition);
		updFood.setString(3, updExp);
		updFood.setString(4, updId);
		ResultSet updInvFood = updFood.executeQuery();

	} else if (request.getParameter("updType") != null && request.getParameter("updType").equalsIgnoreCase("p")) {

		String updCat = request.getParameter("updPersonalcat");
		String updLiquid = request.getParameter("updLiquid");
		String updExp = request.getParameter("updexpdate");

		PreparedStatement updPersonalCare = conn
		.prepareStatement("update personalcare set category=?, liquid=?, expdate=? where inventoryid=?");
		updPersonalCare.setString(1, updCat);
		updPersonalCare.setString(2, updLiquid);
		updPersonalCare.setString(3, updExp);
		updPersonalCare.setString(4, updId);
		ResultSet updInvPersonalCare = updPersonalCare.executeQuery();

	} else if (request.getParameter("updType") != null && request.getParameter("updType").equalsIgnoreCase("s")) {

		String updCat = request.getParameter("updstationeryCat");
		String updType = request.getParameter("updStationeryType");

		PreparedStatement updStationery = conn
		.prepareStatement("update food set category=?, stationerytype=? where inventoryid=?");
		updStationery.setString(1, updCat);
		updStationery.setString(2, updType);
		updStationery.setString(3, updId);
		ResultSet updInvStationery = updStationery.executeQuery();
	}

}

//DELETE INEVNTORY
if (request.getParameter("deleteInv") != null) {

	String deleteId = request.getParameter("DeleteId");

	PreparedStatement deleteQuery2 = conn.prepareStatement("delete from food where inventoryid=?");
	deleteQuery2.setString(1, deleteId);
	ResultSet deleteInv2 = deleteQuery2.executeQuery();

	PreparedStatement deleteQuery3 = conn.prepareStatement("delete from personalcare where inventoryid=?");
	deleteQuery3.setString(1, deleteId);
	ResultSet deleteInv3 = deleteQuery3.executeQuery();

	PreparedStatement deleteQuery4 = conn.prepareStatement("delete from stationery where inventoryid=?");
	deleteQuery4.setString(1, deleteId);
	ResultSet deleteInv4 = deleteQuery4.executeQuery();

	PreparedStatement deleteQuery1 = conn.prepareStatement("delete from inventory where inventoryid=?");
	deleteQuery1.setString(1, deleteId);
	ResultSet deleteInv1 = deleteQuery1.executeQuery();
}

//LIST INVENTORY
String query = "select * from inventory order by inventorytype";
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
				data-toggle="modal" data-target="#addItemModal">Add</button>

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

							<!-- View Item Modal -->
							<div class="modal fade"
								id="viewItemModal<%=execute.getString("inventoryid")%>"
								tabindex="-1" role="dialog" aria-labelledby="viewItemModalLabel"
								aria-hidden="true">
								<!-- Modal content goes here -->
								<div class="modal-dialog modal-lg" role="document">
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

												<form action="" method="post">

													<div class="form-group">
														<label>Inventory ID</label> <input type="text"
															class="form-control" name="updId"
															value="<%=execute.getString("inventoryid")%>" readonly>
													</div>

													<div class="form-group">
														<label>Inventory Name</label> <input type="text"
															class="form-control" name="updName"
															value="<%=execute.getString("inventoryname")%>">
													</div>

													<div class="form-group">
														<label>Inventory Price</label> <input type="text"
															class="form-control" name="updPrice"
															value="<%=execute.getString("inventoryprice")%>">
													</div>

													<div class="form-group">
														<label>Inventory Type</label> <input type="text"
															class="form-control" name="updType"
															value="<%=execute.getString("inventorytype")%>" readonly>
													</div>

													<div class="form-group">
														<label>Inventory Brand</label> <input type="text"
															class="form-control" name="updBrand"
															value="<%=execute.getString("inventorybrand")%>">
													</div>

													<div class="form-group">
														<label>Inventory Balance</label> <input type="text"
															class="form-control" name="updBalance"
															value="<%=execute.getString("inventorybalance")%>">
													</div>




													<%
													String idcat = execute.getString("inventoryid");
													String cat = execute.getString("inventorytype");

													if (cat.equalsIgnoreCase("f")) {

														PreparedStatement food = conn.prepareStatement("select * from food where inventoryid=?");
														food.setString(1, idcat);
														ResultSet foodSelect = food.executeQuery();
														while (foodSelect.next()) {
													%>
													<div class="form-group">
														<label>Food Category </label> <input type="text"
															class="form-control" name="updfoodcategory"
															value="<%=foodSelect.getString("category")%>">
													</div>

													<div class="form-group">
														<label>Store Condition</label> <input type="text"
															class="form-control" name="updcondition"
															value="<%=foodSelect.getString("storecondition")%>">
													</div>

													<div class="form-group">
														<label>Expired Date</label> <input type="text"
															class="form-control" name="updexpdate"
															value="<%=foodSelect.getString("expdate")%>">
													</div>
													<%
													}
													}
													%>
													<%
													if (cat.equalsIgnoreCase("p")) {

														PreparedStatement personal = conn.prepareStatement("select * from personalcare where inventoryid=?");
														personal.setString(1, idcat);
														ResultSet personalSelect = personal.executeQuery();
														while (personalSelect.next()) {
													%>
													<div class="form-group">
														<label>Personal Care Category</label> <input type="text"
															class="form-control" name="updPersonalcat"
															value="<%=personalSelect.getString("category")%>">
													</div>

													<div class="form-group">
														<label>Liquid</label> <input type="text"
															class="form-control" name="updLiquid"
															value="<%=personalSelect.getString("liquid")%>">
													</div>

													<div class="form-group">
														<label>Expired Date</label> <input type="text"
															class="form-control" name="updexpdate"
															value="<%=personalSelect.getString("expdate")%>">
													</div>
													<%
													}
													}
													%>
													<%
													if (cat.equalsIgnoreCase("s")) {

														PreparedStatement stationery = conn.prepareStatement("select * from stationery where inventoryid=?");
														stationery.setString(1, idcat);
														ResultSet stationerySelect = stationery.executeQuery();
														while (stationerySelect.next()) {
													%>
													<div class="form-group">
														<label>Stationery Category </label> <input type="text"
															class="form-control" name="updstationeryCat"
															value="<%=stationerySelect.getString("category")%>">
													</div>

													<div class="form-group">
														<label>Stationery Type</label> <input type="text"
															class="form-control" name="updStationeryType"
															value="<%=stationerySelect.getString("stationerytype")%>">
													</div>
													<%
													}
													}
													%>
												
											</div>
											<!-- End of Item Information Display -->
										</div>
										<div class="modal-footer">
											<!-- Update button -->
											<button type="submit" class="btn btn-warning">
												Update</button>
											<!-- Update Staff Modal -->


											<button type="button" class="btn btn-danger"
												data-dismiss="modal">Back</button>
											</form>
										</div>
									</div>
								</div>



							</div> <!-- DELETE SECTION -->
							<button type="button" class="btn btn-danger btn-sm"
								data-toggle="modal"
								data-target="#deleteModal<%=execute.getString("inventoryid")%>">Delete</button>

							<div class="modal fade"
								id="deleteModal<%=execute.getString("inventoryid")%>"
								tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel"
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
											this inventory?</div>
										<div class="modal-footer">
											<form action="" method="get">

												<input type="hidden"
													value="<%=execute.getString("inventoryid")%>"
													name="DeleteId"> <input type="submit"
													class="btn btn-danger delete-btn" name="deleteInv"
													value="Delete">

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
					i = i + 1;
					%>
					<%
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
					<h5 class="modal-title" id="addItemModalLabel">Add New
						Inventory</h5>
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

