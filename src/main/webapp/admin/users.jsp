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
            <h4>Người dùng</h4>
        </div>

        <div class="card-body">
            <table id="users" class="table table-bordered display">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registerModal">
                    Thêm người dùng
                </button>
                <div style="padding-bottom: 10px">
                    <c:if test="${not empty message}">
                        <div class="alert alert-success">
                                ${message}
                        </div>
                    </c:if>
                </div>
                <thead>
                <tr>
                    <th>Mã người dùng</th>
                    <th>Tên đăng nhập</th>
                    <th>Tên đầy đủ</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>quyền</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}">
                <tr>
                    <td>${u.id}</td>
                    <td>${u.username}</td>
                    <td>${u.fullName}</td>
                    <td>${u.email}</td>
                    <td>${u.phone}</td>
                    <td>${u.role}</td>
                    <td>
                        <button class="btn btn-info btn-sm" data-bs-toggle="modal"
                                data-bs-target="#viewEditUserModal" data-user-id="${u.id}">Xem Chi Tiết
                        </button>
                        <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                                data-bs-target="#deleteUsersModal" data-user-id="${u.id}">Xóa
                        </button>
                    </td>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="deleteUsersModal" tabindex="-1" aria-labelledby="deleteUsersModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteArtistModalLabel">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/users/delete" method="POST">
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xóa người dùng này?</p>
                        <input type="hidden" id="userIdToDelete" name="userId">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!--  view and edit -->
    <div class="modal fade" id="viewEditUserModal" tabindex="-1" aria-labelledby="userDetailModalLabel"
         aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="userDetailModalLabel">Thông Tin Chi Tiết Người Dùng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="userDetailForm" action="${pageContext.request.contextPath}/admin/users/update" method="post">
                        <div class="row mb-3">
                            <input type="hidden" id="editUserId" name="id" value="">
                            <div class="col-md-6">
                                <label for="username" class="form-label">Tên đăng nhập</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="fullName" class="form-label">Tên Đầy Đủ</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="col-md-6">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" id="address" name="address" required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="role" class="form-label">Quyền</label>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="user">User</option>
                                    <option value="admin">Admin</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Số Điện Thoại</label>
                                <input type="tel" class="form-control" id="phone" name="phone" pattern="[0-9]{10}"
                                       required>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <label for="password" class="form-label">Mật Khẩu</label>
                                <input type="text" class="form-control" id="password" name="password" required>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" form="userDetailForm" class="btn btn-primary">Lưu Thay Đổi</button>
                </div>
            </div>
        </div>
    </div>


    <!-- add người dùng-->


    <!-- Modal -->
    <div class="modal fade" id="registerModal" tabindex="-1" aria-labelledby="registerModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="registerModalLabel">Đăng Ký Tài Khoản</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Original Form -->
                    <form id="registerForm" method="post" action="${pageContext.request.contextPath}/admin/users/add">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="registerName" class="form-label">Họ và Tên</label>
                                <input type="text" class="form-control" id="registerName" name="fullName" placeholder="Nhập họ và tên của bạn">
                                <div class="error" id="fullNameError"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="registerUsername" class="form-label">Tên đăng nhập</label>
                                <input type="text" class="form-control" id="registerUsername" name="username" placeholder="Nhập tên đăng nhập">
                                <div class="error" id="usernamergError"></div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="registerPhone" class="form-label">Số điện thoại</label>
                                <input type="text" class="form-control" id="registerPhone" name="phone" placeholder="Nhập số điện thoại">
                                <div class="error" id="phoneError"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="registerEmail" class="form-label">Email</label>
                                <input type="email" class="form-control" id="registerEmail" name="email" placeholder="Nhập email của bạn">
                                <div class="error" id="emailError"></div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="registerAddress" class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" id="registerAddress" name="address" placeholder="Nhập địa chỉ của bạn">
                                <div class="error" id="addressError"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="registerPassword" class="form-label">Mật khẩu</label>
                                <input type="password" class="form-control" id="registerPassword" name="password" placeholder="Tạo mật khẩu">
                                <div class="error" id="passwordrgError"></div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="ConfirmRegisterPassword" class="form-label">Nhập lại mật khẩu</label>
                                <input type="password" class="form-control" id="ConfirmRegisterPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu">
                                <div class="error" id="confirmPasswordError"></div>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-success w-100 login-btn">Đăng Ký</button>
                    </form>
                </div>
            </div>
        </div>
    </div>


</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function () {
        $('#users').DataTable();
    });

    document.querySelectorAll('[data-bs-target="#deleteUsersModal"]').forEach(button => {
        button.addEventListener('click', function () {
            let userId = this.getAttribute('data-user-id');
            document.getElementById('userIdToDelete').value = userId;
        });
    });
</script>
<script src="${pageContext.request.contextPath}/assets/js/admin/user.js"></script>
</body>
</html>
