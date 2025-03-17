// $(document).ready(function () {
//     $('#viewAndEditModal').on('show.bs.modal', function (event) {
//         const button = $(event.relatedTarget);
//         const pid = button.data('product-id');
//         const modal = $(this);
//
//         $.ajax({
//             url: 'products/detail',
//             type: 'GET',
//             data: { pid: pid },
//             dataType: 'json',
//             success: function (response) {
//                 if (response) {
//                     console.log('Response data:', response);
//                     $('#editProductId').val(response.id);
//
//                     const contextPath = '/web_war';
//                     const fullPhotoUrl = `${window.location.origin}${contextPath}/${response.imageUrl}`;
//                     loadProductDetails(response, fullPhotoUrl, modal);
//                 } else {
//                     alert('Không tìm thấy thông tin sản phẩm.');
//                 }
//             },
//             error: function (xhr, status, error) {
//                 console.error('Ajax error:', error);
//                 alert('Đã xảy ra lỗi khi lấy thông tin sản phẩm.');
//             }
//         });
//     });
//
//     $('#viewAndEditModal').on('hidden.bs.modal', function () {
//         const modal = $(this);
//         const form = modal.find('form');
//         form[0].reset();
//         modal.find('.preview-image').remove();
//         modal.find('input[name="image"]').prop('required', true);
//     });
// });

function loadProductDetails(data, fullPhotoUrl, modal) {
    try {
        modal.find('input[name="title"]').val(data.title || '');
        modal.find('textarea[name="description"]').val(data.description || '');
        modal.find('input[name="price"]').val(data.price || '');

        if (data.createDate) {
            const formattedDate = formatDate(data.createDate);
            console.log(formattedDate)
            modal.find('input[name="createdDate"]').val(formattedDate);
        }

        if (data.themeName) {
            modal.find('select[name="themeId"] option').each(function() {
                if ($(this).text().trim() === data.themeName.trim()) {
                    $(this).prop('selected', true);
                }
            });
        }

        if (data.artistName) {
            modal.find('select[name="artistId"] option').each(function() {
                if ($(this).text().trim() === data.artistName.trim()) {
                    $(this).prop('selected', true);
                }
            });
        }
        console.log(data.available)
        const isAvailable = data.available === 'true' || data.available === true;

        modal.find('#isFeaturedEdit').prop('checked', data.isFeatured || false);
        modal.find('#isSoldEdit').prop('checked', !isAvailable);


        if (data.sizes && data.sizes.length > 0) {
            modal.find('.size-quantity-pair').each(function() {
                const sizeId = $(this).find('input[name="sizeId[]"]').val();
                const sizeData = data.sizes.find(s => s.idSize.toString() === sizeId);
                if (sizeData) {
                    $(this).find('input[name="quantity[]"]').val(sizeData.quantity);
                } else {
                    $(this).find('input[name="quantity[]"]').val(0);
                }
            });
        }

        if (data.imageUrl) {
            const imageInput = modal.find('input[name="image"]');
            imageInput.prop('required', false);

            modal.find('.preview-image').remove();

            const imgPreview = $('<img>', {
                src: fullPhotoUrl,
                class: 'preview-image mt-2',
                css: {
                    'max-width': '200px'
                }
            });
            imageInput.parent().append(imgPreview);
        }

    } catch (error) {
        console.error('Error loading product details:', error);
        alert('Đã xảy ra lỗi khi hiển thị thông tin sản phẩm.');
    }
}

function formatDate(dateString) {
    if (!dateString) return '';

    const date = new Date(dateString);
    if (isNaN(date.getTime())) return '';

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}