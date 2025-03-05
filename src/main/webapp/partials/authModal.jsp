<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "f" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<div class="modal fade" id="authModal" tabindex="-1" data-bs-backdrop="static">
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
                        <c:if test="${not empty errorMessage}">
                            <script type="text/javascript">
                                alert("${errorMessage}");
                            </script>
                        </c:if>
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
                            <button type="submit" class="btn btn-primary w-100 login-btn">Đăng Nhập</button>
                        </form>

                        <!-- Nút Quên mật khẩu -->
                        <div class="mt-3 text-center">
                            <a href="../web_war/user/forgot_password.jsp" class="text-decoration-none">Quên mật khẩu?</a>
                        </div>
                    </div>


                    <script>
                        document.getElementById('loginForm').addEventListener('submit', function (e) {
                            let isValid = true;

                            // Lấy các phần tử input và thông báo lỗi
                            const userName = document.getElementById('username');
                            const userNameError = document.getElementById('usernameError');
                            const password = document.getElementById('loginPassword');
                            const passwordError = document.getElementById('passwordError');

                            // Xóa thông báo lỗi cũ
                            userNameError.textContent = '';
                            userName.classList.remove('is-invalid');
                            passwordError.textContent = '';
                            password.classList.remove('is-invalid');

                            // Kiểm tra tên đăng nhập
                            if (userName.value.trim() === '') {
                                userNameError.textContent = 'Vui lòng nhập tên đăng nhập!';
                                userName.classList.add('is-invalid');
                                isValid = false;
                            }

                            // Kiểm tra mật khẩu
                            if (password.value.trim() === '') {
                                passwordError.textContent = 'Vui lòng nhập mật khẩu!';
                                password.classList.add('is-invalid');
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

                    <!-- Register Form -->
                    <div class="tab-pane fade" id="register" role="tabpanel" aria-labelledby="register-tab">
                        <form id="registerForm" method="post" action="register">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="registerName" class="form-label">Họ và Tên</label>
                                    <input type="text" class="form-control" id="registerName" name="fullName" placeholder="Nhập họ và tên của bạn">
                                    <div class="error" id="fullNameError"></div>
                                </div>
                                <div class="col-md-6">
                                    <label for="registerUsername" class="form-label">Tên đăng nhập</label>
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
                                    <label for="registerEmail" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="registerEmail" name="email" placeholder="Nhập email của bạn">
                                    <div class="error" id="emailError"></div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="registerAddress" class="form-label">Địa chỉ</label>
                                    <input type="text" class="form-control" id="registerAddress" name="address" placeholder="Nhập địa chỉ của bạn">
                                    <div class="error" id="addressError"></div>
                                </div>
                                <div class="col-md-6">
                                    <label for="registerPassword" class="form-label">Mật khẩu</label>
                                    <input type="password" class="form-control" id="registerPassword" name="password" placeholder="Tạo mật khẩu">
                                    <div class="error" id="passwordrgError"></div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="ConfirmRegisterPassword" class="form-label">Nhập lại mật khẩu</label>
                                    <input type="password" class="form-control" id="ConfirmRegisterPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu">
                                    <div class="error" id="confirmPasswordError"></div>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-success w-100 login-btn">Đăng Ký</button>
                        </form>
                    </div>

                    <script>
                        document.getElementById("registerForm").addEventListener("submit", function(event) {
                            let isValid = true;

                            // Lấy các phần tử input và thông báo lỗi
                            const fullName = document.getElementById("registerName");
                            const fullNameError = document.getElementById("fullNameError");
                            const username = document.getElementById("registerUsername");
                            const usernameError = document.getElementById("usernamergError");
                            const phone = document.getElementById("registerPhone");
                            const phoneError = document.getElementById("phoneError");
                            const email = document.getElementById("registerEmail");
                            const emailError = document.getElementById("emailError");
                            const address = document.getElementById("registerAddress");
                            const addressError = document.getElementById("addressError");
                            const password = document.getElementById("registerPassword");
                            const passwordError = document.getElementById("passwordrgError");
                            const confirmPassword = document.getElementById("ConfirmRegisterPassword");
                            const confirmPasswordError = document.getElementById("confirmPasswordError");

                            // Xóa thông báo lỗi cũ
                            fullNameError.textContent = '';
                            fullName.classList.remove('is-invalid');
                            usernameError.textContent = '';
                            username.classList.remove('is-invalid');
                            phoneError.textContent = '';
                            phone.classList.remove('is-invalid');
                            emailError.textContent = '';
                            email.classList.remove('is-invalid');
                            addressError.textContent = '';
                            address.classList.remove('is-invalid');
                            passwordError.textContent = '';
                            password.classList.remove('is-invalid');
                            confirmPasswordError.textContent = '';
                            confirmPassword.classList.remove('is-invalid');

                            // Kiểm tra các trường
                            if (fullName.value.trim() === '') {
                                fullNameError.textContent = 'Vui lòng nhập họ và tên!';
                                fullName.classList.add('is-invalid');
                                isValid = false;
                            }

                            if (username.value.trim() === '') {
                                usernameError.textContent = 'Vui lòng nhập tên đăng nhập!';
                                username.classList.add('is-invalid');
                                isValid = false;
                            }

                            if (phone.value.trim() === '') {
                                phoneError.textContent = 'Vui lòng nhập số điện thoại!';
                                phone.classList.add('is-invalid');
                                isValid = false;
                            }

                            if (email.value.trim() === '') {
                                emailError.textContent = 'Vui lòng nhập email!';
                                email.classList.add('is-invalid');
                                isValid = false;
                            }

                            if (address.value.trim() === '') {
                                addressError.textContent = 'Vui lòng nhập địa chỉ!';
                                address.classList.add('is-invalid');
                                isValid = false;
                            }

                            if (password.value.trim() === '') {
                                passwordError.textContent = 'Vui lòng nhập mật khẩu!';
                                password.classList.add('is-invalid');
                                isValid = false;
                            }

                            if (confirmPassword.value.trim() === '') {
                                confirmPasswordError.textContent = 'Vui lòng nhập lại mật khẩu!';
                                confirmPassword.classList.add('is-invalid');
                                isValid = false;
                            }

                            // Kiểm tra mật khẩu và xác nhận mật khẩu có khớp không
                            if (password.value !== confirmPassword.value) {
                                confirmPasswordError.textContent = 'Mật khẩu và xác nhận mật khẩu không khớp!';
                                confirmPassword.classList.add('is-invalid');
                                isValid = false;
                            }

                            // Ngăn form gửi nếu không hợp lệ
                            if (!isValid) {
                                event.preventDefault();
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

                </div>
            </div>
        </div>
    </div>
</div>
<script src="../assets/js/authModal.js"></script>
