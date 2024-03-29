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
	String staffid = UserID;
	int purchaseIDLatest = Integer.parseInt(request.getParameter("completeID"));

	// String purchaseid = request.getParameter("completeID");
	int purchaseid = Integer.parseInt(request.getParameter("completeID"));
	String complete = "COMPLETE";

	//select inventory to update
	PreparedStatement selectinventoryidAndquantity = conn.prepareStatement(
	"select inventoryid, quantity from purchase_item where purchaseid=? and complete is null");
	selectinventoryidAndquantity.setInt(1, purchaseid);
	ResultSet invApurchid = selectinventoryidAndquantity.executeQuery();

	while (invApurchid.next()) {
		int purchaseQuantity = invApurchid.getInt("quantity");
		String purchaseInvId = invApurchid.getString("inventoryid");

		//select quantity to update
		PreparedStatement selectInevntory = conn
		.prepareStatement("select inventorybalance from inventory where inventoryid=?");
		selectInevntory.setString(1, purchaseInvId);
		ResultSet resultselect = selectInevntory.executeQuery();
		resultselect.next();

		int oldquantity = resultselect.getInt("inventorybalance");

		int newQuantityInv = oldquantity - purchaseQuantity;

		PreparedStatement updateQuantityInventory = conn
		.prepareStatement("update inventory set inventorybalance=? where inventoryid=?");
		updateQuantityInventory.setInt(1, newQuantityInv);
		updateQuantityInventory.setString(2, purchaseInvId);
		ResultSet executeupdateQuantityInventory = updateQuantityInventory.executeQuery();

		PreparedStatement completeTransaction = conn.prepareStatement(
		"update purchase_item set complete=? where purchaseid=? and  staffid=? and complete is null");
		completeTransaction.setString(1, complete);
		completeTransaction.setInt(2, purchaseIDLatest);
		completeTransaction.setString(3, UserID);
		ResultSet completeResult = completeTransaction.executeQuery();
	}

	completeFlag = true;

}

if (completeFlag) {
	if (request.getParameter("totalPrice") != null) {
		String totals = request.getParameter("totalString");
		double total = Double.parseDouble(request.getParameter("totalPrice"));
		System.out.println(totals);
		int purchaseIDLatest = Integer.parseInt(request.getParameter("completeID"));

		PreparedStatement updateordertotal = conn
		.prepareStatement("update purchase set ordertotal=? where purchaseid=?");
		updateordertotal.setDouble(1, total);
		updateordertotal.setInt(2, purchaseIDLatest);
		ResultSet updateOrderTotal = updateordertotal.executeQuery();

		response.sendRedirect("../staffMenu.jsp?transaction=success");
	}

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

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
/* Custom CSS */
/* Add your custom styles here */
</style>
</head>

<body>

	<!-- Navbar -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container">
			<a class="navbar-brand" href="../staffmenu.jsp">Shopping Cart</a>
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
			<div class="container mt-4 mb-4">
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
						String name = null, totalPriceDisplay, invid;
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
								<%

								%>
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

						if (name == null) {
						%>
						<tr>
							<td colspan="6" class="text-center">
								<p>There's no item in the cart :(</p>
							</td>

						</tr>
						<%
						}
						%>
						<tr>
							<td colspan="4">Price</td>
							<td><b>RM<%
							double updateTotal = totalPrice;
							String totalString = String.format("%.2f", totalPrice);

							String ttpd;
							out.println(ttpd = String.format("%.2f", totalPrice));
							%></b></td>
						</tr>
					</tfoot>
				</table>

				<div class="row">
					<div class="col"></div>
					<div class="col text-center">
						<a href="../staffMenu.jsp" class="btn btn-warning m-4"> <i
							class="bi bi-arrow-left-circle"></i> Back
						</a> <a href="listItemStaff.jsp" class="btn btn-warning m-4"> <i
							class="bi bi-receipt"></i> Item
						</a>

						<%
						if (name != null) {
						%>
						<a type="button" class="btn btn-warning" data-toggle="modal"
							data-target="#exampleModalCenter"> <i
							class="bi bi-check2-circle"></i> Checkout
						</a>
						<%
						}
						%>

					</div>
					<div class="col"></div>
				</div>
				<div class="row">
					<div class="col"></div>
					<div class="col text-center">




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
											PreparedStatement getLatestPurchase = conn.prepareStatement(
													"select * from PURCHASE where PURCHASEID  = (select max(PURCHASEID) from PURCHASE_item WHERE complete IS null)");
											ResultSet getPurchaseid = getLatestPurchase.executeQuery();
											if (getPurchaseid.next()) {
												int LatestPurchaseid = getPurchaseid.getInt("purchaseid");
											%>
											<input type="hidden" value="<%=LatestPurchaseid%>"
												name="completeID" /> <input type="hidden"
												value="<%=updateTotal%>" name="totalPrice" /> <input
												type="hidden" value="<%=totalString%>"
												name="totalPriceString" />
											<button type="submit" class="btn btn-warning">
												Checkout</button>
											<button type="button" class="btn btn-secondary"
												data-dismiss="modal">Close</button>
											<%
											}
											%>

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
					$('#inventoryTable').DataTable();
				});
			</script>

		</div> 
</body>

</html>

