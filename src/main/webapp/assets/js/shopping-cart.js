
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
                $(`#mini-cart-item-${productId}-${sizeId}`).remove();


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
                
                <button class="remove-item"
                                            data-product-id="${cp.productId}"
                                            data-size-id="${cp.sizeId}"
                                            style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); border: none; background: none; cursor: pointer; font-size: 16px; color: #ff0000;">
                                        X
                                    </button>
            </div>
        `;
        });

        $('#mini-cart-items').html(miniCartHtml);
        $('#mini-cart-count').text(itemArray.length);
    }



