<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ page
	import="java.util.*, java.io.*, java.sql.DriverManager, java.sql.Connection, java.sql.ResultSet, java.sql.SQLException, java.sql.Statement, java.sql.PreparedStatement"%>


<!DOCTYPE html>
<html lang="en">

<%
Connection conn = null;
Class.forName("oracle.jdbc.driver.OracleDriver");
String url = "jdbc:oracle:thin:@localhost:1521:xe";
String username = "INVENTORY_502";
String password = "system";
int newQuantity;
boolean updateSuccess = false, deleteFlag = false, completeFlag = false;
conn = DriverManager.getConnection(url, username, password);

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

// update quantity in the cart
if (request.getParameter("updateQuantity") != null) {
	String prodid = request.getParameter("invID");
	newQuantity = Integer.parseInt(request.getParameter("updateQuantity"));

	PreparedStatement update = conn
	.prepareStatement("update purchase_item set quantity=? where inventoryid=? and complete is null");
	update.setInt(1, newQuantity);
	update.setString(2, prodid);
	ResultSet updateQuant = update.executeQuery();
	updateSuccess = true;
}

//complete transaction

if (request.getParameter("completeID") != null) {
	// String purchaseid = request.getParameter("completeID");
	int purchaseid = Integer.parseInt(request.getParameter("completeID"));
	String complete = "complete";

	PreparedStatement completeTransaction = conn.prepareStatement(
	"update purchase_item set complete=? where  staffid=? and complete is null");
	completeTransaction.setString(1, complete);
	// completeTransaction.setInt(2, purchaseid);
	completeTransaction.setString(2, UserID);
	ResultSet completeResult = completeTransaction.executeQuery();
	completeFlag = true;
}

if (completeFlag) {
	response.sendRedirect("../staffMenu.jsp");
}

//delete item
if (request.getParameter("deleteID") != null) {
	int deleteid = Integer.parseInt(request.getParameter("deleteID"));

	PreparedStatement delete = conn
	.prepareStatement("delete from purchase_item where purchaseitemid=? and complete is null");
	delete.setInt(1, deleteid);
	ResultSet deleteitem = delete.executeQuery();
	deleteFlag = true;
}

//select incompleted transaction to be completed

PreparedStatement list = conn.prepareStatement(
		"select pi.purchaseitemid, inv.inventoryprice, pi.purchaseid ,inv.inventoryid, inv.inventoryname, pi.quantity from purchase_item pi join inventory inv on pi.inventoryid=inv.inventoryid  where pi.complete is null and pi.staffid=?");
list.setString(1, UserID);
ResultSet itemList = list.executeQuery();
%>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Shopping Cart</title>
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
			<a class="navbar-brand" href="#">Shopping Cart</a>
		</div>
	</nav>

	<%
	if (updateSuccess) {
		// if color red : alert-success tukar jadi alert-danger
	%>
	<div class="alert alert-success alert-dismissible fade show"
		role="alert">
		<strong>Item was Updated</strong> The item was updated in cart
		<button type="button" class="close" data-dismiss="alert"
			aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
	</div>
	<%
	}
	%>
	<%
	if (deleteFlag) {
		// if color red : alert-success tukar jadi alert-danger
	%>
	<div class="alert alert-success alert-dismissible fade show"
		role="alert">
		<strong>Item was deleted</strong> The item was updated in cart
		<button type="button" class="close" data-dismiss="alert"
			aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
	</div>
	<%
	}
	%>


	<div class="container mt-4">
		<div class="card card-body">

			<!-- Page Content -->
			<div class="container mt-4">
				<!-- Cart Items Table -->
				<table id="cartTable" class="table table-striped table-bordered"
					style="width: 100%">
					<thead class="thead-dark">
						<tr>
							<th>#</th>
							<th>Item Name</th>
							<th>Quantity</th>
							<th>Price</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
						<!-- Sample Cart Items (Replace this with dynamic cart items) -->
						<%
						int count = 1;
						String name, totalPriceDisplay, invid;
						double invPrice, total;
						double totalPrice = 0.0;
						int quant, piID, purchaseID;

						while (itemList.next()) {
							name = itemList.getString("inventoryname");
							quant = itemList.getInt("quantity");
							piID = itemList.getInt("purchaseitemid");
							invPrice = itemList.getDouble("inventoryprice");
							invid = itemList.getString("inventoryid");
							purchaseID = itemList.getInt("purchaseid");

							// double invPrice = itemList.getDouble("inv.inventoryprice");
							// int quant = Integer.parseInt(itemList.getString("pi.quantity"));
							total = invPrice * quant;
							totalPrice = totalPrice + total;
							totalPriceDisplay = String.format("%.2f", total);
						%>

						<tr>
							<td>
								<%
								out.println(count);
								%>
							</td>
							<td><%=name%></td>
							<td><%=quant%></td>
							<td><%=totalPriceDisplay%></td>
							<td>
								<button type="button" class="btn btn-primary btn-sm view-btn"
									data-toggle="modal" data-target="#viewItemModal<%=piID%>">View</button>
								<button type="button" class="btn btn-danger btn-sm delete-btn"
									data-toggle="modal" data-target="#deleteItemModal<%=piID%>">Remove</button>
							</td>
						</tr>

						<!-- View Item Modal -->
						<div class="modal fade" id="viewItemModal<%=piID%>" tabindex="-1"
							role="dialog" aria-labelledby="viewItemModalLabel"
							aria-hidden="true">
							<div class="modal-dialog" role="document">
								<div class="modal-content">
									<div class="modal-header">
										<h5 class="modal-title" id="viewItemModalLabel">View Item</h5>
										<button type="button" class="close" data-dismiss="modal"
											aria-label="Close">
											<span aria-hidden="true">&times;</span>
										</button>
									</div>
									<div class="modal-body">
										<!-- Product Information Display -->
										<form action="cart.jsp?invID=<%=invid%>" method="post">


											<div class="form-group">
												<label for="productName">Product Name</label> <input
													value="<%=name%>" type="text" class="form-control"
													id="productName" readonly>
											</div>
											<div class="form-group">
												<label for="productQuantity">Quantity</label> <input
													type="number" value="<%=quant%>" class="form-control"
													name="updateQuantity">
											</div>
											<!-- Other product details fields can be added here -->

											<!-- End of Product Information Display -->
									</div>
									<div class="modal-footer">
										<button type="submit" class="btn btn-primary">Update</button>
										<button type="button" class="btn btn-secondary"
											data-dismiss="modal">Close</button>

									</div>
									</form>
								</div>
							</div>
						</div>

						<!-- Delete Item Modal -->
						<div class="modal fade" id="deleteItemModal<%=piID%>"
							tabindex="-1" role="dialog"
							aria-labelledby="deleteItemModalLabel" aria-hidden="true">
							<div class="modal-dialog" role="document">
								<div class="modal-content">
									<div class="modal-header">
										<h5 class="modal-title" id="deleteItemModalLabel">Confirm
											Delete</h5>
										<button type="button" class="close" data-dismiss="modal"
											aria-label="Close">
											<span aria-hidden="true">&times;</span>
										</button>
									</div>
									<div class="modal-body">Are you sure you want to delete
										this item?</div>

									<form action="" method="get">
										<div class="modal-footer">
											<button type="submit" class="btn btn-danger">Remove</button>
											<input type="hidden" value="<%=piID%>" name="deleteID" />
											<button type="button" class="btn btn-secondary"
												data-dismiss="modal">Cancel</button>

										</div>
									</form>
								</div>
							</div>
						</div>

						<%
						count = count + 1;
						}
						%>
						<tr>
							<td colspan="4">Price</td>
							<td><b>RM<%
							String ttpd;
							out.println(ttpd = String.format("%.2f", totalPrice));
							%></b></td>
						</tr>
					</tfoot>
				</table>

				<div class="row">
					<div class="col"></div>
					<div class="col text-center">
						<a href="../staffMenu.jsp" class="btn btn-warning m-4">Back</a>

					</div>
					<div class="col"></div>
				</div>
				<div class="row">
					<div class="col"></div>
					<div class="col text-center">
						<button type="button" class="btn btn-primary" data-toggle="modal"
							data-target="#exampleModalCenter">Checkout</button>
						<!-- Modal -->
						<div class="modal fade" id="exampleModalCenter" tabindex="-1"
							role="dialog" aria-labelledby="exampleModalCenterTitle"
							aria-hidden="true">
							<div class="modal-dialog modal-dialog-centered" role="document">
								<div class="modal-content">
									<div class="modal-header">
										<h5 class="modal-title" id="exampleModalLongTitle">Checkout</h5>
										<button type="button" class="close" data-dismiss="modal"
											aria-label="Close">
											<span aria-hidden="true">&times;</span>
										</button>
									</div>
									<div class="modal-body">Are you sure to checkout?</div>
									<form action="" method="post">
										<div class="modal-footer">

											<%
											PreparedStatement getPurchaseId = conn
													.prepareStatement("select max(purchaseid) from purchase_item where staffid=? and complete is null");
											getPurchaseId.setString(1, UserID);
											ResultSet getPID = getPurchaseId.executeQuery();
											getPID.next();
											int purchid = getPID.getInt("max(purchaseid)");
											%>
											<input type="hidden" value="<%=purchid%>" name="completeID" />
											<button type="submit" class="btn btn-success">
												Checkout</button>
											<button type="button" class="btn btn-secondary"
												data-dismiss="modal">Close</button>

										</div>
									</form>
								</div>
							</div>

						</div>
						<div class="col"></div>
					</div>
					<div class="col"></div>
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
					$('#cartTable').DataTable({
						"searching" : false, // Disable search bar
						"paging" : false, // Disable pagination
						"info" : false
					// Disable information
					});

					// Handle view button click to show view item modal
					$('.view-btn').on('click', function() {
						var row = $(this).closest('tr');
						var itemName = row.find('td:eq(1)').text();
						var itemQuantity = row.find('td:eq(2)').text();

						$('#productName').val(itemName);
						$('#productQuantity').val(itemQuantity);

						$('#viewItemModal').modal('show');
					});

					// Handle delete button click to show delete confirmation modal
					$('.delete-btn').on('click', function() {
						$('#deleteItemModal').modal('show');
					});
				});
			</script>
		</div>
</body>

</html>
