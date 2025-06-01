<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Tranh</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shopping-cart.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/painting-detail.css">
</head>

<body>
<%@ include file="/partials/header.jsp" %>

<div class="container py-4">
    <c:if test="${not empty message}">
        <div id="alertMessage" class="alert alert-success alert-dismissible fade show" role="alert">
            <h2>${message}</h2>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <div class="row">
        <div class="col-md-6">
            <div class="card">
                <img loading="lazy" src="${p.imageUrlCloud}?f_auto,q_auto,w_600" alt="${p.title}"
                     class="card-img-top img-fluid">
            </div>
        </div>

        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h1 class="card-title h3">${p.title}</h1>
                    <p class="text-muted">Mã sản phẩm: #${p.id}</p>

                    <div class="mb-3">
                        <p><strong>Họa sĩ:</strong>
                            <a href="artwork?artist=${p.artistId}" class="link-custom">${p.artistName}</a>
                        </p>
                        <p><strong>Chủ đề: </strong>
                            <a href="artwork?theme=${p.themeId}" class="link-custom">${p.themeName}</a>
                        </p>
                        <p><strong>Mô tả:</strong> ${p.description}</p>

                        <span class="rating-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fas fa-star ${i <= p.averageRating ? 'text-warning' : 'text-gray-200'}"
                                   style="${i > p.averageRating ? 'color: #e9ecef !important;' : ''}; font-size: 0.875rem;"></i>
                            </c:forEach>
                        </span>
                        <span class="ms-1">${p.averageRating}</span>
                    </div>

                    <!-- Giá và giảm giá -->
                    <div class="mb-4">
                        <c:choose>
                            <c:when test="${p.discountPercentage > 0}">
                                <fmt:formatNumber var="originalPrice" value="${p.price}" pattern="#,##0"/>
                                <fmt:formatNumber var="salePrice" value="${p.price * (1 - p.discountPercentage / 100)}"
                                                  pattern="#,##0"/>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="text-muted text-decoration-line-through">
                                        ${fn:replace(originalPrice, ',', '.')} ₫
                                    </span>
                                    <span class="h4 text-danger mb-0">
                                        ${fn:replace(salePrice, ',', '.')} ₫
                                    </span>
                                    <span class="badge bg-success">-${p.discountPercentage}%</span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <fmt:formatNumber var="normalPrice" value="${p.price}" pattern="#,##0"/>
                                <span class="h4">
                                    ${fn:replace(normalPrice, ',', '.')} ₫
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>


                    <!-- Form thêm vào giỏ hàng -->
                    <form id="addToCartForm" class="needs-validation" novalidate>
                        <input type="hidden" name="pid" value="${p.id}">
                        <div class="mb-3">
                            <label class="form-label"><strong>Kích thước:</strong></label>
                            <div class="row g-2">
                                <c:forEach var="size" items="${p.sizes}">
                                    <div class="col-auto">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="size"
                                                   id="size_${size.sizeDescriptions}"
                                                   value="${size.idSize}"
                                                   data-quantity="${size.displayQuantity}"
                                                ${size.displayQuantity <= 0 ? 'disabled' : ''}>
                                            <input type="hidden" name="quantity_${size.idSize}"
                                                   value="${size.displayQuantity}">
                                            <label class="form-check-label" for="size_${size.sizeDescriptions}">
                                                    ${size.sizeDescriptions} <small
                                                    class="text-muted">(Còn ${size.displayQuantity})</small>


                                            </label>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="quantity" class="form-label"><strong>Số lượng:</strong></label>
                            <div class="input-group">
                                <button type="button" class="btn btn-outline-secondary" onclick="decrementQuantity()">
                                    -
                                </button>
                                <input type="number" class="form-control text-center" id="quantity" name="quantity"
                                       value="1" min="1" required>
                                <button type="button" class="btn btn-outline-secondary" onclick="incrementQuantity()">
                                    +
                                </button>
                            </div>
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary" style="background: #e7621b !important;">
                                <i class="fas fa-cart-plus me-2" style="background: #e7621b !important;"></i>Thêm vào
                                giỏ hàng
                            </button>
                        </div>
                    </form>
                    <div id="cartMessage"></div>
                </div>
            </div>
        </div>
        <div class="reviews-section mt-4">
            <h3>Đánh giá sản phẩm</h3>

            <c:forEach items="${reviews}" var="review">
                <div class="review-item mb-3 p-3 border rounded" data-id="${review.id}">
                    <p><strong>Người dùng:</strong> ${review.userName}</p>

                    <p><strong>Đánh giá:</strong>
                        <span class="rating-text">${review.rating}</span> / 5
                        <select class="form-select form-select-sm edit-rating d-none">
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                        </select>
                    </p>

                    <p class="comment-text">${review.comment}</p>
                    <textarea class="form-control d-none edit-comment">${review.comment}</textarea>

                    <p><small>${review.createdAt}</small></p>

                    <c:if test="${sessionScope.user != null && sessionScope.user.id == review.userId}">
                        <button class="btn btn-sm btn-primary edit-review-btn" data-id="${review.id}">Chỉnh sửa</button>
                        <button class="btn btn-sm btn-success save-btn d-none" data-id="${review.id}">Lưu</button>
                        <button class="btn btn-sm btn-danger cancel-btn d-none" data-id="${review.id}">Hủy</button>
                        <button class="btn btn-sm btn-outline-danger delete-review-btn" data-id="${review.id}">Xóa
                        </button>
                    </c:if>
                </div>
            </c:forEach>

            <!-- Modal Xác Nhận Xóa -->
            <div id="deleteConfirmModal" class="modal fade" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Xác nhận xóa</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <p>Bạn có chắc chắn muốn xóa đánh giá này không?</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Xóa</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="mt-4">
            <h3>Các Tranh cùng tác giả</h3>
            <div class="container-product mt-4">
                <div class="row g-4 g-2 col-10" id="artworkSameArtist">
                    <c:forEach var="p" items="${pT}">
                        <div class="col-6 col-md-3">
                            <div class="card artwork-card h-100" style="height: 380px !important;">
                                <a href="painting-detail?pid=${p.id}" class="card-link"></a>
                                <c:choose>
                                    <c:when test="${not empty p.imageUrlCloud}">
                                        <img loading="lazy"
                                             src="${p.imageUrlCloud}?f_auto,q_auto,w_400"
                                             class="card-img-top artwork-image"
                                             alt="${p.title}"
                                             style="width: 100%; height:180px !important;">
                                    </c:when>
                                    <c:otherwise>
                                        <img loading="lazy"
                                             src="${pageContext.request.contextPath}/${p.imageUrl}"
                                             class="card-img-top artwork-image"
                                             alt="${p.title}"
                                             style="width: 100%; height:180px !important;">
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body">
                                    <h5 class="card-title">${p.title}</h5>
                                    <p class="card-text">
                                        <strong>Họa Sĩ:</strong> ${p.artistName}<br>
                                        <strong>Chủ đề:</strong> ${p.themeName}<br>

                                        <span class="rating-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fas fa-star ${i <= p.averageRating ? 'text-warning' : 'text-gray-200'}"
                                   style="${i > p.averageRating ? 'color: #e9ecef !important;' : ''}; font-size: 0.875rem;"></i>
                            </c:forEach>
                        </span>
                                        <span class="ms-1">${p.averageRating}</span>
                                    </p>
                                    <c:choose>
                                        <c:when test="${p.discountPercentage > 0}">
                                            <fmt:formatNumber var="originalPrice" value="${p.price}" pattern="#,##0"/>
                                            <fmt:formatNumber var="salePrice"
                                                              value="${p.price * (1 - p.discountPercentage / 100)}"
                                                              pattern="#,##0"/>

                                            <div class="d-flex align-items-center gap-2">
                                                <del class="text-muted" style="font-size: 0.8rem;">
                                                        ${fn:replace(originalPrice, ',', '.')} ₫
                                                </del>
                                                <span class="badge bg-success"
                                                      style="font-size: 0.75rem;">-${p.discountPercentage}%</span>
                                            </div>

                                            <div class="text-danger fw-bold" style="font-size: 0.925rem;">
                                                    ${fn:replace(salePrice, ',', '.')} ₫
                                            </div>
                                        </c:when>

                                        <c:otherwise>
                                            <fmt:formatNumber var="normalPrice" value="${p.price}" pattern="#,##0"/>
                                            <div class="fw-bold" style="font-size: 0.925rem;">
                                                    ${fn:replace(normalPrice, ',', '.')} ₫
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <div class="mt-4">
            <h3>Các Tranh cùng tác giả</h3>
            <div class="container-product mt-4">
                <div class="row g-4 g-2 col-10" id="artworkSameTheme">
                    <c:forEach var="p" items="${pA}">
                        <div class="col-6 col-md-3">
                            <div class="card artwork-card h-100" style="height: 380px !important;">
                                <a href="painting-detail?pid=${p.id}" class="card-link"></a>
                                <c:choose>
                                    <c:when test="${not empty p.imageUrlCloud}">
                                        <img loading="lazy"
                                             src="${p.imageUrlCloud}?f_auto,q_auto,w_400"
                                             class="card-img-top artwork-image"
                                             alt="${p.title}"
                                             style="width: 100%; height:180px !important;">
                                    </c:when>
                                    <c:otherwise>
                                        <img loading="lazy"
                                             src="${pageContext.request.contextPath}/${p.imageUrl}"
                                             class="card-img-top artwork-image"
                                             alt="${p.title}"
                                             style="width: 100%; height:180px !important;">
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body">
                                    <h5 class="card-title">${p.title}</h5>
                                    <p class="card-text">
                                        <strong>Họa Sĩ:</strong> ${p.artistName}<br>
                                        <strong>Chủ đề:</strong> ${p.themeName}<br>

                                        <span class="rating-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fas fa-star ${i <= p.averageRating ? 'text-warning' : 'text-gray-200'}"
                                   style="${i > p.averageRating ? 'color: #e9ecef !important;' : ''}; font-size: 0.875rem;"></i>
                            </c:forEach>
                        </span>
                                        <span class="ms-1">${p.averageRating}</span>
                                    </p>
                                    <c:choose>
                                        <c:when test="${p.discountPercentage > 0}">
                                            <fmt:formatNumber var="originalPrice" value="${p.price}" pattern="#,##0"/>
                                            <fmt:formatNumber var="salePrice"
                                                              value="${p.price * (1 - p.discountPercentage / 100)}"
                                                              pattern="#,##0"/>

                                            <div class="d-flex align-items-center gap-2">
                                                <del class="text-muted" style="font-size: 0.8rem;">
                                                        ${fn:replace(originalPrice, ',', '.')} ₫
                                                </del>
                                                <span class="badge bg-success"
                                                      style="font-size: 0.75rem;">-${p.discountPercentage}%</span>
                                            </div>

                                            <div class="text-danger fw-bold" style="font-size: 0.925rem;">
                                                    ${fn:replace(salePrice, ',', '.')} ₫
                                            </div>
                                        </c:when>

                                        <c:otherwise>
                                            <fmt:formatNumber var="normalPrice" value="${p.price}" pattern="#,##0"/>
                                            <div class="fw-bold" style="font-size: 0.925rem;">
                                                    ${fn:replace(normalPrice, ',', '.')} ₫
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/partials/footer.jsp" %>
<%@ include file="/partials/authModal.jsp" %>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const form = document.getElementById('addToCartForm');
        const quantityInput = document.getElementById('quantity');
        const sizeInputs = document.querySelectorAll('input[name="size"]');

        sizeInputs.forEach(input => {
            input.addEventListener('change', function () {
                const maxQuantity = parseInt(this.dataset.quantity);
                quantityInput.max = maxQuantity;
                quantityInput.value = Math.min(quantityInput.value, maxQuantity);
            });
        });


        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }

            const selectedSize = document.querySelector('input[name="size"]:checked');
            if (!selectedSize) {
                event.preventDefault();
                alert('Vui lòng chọn kích thước');
                return;
            }

            form.classList.add('was-validated');
        });
    });

    function incrementQuantity() {
        const input = document.getElementById('quantity');
        const max = input.max ? parseInt(input.max) : Infinity;
        const currentValue = parseInt(input.value);
        if (currentValue < max) {
            input.value = currentValue + 1;
        }
    }

    function decrementQuantity() {
        const input = document.getElementById('quantity');
        const currentValue = parseInt(input.value);
        if (currentValue > 1) {
            input.value = currentValue - 1;
        }
    }
</script>
<%-- chỉnh sửa đánh giá--%>
<script>
    $(document).ready(function () {
        $('.edit-review-btn').click(function () {
            let reviewItem = $(this).closest('.review-item');

            reviewItem.find('.comment-text').addClass('d-none');
            reviewItem.find('.edit-comment').removeClass('d-none');

            reviewItem.find('.rating-text').addClass('d-none');
            reviewItem.find('.edit-rating').removeClass('d-none');

            $(this).addClass('d-none');
            reviewItem.find('.save-btn, .cancel-btn').removeClass('d-none');
        });

        $('.cancel-btn').click(function () {
            let reviewItem = $(this).closest('.review-item');

            reviewItem.find('.comment-text').removeClass('d-none');
            reviewItem.find('.edit-comment').addClass('d-none');

            reviewItem.find('.rating-text').removeClass('d-none');
            reviewItem.find('.edit-rating').addClass('d-none');

            reviewItem.find('.edit-review-btn').removeClass('d-none');
            reviewItem.find('.save-btn, .cancel-btn').addClass('d-none');
        });

        $('.save-btn').click(function () {
            let reviewItem = $(this).closest('.review-item');
            let reviewId = $(this).data('id');
            let newComment = reviewItem.find('.edit-comment').val();
            let newRating = reviewItem.find('.edit-rating').val();

            $.ajax({
                url: 'admin/reviews/update',
                method: 'POST',
                data: {reviewId, newComment, newRating},
                success: function (response) {
                    if (response.status === "success") {
                        reviewItem.find('.comment-text').text(newComment).removeClass('d-none');
                        reviewItem.find('.edit-comment').addClass('d-none');

                        reviewItem.find('.rating-text').text(newRating).removeClass('d-none');
                        reviewItem.find('.edit-rating').addClass('d-none');

                        reviewItem.find('.edit-review-btn').removeClass('d-none');
                        reviewItem.find('.save-btn, .cancel-btn').addClass('d-none');
                    } else {
                        alert("Cập nhật thất bại!");
                    }
                },
                error: function () {
                    alert('Lỗi khi cập nhật đánh giá.');
                }
            });
        });
    });
</script>
<%-- Xóa đánh giá--%>
<script>
    $(document).ready(function () {
        let reviewIdToDelete = null;
        $(document).on("click", ".delete-review-btn", function () {
            reviewIdToDelete = $(this).data("id");
            window.reviewElementToDelete = $(this).closest(".review-item");
            $("#deleteConfirmModal").modal("show");
        });
        $("#confirmDeleteBtn").on("click", function () {
            if (!reviewIdToDelete) return;

            $.ajax({
                url: "admin/reviews/delete",
                method: "POST",
                data: {rid: reviewIdToDelete},
                dataType: "json",
                success: function (response) {
                    if (window.reviewElementToDelete && window.reviewElementToDelete.length) {
                        window.reviewElementToDelete.fadeOut(300, function () {
                            $(this).remove();
                        });
                    } else {
                        console.error("Không tìm thấy phần tử để xóa");
                    }
                    $("#deleteConfirmModal").modal("hide");
                },
                error: function (xhr, status, error) {
                    console.error("Lỗi khi xóa:", xhr.responseText);
                    try {
                        const response = JSON.parse(xhr.responseText);
                        alert(response.message || "Lỗi khi xóa đánh giá!");
                    } catch (e) {
                        alert("Lỗi khi xóa đánh giá!");
                    }
                }
            });
        });
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/painting-detail.js"></script>

</body>
</html>