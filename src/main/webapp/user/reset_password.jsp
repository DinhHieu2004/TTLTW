<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Mật Khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

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

<div class="container d-flex justify-content-center align-items-center" style="height: 100vh;">
    <div class="card" style="width: 800px;">
        <div class="card-header bg-primary text-white">
            <h4>Đổi Mật Khẩu</h4>
        </div>
        <div class="card-body">
            <form id="resetPasswordForm" action="reset_password" method="post">
                <input type="hidden" name="token" value="${token}">

                <div class="mb-3">
                    <label for="newPassword" class="form-label">Mật khẩu mới</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới">
                    <div class="error" id="newPasswordError"></div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu">
                    <div class="error" id="confirmPasswordError"></div>
                </div>

                <button type="submit" class="btn btn-warning w-100">Đổi Mật Khẩu</button>
            </form>
        </div>
    </div>
</div>

<script>
    document.getElementById('resetPasswordForm').addEventListener('submit', function (e) {
        let isValid = true;

        // Lấy các phần tử input và thông báo lỗi
        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');
        const newPasswordError = document.getElementById('newPasswordError');
        const confirmPasswordError = document.getElementById('confirmPasswordError');

        // Xóa thông báo lỗi cũ
        newPasswordError.textContent = '';
        confirmPasswordError.textContent = '';
        newPassword.classList.remove('is-invalid');
        confirmPassword.classList.remove('is-invalid');

        // Kiểm tra mật khẩu mới
        if (newPassword.value.trim() === '') {
            newPasswordError.textContent = 'Vui lòng nhập mật khẩu mới!';
            newPassword.classList.add('is-invalid');
            isValid = false;
        } else if (newPassword.value.length < 6) {
            newPasswordError.textContent = 'Mật khẩu phải có ít nhất 6 ký tự!';
            newPassword.classList.add('is-invalid');
            isValid = false;
        }

        // Kiểm tra xác nhận mật khẩu
        if (confirmPassword.value.trim() === '') {
            confirmPasswordError.textContent = 'Vui lòng nhập lại mật khẩu!';
            confirmPassword.classList.add('is-invalid');
            isValid = false;
        } else if (newPassword.value !== confirmPassword.value) {
            confirmPasswordError.textContent = 'Mật khẩu xác nhận không khớp!';
            confirmPassword.classList.add('is-invalid');
            isValid = false;
        }

        // Ngăn form gửi nếu không hợp lệ
        if (!isValid) {
            e.preventDefault();
        }
    });
</script>

<style>
    .error {
        color: red;
        font-size: 0.9em;
        margin-top: 5px;
    }

    .is-invalid {
        border: 1px solid red;
    }
</style>

<!-- Thêm JavaScript của Bootstrap nếu cần -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

