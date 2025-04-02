$(document).ready(function () {
    initializeErrorClearing()
    // Xử lí js phần đăng nhập
    let isBlocked = false;
    let isShowingFastMessage = false;
    $('#loginForm').on('submit', function (e) {
        e.preventDefault();
        if (isBlocked) return;
        // const submitButton = $('#loginButton');
        // submitButton.prop('disabled', true);
        //
        // setTimeout(() => {
        //     submitButton.prop('disabled', false);
        // }, 2000);
        const form = $(this);
        const formData = form.serialize();

        let isValid = true;
        let username = $('#username').val().trim();
        let password = $('#loginPassword').val().trim();
        let captcha = $('#captcha').val().trim();

        // Xóa thông báo lỗi cũ
        if (!isBlocked) {
            $('.text-danger').text('').removeClass('is-invalid');
            $('#username, #loginPassword').removeClass('is-invalid');
            $('#loginMessage').text('').removeClass('text-danger');
        }

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
            data: { username: username, password: password, captcha: captcha },
            dataType: 'json',
            success: function () {
                alert("Đăng nhập thành công!");
                location.reload();
                // $("#userIcon").show();
                // $(".login-btn").hide();
            },
            error: function (xhr) {
                try {
                    var errors = JSON.parse(xhr.responseText);
                    if (xhr.status === 429) {
                        if (!isShowingFastMessage) {
                            isShowingFastMessage = true;
                            isBlocked = true; // Chặn gửi thêm request

                            const message = $('<div id="fastMessage">Bạn đang thao tác quá nhanh. Vui lòng chờ và thử lại.</div>');
                            $('body').append(message);
                            $('#fastMessage').css({
                                'position': 'fixed',
                                'top': '20px',
                                'left': '50%',
                                'transform': 'translateX(-50%)',
                                'background-color': 'rgba(0, 0, 0, 0.7)',
                                'color': 'white',
                                'padding': '10px',
                                'border-radius': '5px',
                                'font-size': '14px',
                                'z-index': '9999',
                                'opacity': '0',
                            }).animate({opacity: 1}, 300).delay(3000).fadeOut(300, function () {
                                $(this).remove();
                                isBlocked = false;
                                isShowingFastMessage = false;
                            });
                        }
                    } else
                    if (xhr.status === 401) {
                        if (errors.captchaRequired) {
                            $('#captchaImage').attr('src', 'captcha?' + new Date().getTime());
                            $('#captchaContainer').show();
                            if (errors.loginCaptError) {
                                $('#captchaError').text(errors.loginCaptError).show();
                                $('#captcha').addClass('is-invalid');
                            }else{
                                $('#loginMessage').text(errors.loginError).addClass('text-danger').show();
                                $('#username, #loginPassword').addClass('is-invalid');
                            }
                        }else {
                            $('#loginMessage').text(errors.loginError).addClass('text-danger').show();
                            $('#username, #loginPassword').addClass('is-invalid');
                        }
                    } else if (xhr.status === 500) {
                        $('#loginMessage').text(errors.errorMess).addClass('text-danger').show();
                    } else {
                        alert("Lỗi không xác định! Mã lỗi: " + xhr.status);
                    }
                    if (errors.captchaRequired) {
                        $('#captchaContainer').show();
                        $('#captchaImage').attr('src', 'captcha?' + new Date().getTime()); // Reload captcha
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
        let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
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
                let errors = JSON.parse(xhr.responseText)
                console.log("aaaa"+errors)
                showServerErrors(errors);

            }
        })
    });
});

function showServerErrors(errors){
    $('.text-danger').text('');
    $('.is-invalid').removeClass('is-invalid');

    Object.keys(errors).forEach(key => {
        let inputId = convertErrorKeyToInputId(key);
        let errorId = convertErrorKeyToErrorId(key);
        showError(inputId, errorId, errors[key]);
    });
}

function convertErrorKeyToInputId(errorKey) {
    let mapping = {
        "errorName": "registerName",
        "errorUser": "registerUsername",
        "errorEmail": "registerEmail",
        "errorPassword": "registerPassword",
        "errorPhone": "registerPhone"
    };
    return mapping[errorKey] || "";
}
function convertErrorKeyToErrorId(errorKey){
    let mapping = {
        "errorName": "fullNameError",
        "errorUser": "usernamergError",
        "errorEmail": "emailError",
        "errorPassword": "passwordrgError",
        "errorPhone": "phoneError"
    };
    return mapping[errorKey] || "";
}
// Hàm hiển thị lỗi lên UI
function showError(inputId, errorId, message) {
    $('#' + errorId).text(message).addClass('text-danger');
    $('#' + inputId).addClass('is-invalid');
}

function resetLoginResForm() {
    $('#loginForm')[0].reset();
    $('#registerForm')[0].reset();
    $('.error').text('');
    $('#loginMessage').text('').removeClass('text-danger').hide();
    $('input').removeClass('is-invalid');

}
const inputs = [
    { id: "username", errorId: "usernameError" },
    { id: "loginPassword", errorId: "passwordError" },
    { id: "captcha", errorId: "captchaError" },
    { id: "registerName", errorId: "fullNameError" },
    { id: "registerUsername", errorId: "usernamergError" },
    { id: "registerEmail", errorId: "emailError" },
    { id: "registerPassword", errorId: "passwordrgError" },
    { id: "ConfirmRegisterPassword", errorId: "confirmPasswordError" }
];

function initializeErrorClearing() {
    inputs.forEach(input => {
        $('#' + input.id).on('input', function() {
            $(this).removeClass('is-invalid');
            $('#' + input.errorId).text('');
        });
    });
}
$('#authModal').on('hidden.bs.modal', function () {
    $('#captchaImage').attr('src', 'captcha?' + new Date().getTime());
    resetLoginResForm();
});

// Khi chuyển tab giữa "Đăng nhập" và "Đăng ký" -> reset form
$('#register-tab, #login-tab').on('click', function () {
    resetLoginResForm();
});

function logout(){
    $.ajax({
        url: 'logout',
        type: 'POST',
        dataType: 'json',
        success: function(response) {
            if (response.success) {
                alert("Đăng xuất thành công!");
                location.reload();
                // window.location.href = "index.jsp";
            } else {
                alert("Đăng xuất thất bại! Vui lòng thử lại.");
            }
        },
        error: function() {
            alert("Có lỗi xảy ra khi đăng xuất.");
        }
    });
}

//login bằng google
function handleCredentialResponse(response) {
    const idToken = response.credential;
    // const csrfToken = document.getElementById("csrfToken").value;

    $.ajax({
        type: "POST",
        url: "login_google",
        // data: { credential: idToken, csrfToken: csrfToken },
        data: { credential: idToken},
        success: function(response) {
            if (response.success) {
                location.reload();
            } else {
                alert("Đăng nhập bằng Google thất bại.");
            }
        },
        error: function(xhr) {
            const errorMessage = xhr.responseJSON?.message || "Lỗi kết nối đến server.";
            alert(errorMessage);
        }
    });
}

window.fbAsyncInit = function() {
    FB.init({
        appId      : '3696159017340978',
        xfbml      : true,
        version    : 'v22.0'
    });
    FB.AppEvents.logPageView();
};

(function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s); js.id = id;
    js.src = "https://connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

document.addEventListener("DOMContentLoaded", function () {
    var fbBtn = document.getElementById('custom-facebook-btn');
        fbBtn.addEventListener('click', function () {
            FB.login(function (response) {
                if (response.authResponse) {
                    const accessToken = response.authResponse.accessToken;

                    $.ajax({
                        type: "POST",
                        url: "login_fb",
                        data: { accessToken: accessToken },
                        success: function (data) {
                            if (data.success) {
                                location.reload();
                            } else {
                                alert(data.message || "Đăng nhập bằng Facebook thất bại.");
                            }
                        },
                        error: function (xhr) {
                            alert("Đăng nhập bằng Facebook thất bại. Vui lòng thử lại sau.");
                        }
                    });
                } else {
                    alert("Người dùng từ chối đăng nhập bằng Facebook.");
                }
            }, { scope: 'public_profile,email', display: 'popup' });
        });
});


