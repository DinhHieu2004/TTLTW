document.addEventListener("DOMContentLoaded", function () {
    const table1 = document.getElementById("product-table");
    const dataTable = new DataTable(table1, {
        "paging": true,
        "searching": true,

        "ordering": true,

        "info": false,
        "lengthChange": false,
        "pageLength": 5,
    });
});


const table2 = document.getElementById("variant-content");
const variantDataTable = new DataTable(table2, {
    "paging": true,
    "searching": true,

    "ordering": true,

    "info": false,
    "lengthChange": false,
    "pageLength": 5,
});


const detailsBtns = document.querySelectorAll('.pdetails-btn');
detailsBtns.forEach(function(btn) {
    btn.addEventListener('click', function() {
        const productId = btn.getAttribute('data-id');
        console.log('ID Sản Phẩm:', productId);
        const productIdDisplay = document.getElementById('product-id-display');
        productIdDisplay.textContent = `ID sản phẩm: ${productId}`;
        productDetailModal.style.display = 'block';
    });


    // Đóng modal khi nhấn nút đóng (×)
    const closeButtons = document.querySelectorAll('.close');
    closeButtons.forEach(function(button) {
        button.addEventListener('click', function() {
            const modal = button.closest('.modal');
            modal.style.display = 'none';
        });
    });

    // Đóng modal khi nhấn ngoài vùng modal
    window.addEventListener('click', function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.style.display = 'none';
        }
    });
});
$(document).ready(function() {
    $('#btn-add-product_variant').click(function () {
        document.getElementById('addVariantForm').style.display = 'block';
        document.getElementById('editVariantForm').style.display = 'none';
        document.querySelector('.modal-title').textContent = 'Thêm biến thể sản phẩm';
        $('#addVariantModal').modal('show')
    });

    $('#btn-add-category').click(function () {
        $('#addCategoryModal').modal('show')
    });

    $('#btn-add-user').click(function () {
        $('#addUserModal').modal('show')
    });

    $('#btn-add-product').click(function () {
        document.getElementById('addProForm').style.display = 'block';
        document.getElementById('editProForm').style.display = 'none';
        document.querySelector('.modal-title').textContent = 'Thêm sản phẩm';
        $('#addProductModal').modal('show')
    });
    $('#btn-add-brand').click(function () {
        $('#addBrandModal').modal('show')
    });
});
function openEditBrandModal(brandId) {

    $.ajax({
        type: 'GET',
        url: '/LTW_BanNonBaoHiem/edit-tab-product',
        data: {
            action: 'findBrand',
            brandId: brandId
        },
        dataType: 'json',
        success: function(data) {
            $('#editBrandId').val(data.id);
            $('#editBrandName').val(data.name);
            $('#editBrandImagePreview').attr('src', '/LTW_BanNonBaoHiem/' + data.imageUrl);

            $('#editBrandModal').modal('show');
        },
        error: function(xhr, status, error) {
            console.log('Lỗi:', error);
            console.log('Response:', xhr.responseText);
        }
    });
}
function openEditProModal(productId) {

    $.ajax({
        type: 'GET',
        url: '/LTW_BanNonBaoHiem/edit-tab-product',
        data: {
            action: 'findProduct',
            productId: productId
        },
        dataType: 'json',
        success: function(data) {
            $('#editProductId').val(data.id);
            $('#productName').val(data.name);
            $('#productDescription').val(data.description);
            $('#brand').val(data.brand.id);
            $('#category').val(data.category.id);

            document.getElementById('addProForm').style.display = 'none';
            document.getElementById('editProForm').style.display = 'block';
            document.querySelector('.modal-title').textContent = 'Chỉnh sửa sản phẩm';
            $('#addProductModal').modal('show');
        },
        error: function(xhr, status, error) {
            console.log('Lỗi:', error);
            console.log('Response:', xhr.responseText);
        }
    });
}
function openEditVariantModal(variantId) {

    $.ajax({
        type: 'GET',
        url: '/LTW_BanNonBaoHiem/edit-tab-product',
        data: {
            action: 'findProductVariant',
            variantId: variantId
        },
        dataType: 'json',
        success: function(data) {
            $('#editVariantId').val(data.id);
            $('#editProductParent').val(data.productId);
            $('#editVariantName').val(data.name);
            $('#editVariantColor').val(data.color);
            $('#editVariantPrice').val(data.price);
            $('#editVariantImagePreview').attr('src', '/LTW_BanNonBaoHiem/' + data.image);
            $('#editVariantActive').val(data.isActive ? 1 : 0);

            document.getElementById('addVariantForm').style.display = 'none';
            document.getElementById('editVariantForm').style.display = 'block';
            document.getElementById('addVariantModalLabel').textContent = 'Chỉnh sửa biến thể sản phẩm';
            $('#addVariantModal').modal('show');
        },
        error: function(xhr, status, error) {
            console.log('Lỗi:', error);
            console.log('Response:', xhr.responseText);
        }
    });
}
$('#addUserModal').submit(function(event){
    event.preventDefault();
    var username = $('#username').val();
    var password = $('#password').val();
    var confirmPassword = $('#password2').val();
    var email = $('#email').val();
    var fullName = $('#fullName').val();
    var role = $('#role').val();
    var active = $('#active').val();

    $.ajax({
        url: '/LTW_BanNonBaoHiem/admin/user',
        method: 'POST',
        data: {
            username: username,
            password: password,
            confirmPassword: confirmPassword,
            email: email,
            fullName: fullName,
            role: role,
            active: active,
            action: 'add'
        },
        success: function(response) {
            if (response.registerSuccess) {
                location.reload();
            }
        },
        error: function(xhr) {
            var errors = JSON.parse(xhr.responseText);

            $('.form-message').text('').hide();


            if (errors.registerError) {
                $('.form-message-register').text(errors.registerError).show();
            }
            if (errors.username) {
                $('.form-message-username').text(errors.username).show();
            }
            if (errors.password) {
                $('.form-message-password').text(errors.password).show();
            }
            if (errors.confirmPass) {
                $('.form-message-password-confi').text(errors.confirmPass).show();
            }
            if (errors.email) {
                $('.form-message-email').text(errors.email).show();
            }
            if (errors.name) {
                $('.form-message-name').text(errors.name).show();
            }
            $('#signup-login').modal('show');
        }
    });
});






