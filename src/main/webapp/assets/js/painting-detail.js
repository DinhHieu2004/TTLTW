$(document).ready(function () {
    $('#addToCartForm').on('submit', function (event) {
        event.preventDefault();

        const formData = $(this).serialize();

        $.ajax({
            url: 'add-to-cart',
            type: 'POST',
            data: formData,
            success: function (response) {
                console.log(response.cart);

                $('#cartMessage').html(`
        <div id="alertMessage" class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>Đã thêm vào giỏ hàng thành công!</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    `);

                if (response.cart && response.cart.items) {
                    if (response.cart.items instanceof Object) {
                        console.log('Giỏ hàng có dạng đối tượng:', response.cart.items);

                        const itemsArray = Object.values(response.cart.items);

                        // Cập nhật giỏ hàng mini
                        updateMiniCartHeader(itemsArray);
                    } else {
                        console.error('Dữ liệu giỏ hàng không đúng định dạng:', response.cart.items);
                    }
                } else {
                    console.error('Dữ liệu giỏ hàng không đúng định dạng:', response.cart);
                }

                setTimeout(() => {
                    $('#alertMessage').fadeOut(500, function () {
                        $(this).remove();
                    });
                }, 1000);
            },
            error: function () {
                $('#cartMessage').html(`
                    <div id="alertMessage" class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Đã xảy ra lỗi, vui lòng thử lại!</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                `);

                setTimeout(() => {
                    $('#alertMessage').fadeOut(500, function () {
                        $(this).remove();
                    });
                }, 1000);
            }
        });
    });

    function updateMiniCartHeader(items) {
        let miniCartHtml = '';

        items.forEach(item => {
            const finalPrice = item.discountPrice ? item.discountPrice.toLocaleString() : item.totalPrice.toLocaleString();
            const discountBadge = item.discountPercent > 0 ? `<span class="badge bg-success ms-2">-${item.discountPercent}%</span>` : '';

            miniCartHtml += `
            <div class="cart-item" id="mini-cart-item-${item.productId}-${item.sizeId}">
                <img src="${item.imageUrl}" alt="${item.productName}" class="cart-item-image" />
                <div class="cart-item-details">
                    <div class="cart-item-name-price">
                        <span class="cart-item-name">${item.productName}</span>
                        <span class="cart-item-price">${finalPrice} VNĐ ${discountBadge}</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 10px; font-size: 14px;">
                        <div class="cart-item-size">Size: ${item.sizeDescriptions}</div>
                        <div class="cart-item-quantity">Số lượng: ${item.quantity}</div>
                    </div>
                </div>
            </div>
        `;
        });

        $('#mini-cart-items').html(miniCartHtml);
        $('#mini-cart-count').text(items.length);
    }

    window.incrementQuantity = function () {
        const input = $('#quantity');
        const max = parseInt(input.attr('max')) || Infinity;
        const currentValue = parseInt(input.val());
        if (currentValue < max) {
            input.val(currentValue + 1);
        }
    };

    window.decrementQuantity = function () {
        const input = $('#quantity');
        const currentValue = parseInt(input.val());
        if (currentValue > 1) {
            input.val(currentValue - 1);
        }
    };
});
