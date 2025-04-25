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
      <h4>Họa sĩ</h4>
    </div>
    <div class="card-body">
      <table id="artists" class="table table-bordered display">
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addArtistModal">
          Thêm họa sĩ
        </button>
        </tr>
        <div style="padding-bottom: 10px">
          <c:if test="${not empty message}">
            <div class="alert alert-success">
                ${message}
            </div>
          </c:if>
        </div>
        <thead>
        <tr>
          <th>Mã họa sĩ</th>
          <th>Ảnh</th>
          <th>Tên họa sĩ</th>
          <th>Ngày sinh</th>
          <th>Quốc tịch</th>
          <th>Hành Động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${artists}">
          <tr>
            <td>${u.id}</td>
            <td>
              <c:choose>
                <c:when test="${not empty u.imageUrlCloud}">
                  <img loading="lazy"
                       src="${u.imageUrlCloud}?f_auto,q_auto,w_60"
                       alt="${u.name}"
                       width="60">
                </c:when>
                <c:otherwise>
                  <img loading="lazy"
                       src="${pageContext.request.contextPath}/${u.photoUrl}"
                       alt="${u.name}"
                       width="60">
                </c:otherwise>
              </c:choose>
            </td>
            <td>${u.name}</td>
            <td>${u.birthDate}</td>
            <td>${u.nationality}</td>
            <td><button class="btn btn-info btn-sm" data-bs-toggle="modal"
                        data-bs-target="#viewEditArtistModal" data-artist-id="${u.id}">Xem Chi Tiết</button>
              <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                      data-bs-target="#deleteArtistModal" data-artist-id="${u.id}">Xóa</button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>
<!--  view and  edit -->
<div class="modal fade" id="viewEditArtistModal" tabindex="-1" aria-labelledby="viewEditArtistModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="viewEditArtistModalLabel">Xem & Chỉnh sửa họa sĩ</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form id="editArtistForm" action="${pageContext.request.contextPath}/admin/artists/update" method="post" enctype="multipart/form-data">
        <div class="modal-body">
          <input type="hidden" id="editArtistId" name="id" value="">

          <div class="mb-3">
            <label for="editArtistName" class="form-label">Tên họa sĩ</label>
            <input type="text" class="form-control" id="editArtistName" name="name" required>
          </div>
          <div class="mb-3">
            <label for="editArtistBio" class="form-label">Tiểu sử</label>
            <textarea class="form-control" id="editArtistBio" name="bio" rows="3"></textarea>
          </div>
          <div class="mb-3">
            <label for="editArtistBirthDate" class="form-label">Ngày sinh</label>
            <input type="date" class="form-control" id="editArtistBirthDate" name="birthDate">
          </div>
          <div class="mb-3">
            <label for="editArtistNationality" class="form-label">Quốc tịch</label>
            <input type="text" class="form-control" id="editArtistNationality" name="nationality">
          </div>
          <div class="mb-3">
            <label for="editArtistPhoto" class="form-label">Ảnh</label>
            <div class="mb-2">
              <img id="currentArtistPhoto" src="" alt="Ảnh họa sĩ" style="max-width: 100%; height: auto;">
            </div>
            <input type="file" class="form-control" id="editArtistPhoto" name="photo">
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
          <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--them hoa sĩ -->
<div class="modal fade" id="addArtistModal" tabindex="-1" aria-labelledby="addArtistModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addArtistModalLabel">Thêm họa sĩ</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="${pageContext.request.contextPath}/admin/artists/add" method="POST" id="addArtistForm" enctype="multipart/form-data">
        <div class="modal-body">
          <div class="mb-3">
            <label for="artistName" class="form-label">Tên họa sĩ</label>
            <input type="text" class="form-control" id="artistName" name="name" required>
          </div>
          <div class="mb-3">
            <label for="artistBio" class="form-label">Tiểu sử</label>
            <textarea class="form-control" id="artistBio" name="bio" rows="3"></textarea>
          </div>
          <div class="mb-3">
            <label for="artistBirthDate" class="form-label">Ngày sinh</label>
            <input type="date" class="form-control" id="artistBirthDate" name="birthDate">
          </div>
          <div class="mb-3">
            <label for="artistNationality" class="form-label">Quốc tịch</label>
            <input type="text" class="form-control" id="artistNationality" name="nationality">
          </div>
          <div class="mb-3">
            <label for="photo">Ảnh:</label>
            <input type="file" id="photo" name="photo" accept="image/*" required>
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

<!-- xóa -->
<div class="modal fade" id="deleteArtistModal" tabindex="-1" aria-labelledby="deleteArtistModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="deleteArtistModalLabel">Xác nhận xóa</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="${pageContext.request.contextPath}/admin/artists/delete" method="POST">
        <div class="modal-body">
          <p>Bạn có chắc chắn muốn xóa nghệ sĩ này?</p>
          <input type="hidden" id="artistIdToDelete" name="artistId">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-danger">Xóa</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  $(document).ready(function () {
    $('#artists').DataTable({
      dom: '<"d-flex justify-content-between align-items-center"lfB>rtip',
      buttons: [
        { extend: 'copy', title: 'Danh sách nghệ sĩ' },
        { extend: 'csv', title: 'Danh sách nghệ sĩ' },
        { extend: 'excel', title: 'Danh sách nghệ sĩ' },
        { extend: 'pdf', title: 'Danh sách nghệ sĩ' },
        { extend: 'print', title: 'Danh sách nghệ sĩ' }
      ]
    });
  });


  document.querySelectorAll('[data-bs-target="#deleteArtistModal"]').forEach(button => {
    button.addEventListener('click', function() {
      let artistId = this.getAttribute('data-artist-id');
      document.getElementById('artistIdToDelete').value = artistId;
    });
  });
</script>
<script src="${pageContext.request.contextPath}/assets/js/admin/artists.js"></script>
</body>
</html>
