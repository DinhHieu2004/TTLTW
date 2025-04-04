<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đã Hủy Thanh Toán</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
  <style>
    .cancel-icon {
      font-size: 5rem;
      color: #6c757d;
    }
    .cancel-header {
      background-color: #f8f9fa;
      border-bottom: 1px solid #eee;
    }
  </style>
</head>
<body>
<header class="cancel-header py-3 mb-4">
  <div class="container">
    <div class="row align-items-center">
      <div class="col-md-6">
        <a href="${pageContext.request.contextPath}/" class="text-decoration-none text-dark">
          <i class="fas fa-home me-1"></i> Trang chủ
        </a>
      </div>
    </div>
  </div>
</header>

<div class="container mb-5">
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card border-0 shadow">
        <div class="card-body text-center py-5">
          <div class="mb-4">
            <i class="fas fa-ban cancel-icon"></i>
          </div>
          <h2 class="card-title mb-3">Thanh Toán Đã Bị Hủy</h2>
          <p class="card-text mb-4">Bạn đã hủy quá trình thanh toán. Đơn hàng của bạn vẫn được lưu trong giỏ hàng nếu bạn muốn tiếp tục mua sắm sau.</p>

          <div class="alert alert-secondary mb-4 mx-auto" style="max-width: 80%;">
            <div class="d-flex">
              <div class="me-3">
                <i class="fas fa-info-circle fs-4"></i>
              </div>
              <div class="text-start">
                <h6 class="mb-1">Thông báo</h6>
                <p class="mb-0">Không có khoản thanh toán nào được thực hiện. Sản phẩm của bạn vẫn còn trong giỏ hàng. Bạn có thể quay lại để hoàn tất thanh toán bất cứ lúc nào.</p>
              </div>
            </div>
          </div>

          <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/show-cart" class="btn btn-outline-secondary">
              <i class="fas fa-shopping-cart me-2"></i>Quay lại giỏ hàng
            </a>
            <a href="${pageContext.request.contextPath}/artwork" class="btn btn-primary">
              <i class="fas fa-shopping-bag me-2"></i>Tiếp tục mua sắm
            </a>
          </div>
        </div>
      </div>


      <!-- Thông tin hỗ trợ -->
      <div class="card border-0 shadow mt-4">
        <div class="card-body">
          <div class="row align-items-center">
            <div class="col-md-8">
              <h6>Bạn có thắc mắc?</h6>
              <p class="mb-md-0">Đội ngũ hỗ trợ của chúng tôi luôn sẵn sàng giúp đỡ bạn tìm kiếm sản phẩm phù hợp.</p>
            </div>
            <div class="col-md-4 text-md-end">
              <a href="#" class="btn btn-outline-primary">
                <i class="fas fa-headset me-2"></i>Liên hệ hỗ trợ
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<footer class="bg-dark text-white py-4 mt-5">
  <div class="container">
    <div class="row">
      <div class="col-md-4 mb-4 mb-md-0">
        <h5>LANVU GALLERY</h5>
        <p class="small">Khu phố 6, P. Linh Trung, TP. Thủ Đức, TP. Hồ Chí Minh</p>
        <div class="d-flex gap-2">
          <a href="#" class="text-white"><i class="fab fa-facebook-f"></i></a>
          <a href="#" class="text-white"><i class="fab fa-instagram"></i></a>
          <a href="#" class="text-white"><i class="fab fa-twitter"></i></a>
        </div>
      </div>
      <div class="col-md-4 mb-4 mb-md-0">
        <h5>Liên kết nhanh</h5>
        <ul class="list-unstyled">
          <li><a href="#" class="text-decoration-none text-white-50">Trang chủ</a></li>
          <li><a href="#" class="text-decoration-none text-white-50">Sản phẩm</a></li>
          <li><a href="#" class="text-decoration-none text-white-50">Về chúng tôi</a></li>
          <li><a href="#" class="text-decoration-none text-white-50">Chính sách</a></li>
        </ul>
      </div>
      <div class="col-md-4">
        <h5>Liên hệ</h5>
        <ul class="list-unstyled text-white-50">
          <li class="mb-1"><i class="fas fa-map-marker-alt me-2"></i> Khu phố 6, P. Linh Trung, TP. Thủ Đức, TP. Hồ Chí Minh</li>
          <li class="mb-1"><i class="fas fa-phone me-2"></i> 0123456789</li>
          <li class="mb-1"><i class="fas fa-envelope me-2"></i> thuonghieu13@gmail.com</li>
        </ul>
      </div>
    </div>
    <div class="text-center pt-3 mt-3 border-top border-secondary">
      <p class="small mb-0">&copy; NÔNG LÂM UNIVERSITY (Nguồn: LAN VU GALLERY)</p>
    </div>
  </div>
</footer>

</body>
</html>