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

String UserID = (String) session.getAttribute("sessionID");
boolean itemUpdateSuccess = false, itemAddSuccess = false;;

out.println(UserID);

if (UserID == null) {
	response.sendRedirect("../login.jsp");
} else {

	PreparedStatement CurrentUser = conn.prepareStatement("select * from staff where staffid=?");
	CurrentUser.setString(1, UserID);
	ResultSet UserSession = CurrentUser.executeQuery();
	UserSession.next();
	out.println("welcome sir, " + UserSession.getString("staffname"));
}

// select * from purchase where PURCHASEID  = (select max(PURCHASEID) from PURCHASE);

if (request.getParameter("id") != null) {
	String staffid = UserID;
	int quantity;
	String inventoryid = request.getParameter("id");

	PreparedStatement checkTransaction = conn
	.prepareStatement("select * from purchase_item where complete is null and staffid=?");
	checkTransaction.setString(1, staffid);
	ResultSet RunCheckTransaction = checkTransaction.executeQuery();

	if (RunCheckTransaction.next()) {
		//kalau ada uncomplete transaction masuk dalam ni

		//get latest purchase id
		PreparedStatement getLatestPurchase = conn
		.prepareStatement("select * from purchase where PURCHASEID  = (select max(PURCHASEID) from PURCHASE)");
		ResultSet getPurchaseid = getLatestPurchase.executeQuery();
		getPurchaseid.next();
		int LatestPurchaseid = getPurchaseid.getInt("purchaseid");

		//get purchase row
		PreparedStatement getCurrentRow = conn
		.prepareStatement("select * from purchase_item where purchaseid=? and inventoryid=? and staffid=?");
		getCurrentRow.setInt(1, LatestPurchaseid);
		getCurrentRow.setString(2, inventoryid);
		getCurrentRow.setString(3, staffid);
		ResultSet RunGetCurrentRow = getCurrentRow.executeQuery();

		if (RunGetCurrentRow.next()) {
	quantity = RunGetCurrentRow.getInt("quantity");
	quantity = quantity + 1;
	//kalau inventory dah ada dalam row, just update quantity
	//update query untuk tambah 1
	PreparedStatement updateQuantity = conn.prepareStatement(
			"update purchase_item set quantity=? where purchaseid=? and inventoryid=? and complete is null and staffid=?");
	updateQuantity.setInt(1, quantity);
	updateQuantity.setInt(2, LatestPurchaseid);
	updateQuantity.setString(3, inventoryid);
	updateQuantity.setString(4, staffid);
	ResultSet updateQ = updateQuantity.executeQuery();
	System.out.println("masuk dah update tambah satu ni sebab dah memang ada dalam table");
	itemUpdateSuccess = true;

		} else {
	//kalau item takde lagi dalam cart tu

	//insert into bridge (masukkan item tu dulu dalam bridge)

	PreparedStatement addPurchaseItem = conn.prepareStatement(
			"insert into purchase_item(purchaseID, inventoryid, quantity, staffid) values(?,?,?,?)");

	addPurchaseItem.setInt(1, LatestPurchaseid);
	addPurchaseItem.setString(2, inventoryid);
	addPurchaseItem.setInt(3, 1);
	addPurchaseItem.setString(4, staffid);
	ResultSet addPurchaseItems = addPurchaseItem.executeQuery();
	System.out.println("masuk add bridge sebab item tak penah masuk lagi dalam table");
	itemAddSuccess = true;
		}

	} else {
		// buat purchase baru sebab semua transaction dah complete
		//insert into purchase (create new purchase transaction)

		PreparedStatement add = conn.prepareStatement(
		"insert into purchase(purchasedate, purchasetime) values(TRUNC(SYSDATE), TO_CHAR(SYSTIMESTAMP, 'HH24:MI'))");
		ResultSet addPurchase = add.executeQuery();

		//get latest purchase id
		PreparedStatement recentlyInsert = conn
		.prepareStatement("select * from purchase where PURCHASEID  = (select max(PURCHASEID) from PURCHASE)");
		ResultSet RunRecentlyInsert = recentlyInsert.executeQuery();
		RunRecentlyInsert.next();
		int RecentlyInsertID = RunRecentlyInsert.getInt("purchaseid");

		//insert into bridge
		PreparedStatement addPurchaseItem = conn.prepareStatement(
		"insert into purchase_item(purchaseID, inventoryid, quantity, staffid) values(?,?,?,?)");

		addPurchaseItem.setInt(1, RecentlyInsertID);
		addPurchaseItem.setString(2, inventoryid);
		addPurchaseItem.setInt(3, 1);
		addPurchaseItem.setString(4, staffid);
		ResultSet addPurchaseItems = addPurchaseItem.executeQuery();
		System.out.println(
		"masuk dah add new purchase and new bridge untuk buat transaction baru since semua transaction dah complete");
		itemAddSuccess = true;

	}

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

	<%
	if (itemAddSuccess) {
		// if color red : alert-success tukar jadi alert-danger
	%>
	<div class="alert alert-success alert-dismissible fade show"
		role="alert">
		<strong>Item added to cart!</strong> The item was added to cart
		<button type="button" class="close" data-dismiss="alert"
			aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
	</div>
	<%
	}
	%>

	<%
	if (itemUpdateSuccess) {
		// if color red : alert-success tukar jadi alert-danger
	%>
	<div class="alert alert-success alert-dismissible fade show"
		role="alert">
		<strong>Item updated in cart!</strong> The item quantity was updated
		in cart
		<button type="button" class="close" data-dismiss="alert"
			aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
	</div>
	<%
	}
	%>



	<!-- Page Content -->
	<div class="container mt-4">

		<div class="card card-body">

		

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

							<a
							href="listItemStaff.jsp?id=<%=execute.getString("inventoryid")%>"
							class="btn btn-success btn-sm">Add</a> <!-- View Item Modal -->
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

										</form>
									</div>
								</div>
							</div>



							</div> <!-- DELETE SECTION --> <script>
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
			<div class="row">
				<div class="col"></div>
				<div class="col text-center">
					<a href="../staffMenu.jsp" class="btn btn-warning m-4">Back</a>

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

</body>

</html>