$(document).ready(function(){
    $(document).on('click', '.add-to-cart-btn', function () {
        const productId = $(this).data('product-id');
        const form = $('#addToCartForm_' + productId);
        const size = form.find(`input[name="size_${productId}"]:checked`).val();
        const quantityOfSize = $(`input[name="quantity_${size}"]`).val();
        if (!size) {
            showToast('Vui lòng chọn kích thước trước khi thêm vào giỏ!', 'warning');
            return;
        }
        $.ajax({
            url: 'add-to-cart',
            type: 'POST',
            data: {
                pid: productId,
                size: size,
                ['quantity_' + size]: quantityOfSize,
                quantity: 1
            },
            success: function (response) {
                showToast('Đã thêm vào giỏ hàng thành công!', 'success');
                if (response.cart && response.cart.items) {
                    if (response.cart.items instanceof Object) {
                        const itemsArray = Object.values(response.cart.items);
                        updateMiniCartHeader(itemsArray);
                        if (typeof response.cart.totalPrice === 'number') {
                            const formattedTotal = response.cart.totalPrice.toLocaleString('vi-VN') + " ₫";
                            $('#total-price').text(formattedTotal);
                            $('#totalAmount').text(formattedTotal);
                        }
                    } else {
                        console.error('Dữ liệu giỏ hàng không đúng định dạng:', response.cart.items);
                    }
                } else {
                    console.error('Dữ liệu giỏ hàng không đúng định dạng:', response.cart);
                }
            },
            error: function () {
                showToast('Đã xảy ra lỗi, vui lòng thử lại!', 'danger');
            }
        });
    });
});
function showToast(message, type = 'success') {
    const toastId = `toast${Date.now()}`;
    const toastHtml = `
        <div id="${toastId}" class="toast align-items-center text-bg-${type} border-0 show" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    ${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    `;

    $('#toastContainer').append(toastHtml);

    const toastEl = document.getElementById(toastId);
    const bsToast = new bootstrap.Toast(toastEl, { delay: 2000 });
    bsToast.show();
    setTimeout(() => {
        $(`#${toastId}`).remove();
    }, 2500);
}

