$(document).ready(function () {
    $('#viewEditArtistModal').on('show.bs.modal', function (event) {

        const button = $(event.relatedTarget); // Nút kích hoạt modal
        const artistId = button.data('artist-id'); // ID của họa sĩ
        $.ajax({
            url: 'artists/detail',
            type: 'GET',
            data: { artistId: artistId },
            dataType: 'json',
            success: function (response) {
                console.log(response)
                if (response) {
                    const data = response;
                    const contextPath = '/web_war';
                    const fullPhotoUrl = `${window.location.origin}${contextPath}/${data.photoUrl}`;


                    const birthDate = data.birthDate ? formatDate(data.birthDate) : '';
                    $('#editArtistId').val(data.id);

                    $('#currentArtistPhoto').attr('src', fullPhotoUrl || 'default-image.jpg');

                    $('#editArtistName').val(data.name);
                    $('#editArtistBio').val(data.bio);
                    $('#editArtistBirthDate').val(birthDate);
                    $('#editArtistNationality').val(data.nationality);
                    $('#editArtistPhotoUrl').val(data.photoUrl);
                } else {
                    alert(response.error || 'Không tìm thấy họa sĩ.');
                }
            },
            error: function () {
                alert('Đã xảy ra lỗi khi lấy thông tin họa sĩ.');
            }
        });

    });



    function updateArtist(artistData) {
        $.ajax({
         //   url: 'artists/update',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(artistData),
            success: function (response) {
                if (response.success) {
                    alert('Cập nhật thành công!');
                    location.reload();
                } else {
                    alert('Cập nhật thất bại: ' + response.message);
                }
            },
            error: function () {
                alert('Đã xảy ra lỗi khi gửi yêu cầu.');
            }
        });
    }

    function formatDate(dateString) {
        const date = new Date(dateString);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }
});
