$(document).on('click', '.increase-quantity, .decrease-quantity', function (e) {
    console.log("Document is ready!");

    e.preventDefault();

    const button = $(this);
    const productId = button.data("product-id");
    const sizeId = button.data("size-id");
    const maxQuantity = button.data("max-quantity");

    let quantitySpan = button.siblings('.quantity');
    let currentQuantity = parseInt(quantitySpan.text());

    if (button.hasClass('increase-quantity') && currentQuantity < maxQuantity) {
        currentQuantity++;
    } else if (button.hasClass('decrease-quantity') && currentQuantity > 1) {
        currentQuantity--;
    }

    quantitySpan.text(currentQuantity);

    $.ajax({
        url: "update-quantity",
        type: "POST",
        data: {
            productId: productId,
            sizeId: sizeId,
            newQuantity: currentQuantity
        },
        success: function(response) {
            console.log(response)
            if (response) {
                let itemKey = productId + "_" + sizeId;
                if (response.items[itemKey]) {
                    let discountPrice = response.items[itemKey].discountPrice.toLocaleString();
                    let price = response.items[itemKey].totalPrice.toLocaleString();
                    let discountPercent = response.items[itemKey].discountPercent.toLocaleString();


                    $("#cart-item-" + productId + "-" + sizeId + " .item-total-price").html(
                        discountPercent > 0 ?
                            '<div class="price-info">' +
                            '<del class="text-muted">Giá gốc: ' + price + ' VND</del>' +
                            '<span class="badge bg-success ms-2">-' + discountPercent + '%</span>' +
                            '<div class="text-danger fw-bold">' +
                            'Giá đã giảm: ' + discountPrice + ' VND' +
                            '</div>' +
                            '</div>'
                            :
                            '<div class="price-info">' +
                            '<span class="fw-bold">Giá: ' + price + ' VND</span>' +
                            '</div>'
                    );

                }
                totalAmount
                $("#total-price").text(response.totalPrice.toLocaleString() + " VND");
                $("#totalAmount").text(response.totalPrice.toLocaleString() + " VND");

            } else {
                alert(response.e);
            }
        },
        error: function() {
            alert("Lỗi kết nối đến máy chủ.");
        }
    });

});
