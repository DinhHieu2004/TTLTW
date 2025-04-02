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

            <!-- Thông tin đơn hàng -->
            <c:choose>
                <c:when test="${not empty requestScope.order}">
                    <div class="card border-0 shadow mt-4">
                        <div class="card-header bg-white py-3">
                            <h5 class="mb-0">Thông tin đơn hàng</h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <p class="fw-bold mb-1">Mã đơn hàng:</p>
                                    <p>#${requestScope.order.id}</p>
                                </div>
                                <div class="col-md-6 text-md-end">
                                    <p class="fw-bold mb-1">Ngày đặt hàng:</p>
                                    <p><fmt:formatDate value="${requestScope.order.orderDate}" pattern="dd/MM/yyyy - HH:mm"/></p>
                                </div>
                            </div>

                            <div class="order-details p-3 mb-4">
                                <h6 class="mb-3">Chi tiết sản phẩm</h6>
                                <div class="table-responsive">
                                    <table class="table table-bordered">
                                        <thead class="table-light">
                                        <tr>
                                            <th>#</th>
                                            <th>Ảnh</th>
                                            <th>Tên Tranh</th>
                                            <th>Kích thước</th>
                                            <th>Số Lượng</th>
                                            <th>Giá</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${requestScope.orderItems}" var="item" varStatus="status">
                                            <tr>
                                                <td>${status.index + 1}</td>
                                                <td><img src="${item.img}" alt="${item.name}" width="50"></td>
                                                <td>${item.name}</td>
                                                <td>${item.sizeDescription}</td>
                                                <td>${item.quantity}</td>
                                                <td><fmt:formatNumber value="${item.price}" type="currency" pattern="#,##0"/> ₫</td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                        <tfoot>
                                        <tr>
                                            <th colspan="4" class="text-end">Tổng tiền:</th>
                                            <th colspan="2"><fmt:formatNumber value="${requestScope.order.totalAmount}" type="currency" pattern="#,##0"/> ₫</th>
                                        </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-danger">Không có thông tin đơn hàng.</div>
                </c:otherwise>
            </c:choose>


            <div class="row">
                        <div class="col-md-6 mb-4 mb-md-0">
                            <div class="payment-details p-3 h-100">
                                <h6 class="mb-3">Thông tin thanh toán</h6>
                                <p class="mb-1"><span class="fw-bold">Phương thức:</span> Thanh toán bằng VNPay</p>
                                <p class="mb-1"><span class="fw-bold">Chủ thẻ:</span>${requestScope.order.recipientName}</p>
                                <p class="mb-1"><span class="fw-bold">Số thẻ:</span> **** **** **** 1234</p>
                                <p class="mb-0"><span class="fw-bold">Ngân hàng:</span> NCB</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="payment-details p-3 h-100">
                                <h6 class="mb-3">Thông tin giao hàng</h6>
                                <p class="mb-1"><span class="fw-bold">Người nhận:</span> ${requestScope.order.recipientName}</p>
                                <p class="mb-1"><span class="fw-bold">Số điện thoại:</span> ${requestScope.order.recipientPhone}</p>
                                <p class="mb-1"><span class="fw-bold">Email:</span> ${requestScope.order.recipientEmail}</p>
                                <p class="mb-0"><span class="fw-bold">Địa chỉ:</span> ${requestScope.userEmail}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thông tin vận chuyển -->
            <div class="card border-0 shadow mt-4">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0">Trạng thái vận chuyển</h5>
                </div>
                <div class="card-body">
                    <div class="d-flex flex-nowrap overflow-auto pb-3">
                        <div class="text-center me-4 position-relative">
                            <div class="rounded-circle bg-success text-white d-flex align-items-center justify-content-center mx-auto mb-2" style="width: 40px; height: 40px;">
                                <i class="fas fa-check"></i>
                            </div>
                            <div class="position-absolute" style="top: 20px; left: 40px; height: 2px; width: 80px; background-color: #28a745;"></div>
                            <div class="mt-2" style="min-width: 100px;">
                                <small class="text-muted d-block">02/04/2025</small>
                                <span class="small">Đặt hàng</span>
                            </div>
                        </div>
                        <div class="text-center me-4 position-relative">
                            <div class="rounded-circle bg-success text-white d-flex align-items-center justify-content-center mx-auto mb-2" style="width: 40px; height: 40px;">
                                <i class="fas fa-check"></i>
                            </div>
                            <div class="position-absolute" style="top: 20px; left: 40px; height: 2px; width: 80px; background-color: #28a745;"></div>
                            <div class="mt-2" style="min-width: 100px;">
                                <small class="text-muted d-block">02/04/2025</small>
                                <span class="small">Xác nhận</span>
                            </div>
                        </div>
                        <div class="text-center me-4 position-relative">
                            <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center mx-auto mb-2" style="width: 40px; height: 40px;">
                                <i class="fas fa-box"></i>
                            </div>
                            <div class="position-absolute" style="top: 20px; left: 40px; height: 2px; width: 80px; background-color: #dee2e6;"></div>
                            <div class="mt-2" style="min-width: 100px;">
                                <small class="text-muted d-block">03/04/2025</small>
                                <span class="small">Đóng gói</span>
                            </div>
                        </div>
                        <div class="text-center me-4 position-relative">
                            <div class="rounded-circle bg-light text-dark d-flex align-items-center justify-content-center mx-auto mb-2" style="width: 40px; height: 40px;">
                                <i class="fas fa-truck"></i>
                            </div>
                            <div class="position-absolute" style="top: 20px; left: 40px; height: 2px; width: 80px; background-color: #dee2e6;"></div>
                            <div class="mt-2" style="min-width: 100px;">
                                <small class="text-muted d-block">04/04/2025</small>
                                <span class="small">Vận chuyển</span>
                            </div>
                        </div>
                        <div class="text-center">
                            <div class="rounded-circle bg-light text-dark d-flex align-items-center justify-content-center mx-auto mb-2" style="width: 40px; height: 40px;">
                                <i class="fas fa-home"></i>
                            </div>
                            <div class="mt-2" style="min-width: 100px;">
                                <small class="text-muted d-block">05/04/2025</small>
                                <span class="small">Giao hàng</span>
                            </div>
                        </div>
                    </div>
                    <div class="alert alert-info mt-3 mb-0">
                        <div class="d-flex">
                            <div class="me-3">
                                <i class="fas fa-info-circle fs-4"></i>
                            </div>
                            <div>
                                <h6 class="mb-1">Đơn hàng đang được đóng gói</h6>
                                <p class="mb-0">Dự kiến giao hàng trong 2-3 ngày tới. Bạn sẽ nhận được tin nhắn và email thông báo khi đơn hàng được gửi đi.</p>
                            </div>
                        </div>
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