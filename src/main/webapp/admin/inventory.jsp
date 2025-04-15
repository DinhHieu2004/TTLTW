<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Panel</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <!-- DataTables Buttons CSS -->
  <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">

  <!-- DataTables Buttons JavaScript -->
  <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
  <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
  <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>
  <style>
    .sidebar {
    height: 100vh;
    position: fixed;
    top: 0;
    left: 0;
    width: 250px;
    background-color: #343a40;
    color: white;
    padding: 20px 10px;
  }
  .sidebar a {
    color: white;
    text-decoration: none;
    display: block;
    padding: 10px;
    margin-bottom: 5px;
  }
  .sidebar a:hover {
    background-color: #495057;
    border-radius: 5px;
  }
  .content {
    margin-left: 260px;
    padding: 20px;
  }
  </style>

</head>
<body>
<%@ include file="/admin/sidebar.jsp" %>

<div class="content">
  <div class="card mb-4">
    <div class="card-header bg-success text-white" style="background: #e7621b !important;">
      <h4>Quản lý xuất/nhập kho</h4>
    </div>
    <div class="card-body">
      <button class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addStockModal">
        + Thêm Phiếu Nhập/Xuất
      </button>

      <div class="table-section">
        <div class="card-header bg-success text-white mt-4" style="background: #198754 !important;">
          <h5>Nhập Kho</h5>
        </div>
        <table id="importTable" class="table table-bordered display">
          <thead>
          <tr>
            <th>Mã Phiếu</th>
            <th>Loại Phiếu</th>
            <th>Ngày Tạo</th>
            <th>Số Sản Phẩm</th>
            <th>Tổng Tiền</th>
            <th>Ghi Chú</th>
            <th>Hành Động</th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td>NK001</td>
            <td>Nhập kho</td>
            <td>2025-04-14</td>
            <td>5</td>
            <td>12,000,000</td>
            <td>Nhập từ NCC A</td>
            <td>
              <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#detailModal">Chi tiết</button>
              <button class="btn btn-sm btn-danger">Xoá</button>
            </td>
          </tr>
          </tbody>
        </table>
      </div>

      <div class="table-section mt-4">
        <div class="card-header bg-success text-white mt-4" style="background: #198754  !important;">
          <h5>Xuất Kho</h5>
        </div>
        <table id="exportTable" class="table table-bordered display">
          <thead>
          <tr>
            <th>Mã Phiếu</th>
            <th>Loại Phiếu</th>
            <th>Ngày Tạo</th>
            <th>Số Sản Phẩm</th>
            <th>Tổng Tiền</th>
            <th>Ghi Chú</th>
            <th>Hành Động</th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td>XK003</td>
            <td>Xuất kho</td>
            <td>2025-04-13</td>
            <td>3</td>
            <td>8,500,000</td>
            <td>Xuất cho khách B</td>
            <td>
              <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#detailModal">Chi tiết</button>
              <button class="btn btn-sm btn-danger">Xoá</button>
            </td>
          </tr>
          <!-- Add more export rows here -->
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title" id="detailModalLabel">Chi tiết Phiếu Nhập/Xuất</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <div class="modal-body">
          <p><strong>Mã phiếu:</strong> NK001</p>
          <p><strong>Loại:</strong> Nhập kho</p>
          <p><strong>Ngày tạo:</strong> 2025-04-14</p>
          <p><strong>Ghi chú:</strong> Nhập từ NCC A</p>

          <table class="table table-bordered mt-3">
            <thead>
            <tr>
              <th>Mã SP</th>
              <th>Tên SP</th>
              <th>Số lượng</th>
              <th>Đơn giá</th>
              <th>Thành tiền</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td>1</td>
              <td>Ram 16GB</td>
              <td>2</td>
              <td>1,200,000</td>
              <td>2,400,000</td>
            </tr>
            <tr>
              <td>SP02</td>
              <td>SSD 1TB</td>
              <td>3</td>
              <td>1,600,000</td>
              <td>4,800,000</td>
            </tr>
            </tbody>
          </table>
        </div>
        <div class="modal-footer">
          <strong class="me-auto">Tổng tiền: 12,000,000</strong>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="addStockModal" tabindex="-1" aria-labelledby="addStockModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title" id="addStockModalLabel">Tạo Phiếu Nhập Kho</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <div class="modal-body">
        <div class="mb-3">
          <label>Người thao tác:</label>
          <input type="text" class="form-control" value="admin01" readonly>
        </div>
        <div class="mb-3">
          <label>Ngày tạo:</label>
          <input type="date" class="form-control" value="2025-04-14">
        </div>
        <div class="mb-3">
          <label>Ghi chú:</label>
          <textarea class="form-control"></textarea>
        </div>

        <div class="mb-2 d-flex justify-content-between align-items-center">
          <h5>Danh sách sản phẩm</h5>
          <button class="btn btn-sm btn-primary" onclick="addEmptyRow()">+ Thêm sản phẩm</button>
        </div>
        <div style="max-height: 300px; overflow-y: auto;">
        <table class="table table-bordered" id="productTable">
          <thead>
          <tr>
            <th>Mã SP</th>
            <th>Tên SP</th>
            <th>Size</th>
            <th>Số lượng</th>
            <th>Đơn giá</th>
            <th>Ghi chú</th>
            <th>Hành động</th>
          </tr>
          </thead>
          <tbody id="productBody">
          </tbody>
        </table>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success">Lưu Phiếu Nhập</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
      </div>
    </div>
  </div>
</div>

<script>
  function addEmptyRow() {
    const tbody = document.getElementById("productBody");

    const row = document.createElement("tr");

    row.innerHTML = `
    <td><select class="form-select">
            <option>-- Chọn --</option>
            <option>SP1</option>
            <option>SP1</option>
            <option>SP1</option>
          </select></td>
    <td><input type="text" class="form-control" name="productName"></td>
    <td> <select class="form-select">
            <option>-- Chọn --</option>
            <option>Nhỏ</option>
            <option>Vừa</option>
            <option>Lớn</option>
          </select></td>
    <td><input type="number" class="form-control" name="productQuantity"></td>
    <td><input type="number" class="form-control" name="productPrice"></td>
    <td><input type="text" class="form-control" name="productNote"></td>
    <td>
      <button class="btn btn-danger btn-sm" onclick="removeRow(this)">Xoá</button>
    </td>
  `;

    tbody.appendChild(row);
  }

  function removeRow(btn) {
    const row = btn.closest("tr");
    row.remove();
  }
  $(document).ready(function() {
    $('#importTable').DataTable();
    $('#exportTable').DataTable();
  });

</script>
<script src="https://cdn.datatables.net/1.12.1/js/jquery.dataTables.min.js"></script>
</body>
</html>
