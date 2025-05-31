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
                    let discountPrice = formatCurrencyVND(response.items[itemKey].discountPrice);
                    let price = formatCurrencyVND(response.items[itemKey].totalPrice);

                    let discountPercent = response.items[itemKey].discountPercent.toLocaleString();

                    $("#cart-item-" + productId + "-" + sizeId + " .item-total-price").html(
                        discountPercent > 0
                            ? `<div class="price-info">
                            <del class="text-muted">Giá gốc: ${price}</del>
                            <span class="badge bg-success ms-2">-${discountPercent}%</span>
                            <div class="text-danger fw-bold">Giá đã giảm: ${discountPrice}</div>
                           </div>`
                                            : `<div class="price-info">
                                <span class="fw-bold">Giá: ${price}</span>
                           </div>`
                    );

                }

                $("#cart-total-price").text(formatCurrencyVND(response.totalPrice));
                $("#totalAmount").text(formatCurrencyVND(response.totalPrice));

                const modalRowSelector = `#cart-itemp-${productId}-${sizeId}`;
                const item = response.items[itemKey];
                if ($(modalRowSelector).length && item) {
                    $(`${modalRowSelector} .quantity`).text(item.quantity);

                    const finalPrice = item.discountPrice !== undefined && item.discountPrice !== null
                        ? item.discountPrice
                        : item.totalPrice;
                    $(`${modalRowSelector} td:last-child`).text(formatCurrencyVND(finalPrice));
                }

                const formattedTotal = formatCurrencyVND(response.totalPrice);
                document.querySelectorAll("#total-price-value, #totalAmount, #checkout-total-price-value, #cart-total-price-value")
                    .forEach(el => {
                        el.textContent = formattedTotal;
                    });


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

            const finalPrice = item.discountPrice
                ? formatCurrencyVND(item.discountPrice)
                : formatCurrencyVND(item.totalPrice);
            const discountBadge = item.discountPercent > 0 ? `<span class="badge bg-success ms-2">-${item.discountPercent}%</span>` : '';

            miniCartHtml += `
        <div class="cart-item" id="mini-cart-item-${item.productId}-${item.sizeId}">
            <img src="${item.imageUrlCloud}" alt="${item.productName}" class="cart-item-image" />
            <div class="cart-item-details">
                <div class="cart-item-name-price">
                    <span class="cart-item-name">${item.productName}</span>
                    <span class="cart-item-price">${finalPrice} ${discountBadge}</span>
                </div>
               <div style="display: flex; align-items: center; gap: 10px; font-size: 14px;">
                    <div class="cart-item-size">size: ${item.sizeDescriptions}</div>
                    <div class="cart-item-quantity">số lượng: ${item.quantity}</div>
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
        $('#mini-cart-count').text(Object.keys(items).length);
    }

    function formatCurrencyVND(amount) {
        if (typeof amount !== 'number') amount = parseFloat(amount);
        if (isNaN(amount)) return '0 ₫';
        return amount.toLocaleString('vi-VN') + ' ₫';
    }


});