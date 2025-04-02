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
                        response.user.role,
                        `<button class="btn btn-info btn-sm" data-bs-toggle="modal"
                                data-bs-target="#viewEditUserModal" data-user-id="${response.user.id}">Xem Chi Tiết</button>
                         <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                                data-bs-target="#deleteUsersModal" data-user-id="${response.user.id}">Xóa</button>`
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
                console.log(response)
                if (response) {
                    const data = response;
                    $('#editUserId').val(data.id);
                    $('#changUsername').val(data.username);
                    $('#changeName').val(data.fullName);
                    $('#changeEmail').val(data.email);
                    $('#role').val(data.role);
                    $('#address').val(data.address);
                    $('#password').val(data.password);
                    $('#changePhone').val(data.phone);

                } else {
                    alert(response.error || 'không tìm thấy người dùng.');
                }
            },
            error: function () {
                alert('Đã xảy ra lỗi khi lấy thông tin người dùng.');
            }
        });

    });
    $('#userDetailForm').on('submit', function(e){
        e.preventDefault();
        let isValid = true;

        let id = $('#editUserId').val().trim();
        let username = $('#changUsername').val().trim();
        let fullName = $("#changeName").val().trim();
        let email = $("#changeEmail").val().trim();
        let address = $("#address").val().trim();
        let phone = $("#changePhone").val().trim();
        let role = $('#role').val().trim();


        let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (email && !emailRegex.test(email)) {
            $('#changeEmailError').text('Email không hợp lệ!').addClass('text-danger');
            $('#email').addClass('is-invalid');
            isValid = false;
        }

        let phoneRegex = /^(0[1-9][0-9]{8})$/;
        if (phone && !phoneRegex.test(phone)) {
            $('#changePhoneError').text('Số điện thoại không hợp lệ!').addClass('text-danger');
            $('#phone').addClass('is-invalid');
            isValid = false;
        }

        if (!isValid) return;
        $.ajax({
            type: "POST",
            url: "users/update",
            data: {
                id: id,
                fullName: fullName,
                username: username,
                email: email,
                address: address,
                phone: phone,
                role: role
            },
            success: function(response){
                console.log(response)
                var $row = $('button[data-user-id="' + response.user.id + '"]').closest('tr');


                table1.cell($row, 0).data(response.user.id);
                table1.cell($row, 1).data(response.user.username);
                table1.cell($row, 2).data(response.user.fullName);
                table1.cell($row, 3).data(response.user.email);
                table1.cell($row, 4).data(response.user.phone);
                table1.cell($row, 5).data(response.user.role);
                $('#viewEditUserModal').modal('hide');
            },
            error: function(xhr){
                if (xhr.status === 400) {
                    let response = JSON.parse(xhr.responseText);
                    $(".error").text("");
                    $.each(response.errors, function (key, message) {
                        $("#" + key).text(message).addClass('text-danger');
                        let inputId = key.replace("Error", "");
                        $("#" + inputId).addClass('is-invalid');
                    });
                } else {
                    alert("Lỗi hệ thống: " + xhr.responseText);
                }
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


});
