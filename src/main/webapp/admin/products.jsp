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
            <td><img src="${pageContext.request.contextPath}/${p.imageUrl}" alt="${p.imageUrl}" width="60"></td>

            <td>${p.title}</td>
            <td>${p.available ? 'Không hoạt động' : 'Hoạt động'}</td>
            <td>${p.price}</td>
            <td>${p.createDate}</td>
            <td>${p.artistName}</td>
            <td><button class="btn btn-info btn-sm" data-bs-toggle="modal"
                        data-bs-target="#viewAndEditModal" data-product-id="${p.id}">Xem Chi Tiết</button>

              <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                      data-bs-target="#deleteProductModal" data-product-id="${p.id}">Xóa</button>
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
                <td>${theme.themeName}</td>
                <td>
                  <button class="btn btn-info btn-sm" data-bs-toggle="modal"
                          data-bs-target="#editThemeModal" data-theme-id="${theme.id}">Chi tiết</button>
                  <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                          data-bs-target="#deleteThemeModal" data-theme-id="${theme.id}">Xóa</button>
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
          <h4>Danh sách Kích Thước</h4> <!-- Sửa tên cho đúng -->
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
                  <button class="btn btn-info btn-sm" data-bs-toggle="modal"
                          data-bs-target="#editSizeModal" data-size-id="${s.idSize}">chi tiết</button>
                  <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                          data-bs-target="#deleteSizeModal" data-size-id="${s.idSize}">Xóa</button>
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
      <form action="${pageContext.request.contextPath}/admin/paintings/add" method="post" enctype="multipart/form-data">
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

          <div class="size-quantities">
            <label class="form-label">Kích thước và Số lượng</label>
              <c:forEach var="size" items="${s}">
                <div class="size-quantity-pair">
                  <div class="row g-2">
                    <div class="col-7">
                      <input type="hidden" name="sizeId[]" value="${size.idSize}">
                      <input type="text" class="form-control form-control-sm" name="size" value="${size.sizeDescriptions}" readonly>
                    </div>
                    <div class="col-5">
                      <input type="number" class="form-control form-control-sm" name="quantity[]" value="0" min="0">
                    </div>
                  </div>
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

<!--view and edit -->
  <div class="modal fade" id="viewAndEditModal" tabindex="-1">
    <div class="modal-dialog">
      <div class="modal-content">
        <form action="${pageContext.request.contextPath}/admin/paintings/update" method="post" enctype="multipart/form-data">
          <input type="hidden" id="editProductId" name="pid" value="">

          <div class="modal-header">
            <h5 class="modal-title">Chi tiết</h5>
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
            <div class="col-md-6">
              <label class="form-label">Ngày tạo</label>
              <input type="date" class="form-control form-control-sm" name="createdDate">

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
              <c:forEach var="size" items="${s}">
                <div class="size-quantity-pair">
                  <div class="row g-2">
                    <div class="col-7">
                      <input type="hidden" name="sizeId[]" value="${size.idSize}">
                      <input type="text" class="form-control form-control-sm" name="size" value="${size.sizeDescriptions}" readonly>
                    </div>
                    <div class="col-5">
                      <input type="number" class="form-control form-control-sm" name="quantity[]" value="0" min="0">
                    </div>
                  </div>
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

  <div class="modal fade" id="deleteProductModal" tabindex="-1" aria-labelledby="deleteProductModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="deleteProductModalLabel">Xác nhận xóa</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/products/delete" method="POST">
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
            <label for="themeName" class="form-label">Tên Chủ Đề</label>
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
        <form action="${pageContext.request.contextPath}/admin/sizes/add" method="POST">
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
        <form action="${pageContext.request.contextPath}/admin/sizes/update" method="POST">
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
      <form action="${pageContext.request.contextPath}/admin/sizes/delete" method="POST">
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
    $('#products').DataTable({
      "order": [[5, "desc"]],
      "columnDefs": [
        { "type": "date", "targets": 5 }
      ]
    });
    $('#sizes').DataTable({

    });
    $('#themes').DataTable({

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



<script src="${pageContext.request.contextPath}/assets/js/admin/product.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/sizes.js"></script>
</body>
</html>
