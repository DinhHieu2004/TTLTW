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
            <h4>VOUCHER</h4>
        </div>
        <div class="card-body">
            <table id="artists" class="table table-bordered display">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addVoucherModal">
                    Thêm voucher
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
                    <th>Tên</th>
                    <th>Phần trăm</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th>Ngày bắt đầu</th>
                    <th>Ngày kết thúc</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${vs}">
                    <tr>
                        <td>${u.id}</td>
                        <td>${u.name}</td>
                        <td>${u.discount}</td>
                        <td>${u.isActive}</td>
                        <td>${u.createAt}</td>
                        <td>${u.startDate}</td>
                        <td>${u.endDate}</td>
                        <td><button class="btn btn-info btn-sm" data-bs-toggle="modal"
                                    data-bs-target="#viewEditVoucherModal" data-voucher-id="${u.id}">Xem Chi Tiết</button>
                            <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                                    data-bs-target="#deleteVoucherModal" data-voucher-id="${u.id}">Xóa</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<


<div class="modal fade" id="viewEditVoucherModal" tabindex="-1" aria-labelledby="addVoucherModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="viewEditVoucherModalLabel">Thêm voucher mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editForm" method="post" action="${pageContext.request.contextPath}/admin/vouchers/update">
                    <input type="hidden" id="editVoucherId" name="vid" value="">

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="name" class="form-label">Tên</label>
                            <input type="text" class="form-control" id="editName" name="name" placeholder="Nhập tên voucher">
                            <div class="error" id="editNameError"></div>
                        </div>
                        <div class="col-md-6">
                            <label for="discount" class="form-label">Phần trăm giảm giá</label>
                            <input type="number" class="form-control" id="editDiscount" name="discount" placeholder="Nhập phần trăm giảm giá">
                            <div class="error" id="editDiscountError"></div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="editIsActive" name="isActive">
                                <label class="form-check-label" for="isActive">Hoạt động</label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="startDate" class="form-label">Ngày bắt đầu</label>
                            <input type="date" class="form-control" id="editStartDate" name="startDate">
                            <div class="error" id="editStartDateError"></div>
                        </div>
                        <div class="col-md-6">
                            <label for="endDate" class="form-label">Ngày kết thúc</label>
                            <input type="date" class="form-control" id="editEndDate" name="endDate">
                            <div class="error" id="editEndDateError"></div>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 login-btn">Lưu thay đổi</button>
                </form>
            </div>
        </div>
    </div>
</div>



<div class="modal fade" id="deleteVoucherModal" tabindex="-1" aria-labelledby="deleteVoucherModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteVoucherModalLabel">Xác nhận xóa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/vouchers/delete" method="POST">
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa voucher này?</p>
                    <input type="hidden" id="voucherIdToDelete" name="vid">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger">Xóa</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="addVoucherModal" tabindex="-1" aria-labelledby="addVoucherModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addVoucherModalLabel">Thêm voucher mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="registerForm" method="post" action="${pageContext.request.contextPath}/admin/vouchers/add">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="name" class="form-label">Tên</label>
                            <input type="text" class="form-control" id="name" name="name" placeholder="Nhập họ và tên của bạn">
                            <div class="error" id="nameError"></div>
                        </div>
                        <div class="col-md-6">
                            <label for="discount" class="form-label">Phần trăm giảm giá</label>
                            <input type="number" class="form-control" id="discount" name="discount" placeholder="Nhập phần trăm giảm giá">
                            <div class="error" id="discountError"></div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="isActive" name="isActive">
                                <label class="form-check-label" for="isActive">Hoạt động</label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="startDate" class="form-label">Ngày bắt đầu</label>
                            <input type="date" class="form-control" id="startDate" name="startDate">
                            <div class="error" id="startDateError"></div>
                        </div>
                        <div class="col-md-6">
                            <label for="endDate" class="form-label">Ngày kết thúc</label>
                            <input type="date" class="form-control" id="endDate" name="endDate">
                            <div class="error" id="endDateError"></div>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 login-btn">Thêm</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function () {
        $('#artists').DataTable({
            dom: '<"d-flex justify-content-between align-items-center"lfB>rtip',
            buttons: [
                { extend: 'copy', title: 'Danh sách vouchers' },
                { extend: 'csv', title: 'Danh sách vouchers' },
                { extend: 'excel', title: 'Danh sách vouchers' },
                { extend: 'pdf', title: 'Danh sách vouchers' },
                { extend: 'print', title: 'Danh sách vouchers' }
            ]
        });
    });

    document.querySelectorAll('[data-bs-target="#deleteVoucherModal"]').forEach(button => {
        button.addEventListener('click', function() {
            let voucherId = this.getAttribute('data-voucher-id');
            document.getElementById('voucherIdToDelete').value = voucherId;
        });
    });
</script>
<script src="${pageContext.request.contextPath}/assets/js/admin/vouchers.js"></script>
</body>
</html>
