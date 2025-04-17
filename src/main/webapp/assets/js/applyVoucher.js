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

    // Nhấn "Áp dụng"
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
                // Cập nhật giá
                $("#finalPrice").text(
                    new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND'
                    }).format(response.finalPrice)
                );

                // Đóng modal
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
    });

});
