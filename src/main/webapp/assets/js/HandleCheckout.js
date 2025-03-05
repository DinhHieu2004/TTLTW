
$(document).ready(function () {
    $('#paymentMethod').change(function () {
        const selectedMethod = $(this).val();
        if (selectedMethod === 'credit') {
            $('#creditCardInfo').removeClass('d-none');
        } else {
            $('#creditCardInfo').addClass('d-none');
        }
    });

    // Xử lý khi nhấn nút Xác nhận
    $('#submitPayment').click(function () {
        const paymentMethod = $('#paymentMethod').val();
        const shippingAddress = $('#shippingAddress').val();
        const shippingPhone = $('#shippingPhone').val();

        if (!paymentMethod) {
            alert('Vui lòng chọn phương thức thanh toán.');
            return;
        }

        const paymentData = {
            paymentMethod: paymentMethod,
            shippingAddress: shippingAddress,
            shippingPhone: shippingPhone,
        };

        if (paymentMethod === 'credit') {
            paymentData.cardHolderName = $('#cardHolderName').val();
            paymentData.cardNumber = $('#cardNumber').val();
            paymentData.cardExpiry = $('#cardExpiry').val();
            paymentData.cardCVV = $('#cardCVV').val();

            if (!paymentData.cardHolderName || !paymentData.cardNumber || !paymentData.cardExpiry || !paymentData.cardCVV) {
                alert('Vui lòng nhập đầy đủ thông tin thẻ tín dụng.');
                return;
            }
        }

        // Gửi dữ liệu lên server (dùng AJAX hoặc form submit)
        console.log('Dữ liệu thanh toán:', paymentData);
        alert('Thanh toán thành công!');
    });
});
