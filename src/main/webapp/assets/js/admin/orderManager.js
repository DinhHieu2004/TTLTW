$(document).ready(function () {
    $.ajax({
        url: `/web_war/admin/show-order`,
        method: 'GET',
        dataType: 'json',
        success: function (response) {
            console.log(response)
            const currentOrders = response.currentOrders;
            const currentTableBody = $('#currentOrders tbody');
            currentOrders.forEach(order => {
                const row = `
                    <tr>
                        <td>${order.id}</td>
                        <td>${order.totalAmount}₫</td>
                        <td>${order.orderDate}</td>
                        <td>${order.status}</td>
                        <td><button class="btn btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#orderDetailsModal" data-order-id="${order.id}">Xem Chi Tiết</button></td>
                    </tr>`;
                currentTableBody.append(row);
            });
            $('#currentOrders').DataTable();

            const previousOrders = response.previousOrders;
            const previousTableBody = $('#orderHistory tbody');
            previousOrders.forEach(order => {
                const row = `
                    <tr>
                        <td>${order.id}</td>
                        <td>${order.totalAmount}₫</td>
                        <td>${order.orderDate}</td>
                        <td>${order.deliveryDate}</td>
                        <td>${order.status}</td>
                        <td><button class="btn btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#orderDetailsModal" data-order-id="${order.id}">Xem Chi Tiết</button></td>
                    </tr>`;
                previousTableBody.append(row);
            });
            $('#orderHistory').DataTable();
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
            const modalInfo = $('#info');
            const modelPrice = $(`#totalPrice`)
            modalInfo.empty();
            modalBody.empty();

            $.ajax({
                url: `../order-detail?orderId=${orderId}`,
                method: 'GET',
                dataType: 'json',
                success: function (response) {
                    console.log('Response from order-detail:', response);

                    if (response && response) {
                        $('#orderStatus').val(response.status);

                        const order = response;

                        modalInfo.html(`
                <p><strong>Tên người nhận:</strong> ${order.recipientName}</p>
                <p><strong>Số điện thoại:</strong> ${order.recipientPhone}</p>
                <p><strong>Địa chỉ nhận hàng:</strong> ${order.deliveryAddress}</p>
                <p><strong>Trạng thái đơn hàng:</strong> ${order.status}</p>

            `);
                        modelPrice.html(`<p><strong>Tổng trả:</strong> ${order.totalAmount}</p>`)
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

            $.ajax({
                url: `../order/order-items?orderId=${orderId}`,
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
                                <td>${product.name}</td>
                                <td>${product.sizeDescription}</td>
                                <td>${product.quantity}</td>
                                <td>${product.price}₫</td>
                            </tr>`;
                        modalBody.append(row);
                    });
                },
                error: function () {
                    alert('Lỗi khi tải chi tiết đơn hàng.');
                }
            });
        }
    });

    $('#orderDetailsModal').on('hidden.bs.modal', function () {
        currentOrderId = null;
    });
});

