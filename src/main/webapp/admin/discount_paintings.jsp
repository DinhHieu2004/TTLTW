<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sản phẩm giảm giá</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
</head>
<body>
<div class="container mt-4">
  <!-- Hiển thị tên chương trình giảm giá -->
  <h2 class="mb-4">Sản phẩm trong chương trình giảm giá: <span>${discountName}</span></h2>

  <!-- Nút thêm sản phẩm -->
  <c:if test="${not empty discountId}">
    <a href="${pageContext.request.contextPath}/admin/addProductDiscount?discountId=${discountId}" class="btn btn-info btn-sm">
      Thêm sản phẩm
    </a>
  </c:if>

  <!-- Hiển thị danh sách sản phẩm dưới dạng DataTable -->
  <table id="paintingsTable" class="table table-bordered table-striped">
    <thead>
    <tr>
      <th>ID</th>
      <th>Tên</th>
      <th>Họa sĩ</th>
      <th>Giá</th>
      <th>Hành động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="painting" items="${paintings}">
      <tr>
        <td>${painting.id}</td>
        <td>${painting.title}</td>
        <td>${painting.artistName}</td>
        <td>${painting.price}</td>
        <td>
          <!-- Nút xóa -->
          <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#confirmDeleteModal" data-product-id="${painting.id}" data-discount-id="${discountId}">
            Xóa
          </button>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>

<!-- Modal xác nhận xóa -->
<div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-labelledby="confirmDeleteModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="confirmDeleteModalLabel">Xác nhận xóa</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        Bạn có chắc chắn muốn xóa sản phẩm này khỏi chương trình giảm giá?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
        <a id="confirmDeleteBtn" class="btn btn-danger">Xóa</a>
      </div>
    </div>
  </div>
</div>
<script>
  $(document).ready(function () {
    $('#paintingsTable').DataTable();
  });
</script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  $(document).ready(function() {
    $('#paintingsTable').DataTable({});

    // Khi nhấn vào nút xóa, lưu thông tin sản phẩm và chương trình giảm giá vào modal
    $('#confirmDeleteModal').on('show.bs.modal', function(event) {
      var button = $(event.relatedTarget); // Nút xóa được nhấn
      var productId = button.data('product-id');
      var discountId = button.data('discount-id');

      // Cập nhật URL của nút xác nhận xóa
      var deleteUrl = '${pageContext.request.contextPath}/admin/removePaintingFromDiscount?discountId=' + discountId + '&productId=' + productId;
      $('#confirmDeleteBtn').attr('href', deleteUrl);
    });
  });
</script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/checkSession.js"></script>
</body>
</html>




