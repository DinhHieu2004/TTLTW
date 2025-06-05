let forgotWidgetId, registerWidgetId;

function renderCaptchas() {
    forgotWidgetId = grecaptcha.render('forgotRecaptcha', {
        'sitekey': '6LcLlxUrAAAAAPXCQ0NU3bAIXe17zjg0aiZhyck-'
    });

    registerWidgetId = grecaptcha.render('registerRecaptcha', {
        'sitekey': '6LcLlxUrAAAAAPXCQ0NU3bAIXe17zjg0aiZhyck-'
    });
}
$(document).ready(function () {
    initializeErrorClearing()
    const authModal = document.getElementById('authModal');

    authModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const tabToShow = button.getAttribute('data-tab');

        if (tabToShow === 'register') {
            new bootstrap.Tab(document.getElementById('register-tab')).show();
        } else {
            new bootstrap.Tab(document.getElementById('login-tab')).show();
        }
    });
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
        $(".loading-spinner").show();
        $(".loading-message").show();
        $("button[type='submit']").attr("disabled", true);
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
        let fullName = $('#registerName').val().trim();
        let username = $('#registerUsername').val().trim();
        $('#reCaptchaSError').text('');
        const captchaResponse = grecaptcha.getResponse(registerWidgetId);

        if (captchaResponse.length === 0) {
            $('#reCaptchaSError').text('Vui lòng xác nhận bạn không phải robot!');
            isValid = false;
        }

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

        if (!isValid){
            $(".loading-spinner").hide();
            $(".loading-message").hide();
            $("button[type='submit']").attr("disabled", false);
            return;
        }
        $.ajax({
            url: 'register',
            type: 'POST',
            data: {
                fullName: fullName,
                username: username,
                password: password,
                email: email,
                phone: phone,
                'g-recaptcha-response': captchaResponse
            },
            datatype: 'json',
            success: function(response){
                grecaptcha.reset();
                if (response.success) {
                    $(".loading-spinner").hide();
                    $(".loading-message").hide();
                    $("button[type='submit']").attr("disabled", false);
                    showVerifyMessage(email);
                }
            },
            error: function(xhr){
                grecaptcha.reset();
                $(".loading-spinner").hide();
                $(".loading-message").hide();
                $("button[type='submit']").attr("disabled", false);
                let errors = JSON.parse(xhr.responseText)
                if (xhr.status === 500) {
                    try {
                        let errors = JSON.parse(xhr.responseText);
                        console.log("Parsed Errors:", errors);
                    } catch (e) {
                        console.error("Lỗi khi parse JSON:", e);
                    }
                }
                console.log("aaaa"+errors)
                showServerErrors(errors);

            }
        })
    });
    //ForgotPassword
    $('#forgotPasswordForm').on('submit', function(e){
        e.preventDefault();
        $('.text-danger').text('');
        $('.is-invalid').removeClass('is-invalid');

        const loadingText = $('#forgotLoading');
        loadingText.hide();
        const submitButton = $('#forgotPasswordForm button[type="submit"]');
        $('#reCaptchaError').text('');
        const captchaResponse = grecaptcha.getResponse(forgotWidgetId);
        let isValid = true;
        let email = $('#forgotEmail').val().trim();

        if(email === ''){
            $('#forgotEmailError').text('Vui lòng nhập Email!').addClass('text-danger');
            $('#forgotEmail').addClass('is-invalid');
            isValid = false;
        }
        if (captchaResponse.length === 0) {
            $('#reCaptchaError').text('Vui lòng xác nhận bạn không phải robot!');
            $('#forgotLoading').hide();
            return;
        }
        if (!isValid){
            return;
        }
        submitButton.prop('disabled', true);
        loadingText.show();


        $.ajax({
            url: "sendPassword",
            type: 'POST',
            data: {
                email: email,
                'g-recaptcha-response': captchaResponse },
            dataType: 'json',

            success: function(resp){
                grecaptcha.reset();
                alert(resp.message)
                submitButton.prop('disabled', false);
                $('#forgotPasswordForm')[0].reset();
                loadingText.hide();
            },
            error: function (xhr){
                const res = JSON.parse(xhr.responseText);
                $('#forgotEmailError').text(res.message);
                submitButton.prop('disabled', false);
                loadingText.hide();
                grecaptcha.reset();
            }
        });
    });
});
function showVerifyMessage(email) {
    document.getElementById("registerForm").style.display = "none";
    document.getElementById("verify-message").style.display = "block";
    document.getElementById("user-email").textContent = email;
}
function handleUserConfirmed() {
    $('#login-tab').tab('show');
    setTimeout(() => {
        document.getElementById("verify-message").style.display = "none";
        document.getElementById("registerForm").style.display = "block";
        resetLoginResForm();
    }, 500);
}
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
    // $('#captchaImage').attr('src', 'captcha?' + new Date().getTime());
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
                location.reload();
        },
        error: function(xhr) {
            let message = "Đăng nhập thất bại";
            if (xhr.responseText) {
                message += ": " + xhr.responseText;
            }
            alert(message);
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

function showForgotPassword() {
    document.getElementById('authTabs').style.display = 'none';
    document.getElementById('authTabsContent').style.display = 'none';
    document.getElementById('forgotPasswordSection').style.display = 'block';
    document.getElementById('authModalLabel').innerText = 'Quên Mật Khẩu';
    resetLoginResForm();
}

function backToLogin() {
    document.getElementById('forgotPasswordSection').style.display = 'none';
    document.getElementById('authTabs').style.display = 'flex';
    document.getElementById('authTabsContent').style.display = 'block';
    document.getElementById('authModalLabel').innerText = 'Đăng Nhập / Đăng Ký';
}
document.getElementById('authModal').addEventListener('hidden.bs.modal', function () {
    backToLogin();
});
