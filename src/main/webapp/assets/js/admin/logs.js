$(document).ready(function (){

    $('#viewLogModal').on('show.bs.modal', function (event){
        const button = $(event.relatedTarget);
        const logId = button.data('log-id');
        $.ajax({
            url:'logs/detail',
            type:'GET',
            data:{logId: logId},
            dataType: 'json',
            success: function (response){
                console.log(response)

                if(response){
                    if( typeof log == "string"){
                        alert(log);
                        return;
                    }
                    $('#logId').text(response.id);
                    $('#logType').text(response.level);
                    $('#logUser').text(response.who);
                    $('#logTime').text(formatDateTime(response.logTime));
                    $('#logLocation').text(response.logWhere);
                    $('#logResource').text(response.resource);
                    $('#logOldData').text(response.preData);
                    $('#logNewData').text(response.flowData);


                } else {
                    alert(response.error || 'Không tìm thấy log.');
                }
            }, error: function () {
                alert('Đã xảy ra lỗi khi lấy thông tin log.');
            }
        })
    });



    $('#confirmDeleteLogBtn').on('click', function () {
        var table = $('#logs').DataTable();
        let logId = $('#logIdToDelete').val();

        console.log(logId)

        if (!logId) {
            Swal.fire('Lỗi', 'Không tìm thấy ID log!', 'error');
            return;
        }

        $.ajax({
            type: "POST",
            url: "logs/delete",
            data: { logId: logId },
            success: function (response) {
                if (response.status === "success") {
                    var $row = $('[data-log-id="' + logId + '"]').closest('tr');
                    table.row($row).remove().draw(false);

                    $('#deleteLogModal').modal('hide');

                    Swal.fire({
                        icon: 'success',
                        title: 'Đã xóa thành công!',
                        showConfirmButton: false,
                        timer: 2000,
                        position: 'center',
                    });
                } else {
                    Swal.fire('Thất bại', response.message || 'Không thể xóa log.', 'error');
                }
            },
            error: function (xhr) {
                Swal.fire('Lỗi', 'Đã xảy ra lỗi khi gửi yêu cầu xóa.', 'error');
            }
        });
    });

    function formatDateTime(dateTimeString) {
        const dt = new Date(dateTimeString);
        return dt.toLocaleString('vi-VN');
    }
});