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
});
function addEmptyRow(tableId) {
    const tbody = document.getElementById(tableId).querySelector("tbody");

    const row = document.createElement("tr");

    row.innerHTML = `
    <td><select class="form-select product-select">
            <option value="">Chọn sản phẩm</option>
                    <c:forEach var="p" items="${p}">
                      <option value="${p.id}" data-name="${p.title}">${p.id} - ${p.title}</option>
                    </c:forEach>
          </select></td>
    <td> <select class="form-select">
            <option>-- Chọn --</option>
            <c:forEach var="s" items="${s}">
                      <option value="${s.idSize}">${s.sizeDescriptions}</option>
            </c:forEach>
          </select></td>
    <td><input type="number" class="form-control" name="productQuantity"></td>
    <td><input type="number" class="form-control" name="productPrice"></td>
    <td><input type="text" class="form-control" name="productNote"></td>
    <td>
      <button class="btn btn-danger btn-sm" onclick="removeRow(this)">Xoá</button>
    </td>
  `;

    tbody.appendChild(row);

}

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
function resetForm() {
    $("#supplier, #createdDate").val("");
    $("textarea").val("");
    $("#productBody").empty();

    $('#addStockModal').modal('hide');
}
function onReasonChange(select) {
    const reason = select.value;
    const otherReasonWrapper = document.getElementById("otherReasonWrapper");
    const orderSelectWrapper = document.getElementById("orderSelectWrapper");

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