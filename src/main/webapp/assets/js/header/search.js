$("#search-input").on("input", function () {
    let keyword = $(this).val().trim();

    if (keyword.length > 2) {
        $.ajax({
            url: contextPath + "/artwork/suggestions", // Sửa lỗi URL
            method: "GET",
            dataType: "json",
            data: { keyword: keyword },
            success: function (response) {
                console.log("API response:", response);
                $("#suggestions").empty().show();

                if (Array.isArray(response) && response.length > 0) {
                    let suggestionList = "<ul class='list-group'>";
                    response.forEach(function (item) {
                        suggestionList += `<li class='list-group-item suggestion-item' data-keyword="${item}" style="cursor: pointer;">${item}</li>`;
                    });
                    suggestionList += "</ul>";
                    $("#suggestions").html(suggestionList);
                } else {
                    $("#suggestions").hide();
                }
            },
            error: function (xhr, status, error) {
                console.error("Lỗi khi gửi yêu cầu API:", error);
                $("#suggestions").hide();
            }
        });
    } else {
        $("#suggestions").empty().hide();
    }
});

function searchArtwork(keyword) {
    let params = keyword ? "keyword=" + encodeURIComponent(keyword) : $("#filterForm").serialize();

    $.ajax({
        url: '/web_war/artwork',
        type: "GET",
        data: params,
        headers: { "X-Requested-With": "XMLHttpRequest" },
        success: function (response) {
            updateArtworkGallery(response.data);
            updatePagination(response.currentPage, response.totalPages);
        },
        error: function (xhr) {
            console.error("Lỗi khi tải danh sách tranh:", xhr);
            $("#artworkGallery").html("<p>Đã xảy ra lỗi khi tải dữ liệu.</p>");
        }
    });
}

$(document).on("click", ".suggestion-item", function () {
    let keyword = $(this).data("keyword");
    console.log(keyword)
    $("#search-input").val(keyword);
    $("#suggestions").empty().hide();
    searchArtwork(keyword);
});

$("#search-btn").click(function (e) {
    e.preventDefault();
    let keyword = $("#search-input").val().trim();
    searchArtwork(keyword);
});

$(document).click(function (event) {
    if (!$(event.target).closest("#search-bar").length) {
        $("#suggestions").hide();
    }

});
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
        const contextPath = '/web_war';
        const fullPhotoUrl = `${window.location.origin}${contextPath}/${p.imageUrl}`;
        let cardHtml = `
                    <div class="col-6 col-md-3">
                        <div class="card artwork-card h-100" style="height: 380px !important;">
                            <a href="painting-detail?pid=${p.id}" class="card-link"></a>
                            
                            <img src="${fullPhotoUrl}" class="card-img-top artwork-image" alt="${p.title}" style="width: 100%; height:180px !important;">
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
                                        <del class="text-muted" style="font-size: 0.8rem;">${price} VNĐ</del>
                                        <span class="badge bg-success" style="font-size: 0.75rem;">-${p.discountPercentage}%</span>
                                    </div>
                                    <div class="text-danger fw-bold" style="font-size: 0.925rem;">${discountPrice} VNĐ</div>
                                ` : `
                                    <div class="fw-bold" style="font-size: 0.925rem;">${price} VNĐ</div>
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
