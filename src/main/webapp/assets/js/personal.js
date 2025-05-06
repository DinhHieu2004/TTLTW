$(document).ready(function () {

    $.ajax({
        url: 'user/orders',
        method: 'GET',
        dataType: 'json',
        success: function (response) {
            const currentOrders = response.currentOrders;
            const currentTableBody = $('#currentOrders tbody');
            currentOrders.forEach(order => {
                const row = `
                    <tr>
                        <td>${order.id}</td>
                        <td>${order.priceAfterShipping} VND</td>
                        <td>${order.orderDate}</td>
                        <td>${order.paymentStatus}</td>
                        <td>${order.deliveryStatus}</td>
                        <td><button class="btn btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#orderDetailsModal" data-order-id="${order.id}">Xem Chi Tiết</button></td>
                    </tr>`;
                currentTableBody.append(row);
            });

            const previousOrders = response.previousOrders;
            const previousTableBody = $('#orderHistory tbody');
            previousOrders.forEach(order => {
                const row = `
                    <tr>
                        <td>${order.id}</td>
                        <td>${order.priceAfterShipping} VND</td>
                        <td>${order.orderDate}</td>
                        <td>${order.deliveryDate}</td>
                        <td>${order.paymentStatus}</td>
                        <td>${order.deliveryStatus}</td>
                        <td><button class="btn btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#orderDetailsModal" data-order-id="${order.id}">Xem Chi Tiết</button></td>
                    </tr>`;
                previousTableBody.append(row);
            });
        },
        error: function () {
            alert('Lỗi khi tải dữ liệu đơn hàng.');
        }
    });

    let currentOrderId = null;

    $('#orderDetailsModal').on('show.bs.modal', function (event) {
        const button = $(event.relatedTarget);
        const orderId = button.data('order-id');

        if (currentOrderId !== orderId) {
            currentOrderId = orderId;
            const modalBody = $('#orderDetailsBody');
            const modalInfo = $('#orderRecipientInfo');
            const modelPrice = $(`#totalPrice`);
            modalInfo.empty();
            modalBody.empty();

            $.ajax({
                url: `order-detail?orderId=${orderId}`,
                method: 'GET',
                dataType: 'json',
                success: function (response) {
                    if (response) {
                        const order = response;
                        debugger
                        modalInfo.html(`
                        <p id="recipientName"><strong>Tên người nhận:</strong> ${order.recipientName}</p>
                        <p id="recipientPhone"><strong>Số điện thoại:</strong> ${order.recipientPhone}</p>
                        <p id="deliveryAddress"><strong>Địa chỉ nhận hàng:</strong> ${order.deliveryAddress}</p>
                        <p ><strong id="statusOrder">Trạng thái thanh toán:</strong>${order.paymentStatus}</p>
                    `);
                        debugger

                        modelPrice.html(`
                        <p><strong>Phí giao hàng:</strong> ${order.shippingFee}</p>
                        <p><strong>Tiền hàng:</strong> ${order.totalAmount}</p>
                        <p><strong>Voucher áp dụng:</strong> ${order.appliedVoucherIds}</p>
                        <p><strong>Tổng trả:</strong> ${order.priceAfterShipping}</p>
`);                     debugger
                        if (order.deliveryStatus.trim().toLowerCase()  === 'chờ' ||
                            order.deliveryStatus.trim().toLowerCase()  === 'đang giao') {
                            modelPrice.append(`
                    <button id="cancelOrderButton" class="btn btn-danger">Hủy đơn hàng</button>
                    
                    
                `)}
                        $('#cancelOrderButton').off('click').on('click', function () {
                            const recipientName = $('#recipientName').val();
                            const recipientPhone = $('#recipientPhone').val();
                            const deliveryAddress = $('#deliveryAddress').val();

                            $.ajax({
                                url: `update-order-status`,
                                method: 'POST',
                                data: {
                                    orderId: orderId,
                                    deliveryStatus: "đã hủy giao hàng",
                                    recipientName : recipientName,
                                    deliveryAddress: deliveryAddress,
                                    recipientPhone :recipientPhone
                                },
                                success: function () {
                                    alert('Đơn hàng đã được hủy thành công.');
                                    $('#statusOrder').text('Trạng thái đơn hàng: đã hủy');
                                    $('#cancelOrderButton').remove();
                                    location.reload();

                                },
                                error: function () {
                                    alert('Lỗi khi hủy đơn hàng.');
                                }
                            });
                        });

                        $.ajax({
                            url: `order/order-items?orderId=${orderId}`,
                            method: 'GET',
                            dataType: 'json',
                            success: function (response) {
                                if (response.length === 0) {
                                    modalBody.append('<tr><td colspan="6">Không có chi tiết đơn hàng.</td></tr>');
                                    return;
                                }
                                debugger
                                response.forEach(product => {
                                    const row = `
                                    <tr>
                                        <td>${product.id}</td>
                                        <td>${product.name}</td>
                                        <td>${product.sizeDescription}</td>
                                        <td>${product.quantity}</td>
                                        <td>${product.price}₫</td>
                                        <td>${(order.deliveryStatus || '').trim().toLowerCase() === "hoàn thành"
                                        ? `<button class="btn btn-primary btn-sm review-btn" data-product-id="${product.id}">Đánh Giá</button>`
                                        : ''}</td>
                                    </tr>`;
                                    modalBody.append(row);
                                });
                                debugger
                                modalBody.find('.review-btn').off('click').on('click', function () {
                                    const productId = $(this).data('product-id');
                                    window.location.href = `review?itemId=${productId}`;
                                });
                            },
                            error: function () {
                                alert('Lỗi khi tải chi tiết đơn hàng.');
                            }
                        });
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error:', error);
                    modalInfo.html('<p>Có lỗi khi tải thông tin đơn hàng</p>');
                }
            });
        }
    });

    $('#orderDetailsModal').on('hidden.bs.modal', function () {
        currentOrderId = null;
    });
});

$(document).ready(function(){
    $("#editPersonalInfoForm").submit(function (e){
        e.preventDefault();
        let isValid = true;

        let fullName = $("#nameChange").val().trim();
        let email = $("#emailChange").val().trim();
        let address = $("#addressChange").val().trim();
        let phone = $("#phoneChange").val().trim();

        if (!fullName) {
            $('#nameChangeError').text('Tên không được để trống!').addClass('text-danger');
            $('#nameChange').addClass('is-invalid');
            isValid = false;
        }

        let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!email) {
            $('#emailChangeError').text('Email không được để trống!').addClass('text-danger');
            $('#emailChange').addClass('is-invalid');
            isValid = false;
        } else if (!emailRegex.test(email)) {
            $('#emailChangeError').text('Email không hợp lệ!').addClass('text-danger');
            $('#emailChange').addClass('is-invalid');
            isValid = false;
        }

        // Kiểm tra số điện thoại hợp lệ (10 chữ số)
        let phoneRegex = /^(0[1-9][0-9]{8})$/;
        if (phone && !phoneRegex.test(phone)) {
            $('#phoneChangeError').text('Số điện thoại không hợp lệ!').addClass('text-danger');
            $('#phoneChange').addClass('is-invalid');
            isValid = false;
        }

        if (!isValid) return;
        $.ajax({
            type: "POST",
            url: "update-personal-info",
            data: {
                fullName: fullName,
                email: email,
                address: address,
                phone: phone
            },
            success: function(response){
                    alert("Cập nhật thông tin thành công!");
                    location.reload();
            },
            error: function(xhr){
                console.log("aaaa")
                let response = JSON.parse(xhr.responseText)
                let { message, ...errors } = response;
                showErrorschange(errors);
            }
        });
    });
});

function showErrorschange(errors){
    $('.text-danger').text('');
    $('.is-invalid').removeClass('is-invalid');

    Object.keys(errors).forEach(key => {
        let inputId = convertErrorKeyToInputIdCh(key);
        let errorId = convertErrorKeyToErrorIdCh(key);
        showErrorc(inputId, errorId, errors[key]);
    });
}

function convertErrorKeyToInputIdCh(errorKey) {
    let mapping = {
        "fullName": "nameChange",
        "errorEmail": "emailChange",
        "errorPhone": "phoneChange"
    };
    return mapping[errorKey] || "";
}
function convertErrorKeyToErrorIdCh(errorKey){
    let mapping = {
        "fullName": "nameChangeError",
        "errorEmail": "emailChangeError",
        "errorPhone": "phoneChangeError"
    };
    return mapping[errorKey] || "";
}
function showErrorc(inputId, errorId, message) {
    $('#' + errorId).text(message).addClass('text-danger');
    $('#' + inputId).addClass('is-invalid');
}
$('#editPersonalInfoModal').on('hidden.bs.modal', function () {
    $('.text-danger').text('').removeClass('text-danger');
    $('input').removeClass('is-invalid');
    $('.error').text('');
});
$('#editPersonalInfoModal').on('show.bs.modal', function () {
    let modal = $(this);

    modal.find('#nameChange').val(modal.find('#nameChange').data('fullname'));
    modal.find('#phoneChange').val(modal.find('#phoneChange').data('phone'));
    modal.find('#emailChange').val(modal.find('#emailChange').data('email'));
});
document.getElementById('saveAddress').addEventListener('click', function () {
    const province = document.getElementById('province').value.trim();
    const district = document.getElementById('district').value.trim();
    const ward = document.getElementById('ward').value.trim();
    const specificAddress = document.getElementById('specificAddress').value.trim();

    const fullAddress = `${specificAddress}, ${ward}, ${district}, ${province}`;
    document.getElementById('addressChange').value = fullAddress;

    const addressModal = bootstrap.Modal.getInstance(document.getElementById('addressModal'));
    addressModal.hide();
});

$('#editPersonalInfoModal').on('hidden.bs.modal', function () {
    $('.text-danger').text('').removeClass('text-danger');
    $('input').removeClass('is-invalid');
    $('.error').text('');
});