<%@ page import="com.example.web.dao.cart.Cart" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "f" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thanh toán</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <style>
    :root {
      --text-color: #333;
      --border-color: #ddd;
      --bg-hover: #f5f5f5;
    }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f8f8f8;
      color: var(--text-color);
      line-height: 1.6;
    }

    .checkout-container {
      max-width: 1250px;
      margin: 1rem auto;
      background-color: #fff;
      padding: 1.5rem;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    h2 {
      text-align: center;
      margin-bottom: 1rem;
      color: var(--text-color);
      font-size: 1.8rem;
    }

    h3 {
      margin-bottom: 1.5rem;
      color: var(--text-color);
      font-size: 1.3rem;
    }

    .checkout-layout {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
      gap: 3rem;
    }

    .order-summary {
      background-color: #fff;
      padding: 2rem;
      border-radius: 8px;
      border: 1px solid var(--border-color);
    }

    .order-summary table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 1.5rem;
    }

    .order-summary th,
    .order-summary td {
      border: 1px solid var(--border-color);
      padding: 12px;
      text-align: left;
    }

    .order-summary th {
      background-color: #f8f8f8;
      font-weight: 600;
    }

    .order-summary tfoot td {
      font-weight: bold;
    }

    .payment-form {
      background-color: #fff;
      padding: 2rem;
      border-radius: 8px;
      border: 1px solid var(--border-color);
    }

    .payment-form label {
      display: block;
      margin-top: 1.2rem;
      font-weight: 500;
      color: var(--text-color);
    }

    .payment-form input,
    .payment-form textarea,
    .payment-form select {
      width: 100%;
      padding: 0.8rem;
      margin-top: 0.5rem;
      border: 1px solid var(--border-color);
      border-radius: 4px;
      font-size: 1rem;
      transition: border-color 0.2s;
    }

    .payment-form input:focus,
    .payment-form textarea:focus,
    .payment-form select:focus {
      outline: none;
      border-color: #666;
    }

    .payment-form button {
      width: 100%;
      padding: 1rem;
      margin-top: 2rem;
      background-color: #333;
      color: #fff;
      border: none;
      border-radius: 4px;
      font-size: 1.1rem;
      font-weight: 600;
      cursor: pointer;
      transition: background-color 0.2s;
    }

    .payment-form button:hover {
      background-color: #444;
    }
    .voucher-container {
      font-family: system-ui, -apple-system, sans-serif;
      max-width: 400px;
      padding: 20px;
      border-radius: 8px;
      background: #ffffff;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .voucher-label {
      display: block;
      margin-bottom: 8px;
      font-weight: 500;
      color: #374151;
    }

    .voucher-select {
      width: 100%;
      padding: 10px;
      border: 1px solid #e5e7eb;
      border-radius: 6px;
      font-size: 14px;
      color: #1f2937;
      background-color: #f9fafb;
      cursor: pointer;
      transition: all 0.2s ease;
      margin-bottom: 16px;
    }

    .voucher-select:hover {
      border-color: #9ca3af;
    }

    .voucher-select:focus {
      outline: none;
      border-color: #3b82f6;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }

    .price-display {
      display: block;
      border: 2px solid #ff5722;
      padding: 12px;
      background-color: #f3f4f6;
      border-radius: 6px;
      font-weight: 500;
      color: #1f2937;
    }

    .price-amount {
      color: #059669;
      font-weight: 600;
    }
    #bankDetails {
      background-color: #f8f8f8;
      padding: 50px;
      margin-top: 50px;
      border-radius: 4px;
      border: 1px solid var(--border-color);
    }

    @media (max-width: 768px) {
      .checkout-container {
        margin: 50px !important;
        padding: 50px;
      }

      .checkout-layout {
        grid-template-columns: 1fr;
        gap: 2rem;
      }
    }
  </style>

  <style>
    .modal {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: rgba(0, 0, 0, 0.5);
      z-index: 1000;
    }

    .modal.hidden {
      display: none;
    }

    .modal-content {
      background-color: white;
      padding: 20px;
      border-radius: 8px;
      width: 90%;
      max-width: 500px;
      max-height: 80vh;
      overflow-y: auto;
      position: relative;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    }

    .close {
      position: absolute;
      top: 10px;
      right: 15px;
      font-size: 24px;
      font-weight: bold;
      color: #333;
      cursor: pointer;
    }

    .voucher-list {
      margin-top: 15px;
    }

    .voucher-item {
      display: flex;
      align-items: center;
      border: 1px solid #ddd;
      padding: 10px;
      margin-bottom: 10px;
      border-radius: 5px;
      cursor: pointer;
      transition: border 0.3s, background-color 0.3s;
    }

    .voucher-item:hover {
      border-color: #4CAF50;
      background-color: #f5fff5;
    }

    .voucher-image {
      width: 60px;
      height: 60px;
      object-fit: cover;
      margin-right: 15px;
      border-radius: 4px;
    }

    .voucher-info {
      flex-grow: 1;
    }

    .voucher-item input[type="checkbox"] {
      margin-right: 12px;
      transform: scale(1.2);
    }

    .modal-actions {
      text-align: right;
      margin-top: 20px;
    }

    #openVoucherModal {
      background-color: white;
      color: #ff5722;
      border: 2px solid #ff5722;
      padding: 5px 6px;
      border-radius: 5px;
      margin-top: 10px;
      margin-bottom: 20px;
      font-size: 14px;
      font-weight: 500;
      cursor: pointer;
      transition: background-color 0.3s ease, transform 0.2s ease;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .apply-btn {
      background-color: #4CAF50;
      color: white;
      padding: 8px 16px;
      font-size: 15px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }

    .apply-btn:hover {
      background-color: #45a049;
    }

  </style>
</head>
<body>
<%@ include file="/partials/header.jsp" %>

<%
  session.removeAttribute("shippingFee");
  session.removeAttribute("shippingFeeAfterVoucher");
  session.removeAttribute("appliedVoucherIds");
%>

<div class="checkout-container">
  <h2>Thanh toán</h2>
  <div class="checkout-layout">
    <div class="order-summary">
      <h3>Thông tin đơn hàng</h3>
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
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${sessionScope.cart.items}" var="cp" varStatus="status">
              <tr id="cart-item-${cp.productId}-${cp.sizeId}">
                <td>${status.index + 1}</td>
                <td>
                  <c:choose>
                    <c:when test="${not empty cp.imageUrlCloud}">
                      <img src="${cp.imageUrlCloud}?f_auto,q_auto,w_50" alt="${cp.productName}" width="50">
                    </c:when>
                    <c:otherwise>
                      <img src="${pageContext.request.contextPath}/${cp.imageUrl}" alt="${cp.productName}" width="50">
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>${cp.productName}</td>
                <td>${cp.sizeDescriptions}</td>
                <td>
                  <span class="mx-2 quantity">${cp.quantity}</span>
                </td>
                <td class="item-total-price">
              <span class="fw-bold">Giá:
                <f:formatNumber value="${cp.discountPrice}" type="currency" pattern="#,##0"/> ₫
            </span>
              </tr>
            </c:forEach>
            </tbody>
            <tfoot>
            <tr>
              <th colspan="4" class="text-end">Tổng tiền</th>
              <th id="total-price" colspan="2">
                <f:formatNumber value="${sessionScope.cart.totalPrice}" pattern="#,##0" type="currency"/> ₫
              </th>            </tr>
            </tfoot>
          </table>
        </c:when>
        <c:otherwise>
          <div class="alert alert-info text-center" role="alert">
            Giỏ hàng của bạn đang trống.
          </div>
          <div class="text-center mt-3">
            <a href="${pageContext.request.contextPath}/artwork" class="btn btn-primary">Tiếp tục mua hàng</a>
          </div>
        </c:otherwise>
      </c:choose>

      <div>
        <label class="voucher-label">Chi phí giao hàng: <span id="shippingFee">Chưa tính</span></label>
      </div>


      <button id="openVoucherModal">Chọn hoặc nhập mã</button>
      <input type="hidden" id="voucherSelect" name="voucherCode"/>

      <span id="voucherCount" class="ms-2 text-muted" style="display: none;"></span>

      <div class="price-display">
        Giá phải trả: <span id="finalPrice" data-original-price="${sessionScope.cart.totalPrice}">
        <f:formatNumber value="${sessionScope.cart.totalPrice}" type="currency" pattern="#,##0"/>₫
      </span>
      </div>

      <div id="voucherModal" class="modal hidden">
        <div class="modal-content">
          <span class="close">&times;</span>
          <h3>Chọn Mã Giảm Giá</h3>

          <!-- Nhập mã thủ công -->
          <div class="row align-items-center mb-3">
            <label for="manualVoucher" class="col-auto fw-bold">Mã Voucher</label>
            <div class="col">
              <input type="text" id="manualVoucher" class="form-control" placeholder="Nhập mã voucher">
            </div>
            <div class="col-auto">
              <button id="applyManualVoucher" class="btn btn-outline-primary">Áp dụng</button>
            </div>
          </div>

          <h5 class="mt-3 mb-2">Mã Miễn Phí Vận Chuyển</h5>
          <div class="voucher-list">
            <c:forEach items="${v}" var="voucher">
              <c:if test="${voucher.type == 'shipping'}">
                <label class="voucher-item">
                  <input type="checkbox" name="voucherOption" value="${voucher.id}" data-type="shipping" />
                  <c:choose>
                    <c:when test="${not empty voucher.imageUrlCloud}">
                      <img src="${voucher.imageUrlCloud}?f_auto,q_auto,w_300" class="voucher-image" alt="Voucher">
                    </c:when>
                    <c:otherwise>
                      <img src="${pageContext.request.contextPath}/${voucher.imageUrl}" class="voucher-image" alt="Voucher">
                    </c:otherwise>
                  </c:choose>
                  <div class="voucher-info">
                    <strong>${voucher.name}</strong>
                    <f:formatNumber value="${voucher.discount}" type="number" maxFractionDigits="0" var="roundedDiscount" />
                    <p class="mb-1">Giảm ${roundedDiscount}%</p>
                    <p class="mb-1">Mã: ${voucher.code}</p>
                    <p class="mb-0">HSD: ${voucher.endDate}</p>
                  </div>
                </label>
              </c:if>
            </c:forEach>
          </div>

          <h5 class="mt-4 mb-2">Mã Giảm Giá Đơn Hàng</h5>
          <div class="voucher-list">
            <c:forEach items="${v}" var="voucher">
              <c:if test="${voucher.type == 'order'}">
                <label class="voucher-item">
                  <input type="checkbox" name="voucherOption" value="${voucher.id}" data-type="order" />
                  <c:choose>
                    <c:when test="${not empty voucher.imageUrlCloud}">
                      <img src="${voucher.imageUrlCloud}?f_auto,q_auto,w_300" class="voucher-image" alt="Voucher">
                    </c:when>
                    <c:otherwise>
                      <img src="${pageContext.request.contextPath}/${voucher.imageUrl}" class="voucher-image" alt="Voucher">
                    </c:otherwise>
                  </c:choose>
                  <div class="voucher-info">
                    <strong>${voucher.name}</strong>
                    <f:formatNumber value="${voucher.discount}" type="number" maxFractionDigits="0" var="roundedDiscount" />
                    <p class="mb-1">Giảm ${roundedDiscount}%</p>
                    <p class="mb-1">Mã: ${voucher.code}</p>
                    <p class="mb-0">HSD: ${voucher.endDate}</p>
                  </div>
                </label>
              </c:if>
            </c:forEach>
          </div>

          <div class="modal-actions mt-3">
            <button id="applyVoucherBtn" class="apply-btn btn btn-success">Áp dụng</button>
          </div>
        </div>
      </div>



    </div>


    <div class="payment-form">
      <h3>Thông tin thanh toán</h3>
      <label for="recipientName">Họ và Tên:</label>
      <input value="${sessionScope.user.fullName}" type="text" id="recipientName" name="fullName" required>

      <label for="recipientPhone">Số điện thoại:</label>
      <input value="${sessionScope.user.phone}" type="text" id="recipientPhone" name="phoneNumber" required>

      <label for="email">Email:</label>
      <input value="${sessionScope.user.email}" type="email" id="email" name="email" required>

      <div class="mb-3">
        <label for="deliveryAddress" class="form-label">Địa chỉ nhận hàng:</label>
        <input type="text" class="form-control" id="deliveryAddress" name="deliveryAddress"
               value="${sessionScope.user.address}" placeholder="Nhập địa chỉ nhận hàng" required readonly data-bs-toggle="modal" data-bs-target="#addressModal">
      </div>

      <label for="paymentMethod">Phương thức thanh toán:</label>
      <select id="paymentMethod" name="paymentMethod" required>
        <option value="1">Thanh toán khi nhận hàng (COD)</option>
        <option value="2">Thanh toán bằng VNPay</option>
      </select>

      <div id="bankDetails" style="display: none;">
        <label for="bankAccount">Số tài khoản:</label>
        <input type="text" id="bankAccount" name="bankAccount">

        <label for="bankName">Ngân hàng:</label>
        <input type="text" id="bankName" name="bankName">
      </div>

      <button type="button" id="submitPayment" class="btn btn-primary">Xác nhận</button>
    </div>
  </div>
</div>


<!-- Address Modal -->
<div class="modal fade" id="addressModal" tabindex="-1" aria-labelledby="addressModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addressModalLabel">Nhập địa chỉ nhận hàng</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="mb-3">
          <label for="province" class="form-label">Tỉnh/Thành phố:</label>
          <input type="text" class="form-control" id="province" placeholder="Tỉnh/Thành phố" required>

        </div>
        <div class="mb-3">
          <label for="district" class="form-label">Quận/Huyện:</label>
          <input type="text" class="form-control" id="district" placeholder="Quận/Huyện" required>

        </div>
        <div class="mb-3">
          <label for="ward" class="form-label">Phường/Xã:</label>
          <input type="text" class="form-control" id="ward" placeholder="Phường/xã" required>

        </div>
        <div class="mb-3">
          <label for="specificAddress" class="form-label">Địa chỉ cụ thể:</label>
          <input type="text" class="form-control" id="specificAddress" placeholder="Số nhà, tên đường..." required>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
        <button type="button" class="btn btn-primary" id="saveAddress">Lưu</button>
      </div>
    </div>
  </div>
</div>


<%@ include file="/partials/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    const fullAddress = "${sessionScope.user.address}";

    if (fullAddress) {
      const parts = fullAddress.split(",").map(part => part.trim());

      const reversed = parts.reverse();

      document.getElementById("province").value = reversed[0] || "";
      document.getElementById("district").value = reversed[1] || "";
      document.getElementById("ward").value = reversed[2] || "";
      document.getElementById("specificAddress").value = reversed[3] || "";
    }
  });
</script>
<script src="${pageContext.request.contextPath}/assets/js/shipping-fee.js"></script>
</body>
<script src="${pageContext.request.contextPath}/assets/js/checkout.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/applyVoucher.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/location.js"></script>
<script>
  const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

</html>
