<%@ page import="com.example.web.dao.model.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Cá Nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.1/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/personal.css">
    <!-- DataTables Buttons CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">

    <!-- DataTables Buttons JavaScript -->
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>

</head>

<body>
<%@ include file="/partials/header.jsp" %>
<c:if test="${not empty successMessage}">
    <div class="alert alert-success">
            ${successMessage}
    </div>
</c:if>
<c:if test="${not empty errorMessage}">
    <div class="alert alert-danger">
            ${errorMessage}
    </div>
</c:if>


<div class="container mt-5">
    <div class="card mb-4">
        <div class="card-header bg-primary text-white">
            <h4>Thông Tin Cá Nhân</h4>
        </div>
        <div class="card">
            <div class="card-body">
                <c:if test="${sessionScope.user != null}">
                    <p><strong>Họ và tên:</strong> ${sessionScope.user.fullName}</p>
                    <p><strong>Số điện thoại:</strong> ${sessionScope.user.phone}</p>
                    <p><strong>Email:</strong> ${sessionScope.user.email}</p>
                    <p><strong>Địa chỉ:</strong> ${sessionScope.user.address}</p>
                    <div class="button-group">
                        <!-- Nút đổi mật khẩu -->
                        <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#changePassword">
                            Đổi mật khẩu
                        </button>
                        <!-- Nút chỉnh sửa thông tin -->
                        <button class="btn btn-success btn-sm" data-bs-toggle="modal"
                                data-bs-target="#editPersonalInfoModal">Chỉnh sửa
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="logout()">Đăng xuất</button>

                        <c:if test="${sessionScope.user.role == 'admin'}">
                            <a href="${pageContext.request.contextPath}/admin" class="btn btn-info btn-sm">Đến trang quản lý</a>
                        </c:if>
                    </div>

                    <!-- Modal chỉnh sửa thông tin cá nhân -->
                    <div class="modal fade" id="editPersonalInfoModal" tabindex="-1"
                         aria-labelledby="editPersonalInfoModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="editPersonalInfoModalLabel">Chỉnh Sửa Thông Tin Cá
                                        Nhân</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Đóng"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="editPersonalInfoForm">
                                        <div class="mb-3">
                                            <label for="nameChange" class="form-label">Họ và tên</label>
                                            <input type="text" class="form-control" id="nameChange" name="fullName"
                                                   value="${sessionScope.user.fullName}">
                                            <div class="error" id="nameChangeError"></div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="phoneChange" class="form-label">Số điện thoại</label>
                                            <input type="text" class="form-control" id="phoneChange" name="phone"
                                                   value="${sessionScope.user.phone}">
                                            <div class="error" id="phoneChangeError"></div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="emailChange" class="form-label">Email</label>
                                            <input type="email" class="form-control" id="emailChange" name="email"
                                                   value="${sessionScope.user.email}"
                                                   style="<c:if test='${not empty sessionScope.user.gg_id or not empty sessionScope.user.fb_id}'>background-color: #e9ecef;</c:if>"
                                                    <c:if test="${not empty sessionScope.user.gg_id or not empty sessionScope.user.fb_id}">
                                                        disabled
                                                    </c:if> />
                                            <div class="error" id="emailChangeError"></div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="addressChange" class="form-label">Địa chỉ</label>
                                            <input type="text" class="form-control" id="addressChange" name="address"
                                                   value="${sessionScope.user.address}">
                                            <div class="error" id="addressChangeError"></div>
                                        </div>
                                        <button type="submit" class="btn btn-primary"
                                                style="background-color: var(--primary-color) !important;">Lưu Thay Đổi
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>


<!-- Modal đổi mật khẩu -->
<div class="modal fade" id="changePassword" tabindex="-1" aria-labelledby="changePasswordLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="changePasswordLabel">Đổi mật khẩu</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            <div class="modal-body">
                <form action="change-password" method="post">
                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">Mật khẩu hiện tại</label>
                        <input type="password" class="form-control" id="currentPassword" name="currentPassword"
                               placeholder="Nhập mật khẩu hiện tại" required>
                    </div>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword"
                               placeholder="Nhập mật khẩu mới" required>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Nhập lại mật khẩu mới</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                               placeholder="Nhập lại mật khẩu mới" required>
                    </div>
                    <button type="submit" class="btn btn-primary"
                            style=" background-color: var(--primary-color) !important">Lưu Thay Đổi
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<c:if test="${sessionScope.user == null}">
    <p>Không tìm thấy thông tin người dùng.</p>
</c:if>
</div>
</div>
</div>

<!-- Bảng Đơn Hàng Hiện Tại -->
<div class="card mb-4" style="margin: 30px">
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
                <th>Trạng Thái</th>
                <th>Hành Động</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>

<div class="card mb-4" style="margin: 30px">
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
                <th>Trạng Thái</th>
                <th>Hành Động</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>

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
                        <th>Mã sản phẩm</th>
                        <th>Tên Sản Phẩm</th>
                        <th>Kích Thước</th>
                        <th>Số Lượng</th>
                        <th>Giá</th>
                        <th>Đánh giá</th>

                    </tr>
                    </thead>
                    <tbody id="orderDetailsBody"></tbody>
                </table>
                <div id="totalPrice">
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/partials/footer.jsp" %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.1/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/personal.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/authModal.js"></script>

</body>

</html>
