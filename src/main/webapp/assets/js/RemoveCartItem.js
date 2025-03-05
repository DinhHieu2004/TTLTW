$(document).ready(function () {
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
                    const formattedPrice = response.cart.totalPrice.toLocaleString() + " VND";
                    $("#total-price").text(formattedPrice);
                    $("#totalAmount").text(formattedPrice);
                    if (!response.cart.items || response.cart.items.length === 0) {
                        $(".card-body").html(`
                            <div class="alert alert-info text-center" role="alert">
                                Giỏ hàng của bạn đang trống.
                            </div>
                        `);
                    }
                    $(`#cart-item-${productId}-${sizeId}`).remove();
                    $(`#cart-itemp-${productId}-${sizeId}`).remove();

                    updateMiniCart(response.cart);
                } else {
                    alert(response.message || "Đã xảy ra lỗi khi xóa sản phẩm khỏi giỏ hàng.");
                }
            },
            error: function() {
                alert("Lỗi kết nối đến máy chủ.");
            }
        });
    });

    function updateMiniCart(cart) {
        const miniCart = $("#mini-cart");
        miniCart.empty();

        if (cart.items && cart.items.length > 0) {
            cart.items.forEach(item => {
                miniCart.append(`
                    <li>
                        <img src="${item.imageUrl}" alt="${item.productName}" width="30">
                        ${item.productName} - ${item.quantity} x ${item.price.toLocaleString()} VND
                    </li>
                `);
            });
            miniCart.append(`
                <li class="text-end fw-bold">Tổng: ${cart.totalPrice.toLocaleString()} VND</li>
            `);
        } else {
            miniCart.html(`
                <li>Giỏ hàng trống.</li>
            `);
        }
    }
});
