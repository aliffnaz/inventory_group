<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Update Staff</title>

  <!-- Bootstrap CSS -->
  <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css" rel="stylesheet">
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  
  <style>
    /* Custom CSS */ 
  </style>

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

    <h2>Update Staff</h2>
    
    <!-- Update Staff Form -->
    <form>
      <div class="form-group">
        <label>Staff ID</label>
        <input type="text" class="form-control" id="staffID">
      </div>

      <div class="form-group">
        <label>Staff Name</label>  
        <input type="text" class="form-control" id="staffName">
      </div>

      <div class="form-group">
        <label>Staff IC</label>
        <input type="text" class="form-control" id="staffIC">
      </div>
      
      <div class="form-group">
        <label>Staff Phone</label>
        <input type="text" class="form-control" id="staffPhone">
      </div>
      
      <div class="form-group">
        <label>Staff Role</label>
        <input type="text" class="form-control" id="staffRole">
      </div>
      
      <div class="form-group">
        <label>Staff Age</label>
        <input type="text" class="form-control" id="staffAge">
      </div>
      
      <!-- Other input fields -->
      
      <button type="submit" class="btn btn-primary">Update</button>
    </form>

  </div>

  <!-- Bootstrap JS and jQuery -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

</body>

</html>