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
            console.log(response);

            if (response && response.items) {
                let itemKey = productId + "_" + sizeId;

                if (response.items[itemKey]) {
                    let discountPrice = response.items[itemKey].discountPrice.toLocaleString();
                    let price = response.items[itemKey].totalPrice.toLocaleString();
                    let discountPercent = response.items[itemKey].discountPercent.toLocaleString();

                    $("#cart-item-" + productId + "-" + sizeId + " .item-total-price").html(
                        discountPercent > 0 ?
                            `<div class="price-info">
                        <del class="text-muted">Giá gốc: ${price} VND</del>
                        <span class="badge bg-success ms-2">-${discountPercent}%</span>
                        <div class="text-danger fw-bold">Giá đã giảm: ${discountPrice} VND</div>
                    </div>`
                            :
                            `<div class="price-info">
                        <span class="fw-bold">Giá: ${price} VND</span>
                    </div>`
                    );
                }

                $("#total-price").text(response.totalPrice.toLocaleString() + " VND");
                $("#totalAmount").text(response.totalPrice.toLocaleString() + " VND");

                updateMiniCartHeader(response.items);

            } else {
                alert("Có lỗi xảy ra khi cập nhật giỏ hàng.");
            }
        },

        error: function() {
            alert("Lỗi kết nối đến máy chủ.");
        }
    });

    function updateMiniCartHeader(items) {
        let miniCartHtml = '';

        Object.keys(items).forEach(key => {
            let item = items[key]; // Truy xuất sản phẩm dựa vào key

            const finalPrice = item.discountPrice ? item.discountPrice.toLocaleString() : item.totalPrice.toLocaleString();
            const discountBadge = item.discountPercent > 0 ? `<span class="badge bg-success ms-2">-${item.discountPercent}%</span>` : '';

            miniCartHtml += `
        <div class="cart-item" id="mini-cart-item-${item.productId}-${item.sizeId}">
            <img src="${item.imageUrl}" alt="${item.productName}" class="cart-item-image" />
            <div class="cart-item-details">
                <div class="cart-item-name-price">
                    <span class="cart-item-name">${item.productName}</span>
                    <span class="cart-item-price">${finalPrice} VND ${discountBadge}</span>
                </div>
               <div style="display: flex; align-items: center; gap: 10px; font-size: 14px;">
                    <div class="cart-item-size">size: ${item.sizeDescriptions}</div>
                    <div class="cart-item-quantity">số lượng: ${item.quantity}</div>
                </div>
                   </div>
        </div>
        `;
        });

        $('#mini-cart-items').html(miniCartHtml);
        $('#mini-cart-count').text(Object.keys(items).length);
    }

});
