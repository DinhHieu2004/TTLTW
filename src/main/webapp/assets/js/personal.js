$(document).ready(function () {
    let orderStatus = null;

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
                        <td>${order.totalAmount} .VND</td>
                        <td>${order.orderDate}</td>
                        <td>${order.status}</td>
                        <td><button class="btn btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#orderDetailsModal" data-order-id="${order.id}">Xem Chi Tiết</button></td>
                    </tr>`;
                currentTableBody.append(row);
            });
            $('#currentOrders').DataTable({
                dom: '<"d-flex justify-content-between align-items-center"lfB>rtip',
                buttons: [
                    { extend: 'copy', title: 'Danh sách đơn hàng hiện tại' },
                    { extend: 'csv', title: 'Danh sách đơn hàng hiện tại' },
                    { extend: 'excel', title: 'Danh sách đơn hàng hiện tại' },
                    { extend: 'pdf', title: 'Danh sách đơn hàng hiện tại' },
                    { extend: 'print', title: 'Danh sách đơn hàng hiện tại' }
                ]
            });

            const previousOrders = response.previousOrders;
            const previousTableBody = $('#orderHistory tbody');
            previousOrders.forEach(order => {
                const row = `
                    <tr>
                        <td>${order.id}</td>
                        <td>${order.totalAmount} .VND</td>
                        <td>${order.orderDate}</td>
                        <td>${order.deliveryDate}</td>
                        <td>${order.status}</td>
                        <td><button class="btn btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#orderDetailsModal" data-order-id="${order.id}">Xem Chi Tiết</button></td>
                    </tr>`;
                previousTableBody.append(row);
            });
            $('#orderHistory').DataTable({
                dom: '<"d-flex justify-content-between align-items-center"lfB>rtip',
                buttons: [
                    { extend: 'copy', title: 'Lịch sử đơn hàng' },
                    { extend: 'csv', title: 'Lịch sử đơn hàng' },
                    { extend: 'excel', title: 'Lịch sử đơn hàng' },
                    { extend: 'pdf', title: 'Lịch sử đơn hàng' },
                    { extend: 'print', title: 'Lịch sử đơn hàng' }
                ]
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
                        orderStatus = order.status;
                        console.log("Order status raw value:", order.status);
                        console.log("Order status after trim and lowercase:", order.status.trim().toLowerCase()); // Thêm dòng này

                        modalInfo.html(`
                        <p id="recipientName"><strong>Tên người nhận:</strong> ${order.recipientName}</p>
                        <p id="recipientPhone"><strong>Số điện thoại:</strong> ${order.recipientPhone}</p>
                        <p id="deliveryAddress"><strong>Địa chỉ nhận hàng:</strong> ${order.deliveryAddress}</p>
                        <p ><strong id="statusOrder">Trạng thái đơn hàng:</strong>${order.status}</p>
                    `);

                        modelPrice.html(`<p><strong>Tổng trả:</strong> ${order.totalAmount}</p>`);
                        if (orderStatus.trim().toLowerCase()  === 'chờ') {
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
                                    status: "dã hủy",
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
                            success: function (details) {
                                if (details.length === 0) {
                                    modalBody.append('<tr><td colspan="4">Không có chi tiết đơn hàng.</td></tr>');
                                    return;
                                }

                                details.forEach(product => {
                                    const row = `
                                    <tr>
                                         <td>${product.id}</td>

                                        <td>${product.name}</td>
                                        <td>${product.sizeDescription}</td>
                                        <td>${product.quantity}</td>
                                        <td>${product.price}₫</td>
                                        <td>${orderStatus.toLowerCase() === "hoàn thành"
                                        ? `<button class="btn btn-primary btn-sm review-btn" data-product-id="${product.id}">Đánh Giá</button>`
                                        : ''}</td>
                                    </tr>`;
                                    modalBody.append(row);
                                });

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
        // Kiểm tra email hợp lệ
        let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (email && !emailRegex.test(email)) {
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

        let fullName = $("#nameChange").val().trim();
        let email = $("#emailChange").val().trim();
        let address = $("#addressChange").val().trim();
        let phone = $("#phoneChange").val().trim();

        $.ajax({
            type: "POST",
            url: "",
            data: {
                fullName: fullName,
                email: email,
                address: address,
                phone: phone
            },
            success: function(response){
                if (response.success) {
                    alert("Cập nhật thông tin thành công!");
                }
            },
            error: function(xhr){
                let errors = JSON.parse(xhr.responseText)
                console.log("aaaa"+errors)
                showServerErrors(errors);
            }
        });
    });
});


