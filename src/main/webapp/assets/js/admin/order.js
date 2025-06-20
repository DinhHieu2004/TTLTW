$(document).ready(function () {
    let orderStatus = null;

    $('#orderDetailsModal').on('show.bs.modal', function (event) {
        const button = $(event.relatedTarget);
        const orderId = button.data('order-id');
        const modalBody = $('#orderDetailsBody');
        const modalInfo = $('#orderRecipientInfo');
        const modelPrice = $(`#totalPrice`)
        const deliveryStatus = $('#orderStatus');
        const statusSelect = $('#statusSelect');
        const recipientName = $('#recipientName');
        const recipientPhone = $('#recipientPhone');
        const deliveryAddress = $('#deliveryAddress');
        const updateStatusBtn = $('#updateStatusBtn');

        modalInfo.empty();
        modalBody.empty();
        // modalStatus.empty();

        $.ajax({
            url: `../order-detail?orderId=${orderId}`,
            method: 'GET',
            dataType: 'json',
            success: function (response) {
                console.log('Response from order-detail:', response);

                if (response) {
                    console.log(response)
                    const order = response.order;
                    const appliedVouchers = response.appliedVouchers || [];
                    orderStatus = order.deliveryStatus;

                    let orderDate = '';
                    if (order.orderDate) {
                        try {
                            orderDate = new Date(order.orderDate).toLocaleDateString('vi-VN');
                        } catch (e) {
                            console.error('Error formatting date:', e);
                            orderDate = order.orderDate;
                        }
                    }

                    modalInfo.html(`
                    <label for="recipientName"><strong>Tên người nhận:</strong></label>
                    <input type="text" id="recipientName" name="recipientName" value="${order.recipientName || ''}" class="form-control mb-2">

                    <label for="recipientPhone"><strong>Số điện thoại:</strong></label>
                    <input type="text" id="recipientPhone" name="recipientPhone" value="${order.recipientPhone || ''}" class="form-control mb-2">
                    
                    <label for="orderDate"><strong>Ngày đặt hàng:</strong></label>
                    <input type="text" id="orderDate" name="orderDate" value="${orderDate || ''}" class="form-control mb-2">
                    
                    <label for="deliveryAddress"><strong>Địa chỉ nhận hàng:</strong></label>
                    <input type="text" id="deliveryAddress" name="deliveryAddress" value="${order.deliveryAddress || ''}" class="form-control mb-2">
                    <p><strong>Ngày nhận hàng:</strong> ${formatDate(order.deliveryDate)}</p>


                `);
                    const voucherText = appliedVouchers.length > 0 ? appliedVouchers.join(', ') : "Không có";

                    modelPrice.html(`
                            <p><strong>Phí vận chuyển:</strong> ${formatCurrency(order.shippingFee)}</p>
                            <p><strong>Voucher áp dụng:</strong> ${voucherText}</p>
                            <p><strong>Tổng trả:</strong> ${formatCurrency(order.priceAfterShipping || 0)}</p>
                            <p><strong>Phương thức TT:</strong> ${order.paymentMethod}</p>
                    `)
                    deliveryStatus.text(order.deliveryStatus || '');
                    if (statusSelect.length) {
                        statusSelect.val(deliveryStatus);
                    }
                    if (deliveryStatus === 'đã hủy giao hàng' || orderStatus === 'giao hàng thất bại') {
                        updateStatusBtn.prop('disabled', true);
                    }else{
                        updateStatusBtn.prop('enable', true);

                    }
                } else {
                    modalInfo.html('<p>Không tìm thấy thông tin đơn hàng</p>');
                }
            },
            error: function (xhr, status, error) {
                console.error('Error:', error);
                console.error('Status:', status);
                console.error('Response:', xhr.responseText);
                modalInfo.html('<p>Có lỗi khi tải thông tin đơn hàng</p>');
            }
        });
        const contextPath = window.location.pathname.split('/')[1];
        $.ajax({
            url: `../order/order-items?orderId=${orderId}`,
            method: 'GET',
            dataType: 'json',
            success: function (details) {
                console.log(details)
                if (details.length === 0) {

                    modalBody.append('<tr><td colspan="4">Không có chi tiết đơn hàng.</td></tr>');
                    return;
                }
                details.forEach(product => {

                    const fullPhotoUrl = `${product.imageUrlCloud}`;

                    const row = `
                            <tr>
                                <td>${product.paintingId}</td>
                                <td>${product.name}</td>
                                <td><img src="${fullPhotoUrl}" alt="${product.name}" width="60"></td>
                                <td>${product.sizeDescription}</td>
                                <td>${product.quantity}</td>
                                <td>${formatCurrency(product.price)}</td>
                             
                                 </tr>`;
                    modalBody.append(row);
                });
            },
            error: function () {
                alert('Lỗi khi tải chi tiết đơn hàng.');
            }

        });
        $('#updateStatusBtn').off('click').on('click', function () {
            const newStatus = $('#statusSelect').val();
            const recipientName = $('#recipientName').val();
            const recipientPhone = $('#recipientPhone').val();
            const deliveryAddress = $('#deliveryAddress').val();

            $.ajax({
                url: '../update-order-status',
                method: 'POST',
                data: {
                    orderId: orderId,
                    deliveryStatus: newStatus,
                    recipientName: recipientName,
                    deliveryAddress: deliveryAddress,
                    recipientPhone: recipientPhone
                },
                success: function () {
                    $('#orderStatus').text(newStatus);

                    $(`.delivery-status[data-order-id='${orderId}']`).text(newStatus);

                    const modal = bootstrap.Modal.getInstance(document.getElementById('orderDetailsModal'));
                    modal.hide();
                },
                error: function () {
                    alert('Lỗi khi cập nhật trạng thái đơn hàng');
                }
            });
        });


    });
    function formatDate(dateString) {
        if (!dateString) return '';

        const date = new Date(dateString);
        if (isNaN(date.getTime())) return '';

        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }
    function formatCurrency(value) {
        return value.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' }).replace('₫', '₫');
    }

});
