$(document).ready(function () {
    $('#viewEditVoucherModal').on('show.bs.modal', function (event) {

        const button = $(event.relatedTarget);
        const vid = button.data('voucher-id');
        $.ajax({
            url: 'vouchers/detail',
            type: 'GET',
            data: { vid: vid },
            dataType: 'json',
            success: function (response) {
                console.log(response)
                if (response) {
                    const data = response;
                    const startDate = data.startDate ? formatDate(data.startDate) : '';
                    const endDate = data.endDate ? formatDate(data.endDate) : '';

                    $('#editVoucherId').val(data.id);
                    $('#editName').val(data.name);
                    $('#editDiscount').val(data.discount);
                    $('#editIsActive').prop('checked', data.isActive || false);
                    $('#editStartDate').val(startDate);
                    $('#editEndDate').val(endDate);


                } else {
                    alert(response.error || 'không tìm thấy người dùng.');
                }
            },
            error: function () {
                alert('Đã xảy ra lỗi khi lấy thông tin người dùng.');
            }
        });

    });
    function formatDate(dateString) {
        const date = new Date(dateString);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

});
