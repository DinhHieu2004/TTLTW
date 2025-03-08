// Xử lí js phần đăng nhập
$(document).ready(function () {
    $('#loginForm').on('submit', function (e) {
        e.preventDefault();

        let isValid = true;
        let username = $('#username').val().trim();
        let password = $('#loginPassword').val().trim();
        let loginMessage = $('#loginMessage');

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
            url: '/TTLTW_war/login',
            type: 'POST',
            data: { username: username, password: password },
            dataType: 'json',
            success: function (response) {
                console.log(response)
                if (response.loginSuccess) {
                    alert("Đăng nhập thành công!");
                    location.reload();
                }else{
                    if (response.loginError) {
                        $('#loginMessage').text(response.loginError).addClass('text-danger').show();
                        $('#username').addClass('is-invalid');
                        $('#loginPassword').addClass('is-invalid');
                    }
                }
            },
            error: function (xhr) {
                var errors = JSON.parse(xhr.responseText);
                alert(errors.errorMess);
                }
        })
    });
});
function resetLoginForm() {
    $('#username, #loginPassword').val('');

    $('.text-danger').text('');
    $('#loginMessage').text('').removeClass('text-danger').hide();

    $('#username, #loginPassword').removeClass('is-invalid');
}
$('#authModal').on('hidden.bs.modal', function () {
    resetLoginForm();
});

// Khi chuyển tab giữa "Đăng nhập" và "Đăng ký" -> reset form
$('#register-tab, #login-tab').on('click', function () {
    resetLoginForm();
});

// Đóng modal khi nhấn ngoài vùng modal
window.addEventListener("click", function (event) {
    let openModal = document.querySelector(".modal.show"); // Tìm modal đang mở
    if (openModal && event.target.classList.contains("modal")) {
        let bsModal = bootstrap.Modal.getInstance(openModal);
        if (bsModal) {
            bsModal.hide();
        }
    }
});




