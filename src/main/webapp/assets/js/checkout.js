document.querySelector("#submitPayment").addEventListener("click", function () {
    const recipientName = $('#recipientName').val();
    const deliveryAddress = $('#deliveryAddress').val();
    const recipientPhone = $('#recipientPhone').val();
    const paymentMethod = $('#paymentMethod').val();

    if (!recipientName || !deliveryAddress || !recipientPhone || !paymentMethod) {
        alert("Vui lòng điền đầy đủ thông tin.");
        return;
    }



    $.ajax({
        url: "checkout",
        type: "POST",
        data: {
            recipientName: recipientName,
            deliveryAddress: deliveryAddress,
            recipientPhone: recipientPhone,
            paymentMethod: paymentMethod

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
                alert("Giỏ hàng của bạn đang trống!");
            } else {
                alert("Đã xảy ra lỗi trong quá trình thanh toán. Vui lòng thử lại!");
            }
        }
    });
});
