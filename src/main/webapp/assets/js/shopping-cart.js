
$(document).on('click', '.remove-item', function (e) {
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
            if (response.status === "success") {
                console.log("Successfully removed item.");

                $("#totalAmount").text(response.cart.totalPrice.toLocaleString() + " VND");
                $("#total-price").text(response.cart.totalPrice.toLocaleString() + " VND");
                $(`#cart-item-${productId}-${sizeId}`).remove();

                // Kiểm tra nếu giỏ hàng trống
                if (!response.cart.items || Object.keys(response.cart.items).length === 0) {
                    $(".card-body").html(`
                        <div class="alert alert-info text-center" role="alert">
                            Giỏ hàng của bạn đang trống.
                        </div>
                    `);
                }

                // Cập nhật mini cart
                updateMiniCartHeader(response.cart.items);
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

        console.log(items)
        let miniCartHtml = '';

        if (!items || Object.keys(items).length === 0) {
            $('#mini-cart-items').html(`
            <div class="alert alert-info text-center" role="alert">
                Giỏ hàng của bạn đang trống.
            </div>
        `);
            $('#mini-cart-count').text(0);
            return;
        }

        // Chuyển object thành array để sử dụng forEach
        let itemArray = Object.values(items);

        itemArray.forEach(item => {
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
        $('#mini-cart-count').text(itemArray.length);
    }



