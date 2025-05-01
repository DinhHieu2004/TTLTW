$(document).ready(function() {
    let importTable = $('#importTable').DataTable({
        "order": [[1, "desc"]],
        "columnDefs": [
            { "type": "date", "targets": 1 }
        ],
        "dom": '<"d-flex justify-content-between align-items-center"lfB>rtip',
        "buttons": [
            { extend: 'copy', title: 'Danh sách Nhập kho' },
            { extend: 'csv', title: 'Danh sách Nhập kho' },
            { extend: 'excel', title: 'Danh sách Nhập kho' },
            { extend: 'pdf', title: 'Danh sách Nhập kho' },
            { extend: 'print', title: 'Danh sách Nhập kho' }
        ],
        "language": {
            "emptyTable": "Không có dữ liệu"
        }
    });
    let exportTable = $('#exportTable').DataTable({
        "order": [[1, "desc"]],
        "columnDefs": [
            { "type": "date", "targets": 1 }
        ],
        dom: '<"d-flex justify-content-between align-items-center"lfB>rtip',
        buttons: [
            { extend: 'copy', title: 'Danh sách Xuất kho' },
            { extend: 'csv', title: 'Danh sách Xuất kho' },
            { extend: 'excel', title: 'Danh sách Xuất kho' },
            { extend: 'pdf', title: 'Danh sách Xuất kho' },
            { extend: 'print', title: 'Danh sách Xuất kho' }
        ],
        "language": {
            "emptyTable": "Không có dữ liệu"
        }
    });

    $(document).on('click', '.viewDetailSIButton', function () {
        const stockInId = $(this).data('stockin-id');
        $.ajax({
            url: 'inventoryTrans/detail',
            method: 'GET',
            data: { id: stockInId, type: "in" },
            success: function(response) {
                console.log(response);
                $('#siId').text(response.id);
                $('#importDate').text(response.transactionDate);
                $('#createBy').text(response.createdName);
                $('#detailSup').text(response.supplier);
                $('#note').text(response.note);
                $('#totalPrice').text(response.totalPrice.toLocaleString());

                $('#stockinItemBody').empty();

                $.each(response.listPro, function(index, product) {
                    var productRow = '<tr data-si-id="'+product.productId+'">' +
                        '<td>' + product.productId + '</td>' +
                        '<td>' + product.productName + '</td>' +
                        '<td>' + product.sizeName + '</td>' +
                        '<td>' + product.quantity + '</td>' +
                        '<td>' + product.price.toLocaleString() + '</td>' +
                        '<td>' + product.totalPrice.toLocaleString() + '</td>' +
                        '<td>' + (product.note ?? '') + '</td>' +
                        '</tr>';
                    $('#stockinItemBody').append(productRow);
                });
            },
            error: function(xhr, status, error) {
                console.error('Có lỗi xảy ra: ' + error);
            }
        });
    });
    $(document).on('click', '.viewDetailSOButton', function () {
        const stockOutId = $(this).data('stockout-id');
        $.ajax({
            url: 'inventoryTrans/detail',
            method: 'GET',
            data: { id: stockOutId, type: "out" },
            success: function(response) {
                console.log(response);
                $('#soId').text(response.id);
                $('#exportDate').text(response.transactionDate);
                $('#createBySo').text(response.createdName);
                $('#reasonSO').text(response.reason ?? '');
                $('#noteSo').text(response.note);
                $('#totalPriceSo').text(response.totalPrice.toLocaleString());

                $('#stockOutItemBody').empty();

                $.each(response.listPro, function(index, product) {
                    var productRow = '<tr data-so-id="'+product.productId+'">' +
                        '<td>' + product.productId + '</td>' +
                        '<td>' + product.productName + '</td>' +
                        '<td>' + product.sizeName + '</td>' +
                        '<td>' + product.quantity + '</td>' +
                        '<td>' + product.price.toLocaleString() + '</td>' +
                        '<td>' + product.totalPrice.toLocaleString() + '</td>' +
                        '<td>' + (product.note ?? '') + '</td>' +
                        '</tr>';
                    $('#stockOutItemBody').append(productRow);
                });

                $('#detailModalSo').modal('show');
            },
            error: function(xhr, status, error) {
                console.error('Có lỗi xảy ra: ' + error);
            }
        });
    });


    $(".deleteStockInButton").click(function() {
        var stockInId = $(this).data("id");

        Swal.fire({
            title: 'Bạn có chắc chắn muốn xóa phiếu nhập kho này?',
            text: "Việc này không thể hoàn tác!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Có, xóa!',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: 'inventoryTrans/delete',
                    type: 'POST',
                    data: {
                        type: 'in',
                        id: stockInId
                    },
                    success: function(response) {
                        if (response.success) {
                            var $row = $('[data-si-id="' + stockInId + '"]').closest('tr');
                            importTable.row($row).remove().draw();

                            Swal.fire(
                                'Đã xóa!',
                                'Phiếu nhập kho đã được xóa.',
                                'success'
                            );
                        } else {
                            Swal.fire(
                                'Lỗi!',
                                response.message || 'Có lỗi xảy ra khi xóa phiếu nhập kho.',
                                'error'
                            );
                        }
                    },
                    error: function() {
                        Swal.fire(
                            'Lỗi!',
                            'Đã xảy ra lỗi với yêu cầu xóa.',
                            'error'
                        );
                    }
                });
            }
        });
    });
    $(".deleteStockOButton").click(function() {
        var stockOutId = $(this).data("id");

        Swal.fire({
            title: 'Bạn có chắc chắn muốn xóa phiếu xuất kho này?',
            text: "Việc này không thể hoàn tác!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Có, xóa!',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: 'inventoryTrans/delete',
                    type: 'POST',
                    data: {
                        type: 'out',
                        id: stockOutId
                    },
                    success: function(response) {
                        if (response.success) {
                            var $row = $('[data-si-id="' + stockOutId + '"]').closest('tr');
                            exportTable.row($row).remove().draw();

                            Swal.fire(
                                'Đã xóa!',
                                'Phiếu xuất kho đã được xóa.',
                                'success'
                            );
                        } else {
                            Swal.fire(
                                'Lỗi!',
                                response.message || 'Có lỗi xảy ra khi xóa phiếu xuất kho.',
                                'error'
                            );
                        }
                    },
                    error: function() {
                        Swal.fire(
                            'Lỗi!',
                            'Đã xảy ra lỗi với yêu cầu xóa.',
                            'error'
                        );
                    }
                });
            }
        });
    });
});
function removeRow(btn) {
    const row = btn.closest("tr");
    row.remove();
}

function submitStockIn() {
    const createdId = $('#userId').val();
    const supplier = $('#supplier').val();
    const createdDate = $('#createdDate').val();
    const note = $('#noteInput').val();

    const products = [];

    let isValid = true;
    let errorMessages = [];

    $('.error-message').remove();
    if (!supplier) {
        $('#supplier').after('<div class="error-message" style="color:red;font-size:12px;">Vui lòng nhập nhà cung cấp</div>');
        isValid = false;
        errorMessages.push("Thiếu nhà cung cấp");
    }

    if (!createdDate) {
        $('#createdDate').after('<div class="error-message" style="color:red;font-size:12px;">Vui lòng chọn ngày nhập</div>');
        isValid = false;
        errorMessages.push("Thiếu ngày nhập");
    }

    $('#productBody tr').each(function (index) {
        const row = $(this);
        const productId = row.find('select').eq(0).val();
        const sizeId = row.find('select').eq(1).val();
        const quantity = row.find('input[name="productQuantity"]').val();
        const price = row.find('input[name="productPrice"]').val();
        const note = row.find('input[name="productNote"]').val();

        if (productId && sizeId >0 && quantity > 0 && price >= 0) {
            products.push({
                productId,
                sizeId,
                quantity,
                price,
                note
            });
        }else {
            isValid = false;
            errorMessages.push(`Thông tin sản phẩm chưa hợp lệ`);
        }
    });

    if (products.length === 0) {
        errorMessages.push(`Chưa có sản phẩm`);
        isValid = false;
    }
    if (!isValid) {
        let errorText = errorMessages.join('<br>');
        Swal.fire({
            icon: 'error',
            title: 'Lỗi nhập liệu',
            html: errorText,
            confirmButtonText: 'OK'
        });
        return;
    }

    const productData = JSON.stringify(products);

    $.ajax({
        url: 'inventoryTrans/addStockIn',
        type: 'POST',
        data: {
            createdId: createdId,
            supplier: supplier,
            createdDate: createdDate,
            note: note,
            products: productData
        },
        success: function (response) {
            Swal.fire({
                icon: 'success',
                title: 'Thành công',
                text: 'Phiếu nhập đã được tạo.',
            });
            console.log(response.stockIn.transactionDate)
            var importTable = $('#importTable').DataTable();
            importTable.row.add([
                response.stockIn.id,
                response.stockIn.transactionDate,
                response.stockIn.createdName,
                response.stockIn.supplier,
                response.stockIn.totalPrice.toLocaleString() + ' VND',
                response.stockIn.note ?? '',
                '<button class="btn btn-sm btn-info viewDetailSIButton" data-stockin-id="'+ response.stockIn.id +'"  data-bs-toggle="modal" data-bs-target="#detailModal">Chi tiết</button>'+
                '<button class="btn btn-sm btn-danger">Xoá</button>'
            ]).draw();
            resetForm();
        },
        error: function (xhr, status, error) {
            let errorMessage = xhr.responseText || "Không xác định!";
            Swal.fire({
                icon: 'error',
                title: 'Có lỗi xảy ra khi nhập kho!',
                text: 'Chi tiết: ' + errorMessage,
                confirmButtonText: 'OK'
            });
        }
    });
}
function submitStockOut() {
    const createdId = $('#userIdSO').val();
    const reason = $('#reason').val();
    const createdDate = $('#createdDateSO').val();
    const noteIn = $('#noteOut').val();
    const orderId = $('#orderSelect').val();
    const otherReason = $('#otherReason').val();

    let reasonToSubmit = reason;

    const products = [];

    let isValid = true;
    let errorMessages = [];

    $('.error-message').remove();

    if (!reason) {
        $('#reason').after('<div class="error-message" style="color:red;font-size:12px;">Vui lòng nhập nhà cung cấp</div>');
        isValid = false;
        errorMessages.push("Thiếu lý do!");
    }
    if (reason === "Khác" && otherReason.trim() === "") {
        $('#otherReason').after('<div class="error-message" style="color:red;font-size:12px;">Vui lòng nhập lý do</div>');
        isValid = false;
        errorMessages.push("Thiếu lý do! ");
    } else if (reason === "Khác") {
        reasonToSubmit = otherReason.trim();
    }
    if (reason === "Giao hàng" && !orderId) {
        $('#orderSelect').after('<div class="error-message" style="color:red;font-size:12px;">Vui lòng chọn hóa đơn</div>');
        isValid = false;
        errorMessages.push("Thiếu đơn hàng");
    }

    if (!createdDate) {
        $('#createdDateSO').after('<div class="error-message" style="color:red;font-size:12px;">Vui lòng chọn ngày nhập</div>');
        isValid = false;
        errorMessages.push("Thiếu ngày nhập");
    }

    $('#productBodySO tr').each(function (index) {
        const row = $(this);
        const isDeliveryProduct = reason === "Giao hàng"
        let productId, sizeId, quantity, price, note;
        if (isDeliveryProduct) {
            productId = row.find('.product-id').val();
            sizeId = row.find('.size-id').val();
        } else {
            productId = row.find('select').eq(0).val();
            sizeId = row.find('select').eq(1).val();
        }
        quantity = row.find('input[name="productQuantity"]').val();
        price = row.find('input[name="productPrice"]').val();
        note = row.find('input[name="productNote"]').val();

        if (productId && sizeId >0 && quantity > 0 && price >= 0) {
            products.push({
                productId,
                sizeId,
                quantity,
                price,
                note
            });
        }else {
            isValid = false;
            console.log(row, price, productId, sizeId, quantity)
            errorMessages.push(`Thông tin sản phẩm chưa hợp lệ`);
        }
    });

    if (products.length === 0) {
        errorMessages.push(`Chưa có sản phẩm`);
        isValid = false;
    }
    if (!isValid) {
        let errorText = errorMessages.join('<br>');
        Swal.fire({
            icon: 'error',
            title: 'Lỗi nhập liệu',
            html: errorText,
            confirmButtonText: 'OK'
        });
        return;
    }

    const productData = JSON.stringify(products);

    $.ajax({
        url: 'inventoryTrans/addStockOut',
        type: 'POST',
        data: {
            createdId: createdId,
            reason: reasonToSubmit,
            createdDate: createdDate,
            note: noteIn,
            orderId: orderId,
            products: productData
        },
        success: function (response) {
            Swal.fire({
                icon: 'success',
                title: 'Thành công',
                text: 'Phiếu nhập đã được tạo.',
            });
            var exportTable = $('#exportTable').DataTable();
            exportTable.row.add([
                response.stockOut.id,
                response.stockOut.transactionDate,
                response.stockOut.createdName,
                response.stockOut.reason,
                response.stockOut.totalPrice.toLocaleString() + ' VND',
                response.stockOut.note ?? '',
                '<button class="btn btn-sm btn-info viewDetailSOButton" data-stockout-id="'+ response.stockOut.id +'"  data-bs-toggle="modal" data-bs-target="#detailModalSo">Chi tiết</button>'+
                '<button class="btn btn-sm btn-danger">Xoá</button>'
            ]).draw();
            resetFormOut();
        },
        error: function (xhr, status, error) {
            let errorMessage = xhr.responseText || "Không xác định!";
            Swal.fire({
                icon: 'error',
                title: 'Có lỗi xảy ra khi nhập kho!',
                text: 'Chi tiết: ' + errorMessage,
                confirmButtonText: 'OK'
            });
        }
    });
}
function resetForm() {
    $("#supplier, #createdDate").val("");
    $("textarea").val("");
    $("#productBody").empty();

    $('#addStockModal').modal('hide');
}
function resetFormOut() {
    $("#reason, #createdDateSO, #orderSelect, #otherReason").val("");
    $("textarea").val("");
    $("#productBodySO").empty();

    $('#addStockOutModal').modal('hide');
}
function onReasonChange(select) {
    const reason = select.value;
    const otherReasonWrapper = document.getElementById("otherReasonWrapper");
    const orderSelectWrapper = document.getElementById("orderSelectWrapper");
    clearProductTable();

    if (reason === "Khác") {
        otherReasonWrapper.style.display = "block";
    } else {
        otherReasonWrapper.style.display = "none";
        document.getElementById("otherReason").value = "";
    }

    if (reason === "Giao hàng") {
        document.getElementById("addProdOut").style.display = "none";
        orderSelectWrapper.style.display = "block";
    } else {
        document.getElementById("addProdOut").style.display = "block";
        orderSelectWrapper.style.display = "none";
        document.getElementById("orderSelect").value = "";
    }
}

function onOrderChange(select) {
    const orderId = $(select).val();
    clearProductTable();

    if (!orderId) return;

    $.ajax({
        url: '../order/order-items',
        method: 'GET',
        data: { orderId: orderId },
        dataType: 'json',
        success: function(data) {
            const tbody = $("#productBodySO");
            data.forEach(function(product) {
                const row = `
         <tr>
            <td>
                <input type="text" class="form-control" value="${product.paintingId} - ${product.name}" readonly>
                <input type="hidden" class="product-id" value="${product.paintingId}">
            </td>
            <td>
                <input type="text" class="form-control" value="${product.sizeDescription}" readonly>
                <input type="hidden" class="size-id" value="${product.sizeId}">
            </td>
            <td><input type="number" class="form-control" name="productQuantity" value="${product.quantity}" readonly></td>
            <td><input type="number" class="form-control" name="productPrice" value="${product.price}" readonly></td>
            <td><input type="text" class="form-control" name="productNote" value="${product.note || ''}" readonly></td>
            <td></td>
        </tr>
        `;
                tbody.append(row);
            });
        },
        error: function(err) {
            console.error("Lỗi lấy sản phẩm từ đơn hàng:", err);
        }
    });
}

function clearProductTable() {
    $("#productBodySO").empty();
}