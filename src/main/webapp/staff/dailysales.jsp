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

if (UserID == null) {
	response.sendRedirect("../login.jsp");
} else {

	PreparedStatement CurrentUser = conn.prepareStatement("select * from staff where staffid=?");
	CurrentUser.setString(1, UserID);
	ResultSet UserSession = CurrentUser.executeQuery();
	UserSession.next();
	//out.println("welcome sir, " + UserSession.getString("staffname"));
}

//LIST STAFF
String query = "SELECT DISTINCT  P.PURCHASEID, PI.STAFFID,TO_CHAR( to_date(P.PURCHASEDATE,'DD-MM-YY'), 'DD-MM-YYYY') AS PURCHASEDATE, P.PURCHASETIME, P.ORDERTOTAL, PI.COMPLETE FROM PURCHASE P JOIN PURCHASE_ITEM PI ON PI.PURCHASEID = P.PURCHASEID ORDER BY P.PURCHASEID DESC";
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


<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

</head>

<body>



	<!-- Navbar -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container">
			<a class="navbar-brand" href="../staffMenu.jsp">Sales Summary</a>
		</div>
	</nav>



	<!-- Page Content -->
	<div class="container mt-4 mb-4">

		<div class="card card-body">



			<!-- Data Table -->
			<table id="inventoryTable" class="table table-striped table-bordered"
				style="width: 100%">
				<thead class="thead-dark">
					<tr>
						<th>No</th>
						<th>Purchase ID</th>
						<th>Date</th>
						<th>Time</th>
						<th>Total</th>
						<th>Handled By</th>
						<th>Status</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<!-- Sample Table Data (Replace this with dynamic data) -->
					<%
					int count = 1;
					while (execute.next()) {

						String tPOrder = String.format("%.2f", execute.getDouble("ordertotal"));
					%>
					<tr>
						<td><%=count%></td>
						<td><%=execute.getInt("purchaseid")%></td>
						<td><%=execute.getString("purchasedate")%></td>
						<td><%=execute.getString("purchasetime")%></td>
						<td>RM<%=tPOrder%></td>
						<td><%=execute.getString("staffid")%></td>
						<td><%=execute.getString("complete")%></td>
						<td>
							<!-- VIEW SECTION -->
							<button type="button" class="btn btn-primary btn-sm"
								data-toggle="modal"
								data-target="#updateStaffModal<%=execute.getInt("purchaseid")%>">
								View</button> <!-- Update Staff Modal -->

							<div class="modal fade"
								id="updateStaffModal<%=execute.getInt("purchaseid")%>"
								tabindex="-1" role="dialog"
								aria-labelledby="updateStaffModalLabel" aria-hidden="true">
								<div class="modal-dialog modal-xl" role="document">
									<div class="modal-content">
										<%
										int pID = execute.getInt("purchaseid");
										PreparedStatement grabitem = conn.prepareStatement(
												"select * from purchase_item pi JOIN INVENTORY i ON pi.INVENTORYID = i.INVENTORYID  where purchaseid=?");
										grabitem.setInt(1, pID);
										ResultSet executeGrabItem = grabitem.executeQuery();
										%>
										<div class="modal-header">
											<h5 class="modal-title" id="updateStaffModalLabel">
												Purchase Details</h5>
											<button type="button" class="close" data-dismiss="modal"
												aria-label="Close">
												<span aria-hidden="true">&times;</span>
											</button>
										</div>

										<div class="modal-body">

											<table id="inventoryTable"
												class="table table-striped table-bordered"
												style="width: 100%">
												<thead class="thead-dark">
													<tr>
														<th>No</th>
														<th>Name</th>
														<th>Type</th>
														<th>Brand</th>
														<th>Quantity</th>
														<th>Total</th>
													</tr>
												</thead>
												<tbody>
													<!-- Sample Table Data (Replace this with dynamic data) -->
													<%
													double grandTotal=0.0;
													int counts = 1;
													while (executeGrabItem.next()) {
														
														double price = executeGrabItem.getDouble("inventoryprice");
														int quant = executeGrabItem.getInt("quantity");
														Double totalEachItem = price * quant;
														String displayPrice = String.format("%.2f", totalEachItem);
													%>
													<tr>
														<td><%=counts%></td>
														<td><%=executeGrabItem.getString("inventoryname")%></td>
														<td><%=executeGrabItem.getString("inventorytype")%></td>
														<td><%=executeGrabItem.getString("inventorybrand")%></td>
														<td><%=executeGrabItem.getInt("quantity")%></td>
														<td><%=displayPrice%></td>

													</tr>
													<%
													counts = counts + 1;
													grandTotal = grandTotal + totalEachItem;
													}
													String tPaymentDisplay = String.format("%.2f", grandTotal);
													%>
													<tr>
														<td colspan="5" class="text-center"><b>Total Payment</b></td>
														<td><%=tPaymentDisplay %></td>
													</tr>
													

													<!-- End of Sample Table Data -->
												</tbody>
											</table>

										</div>

									</div>
								</div>
							</div> <!-- END VIEW SECTION -->

						</td>
					</tr>
					<%
					count = count + 1;
					}
					%>

					<!-- End of Sample Table Data -->
				</tbody>
			</table>

			<div class="row">
				<div class="col"></div>
				<div class="col text-center">
					<a href="../staffMenu.jsp" class="btn btn-warning m-4"> <i
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
