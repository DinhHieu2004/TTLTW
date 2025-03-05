$(document).ready(function () {
    $('#editSizeModal').on('show.bs.modal', function (event) {

        const button = $(event.relatedTarget);
        const sizeId = button.data('size-id');
        $.ajax({
            url: 'sizes/detail',
            type: 'GET',
            data: { sizeId: sizeId },
            dataType: 'json',
            success: function (response) {
                console.log(response)
                if (response) {
                    const data = response;
                    $('#editSizeId').val(data.idSize);
                    $('#idSize').text(data.idSize);
                    $('#editDescription').val(data.sizeDescriptions);

                } else {
                    alert(response.error || 'không tìm thấy chủ đề.');
                }
            },
            error: function () {
                alert('Đã xảy ra lỗi khi lấy thông tin chủ đề.');
            }
        });

    });


});
