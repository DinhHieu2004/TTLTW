<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
    .log-content {
        white-space: pre-wrap;
        word-break: break-word;
    }
    </style>

</head>
<body>
<!-- Sidebar -->
<%@ include file="/admin/sidebar.jsp" %>
<div class="content">
    <div class="card mb-4">
        <div class="card-header bg-success text-white" style="background: #e7621b !important;">
            <h4>logs</h4>
        </div>
        <div class="card-body">
            <table id="logs" class="table table-bordered display">
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
                    <th>Mã log</th>
                    <th>Người dùng</th>
                    <th>Loại</th>
                    <th>Thời gian</th>
                    <th>Tài nguyên</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${logs}">
                    <tr>
                        <td>${u.id}</td>
                        <td>${u.who}</td>
                        <td>${u.level}</td>
                        <td>${u.logTime}</td>
                        <td>${u.resource}</td>
                        <td><button class="btn btn-info btn-sm" data-bs-toggle="modal"
                                    data-bs-target="#viewLogModal" data-log-id="${u.id}">Xem Chi Tiết</button>
                            <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                                    data-bs-target="#deleteLogModal" data-log-id="${u.id}">Xóa</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<!--  view and  edit -->
<div class="modal fade" id="viewLogModal" tabindex="-1" aria-labelledby="viewLogModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg"> <!-- modal-lg để hiển thị rộng hơn -->
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="viewLogModalLabel">Xem chi tiết log</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <dl class="row">
                    <dt class="col-sm-3">ID</dt>
                    <dd class="col-sm-9" id="logId">--</dd>

                    <dt class="col-sm-3">Loại</dt>
                    <dd class="col-sm-9" id="logType">--</dd>

                    <dt class="col-sm-3">Người dùng</dt>
                    <dd class="col-sm-9" id="logUser">--</dd>

                    <dt class="col-sm-3">Thời gian</dt>
                    <dd class="col-sm-9" id="logTime">--</dd>

                    <dt class="col-sm-3">Vị trí</dt>
                    <dd class="col-sm-9" id="logLocation">--</dd>

                    <dt class="col-sm-3">Tài nguyên</dt>
                    <dd class="col-sm-9" id="logResource">--</dd>

                    <dt class="col-sm-3">Dữ liệu trước</dt>
                    <dd class="col-sm-9 log-content" id="logOldData">--</dd>

                    <dt class="col-sm-3">Dữ liệu sau</dt>
                    <dd class="col-sm-9 log-content" id="logNewData">--</dd>
                </dl>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>



<!-- xóa -->
<div class="modal fade" id="deleteLogModal" tabindex="-1" aria-labelledby="deleteLogModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Xác nhận xóa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa log này không?</p>
                <input type="hidden" id="logIdToDelete" name="logId">
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteLogBtn">Xóa</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function () {
        $('#logs').DataTable({
            dom: '<"d-flex justify-content-between align-items-center"lfB>rtip',
            buttons: [
                { extend: 'copy', title: 'Danh sách logs' },
                { extend: 'csv', title: 'Danh sách logs' },
                { extend: 'excel', title: 'Danh sách logs' },
                { extend: 'pdf', title: 'Danh sách logs' },
                { extend: 'print', title: 'Danh sách logs' }
            ]
        });
    });


    document.querySelectorAll('[data-bs-target="#deleteLogModal"]').forEach(button => {
        button.addEventListener('click', function() {
            let logId = this.getAttribute('data-log-id');
            document.getElementById('logIdToDelete').value = logId;
        });
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/checkSession.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/logs.js"></script>
</body>
</html>
