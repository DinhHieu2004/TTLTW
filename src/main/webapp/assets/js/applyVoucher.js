$(document).ready(function () {
    $("#openVoucherModal").on("click", function () {
        const modal = $("#voucherModal");
        modal.removeClass("hidden").addClass("d-flex");
    });

    $(".close").on("click", function () {
        const modal = $("#voucherModal");
        modal.addClass("hidden").removeClass("d-flex");
    });

    function renderCurrency(selector, value) {
        $(selector).text(
            new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(value)
        );
    }

    // tick checkbox
    $("input[name='voucherOption']").on("change", function () {
        const selectedVoucherIds = $("input[name='voucherOption']:checked")
            .map(function () {
                return $(this).val();
            }).get();

        // hiển thị so lượng voucher
        const $countDisplay = $("#voucherCount");
        if (selectedVoucherIds.length === 0) {
            $countDisplay.hide().text("");
        } else {
            $countDisplay.text(`${selectedVoucherIds.length} mã áp dụng`).show();
        }

        $.ajax({
            url: "applyVoucher",
            type: "POST",
            traditional: true,
            data: { vid: selectedVoucherIds },
            dataType: "json",
            success: function (response) {
                const productPrice = response.finalPrice || 0;
                const shippingFee = response.shippingFee || 0;
                const total = productPrice + shippingFee;

                renderCurrency("#finalPrice", total);
            },
            error: function () {
                alert("Lỗi khi áp dụng voucher.");
            }
        });
    });

    $("#applyVoucherBtn").on("click", function () {
        const selectedVoucherIds = $("input[name='voucherOption']:checked")
            .map(function () {
                return $(this).val();
            }).get();

        $("#voucherSelect").val(selectedVoucherIds.join(","));

        $.ajax({
            url: "applyVoucher",
            type: "POST",
            traditional: true,
            data: { vid: selectedVoucherIds },
            dataType: "json",
            success: function (response) {
                const productPrice = response.finalPrice || 0;
                const shippingFee = response.shippingFee || 0;
                const total = productPrice + shippingFee;

                renderCurrency("#finalPrice", total);

                const modal = $("#voucherModal");
                modal.addClass("hidden").removeClass("d-flex");
            },
            error: function () {
                alert("Lỗi khi áp dụng voucher.");
            }
        });
    });

    // nhập mã
    $("#applyManualVoucher").on("click", function () {
        const manualCode = $("#manualVoucher").val().trim();
        if (!manualCode) return;

        $.ajax({
            url: "applyVoucherByCode",
            type: "POST",
            data: { code: manualCode },
            dataType: "json",
            success: function (response) {
                if (response.success) {
                    const productPrice = response.finalPrice || 0;
                    const shippingFee = response.shippingFee || 0;

                    const total = productPrice + shippingFee;

                    renderCurrency("#finalPrice", total);

                    $(`input[name='voucherOption'][value='${response.voucherId}']`).prop("checked", true).trigger("change");
                } else {
                    alert("Mã không hợp lệ hoặc đã hết hạn.");
                }
            },
            error: function () {
                alert("Lỗi khi áp dụng mã voucher.");
            }
        });
    });
});
