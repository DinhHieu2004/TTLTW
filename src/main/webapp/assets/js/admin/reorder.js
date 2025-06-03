$(document).ready(function () {
    $.ajax({
        url: 'reorder',
        method: 'GET',
        dataType: 'json',
        success: function (data) {
            $('#reorderTable').DataTable({
                data: data,
                columns: [
                    { data: 'paintingId' },
                    { data: 'title' },
                    { data: 'sizeDescription' },
                    { data: 'displayQuantity' },
                    {
                        data: 'avgDailySale',
                        render: function (data) {
                            return data.toFixed(2);
                        }
                    },
                    {
                        data: 'reorderThreshold',
                        render: function (data) {
                            return data.toFixed(2);
                        }
                    }
                ],
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
                }
            });
        },
        error: function () {
            alert('Không thể tải danh sách cần nhập hàng.');
        }
    });

    $.ajax({
        url: 'slow-selling',
        method: 'GET',
        dataType: 'json',
        success: function (data){
            $('#slowSellingTable').DataTable({
                data: data,
                columns: [
                    { data: 'paintingId' },
                    { data: 'title' },
                    { data: 'sizeDescription' },


                ],
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
                }
            });
        },
        error: function () {
            alert('Không thể tải danh sách bán chậm.');
        }
    });

});