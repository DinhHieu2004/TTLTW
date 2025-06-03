<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "f" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%--<input type="hidden" id="csrfToken" value="${sessionScope.CSRF_TOKEN}">--%>
<div class="modal fade" id="authModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="authModalLabel">Đăng Nhập / Đăng Ký</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Tabs for Login and Register -->
                <ul class="nav nav-tabs" id="authTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active " id="login-tab" data-bs-toggle="tab" data-bs-target="#login"
                            type="button" role="tab" aria-controls="login" aria-selected="true">Đăng Nhập</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="register-tab" data-bs-toggle="tab" data-bs-target="#register"
                            type="button" role="tab" aria-controls="register" aria-selected="false">Đăng Ký</button>
                    </li>
                </ul>

                <div class="tab-content mt-3" id="authTabsContent">
                    <!-- Login Form -->
                    <div class="tab-pane fade show active" id="login" role="tabpanel" aria-labelledby="login-tab">
                        <div id="loginMessage" class="error"></div>
                        <form id="loginForm" method="post" action="login">
                            <div class="mb-3">
                                <label for="username" class="form-label">Tên đăng nhập</label>
                                <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập của bạn">
                                <div class="error" id="usernameError"></div>
                            </div>
                            <div class="mb-3">
                                <label for="loginPassword" class="form-label">Mật khẩu</label>
                                <input type="password" class="form-control" id="loginPassword" name="password" placeholder="Nhập mật khẩu">
                                <div class="error" id="passwordError"></div>
                            </div>
                            <div class="mb-3" id="captchaContainer" style="display: none;">
                                <label for="captcha">Nhập captcha:</label>
                                <img src="captcha" alt="Captcha Image" id="captchaImage"/>
                                <input type="text" id="captcha" name="captcha" class="form-control">
                                <div class="error" id="captchaError"></div>
                            </div>
                            <button type="submit" id="loginButton" class="btn btn-primary w-100 login-btn">Đăng Nhập</button>
                        </form>

                        <!-- Nút Quên mật khẩu -->
                        <div class="mt-3 text-center">
                            <a href="#" onclick="showForgotPassword()" class="text-decoration-none">Quên mật khẩu?</a>
                        </div>

                        <div class="mt-3 text-center">
                            <div id="g_id_onload"
                                 data-client_id="891978819303-g9qeo4mmukj96bfr51iaaeheeqk1t1eo.apps.googleusercontent.com"
                                 data-callback="handleCredentialResponse"
                                 data-auto_prompt="false">
                            </div>
                            <div class="g_id_signin"
                                 data-type="standard"
                                 data-size="large"
                                 data-theme="outline"
                                 data-text="signin_with"
                                 data-shape="rectangular"
                                 data-logo_alignment="left">

                            </div>
                        </div>
                        <div class="mt-3 text-center">
                            <button id="custom-facebook-btn" class="custom-facebook-btn w-100 d-flex align-items-center">
                                <div class="facebook-icon d-flex align-items-center justify-content-center" style="width: 40px; ">
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/5/51/Facebook_f_logo_%282019%29.svg" alt="Facebook Logo" width="25">
                                </div>
                                <div class="facebook-text flex-grow-1 text-center">Đăng nhập bằng Facebook</div>
                            </button>
                        </div>
                    </div>


                    <!-- Register Form -->
                    <div class="tab-pane fade" id="register" role="tabpanel" aria-labelledby="register-tab">
                        <form id="registerForm" method="post" action="register">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="registerName" class="form-label">Họ và Tên <span style="color: red;">*</span></label>
                                    <input type="text" class="form-control" id="registerName" name="fullName" placeholder="Nhập họ và tên của bạn">
                                    <div class="error" id="fullNameError"></div>
                                </div>
                                <div class="col-md-6">
                                    <label for="registerUsername" class="form-label">Tên đăng nhập <span style="color: red;">*</span></label>
                                    <input type="text" class="form-control" id="registerUsername" name="username" placeholder="Nhập tên đăng nhập">
                                    <div class="error" id="usernamergError"></div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="registerPhone" class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" id="registerPhone" name="phone" placeholder="Nhập số điện thoại">
                                    <div class="error" id="phoneError"></div>
                                </div>
                                <div class="col-md-6">
                                    <label for="registerEmail" class="form-label">Email <span style="color: red;">*</span></label>
                                    <input type="email" class="form-control" id="registerEmail" name="email" placeholder="Nhập email của bạn">
                                    <div class="error" id="emailError"></div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="">
                                    <label for="registerPassword" class="form-label">Mật khẩu <span style="color: red;">*</span></label>
                                    <br>
                                    <small class="form-text text-muted" style="font-size: 12px;">Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.</small>
                                    <input type="password" class="form-control" id="registerPassword" name="password" placeholder="Tạo mật khẩu">
                                    <div class="error" id="passwordrgError"></div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="">
                                    <label for="ConfirmRegisterPassword" class="form-label">Nhập lại mật khẩu <span style="color: red;">*</span></label>
                                    <input type="password" class="form-control" id="ConfirmRegisterPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu">
                                    <div class="error" id="confirmPasswordError"></div>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-success w-100 login-btn">Đăng Ký</button>
                            <div class="loading-spinner">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="sr-only">Loading...</span>
                                </div>
                            </div>
                            <div class="loading-message">
                                Đang xử lý, vui lòng đợi...
                            </div>
                        </form>
                        <div id="verify-message" style="display: none;">
                            <h4>Đăng ký thành công!</h4>
                            <p>Chúng tôi đã gửi một email xác thực đến <strong id="user-email"></strong>.</p>
                            <p>Vui lòng kiểm tra hộp thư đến hoặc mục <strong>Spam</strong>.</p>
                            <p>Nhấn Xác Nhận để tắt thông báo này.</p>
                            <button class="btn btn-success mt-3" onclick="handleUserConfirmed()">Xác nhận</button>
                        </div>
                    </div>


                    <style>
                        .loading-spinner, .loading-message {
                            position: absolute;
                            top: 20%;
                            left: 50%;
                            transform: translate(-50%, -50%);
                            display: none;
                        }
                        .error {
                            color: red;
                            font-size: 12px;
                            margin-top: 5px;
                        }

                        .is-invalid {
                            border: 1px solid red;
                        }
                        #gsi_845239_141389{
                            width: 107% !important;
                        }
                        .g_id_signin{
                            width: 80% !important;
                            margin: auto;
                        }
                        .nsm7Bb-HzV7m-LgbsSe .nsm7Bb-HzV7m-LgbsSe-BPrWId{
                            font-weight: bold !important;
                        }
                        .g_id_signin img {
                            width: 25px !important;
                        }
                        .custom-facebook-btn {
                            width: 80% !important;
                            margin: auto;
                            background-color: white;
                            color: #3c4043;
                            border: 1px solid #ccc;
                            padding: 6px 0;
                            border-radius: 5px;
                            cursor: pointer;
                            transition: background-color 0.3s;
                            display: flex;
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }
                        .facebook-text {
                            font-size: 15px;
                            font-weight: bold;
                        }


                    </style>

                </div>

                <div id="forgotPasswordSection" style="display: none;">
                    <div id="forgotLoading" class="mb-2 text-center text-primary" style="display: none;">
                        <span class="spinner-border spinner-border-sm"></span> Đang gửi liên kết...
                    </div>
                    <div id="forgotPasswordMessage" class="text-danger"></div>
                    <form id="forgotPasswordForm" method="post">
                        <div class="mb-3">
                            <label for="forgotEmail" class="form-label">Nhập Email<span style="color: red;">*</span></label>
                            <input type="email" class="form-control" id="forgotEmail" name="email" placeholder="Nhập email đã đăng ký" required>
                            <div class="error" id="forgotEmailError"></div>
                        </div>
                        <div class="g-recaptcha mb-2" data-sitekey="6LcLlxUrAAAAAPXCQ0NU3bAIXe17zjg0aiZhyck-"></div>
                        <div id="reCaptchaError" class="text-danger mb-2"></div>

                        <button type="submit" class="btn btn-success w-100 login-btn">Gửi liên kết khôi phục</button>
                        <div class="text-center mt-3">
                            <span>Đã nhớ mật khẩu? </span><a href="#" onclick="backToLogin()">Quay lại Đăng nhập</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/authModal.js"></script>
<script src="https://accounts.google.com/gsi/client" async defer></script>
<script async defer crossorigin="anonymous" src="https://connect.facebook.net/en_US/sdk.js"></script>
<script src="https://www.google.com/recaptcha/api.js" async defer></script>
