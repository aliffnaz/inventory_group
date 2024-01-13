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


if (request.getParameter("id") != null) {
	String id = request.getParameter("id");

	session.setAttribute("sessionID", id);

	String temp = (String) session.getAttribute("sessionID");
	System.out.println(temp);

	if (temp == null) {
		response.sendRedirect("login.jsp");
	}

	PreparedStatement manager = conn.prepareStatement("select * from staff where staffid=?");
	manager.setString(1, id);
	ResultSet managerLog = manager.executeQuery();
	managerLog.next();
	// out.println("hello staff, " + managerLog.getString("staffname"));
}

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Menu</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css" rel="stylesheet">
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"  rel="stylesheet">


    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        .menu-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            padding: 10px;
        }

        .menu-item {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin: 20px;
            width: 300px;
            height: 150px;
            text-align: center;
        }

        button-scroll{
            background-color: #c6d46a;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            border-radius: 20px;
        }
        
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .menu-icon {
            font-size: 40px;
            margin-right: 10px;
        }
    </style>
</head>
<body>


      <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand" href="#">Inventory Management</a>
                <a href="staffMenu.jsp">
                    <button-scroll>Staff</button-scroll>
                </a>
            </div>
    </nav>

    <div class="menu-container">
        <div class="menu-item">
            <p><i class="menu-icon fas fa-list"></i></p>
            <a href="staff/listItemStaff.jsp">
                <button>Item List</button>
            </a>
        </div>


        <div class="menu-item">
            <p><i class="menu-icon fas fa-shopping-cart"></i></p>
                <a href="staff/cart.jsp">
                    <button>Orders</button>
                </a>
        </div>
             

        <div class="menu-item">
            <p><i class="menu-icon fas fa-truck"></i></p>
                    <a href="staff/supplierView.jsp">
                        <button>View Supplier</button>
                    </a>
        </div>
        

        <div class="menu-item">
            <p><i class="menu-icon fas fa-chart-line"></i></p>
                <a href="staff/dailysales.jsp">
                    <button>Sales Summary</button>
                </a>    
        </div>
     

        <div class="menu-item">
            <p><i class="menu-icon fas fa-sign-out-alt"></i></p>
                    <a href="login.jsp?logout=1">
                        <button>Logout</button>
                    </a>
        </div>
    </div>

</body>
</html>