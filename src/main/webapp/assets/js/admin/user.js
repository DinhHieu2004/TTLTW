$(document).ready(function () {
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
                    $('#username').val(data.username);
                    $('#fullName').val(data.fullName);
                    $('#email').val(data.email);
                    $('#role').val(data.role);
                    $('#address').val(data.address);
                    $('#password').val(data.password);
                    $('#phone').val(data.phone);

                } else {
                    alert(response.error || 'không tìm thấy người dùng.');
                }
            },
            error: function () {
                alert('Đã xảy ra lỗi khi lấy thông tin người dùng.');
            }
        });

    });

});
