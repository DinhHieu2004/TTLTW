<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "f" uri = "http://java.sun.com/jsp/jstl/fmt" %>
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
                            <button type="submit" class="btn btn-primary w-100 login-btn">Đăng Nhập</button>
                        </form>

                        <!-- Nút Quên mật khẩu -->
                        <div class="mt-3 text-center">
                            <a href="${pageContext.request.contextPath}/user/forgot_password.jsp" class="text-decoration-none">Quên mật khẩu?</a>
                        </div>

                        <div class="mt-3 text-center">
                            <div id="g_id_onload"></div>
                            <div class="g_id_signin"></div>
                        </div>
                        <div class="mt-3 text-center">
                            <button id="custom-facebook-btn" class="custom-facebook-btn">
                                <span class="facebook-icon">
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/5/51/Facebook_f_logo_%282019%29.svg" alt="Facebook Logo" width="25">
                                </span>
                                <span class="facebook-text">Đăng nhập bằng Facebook</span>
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
                        </form>
                    </div>


                    <style>
                        .error {
                            color: red;
                            font-size: 12px;
                            margin-top: 5px;
                        }

                        .is-invalid {
                            border: 1px solid red;
                        }
                        .g_id_signin{
                            width: 60%;
                            margin: auto;
                        }
                        .nsm7Bb-HzV7m-LgbsSe .nsm7Bb-HzV7m-LgbsSe-BPrWId{
                            font-weight: bold !important;
                        }
                        .g_id_signin img {
                            width: 25px !important;
                        }
                        .custom-facebook-btn {
                            width: 60%;
                            margin: auto;
                            display: flex;
                            align-items: center;
                            border: 1px solid #dadce0;
                            background-color: white;
                            padding: 6px 14px;
                            border-radius: 5px;
                            cursor: pointer;
                            font-weight: bold;
                            font-size: 14px;
                            transition: background-color 0.2s;
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        .custom-facebook-btn:hover {
                            background-color: #f7f7f7;
                        }

                        .facebook-icon {
                            margin-right: 20px;
                        }

                    </style>

                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/authModal.js"></script>
<script src="https://accounts.google.com/gsi/client" async defer></script>