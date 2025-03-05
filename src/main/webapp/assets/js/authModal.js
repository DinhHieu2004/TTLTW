
    document.getElementById('loginForm').addEventListener('submit', function (event) {
    event.preventDefault();
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('loginPassword').value.trim();
    if (username === 'admin' && password === '123456') {
    window.location.href = '/admin/dashboard.jsp';
} else {
    alert('Sai thông tin đăng nhập. Vui lòng thử lại.');
    window.location.href = 'index.jsp';
}
});


