<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý giảm giá</title>
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
      <h4>Danh sách giảm giá</h4>
    </div>
    <div class="card-body">
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addDiscountModal">
        Thêm chương trình giảm giá
      </button>
      <table id="discounts" class="table table-bordered display">
        <thead>
        <tr>
          <th>Mã giảm giá</th>
          <th>Ảnh</th>
          <th>Tên giảm giá</th>
          <th>% Giảm</th>
          <th>Ngày bắt đầu</th>
          <th>Ngày kết thúc</th>
          <th>Ngày tạo</th>
          <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="discount" items="${list}">
          <tr>
            <td>${discount.id}</td>
            <td>
            <td><img src="${pageContext.request.contextPath}/${discount.imageUrl}" alt="${discount.imageUrl}" width="60"></td>

            <td>${discount.discountName != null ? discount.discountName : 'Không xác định'}</td>
            <td>
              <f:formatNumber value="${discount.discountPercentage}" type="number"
                              minFractionDigits="0" maxFractionDigits="2"/>%
            </td>
            <td>${discount.startDate}</td>
            <td>${discount.endDate}</td>
            <td>${discount.createdAt}</td>
            <td>
              <button class="btn btn-info btn-sm edit-discount-btn"
                      data-bs-toggle="modal"
                      data-bs-target="#viewEditDiscountModal"
                      data-id="${discount.id}"
                      data-name="${discount.discountName}"
                      data-percentage="${discount.discountPercentage}"
                      data-start="${discount.startDate}"
                      data-end="${discount.endDate}"
                      data-image="${discount.imageUrl}">
                Chỉnh sửa
              </button>

              <button class="btn btn-danger btn-sm"
                      data-bs-toggle="modal"
                      data-bs-target="#deleteDiscountModal"
                      data-discount-id="${discount.id}">
                Xóa
              </button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- Modal: Chỉnh sửa giảm giá -->
<div class="modal fade" id="viewEditDiscountModal" tabindex="-1" aria-labelledby="viewEditDiscountModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="viewEditDiscountModalLabel">Chỉnh sửa giảm giá</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <!-- Form chỉnh sửa thông tin giảm giá -->
        <form id="editDiscountForm" action="${pageContext.request.contextPath}/admin/editDiscount" method="POST">
          <input type="hidden" id="editDiscountId" name="discountId">
          <div class="mb-3">
            <label for="editDiscountName" class="form-label">Tên giảm giá</label>
            <input type="text" class="form-control" id="editDiscountName" name="discountName" required>
          </div>
          <div class="mb-3">
            <label for="editDiscountPercentage" class="form-label">Phần trăm giảm giá</label>
            <input type="number" class="form-control" id="editDiscountPercentage" name="discountPercentage" required>
          </div>
          <div class="mb-3">
            <label for="editStartDate" class="form-label">Ngày bắt đầu</label>
            <input type="date" class="form-control" id="editStartDate" name="startDate" required>
          </div>
          <div class="mb-3">
            <label for="editEndDate" class="form-label">Ngày kết thúc</label>
            <input type="date" class="form-control" id="editEndDate" name="endDate" required>
          </div>

          <!-- Danh sách sản phẩm -->
          <div class="mt-4">
            <h5>Danh sách sản phẩm được giảm giá</h5>
            <table id="discountedProductsTable" class="table table-bordered display">
              <thead>
              <tr>
                <th>Mã sản phẩm</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Hành động</th>
              </tr>
              </thead>
              <tbody id="discountedProductsBody"></tbody>
            </table>

            <h5 class="mt-4">Danh sách sản phẩm chưa được giảm giá</h5>
            <table id="nonDiscountedProductsTable" class="table table-bordered display">
              <thead>
              <tr>
                <th>Mã sản phẩm</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Hành động</th>
              </tr>
              </thead>
              <tbody id="nonDiscountedProductsBody"></tbody>
            </table>
          </div>

          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<!-- Modal: Thêm giảm giá -->
<div class="modal fade" id="addDiscountModal" tabindex="-1" aria-labelledby="addDiscountModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addDiscountModalLabel">Thêm chương trình giảm giá</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="${pageContext.request.contextPath}/admin/discounts/add" method="POST" enctype="multipart/form-data" id="addDiscountForm">
      <div class="modal-body">
          <div class="mb-3">
            <label for="addDiscountName" class="form-label">Tên giảm giá</label>
            <input type="text" class="form-control" id="addDiscountName" name="discountName" required>
          </div>
          <div class="mb-3">
            <label for="addDiscountPercentage" class="form-label">Phần trăm giảm giá</label>
            <input type="number" class="form-control" id="addDiscountPercentage" name="discountPercentage" required>
          </div>
          <div class="mb-3">
            <label for="addStartDate" class="form-label">Ngày bắt đầu</label>
            <input type="date" class="form-control" id="addStartDate" name="startDate" required>
          </div>
          <div class="mb-3">
            <label for="addEndDate" class="form-label">Ngày kết thúc</label>
            <input type="date" class="form-control" id="addEndDate" name="endDate" required>
          </div>
          <div class="mb-3">
            <label for="addImageUrl" class="form-label">Ảnh:</label>
            <input type="file" class="form-control" id="addImageUrl" name="imageUrl" accept="image/*" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
          <button type="submit" class="btn btn-primary">Lưu</button>
        </div>
      </form>

    </div>
  </div>
</div>

<!-- Modal: Xóa giảm giá -->
<div class="modal fade" id="deleteDiscountModal" tabindex="-1" aria-labelledby="deleteDiscountModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="deleteDiscountModalLabel">Xóa giảm giá</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p>Bạn có chắc chắn muốn xóa chương trình giảm giá này không?</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
        <form id="deleteDiscountForm" action="${pageContext.request.contextPath}/admin/deleteDiscount" method="POST">
          <input type="hidden" id="deleteDiscountId" name="discountId">
          <button type="submit" class="btn btn-danger">Xóa</button>
        </form>
      </div>
    </div>
  </div>
</div>


<script>
  $(document).ready(function () {
    $('#discounts').DataTable({
      dom: '<"d-flex justify-content-between align-items-center"lfB>rtip',
      buttons: [
        { extend: 'copy', title: 'Danh sách giảm giá' },
        { extend: 'csv', title: 'Danh sách giảm giá' },
        { extend: 'excel', title: 'Danh sách giảm giá' },
        { extend: 'pdf', title: 'Danh sách giảm giá' },
        { extend: 'print', title: 'Danh sách giảm giá' }
      ]
    });
  });
</script>
<script>
  $(document).on('click', '.edit-discount-btn', function () {
    const id = $(this).data('id');
    const name = $(this).data('name');
    const percentage = $(this).data('percentage');
    const startDate = $(this).data('start');
    const endDate = $(this).data('end');
    const imageUrl = $(this).data('image');

    // Điền thông tin vào form chỉnh sửa
    $('#editDiscountName').val(name);
    $('#editDiscountPercentage').val(percentage);
    $('#editStartDate').val(startDate);
    $('#editEndDate').val(endDate);
    $('#editImageUrl').val(imageUrl);
    $('#editDiscountId').val(id);  // Đảm bảo discountId được gán vào trường ẩn

    // Gửi AJAX để lấy sản phẩm đã giảm giá và chưa giảm giá
    $.ajax({
      url: `${pageContext.request.contextPath}/admin/discountPainting`,  // Đảm bảo URL đúng
      method: 'GET',
      data: { discountId: id },
      success: function (data) {
        console.log('Data received:', data);

        if (data && Array.isArray(data.discountedProducts) && Array.isArray(data.nonDiscountedProducts)) {
          const { discountedProducts, nonDiscountedProducts } = data;

          // Hiển thị sản phẩm đã giảm giá
          let discountedHtml = '';
          discountedProducts.forEach(product => {
            discountedHtml += '<tr>';
            discountedHtml += '<td>' + product.id + '</td>';
            discountedHtml += '<td>' + product.title + '</td>';
            discountedHtml += '<td>' + product.price + '</td>';
            discountedHtml += '<td>';
            discountedHtml += '<button class="btn btn-danger btn-sm remove-from-discount" data-product-id="' + product.id + '">';
            discountedHtml += 'Xóa khỏi giảm giá';
            discountedHtml += '</button>';
            discountedHtml += '</td>';
            discountedHtml += '</tr>';
          });


          $('#discountedProductsBody').html(discountedHtml);

          // Hiển thị sản phẩm chưa giảm giá
          let nonDiscountedHtml = '';
          nonDiscountedProducts.forEach(product => {
            nonDiscountedHtml += '<tr>';
            nonDiscountedHtml += '<td>' + product.id + '</td>';
            nonDiscountedHtml += '<td>' + product.title + '</td>';
            nonDiscountedHtml += '<td>' + product.price + '</td>';
            nonDiscountedHtml += '<td>';
            nonDiscountedHtml += '<button class="btn btn-primary btn-sm add-to-discount" data-product-id="' + product.id + '">';
            nonDiscountedHtml += 'Thêm vào giảm giá';
            nonDiscountedHtml += '</button>';
            nonDiscountedHtml += '</td>';
            nonDiscountedHtml += '</tr>';
          });

          $('#nonDiscountedProductsBody').html(nonDiscountedHtml);

          // Khởi tạo lại DataTable sau khi cập nhật dữ liệu
          $('#discountedProductsTable').DataTable().clear().destroy();
          $('#discountedProductsTable').DataTable();

          $('#nonDiscountedProductsTable').DataTable().clear().destroy();
          $('#nonDiscountedProductsTable').DataTable();
        } else {
          console.error('Dữ liệu không đúng định dạng');
        }
      },
      error: function (xhr, status, error) {
        console.error('AJAX Error:', status, error);
      }
    });
  });
  $(document).on('click', '.remove-from-discount', function () {
    const productId = $(this).data('product-id');
    const discountId = $('#editDiscountId').val();

    $.ajax({
      url: `${pageContext.request.contextPath}/admin/removePaintingFromDiscount`,
      method: 'POST',
      data: { productId, discountId },
      success: function () {
        alert('Xóa sản phẩm thành công!');
        // Tải lại danh sách
        $(`.edit-discount-btn[data-id="${discountId}"]`).click();
      },
      error: function () {
        alert('Có lỗi xảy ra!');
      }
    });
  });
  $(document).on('click', '.add-to-discount', function () {
    const productId = $(this).data('product-id');
    const discountId = $('#editDiscountId').val();

    $.ajax({
      url: `${pageContext.request.contextPath}/admin/assignDiscount`,
      method: 'POST',
      data: { productId, discountId },
      success: function () {
        alert('Thêm sản phẩm vào giảm giá thành công!');
        // Tải lại danh sách sản phẩm
        $(`.edit-discount-btn[data-id="${discountId}"]`).click();
      },
      error: function () {
        alert('Có lỗi xảy ra!');
      }
    });
  });
  $(document).on('click', '[data-bs-target="#deleteDiscountModal"]', function () {
    const discountId = $(this).data('discount-id');
    $('#deleteDiscountId').val(discountId);
  });

</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</body>
</html>
