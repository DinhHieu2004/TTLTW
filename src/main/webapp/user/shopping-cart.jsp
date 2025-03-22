<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shopping-cart.css">
</head>
<body>
<%@ include file="/partials/header.jsp" %>
<div class="page-title-inner">
    <h5>Giỏ hàng</h5>
</div>
<div class="container my-5">
    <div class="card mb-4">
        <div class="card-header">
            <h5>Giỏ hàng của bạn</h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty sessionScope.cart.items}">
                    <table class="table table-bordered">
                        <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Ảnh</th>
                            <th>Tên Tranh</th>
                            <th>Kích thước</th>
                            <th>Số Lượng</th>
                            <th>Giá</th>
                            <th>Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${sessionScope.cart.items}" var="cp" varStatus="status">
                            <tr id="cart-item-${cp.productId}-${cp.sizeId}">
                                <td>${status.index + 1}</td>
                                <td><img src="${cp.imageUrl}" alt="${cp.productName}" width="50"></td>
                                <td>${cp.productName}</td>
                                <td>${cp.sizeDescriptions}</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <button class="btn btn-sm btn-secondary decrease-quantity"
                                                data-product-id="${cp.productId}"
                                                data-size-id="${cp.sizeId}">
                                            -
                                        </button>
                                        <span class="mx-2 quantity">${cp.quantity}</span>
                                        <button class="btn btn-sm btn-secondary increase-quantity"
                                                data-product-id="${cp.productId}"
                                                data-size-id="${cp.sizeId}"
                                                data-max-quantity="${cp.quanlytiOfSize}">
                                            +
                                        </button>
                                    </div>
                                </td>
                                <td class="item-total-price">
                                    <c:choose>
                                        <c:when test="${cp.discountPrice != null && cp.discountPercent > 0}">
                                            <div class="price-info">

                                                <del class="text-muted">Giá gốc: <f:formatNumber value="${cp.totalPrice}" type="currency" currencySymbol="VNĐ"/></del>
                                                <span class="badge bg-success ms-2">-${cp.discountPercent}%</span>
                                                <div class="text-danger fw-bold">
                                                    Giá đã giảm: <f:formatNumber value="${cp.discountPrice} " type="currency" currencySymbol="VNĐ"/>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="price-info">
                                                <span class="fw-bold">Giá: <f:formatNumber value="${cp.totalPrice}" type="currency" currencySymbol="VNĐ"/></span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <button class="btn btn-danger btn-sm remove-item"
                                            data-product-id="${cp.productId}"
                                            data-size-id="${cp.sizeId}">
                                        Xóa
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                        <tfoot>
                        <tr>
                            <th colspan="4" class="text-end">Tổng tiền</th>
                            <th id="total-price" colspan="2"><f:formatNumber value="${sessionScope.cart.totalPrice}" type ="currency" currencySymbol="VNĐ"></f:formatNumber></th>
                        </tr>
                        </tfoot>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info text-center" role="alert">
                        Giỏ hàng của bạn đang trống.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="d-flex justify-content-between">
        <a href="artwork" class="btn btn-secondary">Tiếp tục mua hàng</a>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#paymentModal" style="background: #e7621b !important;">Mua hàng</button>
    </div>
    <div class="modal fade" id="paymentModal">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="paymentModalLabel">Thanh toán</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">

                    <div class="mb-3">
                        <h6 class="fw-bold">Danh sách sản phẩm:</h6>
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Ảnh</th>
                                <th>Tên Tranh</th>
                                <th>Số Lượng</th>
                                <th>Giá</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${sessionScope.cart.items}" var="cp" varStatus="status">
                                <tr id="cart-itemp-${cp.productId}-${cp.sizeId}">
                                    <td>${status.index + 1}</td>
                                    <td><img src="${cp.imageUrl}" alt="${cp.productName}" width="50"></td>
                                    <td>${cp.productName}</td>
                                    <td><span class="mx-2 quantityp">${cp.quantity}</span></td>
                                    <td><f:formatNumber value="${cp.totalPrice}" type="currency" currencySymbol="VNĐ"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="mb-3">
                        <label for="totalAmount" class="form-label fw-bold">Tổng tiền thanh toán:</label>
                        <div id="totalAmount">${sessionScope.cart.totalPrice} VND</div>
                    </div>


                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" id="Payment" class="btn btn-primary" style="background: #e7621b !important;">Thanh Toán</button>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/partials/authModal.jsp" %>

<%@ include file="/partials/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
 <script src="${pageContext.request.contextPath}/assets/js/shopping-cart.js"></script>
 <script src="${pageContext.request.contextPath}/assets/js/UpdateQuantity.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/checkout.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>

<script>
    document.querySelector("#Payment").addEventListener("click", function () {
        const isLoggedIn = ${sessionScope.user != null ? 'true' : 'false'};
        if (!isLoggedIn) {
            alert("Bạn cần đăng nhập để thực hiện thanh toán!");
            $("#paymentModal").modal("hide");
            $("#authModal").modal("show");
        } else {
            window.location.href = "checkout";
        }

});</script>
</body>
</html>
