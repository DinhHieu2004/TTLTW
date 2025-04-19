$(document).ready(function () {
    $("#openVoucherModal").on("click", function () {
        const modal = $("#voucherModal");
        modal.removeClass("hidden");
        modal.addClass("d-flex");
    });

    $(".close").on("click", function () {
        const modal = $("#voucherModal");
        modal.addClass("hidden");
        modal.removeClass("d-flex");
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
                $("#finalPrice").text(
                    new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND'
                    }).format(response.finalPrice)
                );

                const modal = $("#voucherModal");
                modal.addClass("hidden").removeClass("d-flex");
            },
            error: function () {
                alert("Lỗi khi áp dụng voucher.");
            }
        });
    });

    // hiển thị giá và so lượng voucher khi người dùng tick trong modal vouchers
    $("input[name='voucherOption']").on("change", function () {
        const selectedVoucherIds = $("input[name='voucherOption']:checked")
            .map(function () {
                return $(this).val();
            }).get();

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
                $("#finalPrice").text(
                    new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND'
                    }).format(response.finalPrice)
                );
            },
            error: function () {
                alert("Lỗi khi áp dụng voucher.");
            }
        });
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
                        $("#finalPrice").text(
                            new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(response.finalPrice)
                        );

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
});
