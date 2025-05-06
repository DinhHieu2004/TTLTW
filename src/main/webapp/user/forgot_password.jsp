<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu</title>
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
            <h4>Quên Mật Khẩu</h4>
        </div>
        <div class="card-body">
            <form id="forgotPasswordForm" action="sendPassword" method="post">
                <div class="mb-3">
                    <label for="email" class="form-label">Email của bạn</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="Nhập email của bạn">
                    <div class="error" id="emailError"></div>
                </div>

                <button type="submit" class="btn btn-warning w-100">Gửi liên kết khôi phục mật khẩu</button>
            </form>
            <div class="mt-3 text-center">
                <a href="../index" class="text-decoration-none">Quay về trang chủ</a>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('forgotPasswordForm').addEventListener('submit', function (e) {
        let isValid = true;

        // Lấy phần tử input và thông báo lỗi
        const email = document.getElementById('email');
        const emailError = document.getElementById('emailError');

        // Xóa thông báo lỗi cũ
        emailError.textContent = '';
        email.classList.remove('is-invalid');

        // Kiểm tra email có được nhập hay không
        if (email.value.trim() === '') {
            emailError.textContent = 'Vui lòng nhập email!';
            email.classList.add('is-invalid');
            isValid = false;
        } else if (!validateEmail(email.value)) {
            // Kiểm tra cú pháp email
            emailError.textContent = 'Email không hợp lệ!';
            email.classList.add('is-invalid');
            isValid = false;
        }

        // Ngăn form gửi nếu không hợp lệ
        if (!isValid) {
            e.preventDefault();
        }
    });

    // Hàm kiểm tra email hợp lệ bằng regex
    function validateEmail(email) {
        const regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        return regex.test(email);
    }
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
<script src="${pageContext.request.contextPath}/assets/js/location.js"></script>


</body>
</html>
