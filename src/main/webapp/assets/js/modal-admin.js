// Modal management functions
function openManageUsersModal() {
    document.getElementById('manageUsersModal').style.display = 'block';
}

function closeManageUsersModal() {
    document.getElementById('manageUsersModal').style.display = 'none';
}

function openAddUserModal() {
    document.getElementById('addUserModal').style.display = 'block';
}

function closeAddUserModal() {
    document.getElementById('addUserModal').style.display = 'none';
    document.getElementById('addUserForm').reset();
}

function openEditUserModal(userId) {
    const editModal = document.getElementById('editUserModal');
    editModal.style.display = 'block';
    
    // Giả sử bạn có một hàm để lấy thông tin user từ backend
    // Đây là ví dụ mock data
    const userData = {
        username: "User " + userId,
        email: "user" + userId + "@example.com",
        role: "user"
    };
    
    document.getElementById('editUsername').value = userData.username;
    document.getElementById('editEmail').value = userData.email;
    document.getElementById('editRole').value = userData.role;
    editModal.dataset.userId = userId;
}

function closeEditUserModal() {
    document.getElementById('editUserModal').style.display = 'none';
    document.getElementById('editUserForm').reset();
}

function openDeleteUserModal(userId) {
    const deleteModal = document.getElementById('deleteUserModal');
    deleteModal.style.display = 'block';
    deleteModal.dataset.userId = userId;
}

function closeDeleteUserModal() {
    document.getElementById('deleteUserModal').style.display = 'none';
}

// Form submission handlers
function handleAddUser(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    const userData = {
        username: formData.get('username'),
        email: formData.get('email'),
        role: formData.get('role')
    };
    
    // Giả sử bạn có API endpoint để thêm user
    console.log('Adding user:', userData);
    
    // Sau khi thêm thành công
    closeAddUserModal();
    loadUsers(); // Reload user list
}

function handleEditUser(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    const userId = document.getElementById('editUserModal').dataset.userId;
    const userData = {
        username: formData.get('username'),
        email: formData.get('email'),
        role: formData.get('role')
    };
    
    // Giả sử bạn có API endpoint để cập nhật user
    console.log('Updating user:', userId, userData);
    
    // Sau khi cập nhật thành công
    closeEditUserModal();
    loadUsers(); // Reload user list
}

function confirmDeleteUser() {
    const userId = document.getElementById('deleteUserModal').dataset.userId;
    
    // Giả sử bạn có API endpoint để xóa user
    console.log('Deleting user:', userId);
    
    // Sau khi xóa thành công
    closeDeleteUserModal();
    loadUsers(); // Reload user list
}



// Initialize when page loads
document.addEventListener('DOMContentLoaded', () => {
    loadUsers();
});

// Close modals when clicking outside
window.addEventListener('click', (event) => {
    const modals = [
        'manageUsersModal',
        'addUserModal',
        'editUserModal',
        'deleteUserModal'
    ];
    
    modals.forEach(modalId => {
        const modal = document.getElementById(modalId);
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
});