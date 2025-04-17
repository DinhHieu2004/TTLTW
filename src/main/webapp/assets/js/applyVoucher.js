$(document).ready(function () {
    // Mở modal
    $("#openVoucherModal").on("click", function () {
        $("#voucherModal").removeClass("hidden").css("display", "flex");
    });

    // Đóng modal
    $(".close").on("click", function () {
        $("#voucherModal").addClass("hidden").css("display", "none");
    });

    // Nhấn "Áp dụng"
    $("#applyVoucherBtn").on("click", function () {
        const selectedVoucherId = $("input[name='voucherOption']:checked").val();

        if (!selectedVoucherId) {
            alert("Vui lòng chọn một mã giảm giá.");
            return;
        }

        // Set vào hidden input
        $("#voucherSelect").val(selectedVoucherId);

        // Gửi AJAX để áp dụng
        $.ajax({
            url: "applyVoucher",
            type: "POST",
            data: { vid: selectedVoucherId },
            dataType: "json",
            success: function (response) {
                $("#finalPrice").text(
                    new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND'
                    }).format(response.finalPrice)
                );

                // Đóng modal
                $("#voucherModal").addClass("hidden").css("display", "none");
            },
            error: function () {
                alert("Lỗi khi áp dụng voucher.");
            }
        });
    });
});
