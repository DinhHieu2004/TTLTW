<%@ page import="com.example.web.dao.model.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Cá Nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.1/js/jquery.dataTables.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.1/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/personal.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>

    <style>
        #nameChange, #phoneChange, #emailChange, #addressChange {
            color: #000 !important; /* Đảm bảo chữ màu đen */
            opacity: 1 !important; /* Đảm bảo không trong suốt */
            visibility: visible !important; /* Đảm bảo hiển thị */
            font-size: 16px !important; /* Đảm bảo chữ đủ lớn */
        }
    </style>
</head>

<body>
<%@ include file="/partials/header.jsp" %>

<c:if test="${not empty successMessage}">
    <div class="alert alert-success">${successMessage}</div>
</c:if>
<c:if test="${not empty errorMessage}">
    <div class="alert alert-danger">${errorMessage}</div>
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
                        <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#changePassword">
                            <i class="fas fa-key"></i> Đổi mật khẩu
                        </button>
                        <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#editPersonalInfoModal">
                            <i class="fas fa-edit"></i> Chỉnh sửa
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="logout()">
                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                        </button>
                        <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#voucherModal">
                            <i class="fas fa-ticket-alt"></i> Voucher của tôi
                        </button>
                        <c:forEach var="role" items="${sessionScope.user.roles}">
                            <c:if test="${role.name == 'ADMIN'}">
                                <a href="${pageContext.request.contextPath}/admin" class="btn btn-info btn-sm">
                                    <i class="fas fa-cogs"></i> Đến trang quản lý
                                </a>
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="modal fade" id="editPersonalInfoModal" tabindex="-1" aria-labelledby="editPersonalInfoModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="editPersonalInfoModalLabel">Chỉnh Sửa Thông Tin Cá Nhân</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="editPersonalInfoForm">
                                        <div class="mb-3">
                                            <label for="nameChange" class="form-label">Họ và tên <span style="color: red;">*</span></label>
                                            <input type="text" class="form-control" id="nameChange" name="fullName" data-fullName="${sessionScope.user.fullName}">
                                            <div class="error" id="nameChangeError"></div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="phoneChange" class="form-label">Số điện thoại</label>
                                            <input type="text" class="form-control" id="phoneChange" name="phone" data-phone="${sessionScope.user.phone}">
                                            <div class="error" id="phoneChangeError"></div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="emailChange" class="form-label">Email <span style="color: red;">*</span></label>
                                            <input type="email" class="form-control" id="emailChange" name="email" data-email="${sessionScope.user.email}"
                                                   <c:if test="${not empty sessionScope.user.gg_id or not empty sessionScope.user.fb_id}">disabled style="background-color: #e9ecef;"</c:if>>
                                            <div class="error" id="emailChangeError"></div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="addressChange" class="form-label">Địa chỉ</label>
                                            <input type="text" class="form-control" id="addressChange" name="address" value="${sessionScope.user.address}">
                                            <div class="error" id="addressChangeError"></div>
                                        </div>
                                        <button type="submit" class="btn btn-primary" style="background-color: var(--primary-color) !important;">Lưu Thay Đổi</button>
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
                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" placeholder="Nhập mật khẩu hiện tại" required>
                    </div>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới" required>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Nhập lại mật khẩu mới</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                    </div>
                    <button type="submit" class="btn btn-primary" style="background-color: var(--primary-color) !important;">Lưu Thay Đổi</button>
                </form>
            </div>
        </div>
    </div>
</div>

<c:if test="${sessionScope.user == null}">
    <p>Không tìm thấy thông tin người dùng.</p>
</c:if>

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
                <th>Vận chuyển</th>
                <th>Hành Động</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>

<!-- Bảng lịch sử đơn hàng -->
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
                <th>Vận chuyển</th>
                <th>Hành Động</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="orderDetailsModalLabel">Chi Tiết Đơn Hàng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="orderRecipientInfo"></div>
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
                <div id="totalPrice"></div>
            </div>
        </div>
    </div>
</div>

<!-- Address Modal -->
<div class="modal fade" id="addressModal" tabindex="-1" aria-labelledby="addressModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addressModalLabel">Nhập địa chỉ nhận hàng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label for="province" class="form-label">Tỉnh/Thành phố:</label>
                    <input type="text" class="form-control" id="province" placeholder="Tỉnh/Thành phố" required>
                </div>
                <div class="mb-3">
                    <label for="district" class="form-label">Quận/Huyện:</label>
                    <input type="text" class="form-control" id="district" placeholder="Quận/Huyện" required>
                </div>
                <div class="mb-3">
                    <label for="ward" class="form-label">Phường/Xã:</label>
                    <input type="text" class="form-control" id="ward" placeholder="Phường/xã" required>
                </div>
                <div class="mb-3">
                    <label for="specificAddress" class="form-label">Địa chỉ cụ thể:</label>
                    <input type="text" class="form-control" id="specificAddress" placeholder="Số nhà, tên đường..." required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" id="closeAddressModal" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" id="saveAddress">Lưu</button>
            </div>
        </div>
    </div>
</div>
<%-- Model vouchers --%>
<div class="modal fade" id="voucherModal" tabindex="-1" aria-labelledby="voucherModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="voucherModalLabel">Danh sách voucher của bạn</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            <div class="modal-body">
                <c:choose>
                    <c:when test="${not empty userVouchers}">
                        <table class="table table-bordered table-striped">
                            <thead>
                            <tr>
                                <th>Tên voucher</th>
                                <th>Giảm (%)</th>
                                <th>Hiệu lực</th>
                                <th>Hết hạn</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="v" items="${userVouchers}">
                                <tr>
                                    <td>${v.voucher.name}</td>
                                    <td>${v.voucher.discount}</td>
                                    <td>${v.voucher.startDate}</td>
                                    <td>${v.voucher.endDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${v.isUsed}">Đã dùng</c:when>
                                            <c:otherwise>Chưa dùng</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted">Bạn chưa có voucher nào được tặng.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/partials/footer.jsp" %>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Khi editPersonalInfoModal mở, kiểm tra giá trị
        document.getElementById('editPersonalInfoModal').addEventListener('shown.bs.modal', function () {
            const nameInput = document.getElementById('nameChange');
            const phoneInput = document.getElementById('phoneChange');
            const emailInput = document.getElementById('emailChange');
            const addressInput = document.getElementById('addressChange');

            console.log("Modal opened - Full Name:", nameInput.value);
            console.log("Modal opened - Phone:", phoneInput.value);
            console.log("Modal opened - Email:", emailInput.value);
            console.log("Modal opened - Address:", addressInput.value);
        });

        // Khi nhấp vào ô addressChange, mở addressModal
        document.getElementById('addressChange').addEventListener('click', function () {
            const fullAddress = document.getElementById('addressChange').value;
            if (fullAddress) {
                const parts = fullAddress.split(",").map(part => part.trim());
                document.getElementById("specificAddress").value = parts[0] || "";
                document.getElementById("ward").value = parts[1] || "";
                document.getElementById("district").value = parts[2] || "";
                document.getElementById("province").value = parts[3] || "";
            }

            const addressModal = new bootstrap.Modal(document.getElementById('addressModal'), {
                backdrop: 'static'
            });
            addressModal.show();

            const editModalElement = document.getElementById('editPersonalInfoModal');
            editModalElement.classList.add('show');
            editModalElement.style.display = 'block';
        });


        document.getElementById('addressModal').addEventListener('hidden.bs.modal', function () {
            const editModalElement = document.getElementById('editPersonalInfoModal');
            if (editModalElement.classList.contains('show')) {
                editModalElement.style.display = 'block';
                document.body.classList.add('modal-open');
                if (!document.querySelector('.modal-backdrop')) {
                    const backdrop = document.createElement('div');
                    backdrop.className = 'modal-backdrop fade show';
                    document.body.appendChild(backdrop);
                }
            }
        });
    });
</script>

<script src="${pageContext.request.contextPath}/assets/js/personal.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/authModal.js"></script>

</body>
</html>