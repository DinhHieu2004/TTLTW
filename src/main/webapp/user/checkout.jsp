<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "f" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thanh toán</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
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
</head>
<body>
<%@ include file="/partials/header.jsp" %>

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
                <td><img src="${cp.imageUrl}" alt="${cp.productName}" width="50"></td>
                <td>${cp.productName}</td>
                <td>${cp.sizeDescriptions}</td>
                <td>
                    <span class="mx-2 quantity">${cp.quantity}</span>
                </td>
                <td class="item-total-price">
              <span class="fw-bold">Giá:
                <f:formatNumber value="${cp.discountPrice}" type="currency" currencySymbol="₫"/>
            </span>
              </tr>
            </c:forEach>
            </tbody>
            <tfoot>
            <tr>
              <th colspan="4" class="text-end">Tổng tiền</th>
              <th id="total-price" colspan="2">
                <f:formatNumber value="${sessionScope.cart.totalPrice}" type="currency" currencySymbol="VND"/>
              </th>            </tr>
            </tfoot>
          </table>
        </c:when>
        <c:otherwise>
          <div class="alert alert-info text-center" role="alert">
            Giỏ hàng của bạn đang trống.
          </div>
        </c:otherwise>
      </c:choose>

      <div class="voucher-container">
        <label for="voucherSelect" class="voucher-label">Chọn mã giảm giá:</label>
        <select id="voucherSelect" name="voucherCode" class="voucher-select">
          <option value="">--Chọn mã giảm giá--</option>
          <c:forEach items="${v}" var="voucher">
            <option value="${voucher.id}">${voucher.name} - Giảm ${voucher.discount}%</option>
          </c:forEach>
        </select>

        <div class="price-display">
          Giá phải trả: <span id="finalPrice">
        <f:formatNumber value="${sessionScope.cart.totalPrice}" type="currency" currencySymbol="VND"/>
      </span>
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
        <input  value="${sessionScope.user.email}" type="email" id="email" name="email" required>

        <div class="mb-3">
          <label for="deliveryAddress" class="form-label">Địa chỉ nhận hàng:</label>
          <input type="text" class="form-control" id="deliveryAddress" name="deliveryAddress"
                 value="${sessionScope.user.address}" placeholder="Nhập địa chỉ nhận hàng" required>
        </div>

        <label for="paymentMethod">Phương thức thanh toán:</label>
        <select id="paymentMethod" name="paymentMethod" required onchange="toggleBankDetails()">
          <option value="1">Thanh toán khi nhận hàng (COD)</option>
          <option value="2">Thẻ tín dụng / Thẻ ghi nợ</option>
        </select>

        <div id="bankDetails" style="display: none;">
          <label for="bankAccount">Số tài khoản:</label>
          <input type="text" id="bankAccount" name="bankAccount">

          <label for="bankName">Ngân hàng:</label>
          <input type="text" id="bankName" name="bankName">
        </div>

        <button type="button" id="submitPayment" class="btn btn-primary">Xác nhân thanh toán</button>
    </div>
  </div>
</div>
<%@ include file="/partials/footer.jsp" %>


<script>
  function toggleBankDetails() {
    const paymentMethod = document.getElementById("paymentMethod").value;
    const bankDetails = document.getElementById("bankDetails");
    if (paymentMethod === "credit") {
      bankDetails.style.display = "block";
    } else {
      bankDetails.style.display = "none";
    }
  }
</script>
</body>
<script src="${pageContext.request.contextPath}/assets/js/checkout.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/applyVoucher.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/location.js"></script>



</html>
