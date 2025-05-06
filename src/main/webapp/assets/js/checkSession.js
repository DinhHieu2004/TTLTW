
function checkSession() {
    const contextPath = getContextPath();
    console.log(contextPath)
    $.ajax({
        url: contextPath + '/check-session',
        type: 'GET',
        success: function(response) {

        },
        error: function(xhr) {
            if (xhr.status === 440) {
                var message = JSON.parse(xhr.responseText).message;

                Swal.fire({
                    icon: 'warning',
                    title: 'Thông báo',
                    text: message,
                    confirmButtonText: 'Đăng nhập lại'
                }).then(() => {
                    window.location.href = contextPath+'/';
                });
            }
        }
    });
}
function getContextPath() {
    const path = window.location.pathname;
    const firstSlash = path.indexOf("/", 1);
    return firstSlash !== -1 ? path.substring(0, firstSlash) : "";
}
$(document).ready(function() {
    checkSession();

    setInterval(checkSession, 10000);
});
