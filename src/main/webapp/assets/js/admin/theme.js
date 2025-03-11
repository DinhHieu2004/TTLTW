$(document).ready(function () {
    $('#editThemeModal').on('show.bs.modal', function (event) {

        const button = $(event.relatedTarget);
        const themeId = button.data('theme-id');
        $.ajax({
            url: 'themes/detail',
            type: 'GET',
            data: {themeId: themeId},
            dataType: 'json',
            success: function (response) {
                console.log(response)
                if (response) {
                    const data = response;
                    $('#editThemeId').val(data.id);
                    $('#idTheme').text(data.id);
                    $('#editThemeName').val(data.themeName);

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


