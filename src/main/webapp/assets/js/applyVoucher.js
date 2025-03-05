$(document).ready(function () {
    $("#voucherSelect").on("change", function () {
        const vid = $(this).val();
        const finalPriceElement = $("#finalPrice");

        if (!vid) {
            finalPriceElement.html(
                "Gía phải trả: <f:formatNumber value=\"${sessionScope.cart.totalPrice}\" type=\"currency\" currencySymbol=\"VND\"/>"
            );
            return;
        }

        $.ajax({
            url: `applyVoucher`,
            type: "POST",
            data: { vid: vid },
            dataType: "json",
            success: function (response) {
                finalPriceElement.html(
                    `Gía phải trả: ${new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND',
                    }).format(response.finalPrice)}`
                );
            },
            error: function (xhr, status, error) {
                console.error("Error applying voucher:", error);
                alert("Có lỗi xảy ra khi áp dụng mã giảm giá.");
            },
        });
    });
});