<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Thất Bại</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <style>
        .failure-icon {
            font-size: 5rem;
            color: #dc3545;
        }
        .failure-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #eee;
        }
    </style>
</head>
<body>
<header class="failure-header py-3 mb-4">
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
                        <i class="fas fa-times-circle failure-icon"></i>
                    </div>
                    <h2 class="card-title mb-3">Thanh Toán Thất Bại!</h2>
                    <p class="card-text mb-4">Rất tiếc, quá trình thanh toán của bạn không thành công. Vui lòng kiểm tra thông tin và thử lại.</p>

                    <div class="alert alert-danger mb-4 mx-auto" style="max-width: 80%;">
                        <div class="d-flex">
                            <div class="me-3">
                                <i class="fas fa-exclamation-triangle fs-4"></i>
                            </div>
                            <div class="text-start">
                                <h6 class="mb-1">Lỗi thanh toán</h6>
                                <p class="mb-0">Ngân hàng từ chối giao dịch hoặc thông tin thẻ không chính xác. Vui lòng kiểm tra thông tin và thử lại hoặc chọn phương thức thanh toán khác.</p>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/show-cart" class="btn btn-outline-secondary">
                            <i class="fas fa-shopping-cart me-2"></i>Quay lại giỏ hàng
                        </a>
                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary">
                            <i class="fas fa-credit-card me-2"></i>Thử lại thanh toán
                        </a>
                    </div>
                </div>
            </div>

            <!-- Các phương thức thanh toán khác -->
            <div class="card border-0 shadow mt-4">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0">Phương thức thanh toán khác</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="d-flex align-items-center border rounded p-3">
                                <div class="me-3">
                                    <i class="fas fa-money-bill-wave text-success fs-4"></i>
                                </div>
                                <div>
                                    <h6 class="mb-1">Thanh toán khi nhận hàng (COD)</h6>
                                    <p class="small text-muted mb-0">Trả tiền mặt khi nhận được sản phẩm</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="d-flex align-items-center border rounded p-3">
                                <div class="me-3">
                                    <i class="fas fa-university text-primary fs-4"></i>
                                </div>
                                <div>
                                    <h6 class="mb-1">Chuyển khoản ngân hàng</h6>
                                    <p class="small text-muted mb-0">Chuyển khoản trực tiếp đến tài khoản của chúng tôi</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Câu hỏi thường gặp -->
            <div class="card border-0 shadow mt-4">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0">Câu hỏi thường gặp về thanh toán</h5>
                </div>
                <div class="card-body">
                    <div class="accordion" id="faqAccordion">
                        <div class="accordion-item border-0 mb-3">
                            <h2 class="accordion-header" id="headingOne">
                                <button class="accordion-button collapsed bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
                                    Tại sao thanh toán của tôi bị từ chối?
                                </button>
                            </h2>
                            <div id="collapseOne" class="accordion-collapse collapse" aria-labelledby="headingOne" data-bs-parent="#faqAccordion">
                                <div class="accordion-body">
                                    Thanh toán có thể bị từ chối vì nhiều lý do như: thông tin thẻ không chính xác, số dư không đủ, thẻ hết hạn, hoặc do các biện pháp bảo mật của ngân hàng. Vui lòng kiểm tra thông tin thẻ và liên hệ với ngân hàng của bạn nếu vấn đề vẫn tiếp tục.
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item border-0 mb-3">
                            <h2 class="accordion-header" id="headingTwo">
                                <button class="accordion-button collapsed bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                    Tôi đã bị trừ tiền nhưng hệ thống báo thanh toán thất bại?
                                </button>
                            </h2>
                            <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#faqAccordion">
                                <div class="accordion-body">
                                    Trong một số trường hợp, giao dịch có thể bị tạm giữ nhưng không hoàn tất. Số tiền này thường sẽ được hoàn lại trong vòng 3-5 ngày làm việc. Nếu sau thời gian này bạn vẫn chưa nhận được số tiền hoàn lại, vui lòng liên hệ với bộ phận hỗ trợ của chúng tôi hoặc ngân hàng của bạn.
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item border-0">
                            <h2 class="accordion-header" id="headingThree">
                                <button class="accordion-button collapsed bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                    Làm thế nào để chọn phương thức thanh toán khác?
                                </button>
                            </h2>
                            <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#faqAccordion">
                                <div class="accordion-body">
                                    Bạn có thể quay lại trang thanh toán bằng cách nhấn vào nút "Thử lại thanh toán" và chọn phương thức thanh toán khác. Chúng tôi hỗ trợ nhiều phương thức như thẻ tín dụng/ghi nợ, VNPay, chuyển khoản ngân hàng và thanh toán khi nhận hàng (COD).
                                </div>
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
                            <h6>Cần hỗ trợ về thanh toán?</h6>
                            <p class="mb-md-0">Đội ngũ hỗ trợ của chúng tôi luôn sẵn sàng giúp đỡ bạn 24/7.</p>
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