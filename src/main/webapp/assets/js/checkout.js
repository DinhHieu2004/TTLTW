document.querySelector("#submitPayment").addEventListener("click", function () {
    const recipientName = $('#recipientName').val();
    const deliveryAddress = $('#deliveryAddress').val();
    const recipientPhone = $('#recipientPhone').val();
    const paymentMethod = $('#paymentMethod').val();
    const shippingFeeStr = $('#shippingFee').text();
    const shippingFee = shippingFeeStr.split(' ')[0];


    console.log(recipientName + " "+ deliveryAddress+" "+ shippingFee)
    const amountText = $("#finalPrice").text(); // lấy giá trị từ label
    const amount = parseInt(amountText.replace(/[^\d]/g, ""), 10);


    if (!recipientName || !deliveryAddress || !recipientPhone || !paymentMethod) {
        alert("Vui lòng điền đầy đủ thông tin.");
        return;
    }



    if (paymentMethod === "1") {
        $.ajax({
            url: "checkout",
            type: "POST",
            data: {
                recipientName: recipientName,
                deliveryAddress: deliveryAddress,
                recipientPhone: recipientPhone,
                paymentMethod: paymentMethod,
                shippingFee: shippingFee
            },
            success: function (response) {
                alert(response);
                location.reload();
            },
            error: function (xhr) {
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
                    alert("Đã xảy ra lỗi trong quá trình thanh toán. Vui lòng thử lại!");
                }
            }
        });
    }
    else {
        $.ajax({
            url: "ajaxServlet",
            type: "POST",
            data: { amount: amount,
                recipientName: $("#recipientName").val(),
                recipientPhone: $("#recipientPhone").val(),
                deliveryAddress: $("#deliveryAddress").val(),
                shippingFee : shippingFee
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