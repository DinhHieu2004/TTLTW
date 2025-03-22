$(document).on('click', '.remove-item', function (e) {
    e.preventDefault();

    console.log("Document is ready!");

    $(".remove-item").click(function (e) {
        e.preventDefault();
        console.log("Remove item button clicked!");

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
                console.log(response.status)
                if (response.status === "success") {
                    console.log("Successfully removed item.");
                    $("#totalAmount").text(response.totalPrice.toLocaleString() + " VND");
                    $("#total-price").text(response.totalPrice.toLocaleString() + " VND");
                    $(`#cart-item-${productId}-${sizeId}`).remove();

                    if (!response.cart.items || response.cart.items.length === 0) {
                        $(".card-body").html(`
                            <div class="alert alert-info text-center" role="alert">
                                Giỏ hàng của bạn đang trống.
                            </div>
                        `);
                    }
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

    function updateMiniCart(items) {
        let miniCartHtml = '';

        items.forEach(item => {
            const finalPrice = item.discountPrice ? item.discountPrice : item.totalPrice;

            miniCartHtml += `
        <div class="cart-item">
            <img src="${item.imageUrl}" alt="${item.productName}" class="cart-item-image" />
            <div class="cart-item-details">
                <div class="cart-item-name-price">
                    <span class="cart-item-name">${item.productName}</span>
                    <span class="cart-item-price">${finalPrice} VNĐ</span>
                </div>
                <div class="cart-item-size">${item.sizeDescriptions}</div>
            </div>
        </div>
        `;
        });

        $('#mini-cart-items').html(miniCartHtml);
        $('#mini-cart-count').text(items.length);
    }
});
