$(document).ready(function() {
    loadPaintings();

    $('#filterForm').submit(function(e) {
        e.preventDefault();
        loadPaintings($(this).serialize());
    });

    $(document).on('click', '.page-link', function(e) {
        e.preventDefault();
        let page = $(this).data('page');
        let params = $('#filterForm').serialize() + '&page=' + page;
        loadPaintings(params);
    });

    $('#resetFilters').click(function() {
        $('#filterForm')[0].reset();
        loadPaintings();
    });

    function loadPaintings(params = '') {
        $.ajax({
            url: 'artwork',
            type: 'GET',
            data: params,
            headers: { 'X-Requested-With': 'XMLHttpRequest' },
            success: function(response) {
                updateArtworkGallery(response.data);
                updatePagination(response.currentPage, response.totalPages);
                debugger
            },
            error: function(xhr) {
                console.error('Error loading paintings:', xhr);
                $('#artworkGallery').html('<p>Đã xảy ra lỗi khi tải dữ liệu.</p>');
            }
        });
    }

    function updateArtworkGallery(data) {
        let gallery = $('#artworkGallery');
        gallery.empty();
        if (!data || data.length === 0) {
            gallery.append('<p>Không tìm thấy tác phẩm nào.</p>');
            return;
        }
        data.forEach(function(p) {
            let discountPrice = p.discountPercentage > 0 ? (p.price * (1 - p.discountPercentage / 100)).toLocaleString('vi-VN') : null;
            let price = p.price.toLocaleString('vi-VN');
            const fullPhotoUrl = p.imageUrlCloud && p.imageUrlCloud.trim() !== ""
                ? `${p.imageUrlCloud}?f_auto,q_auto,w_400`
                : `${window.location.origin}${contextPath}/${p.imageUrl}`;

            debugger
            let cardHtml = `
            <div class="col-6 col-md-3">
                <div class="card artwork-card h-100" style="height: 380px !important;">
                    <a href="painting-detail?pid=${p.id}" class="card-link"></a>
                    
                    <img loading="lazy" src="${fullPhotoUrl}" class="card-img-top artwork-image" alt="${p.title}" style="width: 100%; height:180px !important;">
                    <div class="card-body">
                        <h5 class="card-title">${p.title}</h5>
                        <p class="card-text">
                            <strong>Họa Sĩ:</strong> ${p.artistName}<br>
                            <strong>Chủ đề:</strong> ${p.themeName}<br>
                            <span class="rating-stars">
                                ${Array(5).fill().map((_, i) => `
                                    <i class="fas fa-star ${i < p.averageRating ? 'text-warning' : 'text-gray-200'}" style="${i >= p.averageRating ? 'color: #e9ecef !important;' : ''}; font-size: 0.875rem;"></i>
                                `).join('')}
                            </span>
                            <span class="ms-1">${p.averageRating}</span>
                        </p>
                        ${p.discountPercentage > 0 ? `
                            <div class="d-flex align-items-center gap-2">
                                <del class="text-muted" style="font-size: 0.8rem;">${price}₫</del>
                                <span class="badge bg-success" style="font-size: 0.75rem;">-${p.discountPercentage}%</span>
                            </div>
                            <div class="text-danger fw-bold" style="font-size: 0.925rem;">${discountPrice}₫</div>
                        ` : `
                            <div class="fw-bold" style="font-size: 0.925rem;">${price}₫</div>
                        `}
                    </div>
                </div>
            </div>
        `;
            gallery.append(cardHtml);
        });
    }


    function updatePagination(currentPage, totalPages) {
        let pagination = $('#pagination');
        pagination.empty();
        if (totalPages <= 1) return;

        if (currentPage > 1) {
            pagination.append(`<li class="page-item"><a class="page-link" href="#" data-page="${currentPage - 1}">«</a></li>`);
        }

        for (let i = 1; i <= totalPages; i++) {
            pagination.append(`
                    <li class="page-item ${i === currentPage ? 'active' : ''}">
                        <a class="page-link" href="#" data-page="${i}">${i}</a>
                    </li>
                `);
        }

        if (currentPage < totalPages) {
            pagination.append(`<li class="page-item"><a class="page-link" href="#" data-page="${currentPage + 1}">»</a></li>`);
        }
    }
});

$(document).ready(function () {
    let urlParams = new URLSearchParams(window.location.search);
    let searchQuery = urlParams.get('search');

    if (searchQuery) {
        $("#search-input").val(searchQuery);
        searchArtwork(searchQuery);
    }
});