<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Thành Công</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <style>
        .success-icon {
            font-size: 5rem;
            color: #28a745;
        }
        .success-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #eee;
        }
        .order-details {
            background-color: #f8f9fa;
            border-radius: 10px;
        }
        .payment-details {
            background-color: #f8f9fa;
            border-radius: 10px;
        }
    </style>
</head>
<body>
<header class="success-header py-3 mb-4">
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
                        <i class="fas fa-check-circle success-icon"></i>
                    </div>
                    <h2 class="card-title mb-3">Thanh Toán Thành Công!</h2>
                    <p class="card-text mb-4">Cảm ơn bạn đã mua hàng. Đơn hàng của bạn đã được xác nhận và sẽ được xử lý ngay.</p>
                    <div class="d-flex justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/personal" class="btn btn-outline-secondary">
                            <i class="fas fa-receipt me-2"></i>Xem đơn hàng
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
                            <h6>Cần hỗ trợ?</h6>
                            <p class="mb-md-0">Nếu bạn có bất kỳ câu hỏi nào về đơn hàng, vui lòng liên hệ với chúng tôi.</p>
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