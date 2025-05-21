$(document).ready(function () {
    var table1 = $('#users').DataTable();

    $('#addUserForm').on('submit', function (event) {
        event.preventDefault()
        let isValid = true;
        const fields = [
            {id: "registerName", errorId: "fullNameError", message: "Vui lòng nhập họ và tên!"},
            {id: "registerUsername", errorId: "usernamergError", message: "Vui lòng nhập tên đăng nhập!"},
            {id: "registerEmail", errorId: "emailError", message: "Vui lòng nhập email!"},
            {id: "registerPassword", errorId: "passwordrgError", message: "Vui lòng nhập mật khẩu!"},
            {id: "confirmRegisterPassword", errorId: "confirmPasswordError", message: "Vui lòng nhập lại mật khẩu!"}
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
        let address = $('#registerAddress').val().trim();
        let password = $('#registerPassword').val().trim();
        let confirmPassword = $('#confirmRegisterPassword').val().trim();

        let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (email && !emailRegex.test(email)) {
            $('#emailError').text('Email không hợp lệ!').addClass('text-danger');
            $('#registerEmail').addClass('is-invalid');
            isValid = false;
        }

        let phoneRegex = /^(0[1-9][0-9]{8})$/;
        if (phone && !phoneRegex.test(phone)) {
            $('#phoneError').text('Số điện thoại không hợp lệ!').addClass('text-danger');
            $('#registerPhone').addClass('is-invalid');
            isValid = false;
        }

        let passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
        if (password && !passwordRegex.test(password)) {
            $('#passwordrgError').text('Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!').addClass('text-danger');
            $('#registerPassword').addClass('is-invalid');
            isValid = false;
        }

        if (password && confirmPassword && password !== confirmPassword) {
            $('#confirmPasswordError').text('Mật khẩu và xác nhận không khớp!').addClass('text-danger');
            $('#ConfirmRegisterPassword').addClass('is-invalid');
            isValid = false;
        }

        if (!isValid) return;
        $.ajax({
            url: 'users/add',
            type: 'POST',
            data: {
                fullName: $('#registerName').val().trim(),
                username: $('#registerUsername').val().trim(),
                password: password,
                email: email,
                phone: phone,
                address: address
            },
            datatype: 'json',
            success: function (response) {
                if (response.success) {
                    table1.row.add([
                        response.user.id,
                        response.user.username,
                        response.user.fullName,
                        response.user.email,
                        response.user.phone,
                        Array.from(response.user.roles).map(r => r.name).join(', '),
                        `<button class="btn btn-info btn-sm" data-bs-toggle="modal"
                                data-bs-target="#viewEditUserModal" data-user-id="${response.user.id}">
                                <i class="fas fa-eye"></i>
                        </button>
                         <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                                data-bs-target="#deleteUsersModal" data-user-id="${response.user.id}">
                                <i class="fas fa-trash-alt"></i>
                        </button>
                        <button class="btn btn-warning btn-sm change-password-btn"
                                data-bs-toggle="modal" data-bs-target="#changePasswordModal"
                                data-user-id="${response.user.id}">
                                <i class="fas fa-key"></i>
                        </button>`

                    ]).draw(false);
                    $('#addUserModal').modal('hide');

                }
            },
            error: function (xhr) {
                let errors = JSON.parse(xhr.responseText)
                console.log("aaaa" + errors)
                showaddUserrErrors(errors);

            }
        });
    });
    function showaddUserrErrors(errors){
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
            "errorPhone": "registerPhone",
            "errorAddress": "registerAddress"
        };
        return mapping[errorKey] || "";
    }
    function convertErrorKeyToErrorId(errorKey){
        let mapping = {
            "errorName": "fullNameError",
            "errorUser": "usernamergError",
            "errorEmail": "emailError",
            "errorPassword": "passwordrgError",
            "errorPhone": "phoneError",
            "errorAddress": "addressError"
        };
        return mapping[errorKey] || "";
    }
    function showError(inputId, errorId, message) {
        $('#' + errorId).text(message).addClass('text-danger');
        $('#' + inputId).addClass('is-invalid');
    }

    $('#viewEditUserModal').on('show.bs.modal', function (event) {
        const button = $(event.relatedTarget);
        const userId = button.data('user-id');

        $.ajax({
            url: 'users/detail',
            type: 'GET',
            data: { userId: userId },
            dataType: 'json',
            success: function (response) {
                console.log(response);
                if (response && !response.error) {
                    const data = response;

                    // Điền thông tin cơ bản
                    $('#editUserId').val(data.id);
                    $('#changUsername').val(data.username);
                    $('#changeName').val(data.fullName);
                    $('#changeEmail').val(data.email);
                    $('#address').val(data.address);
                    $('#password').val(data.password);
                    $('#changePhone').val(data.phone);
                    $('#status').val(data.status);

                    const userRoles = data.roles || [];

                    $('input[name="rolesIds"]').prop('checked', false);

                    userRoles.forEach(function(role) {
                        const roleId = role.id;
                        const checkbox = $(`#new_role_${roleId}`);
                        if (checkbox.length) {
                            checkbox.prop('checked', true);
                        }
                    });

                    const currentRoleDiv = $('#currentRole');
                    currentRoleDiv.empty();
                    if (userRoles.length === 0) {
                        currentRoleDiv.html('<p class="text-muted">Không có role nào.</p>');
                    } else {
                        let rolesHtml = '';
                        userRoles.forEach(function(role) {
                            rolesHtml += `
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" 
                                       name="currentRoleIds" id="current_role_${role.id}" 
                                       value="${role.id}" checked disabled>
                                <label class="form-check-label" for="current_role_${role.id}">
                                    ${role.name} (ID: ${role.id})
                                </label>
                            </div>`;
                        });
                        currentRoleDiv.html(rolesHtml);
                    }

                } else {
                    alert(response.error || 'Không tìm thấy người dùng.');
                }
            },
            error: function (xhr, status, error) {
                console.error('AJAX Error:', status, error);
                alert('Đã xảy ra lỗi khi lấy thông tin người dùng.');
            }
        });
    });
    $('#userDetailForm').on('submit', function(e) {
        e.preventDefault();
        let isValid = true;

        // Lấy dữ liệu từ form
        let id = $('#editUserId').val().trim();
        let username = $('#changUsername').val().trim();
        let fullName = $("#changeName").val().trim();
        let email = $("#changeEmail").val().trim();
        let address = $("#address").val().trim();
        let phone = $("#changePhone").val().trim();
        let status = $("#status").val();

        // Lấy danh sách role IDs đã chọn
        let selectedRoleIds = $('input[name="rolesIds"]:checked')
            .map(function() { return this.value; })
            .get();

        // Validate email
        let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (email && !emailRegex.test(email)) {
            $('#changeEmailError').text('Email không hợp lệ!').addClass('text-danger');
            $('#changeEmail').addClass('is-invalid');
            isValid = false;
        } else {
            $('#changeEmailError').text('').removeClass('text-danger');
            $('#changeEmail').removeClass('is-invalid');
        }

        // Validate phone
        let phoneRegex = /^(0[1-9][0-9]{8})$/;
        if (phone && !phoneRegex.test(phone)) {
            $('#changePhoneError').text('Số điện thoại không hợp lệ!').addClass('text-danger');
            $('#changePhone').addClass('is-invalid');
            isValid = false;
        } else {
            $('#changePhoneError').text('').removeClass('text-danger');
            $('#changePhone').removeClass('is-invalid');
        }

        if (!isValid) return;

        // Tạo form data sử dụng URLSearchParams
        let formData = new URLSearchParams();
        formData.append('id', id);
        formData.append('username', username);
        formData.append('fullName', fullName);
        formData.append('email', email);
        formData.append('address', address);
        formData.append('phone', phone);
        formData.append('status', status);
        selectedRoleIds.forEach(function(roleId) {
            formData.append('roleIds', roleId);
        });

        let $submitBtn = $('#userDetailForm button[type="submit"]');
        $submitBtn.prop('disabled', true)
            .html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang xử lý...');

        $.ajax({
            type: "POST",
            url: "users/update",
            data: formData.toString(),
            contentType: 'application/x-www-form-urlencoded',
            processData: false,
            success: function(response) {
                console.log(response);

                if (response && response.user) {
                    let table1 = $('#users').DataTable();
                    let $row = $('button[data-user-id="' + response.user.id + '"]').closest('tr');

                    // Lấy nội dung cột "Hành động" (cột thứ 6, index 6)
                    let actionColumn = table1.cell($row, 6).data();

                    // Cập nhật dữ liệu với 7 cột
                    table1.row($row).data([
                        response.user.id,
                        response.user.username,
                        response.user.fullName,
                        response.user.email,
                        response.user.phone,
                        response.user.roles.map(r => r.name).join(', '), // Cột Roles
                        actionColumn // Cột Hành động
                    ]).draw(false);

                    $('#viewEditUserModal').modal('hide');
                    alert('Cập nhật người dùng thành công!');
                }
            },
            error: function(xhr) {
                if (xhr.status === 400) {
                    let response = JSON.parse(xhr.responseText);
                    $(".error").text("");
                    $.each(response.errors, function(key, message) {
                        $("#" + key).text(message).addClass('text-danger');
                        let inputId = key.replace("Error", "");
                        $("#" + inputId).addClass('is-invalid');
                    });
                } else if (xhr.status === 403) {
                    let response = JSON.parse(xhr.responseText);
                    alert(response.message || "Bạn không có quyền thực hiện chức năng này!");
                } else {
                    alert("Lỗi hệ thống: " + xhr.responseText);
                }
            },
            complete: function() {
                // Khôi phục nút submit
                $submitBtn.prop('disabled', false).html('Lưu thay đổi');
                // Reset form
                $('#userDetailForm')[0].reset();
                $('.is-invalid').removeClass('is-invalid');
                $('.error').text('');
            }
        });
    });

        $('#deleteUsersModal form').on('submit', function (e) {
            e.preventDefault();

            let userId = $('#userIdToDelete').val();
            console.log(userId);
            if (!userId) {
                console.log("Không tìm thấy ID người dùng!");
                return;
            }

            $.ajax({
                type: "POST",
                url: "users/delete",
                data: { id: userId },
                success: function (response) {
                    if (response.status === "success") {
                        var $row = $('[data-user-id="' + userId + '"]').closest('tr');
                        table1.row($row).remove().draw(false);

                        $('#deleteUsersModal').modal('hide');
                    } else {
                        console.error("Xóa thất bại:", response.message);
                    }
                },
                error: function (xhr) {
                    console.error("Lỗi khi gửi yêu cầu xóa:", xhr.responseText);
                }
            });
        });


        // đổi pass ở admin
    $('.change-password-btn').on('click', function () {
        const userId = $(this).data('user-id');
        $('#changeUserId').val(userId);
        $('#newPassword').val('');
        console.log(userId);
    });


    $('#changePasswordForm').on('submit', function (e) {
        e.preventDefault();

        const userId = $('#changeUserId').val();
        const newPassword = $('#newPassword').val();
        console.log(userId);
        $.ajax({
            url: 'users/reset_pass',
            type: 'POST',
            data: {
                userId: userId,
                newPassword: newPassword
            },
            success: function () {
                Swal.fire({
                    icon: 'success',
                    title: 'Thành công',
                    text: 'Mật khẩu đã được thay đổi!'
                });
                $('#changePasswordModal').modal('hide');
            },
            error: function (xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Thất bại',
                    text: 'Lỗi: ' + xhr.status
                });
            }
        });
    });


});
