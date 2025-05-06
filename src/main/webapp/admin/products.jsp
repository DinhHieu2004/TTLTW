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

   .modal-body {
     padding: 2rem;
   }
  .form-group {
    margin-bottom: 1.5rem;
  }
  .form-label {
    font-weight: 500;
    margin-bottom: 0.5rem;
  }
  .form-control, .form-select {
    padding: 0.625rem;
    border-radius: 0.375rem;
  }
  #sizeQuantityContainer {
    background-color: #f8f9fa;
    padding: 1.5rem;
    border-radius: 0.5rem;
    margin-top: 1rem;
  }
  .size-quantity-pair {
    background-color: white;
    padding: 1rem;
    border-radius: 0.375rem;
    margin-bottom: 1rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  }
  .modal-footer {
    padding: 1rem 2rem;
    border-top: 1px solid #dee2e6;
  }
  .btn-primary {
    padding: 0.5rem 1.5rem;
  }
  #addSizeField {
    margin-top: 1rem;
    width: auto;
  }
  .modal-body {
    padding: 2rem;
  }
  .size-quantity-pair {
    background-color: #f8f9fa;
    padding: 0.75rem;
    border-radius: 0.375rem;
    margin-bottom: 0.5rem;
  }
  .form-label {
    font-weight: 500;
    margin-bottom: 0.25rem;
    font-size: 0.9rem;
  }
  .form-control-sm {
    height: 30px;
    padding: 0.25rem 0.5rem;
  }
  .d-flex {
    display: flex;
  }
  .w-50 {
    width: 50%;
  }


  </style>
</head>
<body>
<!-- Sidebar -->
<%@ include file="/admin/sidebar.jsp" %>
<div class="content">

  <div style="padding-bottom: 10px">
    <c:if test="${not empty message}">
      <div class="alert alert-success">
          ${message}
      </div>
    </c:if>
  </div>
  <div class="card mb-4">
    <div class="card-header bg-success text-white" style="background: #e7621b !important;">
      <h4>Tranh</h4>

<%-- Thêm tranh--%>
    </div>
    <div class="card-body">
      <table id="products" class="table table-bordered display">

        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPaintingModal">
          Thêm tranh
        </button>
        <thead>
        <tr>
          <th>Mã sản phẩm</th>
          <th>Ảnh</th>
          <th>Tên </th>
          <th>Trạng thái</th>
          <th>giá</th>
          <th>Ngày tạo</th>
          <th>tác giả</th>
          <th>Hành Động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${products}">
          <tr>
            <td>${p.id}</td>
            <td>
              <c:choose>
                <c:when test="${not empty p.imageUrlCloud}">
                  <img loading="lazy"
                       src="${p.imageUrlCloud}?f_auto,q_auto,w_60"
                       alt="${p.imageUrl}"
                       width="60">
                </c:when>
                <c:otherwise>
                  <img loading="lazy"
                       src="${pageContext.request.contextPath}/${p.imageUrl}"
                       alt="${p.imageUrl}"
                       width="60">
                </c:otherwise>
              </c:choose>
            </td>
            <td>${p.title}</td>
            <td>${p.available ? 'Không hoạt động' : 'Hoạt động'}</td>
            <td>${p.price}</td>
            <td>${p.createDate}</td>
            <td>${p.artistName}</td>
            <td><button class="btn btn-info btn-sm edit-painting"
                        data-bs-toggle="modal"
                        data-bs-target="#viewAndEditModal"
                        data-product-id="${p.id}">Xem Chi Tiết</button>

              <button class="btn btn-danger btn-sm delete-painting"
                      data-bs-toggle="modal"
                      data-bs-target="#deleteProductModal"
                      data-product-id="${p.id}">Xóa</button>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>


  <div class="row">
    <div class="col-6">
      <div class="card mb-4">
        <div class="card-header bg-secondary text-white">
          <h4>Danh sách Chủ Đề</h4>
        </div>
        <div class="card-body">
          <table id="themes" class="table table-bordered display">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addThemeModal">
              Thêm chủ đề
            </button>
            <thead>
            <tr>
              <th>ID</th>
              <th>Tên Chủ Đề</th>
              <th>Hành Động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="theme" items="${t}">
              <tr>
                <td>${theme.id}</td>
                <td class="theme-name">${theme.themeName}</td>
                <td>
                  <button class="btn btn-info btn-sm edit-theme"
                          data-bs-toggle="modal"
                          data-bs-target="#editThemeModal"
                          data-theme-id="${theme.id}" >Chi tiết</button>
                  <button class="btn btn-danger btn-sm delete-theme"
                          data-bs-toggle="modal"
                          data-bs-target="#deleteThemeModal"
                          data-theme-id="${theme.id}">Xóa</button>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="col-6">
      <div class="card mb-4">
        <div class="card-header bg-secondary text-white">
          <h4>Danh sách Kích Thước</h4>
        </div>
        <div class="card-body">
          <table id="sizes" class="table table-bordered display">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addSizeModal">
              Thêm kích thước
            </button>
            <thead>
            <tr>
              <th>ID</th>
              <th>Tên Kích thước</th>
              <th>Hành Động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="s" items="${s}">
              <tr>
                <td>${s.idSize}</td>
                <td>${s.sizeDescriptions}</td>
                <td>
                  <button class="btn btn-info btn-sm edit-size"
                          data-bs-toggle="modal"
                          data-bs-target="#editSizeModal"
                          data-size-id="${s.idSize}">Chi tiết</button>
                  <button class="btn btn-danger btn-sm delete-size"
                          data-bs-toggle="modal"
                          data-bs-target="#deleteSizeModal"
                          data-size-id="${s.idSize}">Xóa</button>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

<!-- Modal thêm tranh -->
<div class="modal fade" id="addPaintingModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form id="addPaintingForm" enctype="multipart/form-data">
        <div class="modal-header">
          <h5 class="modal-title">Thêm Tranh</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="row mb-3">
            <div class="col-md-6">
              <label class="form-label">Tiêu đề</label>
              <input type="text" class="form-control form-control-sm" name="title" required>
            </div>

            <div class="col-md-6">
              <label class="form-label">Chủ đề</label>
              <select class="form-select form-select-sm" name="themeId" required>
                <c:forEach var="t" items="${t}">
                  <option value="${t.id}">${t.themeName}</option>
                </c:forEach>
              </select>
            </div>
          </div>
            <div class="mb-3">
            <label class="form-label">Mô tả</label>
            <textarea class="form-control form-control-sm" name="description" rows="4"
                      placeholder="Nhập mô tả chi tiết về tranh..."></textarea>
            </div>

          <div class="row mb-3">
            <div class="col-md-6">
              <label class="form-label">Giá</label>
              <input type="number" step="0.01" class="form-control form-control-sm" name="price" required>
            </div>
            <div class="col-md-6">
              <label class="form-label">Họa sĩ</label>
              <select class="form-select form-select-sm" name="artistId" required>
                <c:forEach var="artist" items="${a}">
                <option value="${artist.id}">${artist.name}</option>
                </c:forEach>

              </select>
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label">Ảnh tranh</label>
            <input type="file" class="form-control form-control-sm" name="image" accept="image/*" required>
          </div>

          <div class="mb-3">
            <div class="form-check">
              <input type="checkbox" class="form-check-input" id="isFeatured" name="isFeatured">
              <label class="form-check-label" for="isFeatured">Tranh nổi bật</label>
            </div>
          </div>

<%--          <div class="size-quantities">--%>
<%--            <label class="form-label">Kích thước và Số lượng</label>--%>
<%--              <c:forEach var="size" items="${s}">--%>
<%--                <div class="size-quantity-pair">--%>
<%--                  <div class="row g-2">--%>
<%--                    <div class="col-7">--%>
<%--                      <input type="hidden" name="sizeId[]" value="${size.idSize}">--%>
<%--                      <input type="text" class="form-control form-control-sm" name="size" value="${size.sizeDescriptions}" readonly>--%>
<%--                    </div>--%>
<%--                    <div class="col-5">--%>
<%--                      <input type="number" class="form-control form-control-sm" name="quantity[]" value="0" min="0">--%>
<%--                    </div>--%>
<%--                  </div>--%>
<%--                </div>--%>
<%--              </c:forEach>--%>
<%--          </div>--%>
          <div class="size-quantities">
            <label class="form-label">Kích thước</label>
            <c:forEach var="size" items="${s}">
              <div class="mb-2">
                <input type="hidden" name="sizeId[]" value="${size.idSize}">
                <input type="text" class="form-control form-control-sm" name="size" value="${size.sizeDescriptions}" readonly>
              </div>
            </c:forEach>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Đóng</button>
          <button type="submit" class="btn btn-primary btn-sm">Thêm</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- sửa tranh -->
  <div class="modal fade" id="viewAndEditModal" tabindex="-1">
    <div class="modal-dialog">
      <div class="modal-content">
        <form id="editPaintingForm" enctype="multipart/form-data">
          <input type="hidden" id="editPaintingId" name="pid" value="">

          <div class="modal-header">
            <h5 class="modal-title">Chi tiết</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="row mb-3">
              <div class="col-md-6">
                <label class="form-label">Tiêu đề</label>
                <input type="text" class="form-control form-control-sm" name="title">
              </div>

              <div class="col-md-6">
                <label class="form-label">Chủ đề</label>
                <select class="form-select form-select-sm" name="themeId">
                  <c:forEach var="t" items="${t}">
                    <option value="${t.id}">${t.themeName}</option>
                  </c:forEach>
                </select>
              </div>
            </div>
            <div class="mb-3">
              <label class="form-label">Mô tả</label>
              <textarea class="form-control form-control-sm" name="description" rows="4"
                        placeholder="Nhập mô tả chi tiết về tranh..."></textarea>
            </div>
            <div class="col-md-6">
              <label class="form-label">Ngày tạo</label>
              <input type="date" class="form-control form-control-sm" name="createdDate">

            </div>

            <div class="row mb-3">
              <div class="col-md-6">
                <label class="form-label">Giá</label>
                <input type="number" step="0.01" class="form-control form-control-sm" name="price">
              </div>
              <div class="col-md-6">
                <label class="form-label">Họa sĩ</label>
                <select class="form-select form-select-sm" name="artistId">
                  <c:forEach var="artist" items="${a}">
                    <option value="${artist.id}">${artist.name}</option>
                  </c:forEach>

                </select>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label">Ảnh tranh</label>
              <input type="file" class="form-control form-control-sm" name="image" accept="image/*">
            </div>

            <div class="mb-3">
              <div class="form-check">
                <input type="checkbox" class="form-check-input" id="isFeaturedEdit" name="isFeatured">
                <label class="form-check-label" for="isFeatured">Tranh nổi bật</label>
              </div>
            </div>
            <div class="mb-3">
              <div class="form-check">
                <input type="checkbox" class="form-check-input" id="isSoldEdit" name="isSold">
                <label class="form-check-label" for="isSoldEdit">Còn hàng</label>
              </div>
            </div>

            <div class="size-quantities">
              <label class="form-label">Kích thước và Số lượng</label>

              <div class="row fw-bold border-bottom pb-2 mb-2 text-center">
                <div class="col-md-3" style="font-size: 0.85rem;">Kích thước</div>
                <div class="col-md-2" style="font-size: 0.85rem;">Tổng</div>
                <div class="col-md-2" style="font-size: 0.85rem;">Đã Đặt</div>
                <div class="col-md-3" style="font-size: 0.85rem;">Có Sẵn</div>
              </div>
              <c:forEach var="size" items="${sizes}">
                <div class="size-quantity-pair">
                  <div class="row g-2">
                    <div class="col-md-4">
                      <input type="hidden" name="sizeId[]" value="${size.idSize}">
                      <input type="text" class="form-control form-control-sm" name="size" value="${size.sizeDescriptions}" readonly>
                    </div>
                    <div class="col-md-2">
                      <p class="total-quantity"></p>
                    </div>
                    <div class="col-md-2">
                      <p class="reserved-quantity"></p>
                    </div>
                    <div class="col-md-4">
                      <input type="number" class="form-control form-control-sm" name="quantity[]" min="0"
                             max=""
                             title="Số lượng còn lại (Tổng - Đặt trước)">
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>

          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Đóng</button>
            <button type="submit" class="btn btn-primary btn-sm">Lưu thay đổi</button>
          </div>
        </form>
      </div>
    </div>
  </div>

<%--  Xóa tranh --%>
  <div class="modal fade" id="deleteProductModal" tabindex="-1" aria-labelledby="deleteProductModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="deleteProductModalLabel">Xác nhận xóa</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form id="deletePaintingForm">
          <div class="modal-body">
            <p>Bạn có chắc chắn muốn xóa sản phẩm này?</p>
            <input type="hidden" id="pidToDelete" name="pid">
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <button type="submit" class="btn btn-danger">Xóa</button>
          </div>
        </form>
      </div>
    </div>
  </div>

</div>


<!-- Modal thêm Theme -->
<div class="modal" id="addThemeModal" tabindex="-1" aria-labelledby="addThemeModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addThemeModalLabel">Thêm Chủ Đề</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="addThemeForm">
          <div class="mb-3">
            <label for="themeName" class="form-label">Tên Chủ Đề</label>
            <input type="text" class="form-control" id="themeName" name="themeName" required>
          </div>
          <button type="submit" class="btn btn-primary">Thêm Chủ Đề</button>
        </form>
      </div>
    </div>
  </div>
</div>


<!-- Modal edit Theme -->
<div class="modal fade" id="editThemeModal" tabindex="-1" aria-labelledby="editThemeModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="editThemeModalLabel">Thông tin chủ đề</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="editThemeForm">
          <input type="hidden" id="editThemeId" name="themeId" value="">

          <div class="mb-3">
            <label for="idTheme" class="form-label">Mã chủ đề: #</label>
            <strong id="idTheme"></strong>
          </div>
          <div class="mb-3">
            <label for="editThemeName" class="form-label">Tên Chủ Đề</label>
            <input type="text" class="form-control" id="editThemeName" name="themeName" required>
          </div>
          <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
        </form>
      </div>
    </div>
  </div>
</div>
<!-- Modal xóa Theme -->

<div class="modal fade" id="deleteThemeModal" tabindex="-1" aria-labelledby="deleteThemeModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="deleteThemeModalLabel">Xác nhận xóa</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form id="deleteThemeForm">
        <div class="modal-body">
          <p>Bạn có chắc chắn muốn xóa chủ đề này?</p>
          <input type="hidden" id="themeIdToDelete" name="themeId">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-danger">Xóa</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%--Thêm Size--%>
<div class="modal fade" id="addSizeModal" tabindex="-1" aria-labelledby="addSizeModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addSizeModalLabel">Thêm Kích Thước</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="addSizeForm">
          <div class="mb-3">
            <label for="sizeName" class="form-label">Tên Kích Thước</label>
            <input type="text" class="form-control" id="sizeName" name="description" required>
          </div>
          <button type="submit" class="btn btn-primary">Thêm Kích Thước</button>
        </form>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="editSizeModal" tabindex="-1" aria-labelledby="editSizeModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="editSizeModalLabel">Thông tin chủ đề</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="editSizeForm">
          <input type="hidden" id="editSizeId" name="sizeId" value="">

          <div class="mb-3">
            <label for="idSize" class="form-label">Mã kích thước: #</label>
            <strong id="idSize"></strong>
          </div>
          <div class="mb-3">
            <label for="editDescription" class="form-label">Mô tả kích thươc</label>
            <input type="text" class="form-control" id="editDescription" name="description" required>
          </div>
          <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
        </form>
      </div>
    </div>
  </div>
</div>

<!-- Modal xóa Size -->

<div class="modal fade" id="deleteSizeModal" tabindex="-1" aria-labelledby="deleteSizeModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="deleteSizeModalLabel">Xác nhận xóa</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form id="deleteSizeForm">
        <div class="modal-body">
          <p>Bạn có chắc chắn muốn xóa kích thước này?</p>
          <input type="hidden" id="sizeIdToDelete" name="sizeId">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-danger">Xóa</button>
        </div>
      </form>
    </div>
  </div>
</div>
<script>
  $(document).ready(function () {
    let table = $('#products').DataTable({
      "order": [[5, "desc"]],
      "columnDefs": [
        { "type": "date", "targets": 5 }
      ],
      dom: '<"d-flex justify-content-between align-items-center"lfB>rtip',
      buttons: [
        { extend: 'copy', title: 'Danh sách sản phẩm' },
        { extend: 'csv', title: 'Danh sách sản phẩm' },
        { extend: 'excel', title: 'Danh sách sản phẩm' },
        { extend: 'pdf', title: 'Danh sách sản phẩm' },
        { extend: 'print', title: 'Danh sách sản phẩm' }
      ]
    });

    let table2 = $('#sizes').DataTable({
    });

    let table3 = $('#themes').DataTable({
    });
  });

  document.querySelectorAll('[data-bs-target="#deleteProductModal"]').forEach(button => {
    button.addEventListener('click', function() {
      let pid = this.getAttribute('data-product-id');
      document.getElementById('pidToDelete').value = pid;
    });
  });
  document.querySelectorAll('[data-bs-target="#deleteThemeModal"]').forEach(button => {
    button.addEventListener('click', function() {
      let themeId = this.getAttribute('data-theme-id');
      document.getElementById('themeIdToDelete').value = themeId;
    });
  });
  document.querySelectorAll('[data-bs-target="#deleteSizeModal"]').forEach(button => {
    button.addEventListener('click', function() {
      let sizeId = this.getAttribute('data-size-id');
      document.getElementById('sizeIdToDelete').value = sizeId;
    });
  });
</script>

<script>
  // thêm theme
  $(document).ready(function () {
    var table = $('#themes').DataTable();

    $("#addThemeForm").submit(function (event) {
      event.preventDefault();
      var themeName = $("#themeName").val();

      $.ajax({
        type: "POST",
        url: "themes/add",
        data: { themeName: themeName },
        dataType: "json",
        success: function (response) {
          if (response.success) {
            // Thêm hàng mới
            table.row.add([
              response.id,
              themeName,
              '<button class="btn btn-info btn-sm edit-theme" data-theme-id="' + response.id + '">Chi tiết</button> ' +
              '<button class="btn btn-danger btn-sm delete-theme" data-theme-id="' + response.id + '">Xóa</button>'
            ]).draw();
            $('#addThemeModal').modal('hide');
            $("#addThemeForm")[0].reset();
          }
        }
      });
    });
  });

  // xóa theme (event deligation)
  $(document).ready(function () {
    $(document).on('click', '.delete-theme', function () {
      $('#themeIdToDelete').val($(this).data('theme-id'));
      $('#deleteThemeModal').modal('show');
    });

    $('#deleteThemeForm').on('submit', function (event) {
      event.preventDefault();
      var themeId = $('#themeIdToDelete').val();

      $.ajax({
        type: 'POST',
        url: 'themes/delete',
        data: { themeId: themeId },
        dataType: 'json',
        success: function (response) {
          if (response.success) {
            var $row = $('[data-theme-id="' + themeId + '"]').closest('tr');
            $('#themes').DataTable().row($row).remove().draw();
            $('#deleteThemeModal').modal('hide');
          }
        }
      });
    });
  });
  // sửa theme
  $(document).ready(function () {
    var table = $('#themes').DataTable();

    // Khi bấm nút "Chi tiết" để mở modal sửa theme
    $(document).on('click', '.edit-theme', function (event) {
      event.preventDefault();
      var themeId = $(this).data('theme-id');
      var themeName = $(this).closest('tr').find('td:eq(1)').text().trim();

      // Gán dữ liệu vào modal chỉnh sửa
      $('#editThemeId').val(themeId);
      $('#editThemeName').val(themeName);
      $('#idTheme').text(themeId);
      $('#editThemeModal').modal('show');
    });

    // Xử lý cập nhật theme khi submit form
    $("#editThemeForm").submit(function (event) {
      event.preventDefault();
      var themeId = $("#editThemeId").val();
      var themeName = $("#editThemeName").val();

      $.ajax({
        type: "POST",
        url: "themes/update",
        data: { themeId: themeId, themeName: themeName },
        dataType: "json",
        success: function (response) {
          if (response.success) {
            // Cập nhật tên theme trong bảng DataTable
            var $row = $('button[data-theme-id="' + themeId + '"]').closest('tr');
            table.cell($row, 1).data(themeName).draw();

            $('#editThemeModal').modal('hide'); // Đóng modal
          } else {
            alert(response.message);
          }
        },
        error: function () {
          alert("Lỗi khi cập nhật theme.");
        }
      });
    });
  });
</script>
<script>
  $(document).ready(function () {
    var table = $('#sizes').DataTable();

    // thêm size
    $("#addSizeForm").submit(function (event) {
      event.preventDefault();
      var sizeDescription = $("#sizeName").val();

      $.ajax({
        type: "POST",
        url: "sizes/add",
        data: { description: sizeDescription },
        dataType: "json",
        success: function (response) {
          if (response.success) {
            // Thêm hàng mới
            table.row.add([
              response.id,
              sizeDescription,
              '<button class="btn btn-info btn-sm edit-size" data-size-id="' + response.id + '">Chi tiết</button> ' +
              '<button class="btn btn-danger btn-sm delete-size" data-size-id="' + response.id + '">Xóa</button>'
            ]).draw();

            $('#addSizeModal').modal('hide');
            $("#addSizeForm")[0].reset();
          } else {
            alert(response.message);
          }
        },
        error: function () {
          alert("Lỗi khi thêm kích thước.");
        }
      });
    });

    // Xóa size
    $(document).on('click', '.delete-size', function () {
      $('#sizeIdToDelete').val($(this).data('size-id'));
      $('#deleteSizeModal').modal('show');
    });

    $('#deleteSizeForm').submit(function (event) {
      event.preventDefault();
      var sizeId = $('#sizeIdToDelete').val();

      $.ajax({
        type: 'POST',
        url: 'sizes/delete',
        data: { sizeId: sizeId },
        dataType: 'json',
        success: function (response) {
          if (response.success) {
            var $row = $('[data-size-id="' + sizeId + '"]').closest('tr');
            table.row($row).remove().draw();
            $('#deleteSizeModal').modal('hide');
          } else {
            alert(response.message);
          }
        },
        error: function () {
          alert("Lỗi khi xóa kích thước.");
        }
      });
    });

    // edit size
    $(document).on('click', '.edit-size', function (event) {
      event.preventDefault();
      var sizeId = $(this).data('size-id');
      var sizeDescription = $(this).closest('tr').find('td:eq(1)').text().trim();

      $('#editSizeId').val(sizeId);
      $('#editDescription').val(sizeDescription);
      $('#idSize').text(sizeId);
      $('#editSizeModal').modal('show');
    });

    $("#editSizeForm").submit(function (event) {
      event.preventDefault();
      var sizeId = $("#editSizeId").val();
      var sizeDescription = $("#editDescription").val();

      $.ajax({
        type: "POST",
        url: "sizes/update",
        data: { sizeId: sizeId, description: sizeDescription },
        dataType: "json",
        success: function (response) {
          if (response.success) {
            var $row = $('button[data-size-id="' + sizeId + '"]').closest('tr');
            table.cell($row, 1).data(sizeDescription).draw();
            $('#editSizeModal').modal('hide');
          } else {
            alert(response.message);
          }
        },
        error: function () {
          alert("Lỗi khi cập nhật kích thước.");
        }
      });
    });
  });
</script>

<script>
  // add painting
  $(document).ready(function () {
    var table = $('#products').DataTable();

    $("#addPaintingForm").submit(function (event) {
      event.preventDefault();
      var formData = new FormData(this);

      $.ajax({
        type: "POST",
        url: "paintings/add",
        data: formData,
        processData: false,
        contentType: false,
        dataType: "json",
        success: function (response) {
          if (response.success) {
            var imageUrl = response.painting.imageUrl;
            table.row.add([
              response.painting.id,
              '<img src="' + imageUrl + '" width="60">',
              response.painting.title,
              response.painting.available ? 'Không hoạt động' : 'Hoạt động',
              response.painting.price.toFixed(1),
              response.painting.createDate,
              response.painting.artistName,
              '<button class="btn btn-info btn-sm edit-painting" data-bs-toggle="modal" data-bs-target="#viewAndEditModal" data-product-id="' + response.painting.id + '">Xem Chi Tiết</button> ' +
              '<button class="btn btn-danger btn-sm delete-painting" data-product-id="' + response.painting.id + '">Xóa</button>'
            ]).draw();

            $('#addPaintingModal').modal('hide');
            $("#addPaintingForm")[0].reset();
          } else {
            alert(response.message);
          }
        },
        error: function(xhr) {
          alert("Lỗi server: " + xhr.responseText);
        }
      });
    });
  });
// delete
  $(document).ready(function () {
    var table = $('#products').DataTable();

    $(document).on("click", ".delete-painting", function () {
      var paintingId = $(this).data("product-id");
      $("#pidToDelete").val(paintingId);
      $("#deleteProductModal").modal("show");
    });

    $("#deletePaintingForm").submit(function (event) {
      event.preventDefault();
      var paintingId = $("#pidToDelete").val();

      $.ajax({
        type: "POST",
        url: "products/delete",
        data: { pid: paintingId },
        dataType: "json",
        success: function (response) {
          if (response.success) {
            var $row = $('[data-product-id="' + paintingId + '"]').closest('tr');
            table.row($row).remove().draw();
            $("#deleteProductModal").modal("hide");
          } else {
            alert(response.message);
          }
        },
        error: function () {
          alert("Lỗi khi xóa tranh.");
        }
      });
    });
  });
// update
$(document).on('click', '.edit-painting', function (event) {
  event.preventDefault();

  var $row = $(this).closest('tr');
  var paintingId = $(this).data('product-id');
  var imageUrl = $row.find('img').attr('src');
  var title = $row.find('td:eq(2)').text().trim();
  var price = parseFloat($row.find('td:eq(4)').text().replace(/[^0-9.]/g, ''));
  var available = $row.find('td:eq(3)').text().trim() === 'Hoạt động';
  var artistName = $row.find('td:eq(6)').text().trim();

  // dua du lieu vào modal
  $('#editPaintingId').val(paintingId);
  $('#editTitle').val(title);
  $('#editPrice').val(price.toFixed(1));
  $('#editAvailable').prop('checked', available);
  $('#currentImage').attr('src', imageUrl);

  $('#viewAndEditModal').modal('show');
});

$("#editPaintingForm").submit(function (event) {
  event.preventDefault();

  var formData = new FormData(this);
  var paintingId = $('#editPaintingId').val();

  $.ajax({
    type: "POST",
    url: "paintings/update",
    data: formData,
    processData: false,
    contentType: false,
    dataType: "json",
    success: function (response) {
      if (response.success) {
        // Cập nhật DataTable
        var $row = $('button[data-product-id="' + paintingId + '"]').closest('tr');
        var table = $('#products').DataTable();

        // cập nhat du lieu
        table.cell($row, 2).data(response.painting.title);
        table.cell($row, 3).data(response.painting.available ? 'Không hoạt động' : 'Hoạt động');
        table.cell($row, 4).data(parseFloat(response.painting.price).toFixed(1));
        table.cell($row, 6).data(response.painting.artistName);

        if(response.painting.imageUrl) {
          table.cell($row, 1).data('<img src="' + response.painting.imageUrl + '" width="60">');
        }

        table.draw();
        $('#viewAndEditModal').modal('hide');
      } else {
        alert(response.message);
      }
    },
    error: function(xhr) {
      alert("Lỗi server: " + xhr.responseText);
    }
  });
});
</script>



<script src="${pageContext.request.contextPath}/assets/js/admin/product.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/sizes.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/checkSession.js"></script>
</body>
</html>
