<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.example.web.dao.model.User" %>
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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/preview.css">

</head>

<body>
<%@ include file="/partials/header.jsp" %>

<div class="container py-4">
  <div class="row">
    <div class="col-md-6">
      <div class="card">

        <img src="${p.imageUrl}" alt="${p.title}" class="card-img-top img-fluid">
      </div>
    </div>

    <div class="col-md-6">
      <div class="card">
        <div class="card-body">
          <h1 class="card-title h3">${p.title}</h1>
          <p class="text-muted">Mã sản phẩm: #${p.id}</p>

          <div class="mb-3">
            <p><strong>Họa sĩ:</strong> ${p.artistName}</p>
            <p><strong>Chủ đề:</strong> ${p.themeName}</p>
            <p><strong>Mô tả:</strong> ${p.description}</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="reviews-section mt-4">
    <h3>Đánh giá sản phẩm</h3>
    <form id="reviewForm">
      <input type="hidden" id="paintingId" value="${p.id}">
      <input type="hidden" id="itemId" value="${param.itemId}">

      <div id="starRating">
        <i class="fa fa-star" data-value="1"></i>
        <i class="fa fa-star" data-value="2"></i>
        <i class="fa fa-star" data-value="3"></i>
        <i class="fa fa-star" data-value="4"></i>
        <i class="fa fa-star" data-value="5"></i>
      </div>
      <textarea id="comment" placeholder="Viết đánh giá của bạn..."></textarea>
      <input type="hidden" id="rating" value="0">
      <button type="submit">Gửi đánh giá</button>
    </form>

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

        <c:if test="${sessionScope.user != null && sessionScope.user.id == review.userId || sessionScope.user.id == 4}">
        <button class="btn btn-sm btn-primary edit-review-btn" data-id="${review.id}">Chỉnh sửa</button>
          <button class="btn btn-sm btn-success save-btn d-none" data-id="${review.id}">Lưu</button>
          <button class="btn btn-sm btn-danger cancel-btn d-none" data-id="${review.id}">Hủy</button>
          <button class="btn btn-sm btn-outline-danger delete-review-btn" data-id="${review.id}">Xóa</button>
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
</div>

<%@ include file="/partials/footer.jsp" %>
<script>
  $(document).ready(function () {
    $('#starRating i').on('click', function () {
      const rating = $(this).data('value');
      $('#rating').val(rating);
      $('#starRating i').removeClass('text-warning');
      $('#starRating i').each(function () {
        if ($(this).data('value') <= rating) {
          $(this).addClass('text-warning');
        }
      });
    });

    $('#reviewForm').on('submit', function (e) {
      e.preventDefault();
      const rating = $('#rating').val();
      const comment = $('#comment').val();
      const paintingId = $('#paintingId').val();
      const itemId = $('#itemId').val();


      if (rating === "0") {
        alert('Vui lòng chọn số sao.');
        return;
      }

      $.ajax({
        url: 'review',
        method: 'POST',
        data: {
          itemId : itemId,
          paintingId: paintingId,
          rating: rating,
          comment: comment
        },
        success: function (response) {
          alert('Đánh giá của bạn đã được gửi thành công!');
          location.reload();
        },
        error: function (xhr) {
          const responseText = xhr.responseText;

          if (responseText.includes("<html")) {
            alert("Có lỗi xảy ra, không tìm thấy tài nguyên.");
          } else {
            try {
              const error = JSON.parse(responseText);
              alert(error.error || 'Có lỗi xảy ra. Vui lòng thử lại.');
            } catch (e) {
              alert('Có lỗi xảy ra. Vui lòng thử lại.');
            }
          }
        }
      });
    });
  });
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
        data: { reviewId, newComment, newRating },
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
        data: { rid: reviewIdToDelete },
        dataType: "json",
        success: function (response) {
          if (window.reviewElementToDelete && window.reviewElementToDelete.length) {
            window.reviewElementToDelete.fadeOut(300, function() {
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

</body>
</html>
