<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chi Tiết Tranh</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
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
      <div class="review-item mb-3 p-3 border rounded">
        <p><strong>Người dùng:</strong> ${review.userName}</p>
        <p><strong>Đánh giá:</strong> ${review.rating} / 5</p>
        <p>${review.comment}</p>
        <p><small>${review.createdAt}</small></p>
      </div>
    </c:forEach>
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

  </body>

</html>
