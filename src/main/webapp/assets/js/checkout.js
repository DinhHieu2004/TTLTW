document.querySelector("#submitPayment").addEventListener("click", function () {
    const recipientName = $('#recipientName').val();
    const deliveryAddress = $('#deliveryAddress').val();
    const recipientPhone = $('#recipientPhone').val();
    const paymentMethod = $('#paymentMethod').val();
    const shippingFeeStr = $('#shippingFee').text();
    const shippingFee = shippingFeeStr.split(' ')[0];

    // cac voucher đã chọn (checkbox)
    const selectedVoucherIds = $("input[name='voucherOption']:checked")
        .map(function () {
            return $(this).val();
        }).get(); // array

    // voucher nhập
    const manualCode = $("#manualVoucher").val().trim();

    // gộp lại
    const allVoucherCodes = [...selectedVoucherIds];
    if (manualCode) allVoucherCodes.push(manualCode);

    const amountText = $("#finalPrice").text();
    const amount = parseInt(amountText.replace(/[^\d]/g, ""), 10);


    if (!recipientName || !deliveryAddress || !recipientPhone || !paymentMethod) {
        alert("Vui lòng điền đầy đủ thông tin.");
        return;
    }

    if (paymentMethod === "1") {
        $.ajax({
            url: "checkout",
            type: "POST",
            traditional: true,
            data: {
                recipientName: recipientName,
                deliveryAddress: deliveryAddress,
                recipientPhone: recipientPhone,
                paymentMethod: paymentMethod,
                shippingFee: shippingFee,
                voucherCodes: allVoucherCodes
            },
            success: function (response) {
                Swal.fire({
                    toast: true,
                    position: 'top-end',
                    icon: 'info',
                    iconHtml: '🎁',
                    title: ' Đặt hàng thành công, nhận voucher quà tặng?',
                    showCancelButton: true,
                    confirmButtonText: 'Nhận',
                    cancelButtonText: 'Đóng',
                    timer: 8000,
                    timerProgressBar: true,
                    customClass: {
                        popup: 'custom-swal-popup',
                        confirmButton: 'btn btn-sm btn-danger me-2',
                        cancelButton: 'btn btn-sm btn-secondary'
                    },
                    buttonsStyling: false
                }).then((result) => {
                    if (result.isConfirmed) {
                        $.ajax({
                            url: 'collect-voucher',
                            type: 'POST',
                            success: function () {
                                Swal.fire({
                                    toast: true,
                                    position: 'top-end',
                                    icon: 'success',
                                    title: '🎁 Voucher đã được lưu vào tài khoản của bạn!',
                                    showConfirmButton: false,
                                    timer: 3500
                                });
                            },
                            error: function () {
                                alert("Có lỗi xảy ra khi lưu voucher.");
                            }
                        });
                    }
                });
                $(".order-summary").append(`
        <div class="alert alert-info text-center mt-3" role="alert">
            Giỏ hàng của bạn đang trống.
        </div>
        <div class="text-center mt-3">
                <a href="${contextPath}/artwork" class="btn btn-primary">Tiếp tục mua hàng</a>
        </div>
    `);
                $(".order-summary table").remove();
                $("#voucherCount").hide().text("");
                $("#shippingFee").text("Chưa tính");

                $("#finalPrice").text("0 ₫");

                $("#voucherModal").remove();

                $("#cart-item-count").text("0");

                $("#mini-cart-items").html(`
        <div class="alert alert-info text-center" role="alert">
            Giỏ hàng của bạn đang trống.
        </div>
    `);

                $(".cart-footer").html(`
        <div class="total-price">
            Tổng tiền: <span id="total-price">0 ₫</span>
        </div>
        <button class="btn btn-primary" onclick="window.location.href='show-cart'"
                style="background: #e7621b !important;">
            Xem Giỏ Hàng
        </button>
    `);
            },
            error: function (xhr) {
                let errorText = xhr.responseText
                if (xhr.status === 401) {
                    alert("Bạn cần đăng nhập để thực hiện thanh toán!");
                    $("#loginModal").modal("show");
                } else if (xhr.status === 400) {
                    let msg = xhr.responseText;
                    if (msg.includes("Giỏ hàng của bạn đang trống")) {
                        alert("Giỏ hàng của bạn đang trống!");
                    } else {
                        alert(msg);
                    }
                } else {
                    console.error("Lỗi từ server: " + errorText);
                    alert("Đã xảy ra lỗi trong quá trình thanh toán. Vui lòng thử lại!");
                }
            }
        });
    }
    else {
        $.ajax({
            url: "ajaxServlet",
            type: "POST",
            traditional: true,
            data: { amount: amount,
                recipientName: $("#recipientName").val(),
                recipientPhone: $("#recipientPhone").val(),
                deliveryAddress: $("#deliveryAddress").val(),
                shippingFee : shippingFee,
                voucherCodes: allVoucherCodes
            },
            dataType: "json",
            success: function (response) {
                if (response.success) {
                    window.location.href = response.paymentUrl;
                } else {
                    alert("Lỗi khi tạo đơn hàng VNPay!");
                }
            },
            error: function (xhr) {
                if (xhr.status === 400) {
                    let msg = xhr.responseText;
                    if (msg.includes("Giỏ hàng của bạn đang trống")) {
                        alert("Giỏ hàng của bạn đang trống!");
                    } else {
                        alert(msg);
                    }
                } else {
                    alert("Đã xảy ra lỗi khi kết nối với VNPay.");
                }
            }
        });
    }
});