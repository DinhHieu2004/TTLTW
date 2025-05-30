$(document).ready(function () {
    // Thêm vào giỏ hàng
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

    // Xóa khỏi giỏ hàng
    $(".remove-item").click(function (e) {
        e.preventDefault();

        const button = $(this);
        const productId = button.data("product-id");
        const sizeId = button.data("size-id");

        $.ajax({
            url: "remove-from-cart",
            type: "POST",
            data: {
                productId: productId,
                sizeId: sizeId,
            },
            success: function(response) {
                console.log(response);
                if (response.status === "success") {
                    const formattedPrice = formatCurrencyVND(response.cart.totalPrice);

                    $("#total-price").text(formattedPrice);
                    $("#totalAmount").text(formattedPrice);

                    $(`#cart-item-${productId}-${sizeId}`).remove();
                    $(`#cart-itemp-${productId}-${sizeId}`).remove();
                    $(`#mini-cart-item-${productId}-${sizeId}`).remove();

                    if (!response.cart.items || response.cart.items.length === 0) {
                        $(".card-body").html(`
                            <div class="alert alert-info text-center" role="alert">
                                Giỏ hàng của bạn đang trống.
                            </div>
                        `);
                    }
                    updateMiniCartHeader(Object.values(response.cart.items));
                } else {
                    alert(response.message || "Đã xảy ra lỗi khi xóa sản phẩm khỏi giỏ hàng.");
                }
            },
            error: function() {
                alert("Lỗi kết nối đến máy chủ.");
            }
        });
    });

    function updateMiniCartHeader(items) {
        let miniCartHtml = '';

        if (!items || Object.keys(items).length === 0) {
            $('#mini-cart-items').html(`
                <div class="alert alert-info text-center" role="alert">
                    Giỏ hàng của bạn đang trống.
                </div>
            `);
            $('#mini-cart-count').text(0);
            $('#cart-item-count').hide();
            return;
        }

        let totalQuantity = 0;

        Object.values(items).forEach(item => {
            totalQuantity += item.quantity;

            const finalPrice = item.discountPrice
                ? formatCurrencyVND(item.discountPrice)
                : formatCurrencyVND(item.totalPrice);
            const discountBadge = item.discountPercent > 0 ? `<span class="badge bg-success ms-2">-${item.discountPercent}%</span>` : '';
            const fullImgUrl = item.imageUrlCloud && item.imageUrlCloud.trim() !== ""
                ? `${item.imageUrlCloud}?f_auto,q_auto,w_80`
                : `${window.location.origin}${contextPath}/${item.imageUrl}`;
            miniCartHtml += `
                <div class="cart-item" id="mini-cart-item-${item.productId}-${item.sizeId}">
                    <img src="${fullImgUrl}" alt="${item.productName}" class="cart-item-image" />
                    <div class="cart-item-details">
                        <div class="cart-item-name-price">
                            <span class="cart-item-name">${item.productName}</span>
                            <span class="cart-item-price">${finalPrice} ${discountBadge}</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px; font-size: 14px;">
                            <div class="cart-item-size">Size: ${item.sizeDescriptions}</div>
                            <div class="cart-item-quantity">Số lượng: ${item.quantity}</div>
                        </div>
                    </div>
                    <button class="remove-item"
                            data-product-id="${item.productId}"
                            data-size-id="${item.sizeId}"
                            style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); border: none; background: none; cursor: pointer; font-size: 16px; color: #ff0000;">
                        X
                    </button>
                </div>
            `;
        });

        $('#mini-cart-items').html(miniCartHtml);
        $('#mini-cart-count').text(Object.keys(items).length); // Số loại sản phẩm
        $('#cart-item-count').text(totalQuantity).show();
    }

    function formatCurrencyVND(amount) {
        if (typeof amount !== 'number') {
            amount = parseFloat(amount);
        }
        if (isNaN(amount)) return '0 ₫';
        return amount.toLocaleString('vi-VN') + ' ₫';
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