<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Panel</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
  <!-- DataTables Buttons CSS -->
  <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">

  <!-- DataTables Buttons JavaScript -->
  <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
  <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
  <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>

  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
      <button class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addStockOutModal">
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
            <th>Người tạo</th>
            <th>Nhà cung cấp</th>
            <th>Tổng Tiền</th>
            <th>Ghi Chú</th>
            <th>Hành Động</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="si" items="${stockIn}">
            <tr data-si-id="${si.id}">
              <td>${si.id}</td>
              <td>${si.transactionDate}</td>
              <td>${si.createdName}</td>
              <td>${si.supplier}</td>
              <td><f:formatNumber value="${si.totalPrice}" type="currency" pattern="#,##0"/> VND</td>
              <td>${si.note}</td>
              <td>
                <button class="btn btn-sm btn-info viewDetailSIButton" data-stockin-id="${si.id}" data-bs-toggle="modal" data-bs-target="#detailModal">Chi tiết</button>
                <button class="btn btn-sm btn-danger deleteStockInButton" data-id="${si.id}">Xoá</button>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>

      <div class="table-section">
        <div class="card-header bg-success text-white mt-4" style="background: #198754 !important;">
          <h5>Xuất Kho</h5>
        </div>
        <table id="exportTable" class="table table-bordered display">
          <thead>
          <tr>
            <th>Mã Phiếu</th>
            <th>Ngày Tạo</th>
            <th>Người tạo</th>
            <th>Lý do</th>
            <th>Tổng Tiền</th>
            <th>Ghi Chú</th>
            <th>Hành Động</th>
          </tr>
          </thead>
          <tbody>
              <c:forEach var="so" items="${stockOut}">
                <tr data-so-id="${so.id}">
                  <td>${so.id}</td>
                  <td>${so.transactionDate}</td>
                  <td>${so.createdName}</td>
                  <td>${so.reason}</td>
                  <td><f:formatNumber value="${so.totalPrice}" type="currency" pattern="#,##0"/> VND</td>
                  <td>${so.note}</td>
                  <td>
                    <button class="btn btn-sm btn-info viewDetailSOButton" data-stockout-id="${so.id}" data-bs-toggle="modal" data-bs-target="#detailModalSo">Chi tiết</button>
                    <button class="btn btn-sm btn-danger deleteStockOButton" data-id="${so.id}">Xoá</button>
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
          <button type="button" class="btn btn-success" id="applyBtn">Áp dụng</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
        </div>
      </div>
    </div>
  </div>


<div class="modal fade" id="detailModalSo" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title" id="detailModalLabelSO">Chi tiết Phiếu Xuất kho</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <div class="modal-body">
        <p><strong>Mã phiếu:</strong> <span id="soId"></span></p>
        <p><strong>Người lập:</strong> <span id="createBySo"></span></p>
        <p><strong>Loại:</strong> Xuất kho</p>
        <p><strong>Lý do:</strong> <span id="reasonSO"></span></p>
        <p><strong>Mã đơn hàng (giao hàng):</strong> <span id="orderIdSO"></span></p>
        <p><strong>Ngày tạo:</strong> <span id="exportDate"></span></p>
        <p><strong>Ghi chú:</strong> <span id="noteSo"></span></p>

        <table id="stockOutItem" class="table table-bordered mt-3">
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
          <tbody id="stockOutItemBody">
          </tbody>
        </table>
      </div>
      <div class="modal-footer">
        <strong class="me-auto"> Tổng tiền: <span id="totalPriceSo"></span></strong>
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
          <textarea class="form-control" id="noteInput"></textarea>
        </div>

        <div class="mb-2 d-flex justify-content-between align-items-center">
          <h5>Danh sách sản phẩm</h5>
          <button class="btn btn-sm btn-primary btn-addProd" onclick="addEmptyRow('productTable')">+ Thêm sản phẩm</button>
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

<div class="modal fade" id="addStockOutModal" tabindex="-1" aria-labelledby="addStockOutModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title" id="addStockOutModalLabel">Tạo Phiếu Xuất Kho</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <div class="modal-body">
        <div class="mb-3">
          <label>Người thực hiện:</label>
          <input type="text" id="userSO" class="form-control" value="${sessionScope.user.fullName}" readonly>
          <input type="hidden" id="userIdSO" name="userId" value="${sessionScope.user.id}">
        </div>
        <div class="mb-3">
          <label>Lý do xuất kho:</label>
          <select id="reason" class="form-select" onchange="onReasonChange(this)">
              <option value="">-- Chọn lý do --</option>
              <option value="Giao hàng">Giao hàng</option>
              <option value="Xuất hỏng">Xuất hỏng</option>
              <option value="Khác">Khác</option>
          </select>
        </div>
        <div class="mb-3" id="otherReasonWrapper" style="display: none;">
            <label>Nhập lý do khác:</label>
            <input type="text" id="otherReason" class="form-control">
        </div>
        <div class="mb-3" id="orderSelectWrapper" style="display: none;">
          <label>Chọn hóa đơn:</label>
          <select id="orderSelect" class="form-select" onchange="onOrderChange(this)">
            <option value="">-- Không chọn --</option>
            <c:forEach var="o" items="${o}">
              <option value="${o.id}">#${o.id} - ${o.paymentMethod} - ${o.recipientName}</option>
            </c:forEach>
          </select>
        </div>

        <div class="mb-3">
          <label>Ngày xuất kho:</label>
          <input type="date" id="createdDateSO" class="form-control" >
        </div>
        <div class="mb-3">
          <label>Ghi chú:</label>
          <textarea class="form-control" id="noteOut"></textarea>
        </div>

        <div class="mb-2 d-flex justify-content-between align-items-center">
            <h5>Danh sách sản phẩm</h5>
            <button class="btn btn-sm btn-primary " id="addProdOut"  onclick="addEmptyRow('productTableSO')">+ Thêm sản phẩm</button>
        </div>
        <div style="max-height: 300px; overflow-y: auto;">
            <table class="table table-bordered" id="productTableSO">
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
            <tbody id="productBodySO">
              </tbody>
            </table>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" onclick="submitStockOut()">Lưu Phiếu Xuất</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
      </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/admin/stockIO.js"></script>
<script>
  function addEmptyRow(tableId) {
    const tbody = document.getElementById(tableId).querySelector("tbody");

    const row = document.createElement("tr");

    row.innerHTML = `
    <td><select class="form-select product-select">
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
</script>
</body>
</html>
