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
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
        + Thêm Phiếu Nhập kho
      </button>
      <button class="btn btn-success mb-3" data-bs-toggle="modal">
        + Thêm Phiếu Xuất kho
      </button>

      <div class="table-section">
        <div class="card-header bg-success text-white mt-4" style="background: #198754 !important;">
          <h5>Nhập Kho</h5>
        </div>
        <table id="importTable" class="table table-bordered display">
          <thead>
          <tr>
            <th>Mã Phiếu</th>
            <th>Ngày Tạo</th>
            <th>Nhà cung cấp</th>
            <th>Tổng Tiền</th>
            <th>Ghi Chú</th>
            <th>Hành Động</th>
          </tr>
          </thead>
          <tbody>
          <c:if test="${empty stockIn}">
            <tr>
              <td colspan="6" class="text-center">Không có dữ liệu</td>
            </tr>
          </c:if>

          <c:forEach var="si" items="${stockIn}">
            <tr>
              <td>${si.id}</td>
              <td>${si.transactionDate}</td>
              <td>${si.supplier}</td>
              <td>${si.totalPrice}</td>
              <td>${si.note}</td>
              <td>
                <button class="btn btn-sm btn-info viewDetailSIButton" data-stockin-id="${si.id}" data-bs-toggle="modal" data-bs-target="#detailModal">Chi tiết</button>
                <button class="btn btn-sm btn-danger">Xoá</button>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title" id="detailModalLabel">Chi tiết Phiếu Nhập kho</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
        </div>
        <div class="modal-body">
          <p><strong>Mã phiếu:</strong> <span id="siId"></span></p>
          <p><strong>Người lập:</strong> <span id="createBy"></span></p>
          <p><strong>Loại:</strong> Nhập kho</p>
          <p><strong>Nhà cung cấp:</strong> <span id="detailSup"></span></p>
          <p><strong>Ngày tạo:</strong> <span id="importDate"></span></p>
          <p><strong>Ghi chú:</strong> <span id="note"></span></p>

          <table id="stockInItem" class="table table-bordered mt-3">
            <thead>
            <tr>
              <th>Mã SP</th>
              <th>Tên SP</th>
              <th>Kích thước</th>
              <th>Số lượng</th>
              <th>Đơn giá</th>
              <th>Thành tiền</th>
              <th>Ghi chú</th>
            </tr>
            </thead>
            <tbody id="stockinItemBody">
            </tbody>
          </table>
        </div>
        <div class="modal-footer">
          <strong class="me-auto"> Tổng tiền: <span id="totalPrice"></span></strong>
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
          <label>Người thực hiện:</label>
          <input type="text" id="user" class="form-control" value="${sessionScope.user.fullName}" readonly>
          <input type="hidden" id="userId" name="userId" value="${sessionScope.user.id}">
        </div>
        <div class="mb-3">
          <label>Nhà cung cấp:</label>
          <input type="text" id="supplier" class="form-control" >
        </div>
        <div class="mb-3">
          <label>Ngày nhập:</label>
          <input type="date" id="createdDate" class="form-control" >
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
            <th>Mã Sản phẩm</th>
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
        <button type="button" class="btn btn-success" onclick="submitStockIn()">Lưu Phiếu Nhập</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(function() {
    let importTable = $('#importTable').DataTable({
      "order": [[1, "desc"]],
      "columnDefs": [
        { "type": "date", "targets": 1 }
      ],
      dom: '<"d-flex justify-content-between align-items-center"lfB>rtip',
      buttons: [
        { extend: 'copy', title: 'Danh sách Nhập kho' },
        { extend: 'csv', title: 'Danh sách Nhập kho' },
        { extend: 'excel', title: 'Danh sách Nhập kho' },
        { extend: 'pdf', title: 'Danh sách Nhập kho' },
        { extend: 'print', title: 'Danh sách Nhập kho' }
      ]
    });
    $(document).on('click', '.viewDetailSIButton', function () {
      const stockInId = $(this).data('stockin-id');
      $.ajax({
        url: 'inventoryTrans/detail',
        method: 'GET',
        data: { id: stockInId, type: "in" },
        success: function(response) {
          console.log(response);
          $('#siId').text(response.id);
          $('#importDate').text(response.transactionDate);
          $('#createBy').text(response.createdName);
          $('#detailSup').text(response.supplier);
          $('#note').text(response.note);
          $('#totalPrice').text(response.totalPrice);

          $('#stockinItemBody').empty();

          $.each(response.listPro, function(index, product) {
            var productRow = '<tr>' +
                    '<td>' + product.productId + '</td>' +
                    '<td>' + product.productName + '</td>' +
                    '<td>' + product.sizeName + '</td>' +
                    '<td>' + product.quantity + '</td>' +
                    '<td>' + product.price.toLocaleString() + '</td>' +
                    '<td>' + product.totalPrice.toLocaleString() + '</td>' +
                    '<td>' + (product.note ?? '') + '</td>' +
                    '</tr>';
            $('#stockinItemBody').append(productRow);
          });
        },
        error: function(xhr, status, error) {
          console.error('Có lỗi xảy ra: ' + error);
        }
      });
    });
  });
  function addEmptyRow() {
    const tbody = document.getElementById("productBody");

    const row = document.createElement("tr");

    row.innerHTML = `
    <td><select class="form-select">
            <option value="">Chọn sản phẩm</option>
                    <c:forEach var="p" items="${p}">
                      <option value="${p.id}" data-name="${p.title}">${p.id} - ${p.title}</option>
                    </c:forEach>
          </select></td>
    <td> <select class="form-select">
            <option>-- Chọn --</option>
            <c:forEach var="s" items="${s}">
                      <option value="${s.idSize}">${s.sizeDescriptions}</option>
            </c:forEach>
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

  function submitStockIn() {
    const createdId = $('#userId').val();
    const supplier = $('#supplier').val();
    const createdDate = $('#createdDate').val();
    const note = $('#noteInput').val();

    const products = [];

    let isValid = true;
    let errorMessages = [];

    $('.error-message').remove();
    if (!supplier) {
      $('#supplier').after('<div class="error-message" style="color:red;font-size:12px;">Vui lòng nhập nhà cung cấp</div>');
      isValid = false;
      errorMessages.push("Thiếu nhà cung cấp");
    }

    if (!createdDate) {
      $('#createdDate').after('<div class="error-message" style="color:red;font-size:12px;">Vui lòng chọn ngày nhập</div>');
      isValid = false;
      errorMessages.push("Thiếu ngày nhập");
    }

    $('#productBody tr').each(function (index) {
      const row = $(this);
      const productId = row.find('select').eq(0).val();
      const sizeId = row.find('select').eq(1).val();
      const quantity = row.find('input[name="productQuantity"]').val();
      const price = row.find('input[name="productPrice"]').val();
      const note = row.find('input[name="productNote"]').val();

      if (productId && sizeId >0 && quantity > 0 && price >= 0) {
        products.push({
          productId,
          sizeId,
          quantity,
          price,
          note
        });
      }else {
        isValid = false;
        errorMessages.push(`Thông tin sản phẩm chưa hợp lệ`);
      }
    });

    if (products.length === 0) {
      errorMessages.push(`Chưa có sản phẩm`);
      isValid = false;
    }
    if (!isValid) {
      console.log('Các lỗi:', errorMessages);

      let errorText = errorMessages.join('<br>');

      Swal.fire({
        icon: 'error',
        title: 'Lỗi nhập liệu',
        html: errorText,
        confirmButtonText: 'OK'
      });
      return;
    }

    const productData = JSON.stringify(products);

    $.ajax({
      url: 'inventoryTrans/addStockIn',
      type: 'POST',
      data: {
        createdId: createdId,
        supplier: supplier,
        createdDate: createdDate,
        note: note,
        products: productData
      },
      success: function (response) {
        Swal.fire({
          icon: 'success',
          title: 'Thành công',
          text: 'Phiếu nhập đã được tạo.',
        });
        console.log(response.stockIn.transactionDate)
        var importTable = $('#importTable').DataTable();
        importTable.row.add([
          response.stockIn.id,
          response.stockIn.transactionDate,
          response.stockIn.supplier,
          response.stockIn.totalPrice,
          response.stockIn.note ?? '',
          '<button class="btn btn-sm btn-info viewDetailSIButton" data-stockin-id="'+ response.stockIn.id +'"  data-bs-toggle="modal" data-bs-target="#detailModal">Chi tiết</button>'+
          '<button class="btn btn-sm btn-danger">Xoá</button>'
        ]).draw();
        $('#addStockModal').modal('hide');
      },
      error: function (xhr, status, error) {
        let errorMessage = xhr.responseText || "Không xác định!";
        Swal.fire({
          icon: 'error',
          title: 'Có lỗi xảy ra khi nhập kho!',
          text: 'Chi tiết: ' + errorMessage,
          confirmButtonText: 'OK'
        });
      }
    });
  }
</script>
<script src="https://cdn.datatables.net/1.12.1/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>
