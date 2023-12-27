
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Inventory Management</title>
  <!-- Bootstrap CSS -->
  <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css" rel="stylesheet">
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
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
  
    <!-- Add Item Button -->
<button type="button" class="btn btn-primary mb-3" data-toggle="modal" data-target="#addItemModal">
  Add Item
</button>

<!-- Add Item Modal -->
<div class="modal fade" id="addItemModal" tabindex="-1" role="dialog" aria-labelledby="addItemModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content" >
    	
    
      <div class="modal-header" class="container mt-4">
        <h5 class="modal-title" id="addItemModalLabel">Add New Item</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>

      <div class="modal-body" >

        <form>
      <div class="form-group">
        <label>Inventory ID</label>
        <input type="text" class="form-control" id="" name="">
      </div>

      <div class="form-group">
        <label>Inventory Name</label>  
        <input type="text" class="form-control" id="" name="">
      </div>

      <div class="form-group">
        <label>Inventory Price</label>
        <input type="text" class="form-control" id="" name="">
      </div>
      
      <div class="form-group">
        <label>Inventory Brand</label>
        <input type="text" class="form-control" id="" name="">
      </div>
      
      <div class="form-group">
        <label>Inventory Balance</label>
        <input type="text" class="form-control" id="" name="">
      </div>
      
      <select id="dropdown" class="form-control" onchange="showInput(this.value)">
            <option value="">Select an option</option>
            <option value="F">Food</option>
            <option value="P">Personal Care</option>
            <option value="S">Stationery</option>
        </select>
        <br>
        
        <div id="inputF" style="display: none;" >
        Inventory ID<input type="text" class="form-control" name="">
        <br>
        Category<input type="text" class="form-control" name="">
        <br>
        Store Condition<input type="text" class="form-control" name="">
        <br>
        Expired Date<input type="date" class="form-control" name="">
        <br>
        </div>
        
        <div id="inputP" style="display: none;" >
        Inventory ID<input type="text" class="form-control" name="">
        <br>
        Category<input type="text" class="form-control" name="">
        <br>
        Liquid<input type="text" class="form-control" name="">
        <br>
        Expired Date<input type="date" class="form-control" name="">
        <br>
        </div>
        
        <div id="inputS" style="display: none;" >
        Inventory ID<input type="text" class="form-control" name="">
        <br>
        Category<input type="text" class="form-control" name="">
        <br>
        Stationery Type<input type="text" class="form-control" name="">
        <br>
        </div>
      
          <!-- Other input fields -->

          <button type="submit" class="btn btn-primary">Submit</button>
        </form>
		
      </div>

    </div>
  </div>
</div>

          <!-- Data Table -->
          <table id="inventoryTable" class="table table-striped table-bordered" style="width:100%">
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

                  <tr>
                    <td>1</td>
                    <td>I001</td>
                    <td>Ramen</td>
                    <td>5.60</td>
                    <td>Food</td>
                    <td>Buldak</td>
                    <td>10</td>
                    <td>
                      <button type="button" class="btn btn-primary btn-sm view-btn" data-toggle="modal"
                        data-target="#viewItemModal">View</button>
                      <button type="button" class="btn btn-danger btn-sm delete-btn">Delete</button>
                    </td>
                  </tr>
                  <!-- End of Sample Table Data -->
            </tbody>
          </table>

          <!-- Add Item Modal -->
          <div class="modal fade" id="addItemModal" tabindex="-1" role="dialog" aria-labelledby="addItemModalLabel"
            aria-hidden="true">
            <!-- Modal content goes here -->
          </div>

          <!-- View Item Modal -->
          <div class="modal fade" id="viewItemModal" tabindex="-1" role="dialog" aria-labelledby="viewItemModalLabel"
            aria-hidden="true">
            <!-- Modal content goes here -->
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="viewItemModalLabel">Item Information</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  <!-- Item Information Display (Replace this with your actual item information) -->
                  <p>Inventory ID: <span id=""></span></p>
                  <p>Inventory Name: <span id=""></span></p>
                  <p>Inventory Price: <span id=""></span></p>
                  <p>Inventory Type: <span id=""></span></p>
                  <p>Inventory Brand: <span id=""></span></p>
                  <p>Inventory Balance: <span id=""></span></p>
                  <!-- End of Item Information Display -->
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-dismiss="modal">Back</button>
                  <!-- Update button -->
			<button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#updateItemModal">
  				Update
			</button>
                <!-- Update Staff Modal -->
<div class="modal fade" id="updateItemModal" tabindex="-1" role="dialog" aria-labelledby="updateItemModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
    
      <div class="modal-header">
        <h5 class="modal-title" id="updateItemModalLabel">Update Item Details</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>

      <div class="modal-body">

        <form>
          
          <div class="form-group">
        <label>Inventory ID</label>
        <input type="text" class="form-control" id="">
      </div>

      <div class="form-group">
        <label>Inventory Name</label>  
        <input type="text" class="form-control" id="">
      </div>

      <div class="form-group">
        <label>Inventory Price</label>
        <input type="text" class="form-control" id="">
      </div>
      
      <div class="form-group">
        <label>Inventory Type</label>
        <input type="text" class="form-control" id="">
      </div>
      
      <div class="form-group">
        <label>Inventory Brand</label>
        <input type="text" class="form-control" id="">
      </div>
      
      <div class="form-group">
        <label>Inventory Balance</label>
        <input type="text" class="form-control" id="">
      </div>

          <!-- Other editable fields -->

          <button type="submit" class="btn btn-primary">Update Item</button>

        </form>

      </div>

    </div>
  </div>
</div>
          </div>
        </div>
      </div>
    </div>

          <!-- Bootstrap JS and jQuery -->
          <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
          <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
          <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap4.min.js"></script>
          <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

          <!-- DataTables Initialization Script -->
          <script>
            $(document).ready(function () {
              $('#inventoryTable').DataTable();
            });
          </script>
        </div>

      </body>

      </html>
