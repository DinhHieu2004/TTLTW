$(document).ready(function () {
    $('#viewEditReviewModal').on('show.bs.modal', function (event) {
        const button = $(event.relatedTarget);
        const rid = button.data('review-id');
        $.ajax({
            url: 'reviews/detail',
            type: 'GET',
            data: { rid: rid },
            dataType: 'json',
            success: function (response) {
                console.log(response)
                if (response) {
                    const data = response;
                    const createdDate = data.createdAt ? formatDate(data.createdAt) : '';

                    $('#editReviewId').val(data.id);
                    $('#pName').val(data.name);
                    $('#uName').val(data.discount);

                    $('#rating').prop('checked', data.isActive || false);
                    $('#content').val(createdDate);


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
