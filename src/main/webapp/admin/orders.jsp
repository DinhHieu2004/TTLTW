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
  <style> .sidebar {
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
    margin-left: 260px; /* Sidebar width + margin */
    padding: 20px;
  }
  </style>

</head>
<body>
<!-- Sidebar -->
<%@ include file="/admin/sidebar.jsp" %>
<div class="content">
<div class="card mb-4">
  <div class="card-header bg-success text-white" style="background: #e7621b !important;">
    <h4>Đơn Hàng Hiện Tại</h4>
  </div>
  <div class="card-body">
    <table id="currentOrders" class="table table-bordered display">
      <thead>
      <tr>
        <th>Mã Đơn Hàng</th>
        <th>Tổng Tiền</th>
        <th>Ngày Đặt</th>
        <th>Thanh Toán</th>
        <th>Vận chuyển</th>
        <th>Hành Động</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="order" items="${currentOrder}">
        <tr>
          <td>${order.id}</td>
          <td>${order.totalAmount}</td>
          <td>${order.orderDate}</td>
          <td>${order.paymentStatus}</td>
          <td>${order.deliveryStatus}</td>
          <td><button class="btn btn-info btn-sm" data-bs-toggle="modal"
                      data-bs-target="#orderDetailsModal"
                      data-order-id="${order.id}">Xem Chi Tiết</button>
              <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                      data-bs-target="#deleteOrderModal"
                      data-order-id="${order.id}">Xóa</button>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<div class="card mb-4">
  <div class="card-header bg-secondary text-white">
    <h4>Lịch Sử Đơn Hàng</h4>
  </div>
  <div class="card-body">
    <table id="orderHistory" class="table table-bordered display">
      <thead>
      <tr>
        <th>Mã Đơn Hàng</th>
        <th>Tổng Tiền</th>
        <th>Ngày Đặt</th>
        <th>Ngày Giao</th>
        <th>Thanh Toán</th>
        <th>Vận chuyển</th>
        <th>Hành Động</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="order" items="${historyOrder}">
        <tr>
          <td>${order.id}</td>
          <td>${order.totalAmount}</td>
          <td>${order.orderDate}</td>
          <td>${order.deliveryDate}</td>
          <td>${order.paymentStatus}</td>
          <td>${order.deliveryStatus}</td>
          <td><button class="btn btn-info btn-sm" data-bs-toggle="modal"
                      data-bs-target="#orderDetailsModal"
                      data-order-id="${order.id}">Xem Chi Tiết</button>
            <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                    data-bs-target="#deleteOrderModal"
                    data-order-id="${order.id}">Xóa</button>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<%-- Modal xóa đơn --%>
  <div class="modal fade" id="deleteOrderModal" tabindex="-1" aria-labelledby="deleteOrderModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="deleteOrderModalLabel">Xác nhận xóa</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
          <div class="modal-body">
            <p>Bạn có chắc chắn muốn xóa đơn hàng này?</p>
            <input type="hidden" id="orderIdToDelete" name="orderId">
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <button type="button" id="confirmDeleteOrder" class="btn btn-danger">Xóa</button>
          </div>
      </div>
    </div>
  </div>

<%--  Modal sửa đơn --%>
  <div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel"
  aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="orderDetailsModalLabel">Chi Tiết Đơn Hàng</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div id="orderRecipientInfo">
        </div>
        <table class="table table-striped">
          <thead>
          <tr>
            <th>Max sản phẩm</th>
            <th>Tên Sản Phẩm</th>
            <th>Ảnh</th>
            <th>Kích Thước</th>
            <th>Số Lượng</th>
            <th>Giá</th>
          </tr>
          </thead>
          <tbody id="orderDetailsBody"></tbody>
        </table>
        <div id="totalPrice">
        </div>

        <div id="orderStatusInfo">
          <p><strong>Trạng thái: </strong><span id="orderStatus"></span></p>

          <label for="statusSelect">Cập nhật trạng thái:</label>
          <select id="statusSelect" class="form-select">
            <option value="chờ">chờ</option>
            <option value="đang giao">đang giao</option>
            <option value="hoàn thành">hoàn thành</option>
            <option value="giao hàng thất bại">giao hàng thất bại</option>
            <option value="đã hủy giao hàng">đã hủy giao hàng</option>
          </select>

          <button id="updateStatusBtn" class="btn btn-primary mt-3">Cập nhật đơn hàng</button>
        </div>
      </div>
      </div>
    </div>
  </div>
</div>



<script>
  $(document).ready(function () {
    function initDataTable(selector, title) {
      $(selector).DataTable({
        dom: '<"d-flex justify-content-between align-items-center"lfB>rtip',
        buttons: [
          { extend: 'copy', title: title },
          { extend: 'csv', title: title },
          { extend: 'excel', title: title },
          { extend: 'pdf', title: title },
          { extend: 'print', title: title }
        ]
      });
    }

    initDataTable('#currentOrders', 'Danh sách đơn hàng hiện tại');
    initDataTable('#orderHistory', 'Lịch sử đơn hàng');
  });



  document.querySelectorAll('[data-bs-target="#deleteOrderModal"]').forEach(button => {
    button.addEventListener('click', function() {
      let orderId = this.getAttribute('data-order-id');
      document.getElementById('orderIdToDelete').value = orderId;
    });
  });
</script>
<script>
  // xóa đơn hàng
  $(document).ready(function () {
    const tableCurrent = $("#currentOrders").DataTable();
    const tableHistory = $("#orderHistory").DataTable();

    $(document).on("click", ".delete-order", function () {
      const orderId = $(this).data("order-id");
      $("#orderIdToDelete").val(orderId);
      $("#deleteOrderModal").modal("show");
    });

    $("#confirmDeleteOrder").click(function () {
      const orderId = $("#orderIdToDelete").val();

      $.ajax({
        type: "POST",
        url: "orders/delete",
        data: { orderId: orderId },
        dataType: "json",
        success: function (response) {
          if (response.success) {
            const $row = $('[data-order-id="' + orderId + '"]').closest("tr");
            const tableId = $row.closest("table").attr("id");

            if (tableId === "currentOrders") {
              tableCurrent.row($row).remove().draw();
            } else {
              tableHistory.row($row).remove().draw();
            }

            $("#deleteOrderModal").modal("hide");
          } else {
            alert(response.message);
          }
        },
        error: function () {
          alert("Lỗi khi xóa đơn hàng.");
        }
      });
    });
  });
</script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/checkSession.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/order.js"></script>
</body>
</html>
