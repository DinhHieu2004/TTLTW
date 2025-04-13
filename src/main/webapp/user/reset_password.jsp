<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Mật Khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>

    <style>
        body {
            background-image: url("${pageContext.request.contextPath}/assets/images/pngtree-an-art-gallery-with-many-framed-paintings-in-the-background-and-picture-image_3157704.jpg");
            background-size: cover;
            background-position: center;
            height: 100vh;
            margin: 0;
        }

        .message-box {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 50%;
            height: 60%;
            padding: 30px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .message-box h2 {
            margin-bottom: 20px;
        }
    </style>
</head>

<body>

<div class="container">
    <c:choose>
        <c:when test="${status == 'VALID_TOKEN'}">
            <div class="message-box">

                <h2>Đổi Mật Khẩu</h2>
                <div id="resultMessage" class="mt-3 text-center"></div>
                <form id="resetPasswordForm" action="reset_password" method="post" novalidate>
                    <input type="hidden" name="token" value="${token}">

                    <div class="mb-3 text-start">
                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới">
                        <div class="text-danger small" id="newPasswordError"></div>
                    </div>

                    <div class="mb-3 text-start">
                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu">
                        <div class="text-danger small" id="confirmPasswordError"></div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 mb-3">Đổi Mật Khẩu</button>
                </form>
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="message-box">
                <h2 class="text-danger">
                    <c:choose>
                        <c:when test="${status == 'INVALID_TOKEN'}">Liên kết không hợp lệ.</c:when>
                        <c:when test="${status == 'TOKEN_NOT_FOUND'}">Liên kết không tồn tại hoặc đã bị xóa.</c:when>
                        <c:when test="${status == 'TOKEN_EXPIRED'}">Liên kết đã hết hạn. Vui lòng yêu cầu lại.</c:when>
                        <c:when test="${status == 'ERROR'}">Lỗi hệ thống. Vui lòng thử lại sau.</c:when>
                        <c:otherwise>Đã xảy ra lỗi không xác định.</c:otherwise>
                    </c:choose>
                </h2>
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
            </div>
        </c:otherwise>
    </c:choose>

</div>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $('#resetPasswordForm').on('submit', function (e) {
        e.preventDefault();

        let isValid = true;
        const newPassword = $('#newPassword');
        const confirmPassword = $('#confirmPassword');
        const newPasswordError = $('#newPasswordError');
        const confirmPasswordError = $('#confirmPasswordError');
        const submitButton = $('#resetPasswordForm button[type="submit"]');
        let passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

        $('.text-danger').text('');
        $('.is-invalid').removeClass('is-invalid');
        submitButton.prop('disabled', false);

        if (newPassword.val().trim() === '') {
            newPasswordError.text('Vui lòng nhập mật khẩu mới!').addClass('text-danger');;
            newPassword.addClass('is-invalid');
            isValid = false;
        } else if (!passwordRegex.test(newPassword.val())) {
            newPasswordError.text('Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!').addClass('text-danger');;
            newPassword.addClass('is-invalid');
            isValid = false;
        }

        if (confirmPassword.val().trim() === '') {
            confirmPasswordError.text('Vui lòng xác nhận lại mật khẩu!').addClass('text-danger');;
            confirmPassword.addClass('is-invalid');
            isValid = false;
        } else if (newPassword.val() !== confirmPassword.val()) {
            confirmPasswordError.text('Mật khẩu xác nhận không khớp!').addClass('text-danger');;
            confirmPassword.addClass('is-invalid');
            isValid = false;
        }

        if (!isValid){
            return;
        }
        submitButton.prop('disabled', true);

        $.ajax({
            type: 'POST',
            url: "reset_password",
            data: $(this).serialize(),
            success: function (response) {
                alert("Đổi mật khẩu thành công!")
                window.location.href = "http://localhost:8080/TTLTW_war/";
                submitButton.prop('disabled', false);
            },
            error: function (xhr) {
                const res = JSON.parse(xhr.responseText);
                console.log(res);
                $('#resultMessage').text(res.message).addClass('text-danger');
                submitButton.prop('disabled', false);
            }
        });
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

