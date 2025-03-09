$(document).ready(function () {
    // Xử lí js phần đăng nhập
    $('#loginForm').on('submit', function (e) {
        e.preventDefault();

        let isValid = true;
        let username = $('#username').val().trim();
        let password = $('#loginPassword').val().trim();

        // Xóa thông báo lỗi cũ
        $('.text-danger').text('').removeClass('is-invalid');
        $('#username, #loginPassword').removeClass('is-invalid');
        $('#loginMessage').text('').removeClass('text-danger');

        if (username === '') {
            $('#usernameError').text('Vui lòng nhập tên đăng nhập!').addClass('text-danger');
            $('#username').addClass('is-invalid');
            isValid = false;
        }

        // Kiểm tra mật khẩu
        if (password === '') {
            $('#passwordError').text('Vui lòng nhập mật khẩu!').addClass('text-danger');
            $('#loginPassword').addClass('is-invalid');
            isValid = false;
        }

        if (!isValid) return;

        // Gửi AJAX request
        $.ajax({
            url: 'login',
            type: 'POST',
            data: { username: username, password: password },
            dataType: 'json',
            success: function () {
                alert("Đăng nhập thành công!");
                location.reload();
            },
            error: function (xhr) {
                try {
                    var errors = JSON.parse(xhr.responseText);
                    if (xhr.status === 401) {
                        $('#loginMessage').text(errors.loginError).addClass('text-danger').show();
                        $('#username, #loginPassword').addClass('is-invalid');
                    } else if (xhr.status === 500) {
                        $('#loginMessage').text(errors.errorMess).addClass('text-danger').show();
                    } else {
                        alert("Lỗi không xác định! Mã lỗi: " + xhr.status);
                    }
                } catch (e) {
                    alert("Không thể xử lý phản hồi lỗi từ server.");
                }
            }
        });
    });
    // Xử lí đăng kí tài khoản
    $('#registerForm').on('submit', function (event) {
        event.preventDefault()
        let isValid = true;
        const fields = [
            { id: "registerName", errorId: "fullNameError", message: "Vui lòng nhập họ và tên!" },
            { id: "registerUsername", errorId: "usernamergError", message: "Vui lòng nhập tên đăng nhập!" },
            { id: "registerEmail", errorId: "emailError", message: "Vui lòng nhập email!" },
            { id: "registerPassword", errorId: "passwordrgError", message: "Vui lòng nhập mật khẩu!" },
            { id: "ConfirmRegisterPassword", errorId: "confirmPasswordError", message: "Vui lòng nhập lại mật khẩu!" }
        ];

        $('.text-danger').text('');
        $('.is-invalid').removeClass('is-invalid');

        fields.forEach(field => {
            let input = $('#' + field.id);
            if (input.val().trim() === '') {
                $('#' + field.errorId).text(field.message).addClass('text-danger');
                input.addClass('is-invalid');
                isValid = false;
            }
        });

        let email = $('#registerEmail').val().trim();
        let phone = $('#registerPhone').val().trim();
        let password = $('#registerPassword').val().trim();
        let confirmPassword = $('#ConfirmRegisterPassword').val().trim();

        // Kiểm tra email hợp lệ
        let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email && !emailRegex.test(email)) {
            $('#emailError').text('Email không hợp lệ!').addClass('text-danger');
            $('#registerEmail').addClass('is-invalid');
            isValid = false;
        }

        // Kiểm tra số điện thoại hợp lệ (10 chữ số)
        let phoneRegex = /^(0[1-9][0-9]{8})$/;
        if (phone && !phoneRegex.test(phone)) {
            $('#phoneError').text('Số điện thoại không hợp lệ!').addClass('text-danger');
            $('#registerPhone').addClass('is-invalid');
            isValid = false;
        }

        // Kiểm tra mật khẩu mạnh
        let passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
        if (password && !passwordRegex.test(password)) {
            $('#passwordrgError').text('Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!').addClass('text-danger');
            $('#registerPassword').addClass('is-invalid');
            isValid = false;
        }

        // Kiểm tra mật khẩu có khớp không
        if (password && confirmPassword && password !== confirmPassword) {
            $('#confirmPasswordError').text('Mật khẩu và xác nhận không khớp!').addClass('text-danger');
            $('#ConfirmRegisterPassword').addClass('is-invalid');
            isValid = false;
        }

        if (!isValid) return;
        $.ajax({
            url: 'register',
            type: 'POST',
            data: {
                fullName: $('#registerName').val().trim(),
                username: $('#registerUsername').val().trim(),
                password: password,
                email: email,
                phone: phone
            },
            datatype: 'json',
            success: function(response){
                if (response.success) {
                    alert("Đăng ký thành công!");
                    $('#login-tab').tab('show');
                    resetLoginResForm();
                }
            },
            error: function(xhr){
                var error = JSON.parse(xhr.responseText)

            }
        })
    });
});

function resetLoginResForm() {
    $('#loginForm')[0].reset();
    $('#registerForm')[0].reset();
    $('.text-danger').text('');
    $('#loginMessage').text('').removeClass('text-danger').hide();
    $('input').removeClass('is-invalid');
}
$('#authModal').on('hidden.bs.modal', function () {
    resetLoginResForm();
});

// Khi chuyển tab giữa "Đăng nhập" và "Đăng ký" -> reset form
$('#register-tab, #login-tab').on('click', function () {
    resetLoginResForm();
});




