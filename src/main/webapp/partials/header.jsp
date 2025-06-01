<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        const contextPath = "${pageContext.request.contextPath}";
    </script>
</head>
<header id="header-container" class="fixed-top">
    <div class="header-top">

    </div>
    <div class="container-fluid">
        <nav class="navbar navbar-expand-lg">
            <!-- Logo -->
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">

                <img src="assets/images/z6089438426018_bba333fc15dcbab8feae6b9b8cb460bd.jpg" alt="NLUER Gallery"
                     height="60">
            </a>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarMain">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">TRANG CHỦ</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link" href="introduce" id="navbarDropdown">GIỚI THIỆU</a>
                    </li>
                    <li class="nav-item"><a class="nav-link" href="artwork">TÁC PHẨM</a></li>
                    <li class="nav-item"><a class="nav-link" href="discount">CHƯƠNG TRÌNH GIẢM GIÁ</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#">HỌA SĨ</a>
                        <ul class="dropdown-menu">
                            <c:forEach var="artist" items="${artists}">
                                <li><a class="nav-link" href="painter-detail?id=${artist.id}">${artist.name}</a></li>
                            </c:forEach>
                        </ul>
                    </li>
                </ul>
            </div>

            <div class="header-icons d-flex align-items-center justify-content-between">
                <a href="#" class="icon_items search-icon me-3" id="search-icon">
                    <i class="fa fa-search"></i>
                </a>
                <c:choose>
                <c:when test="${not empty sessionScope.user}">
                <a href="personal" class="icon_items user-icon me-3">
                    <i class="fa fa-user"></i>
                </a>
                </c:when>
                </c:choose>
                <%--                <div id="userIcon" style="display: none;">--%>
                <%--                    <a href="personal" class="icon_items user-icon me-3">--%>
                <%--                        <i class="fa fa-user"></i>--%>
                <%--                    </a>--%>
                <%--                </div>--%>
                <div class="cart-icon position-relative">
                    <a href="show-cart" class="icon_items user-icon me-3 position-relative">
                        <i class="fa fa-shopping-cart"></i>
                        <span id="cart-item-count" class="cart-badge">
                            <c:choose>
                                <c:when test="${not empty sessionScope.cart and sessionScope.cart.itemCount > 0}">
                                    ${sessionScope.cart.itemCount}
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </span>
                    </a>


                    <div class="cart-dropdown" id="mini-cart">
                        <div class="cart-header">Sản Phẩm Mới Thêm</div>

                        <div class="cart-items" id="mini-cart-items">
                            <c:choose>
                                <c:when test="${empty sessionScope.cart.items }">
                                    <div class="alert alert-info text-center" role="alert">
                                        Giỏ hàng của bạn đang trống.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${sessionScope.cart.items}" var="cp">
                                        <div class="cart-item" id="mini-cart-item-${cp.productId}-${cp.sizeId}">
                                            <img src="${cp.imageUrlCloud}" alt="${cp.productName}" class="cart-item-image"/>

                                            <div class="cart-item-details">
                                                <div class="cart-item-name-price">
                                                    <span class="cart-item-name">${cp.productName}</span>
                                                    <span class="cart-item-price">
                                    <c:choose>
                                        <c:when test="${cp.discountPercent > 0}">
                                            <f:formatNumber var="discounted" value="${cp.discountPrice}" pattern="#,##0" />
                                            <span>
                                                ${fn:replace(discounted, ',', '.')} ₫
                                            </span>
                                            <span class="badge bg-success ms-2">-${cp.discountPercent}%</span>
                                        </c:when>
                                        <c:otherwise>
                                            <f:formatNumber var="total" value="${cp.totalPrice}" pattern="#,##0" />
                                            <span>
                                                ${fn:replace(total, ',', '.')} ₫
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                                                </div>

                                                <div style="display: flex; align-items: center; gap: 10px; font-size: 14px;">
                                                    <div class="cart-item-size">Size: ${cp.sizeDescriptions}</div>
                                                    <div class="cart-item-quantity">Số lượng: ${cp.quantity}</div>
                                                </div>
                                            </div>

                                            <button class="remove-item"
                                                    data-product-id="${cp.productId}"
                                                    data-size-id="${cp.sizeId}"
                                                    style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); border: none; background: none; cursor: pointer; font-size: 16px; color: #ff0000;">
                                                X
                                            </button>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="cart-footer">
                            <div class="total-price">
                                Tổng tiền:
                                <span id="total-price">
                                    <span id="total-price-value">
                                        <f:formatNumber var="totalFormatted" value="${sessionScope.cart.totalPrice != null ? sessionScope.cart.totalPrice : 0}" pattern="#,##0" />
                                        ${fn:replace(totalFormatted, ',', '.')} ₫
                                    </span>
                                </span>
                            </div>

                            <button class="btn btn-primary" onclick="window.location.href='show-cart'"
                                    style="background: #e7621b !important;">
                                Xem Giỏ Hàng
                            </button>
                        </div>
                    </div>

                </div>

                <c:choose>
                   <c:when test="${empty sessionScope.user}">
                    <button class="btn login-btn" data-bs-toggle="modal" data-bs-target="#authModal"
                        style="background: #e7621b !important; margin-right: 10px;">Đăng nhập
                    </button>
                    <button class="btn register-btn" data-bs-toggle="modal" data-bs-target="#authModal"
                        data-tab="register" style="background: #e7621b !important;">Đăng ký
                    </button>
                    </c:when>
                    <c:when test="${not empty sessionScope.user}">
                    <button class="btn logout-btn" onclick="logout()" style="background: #e7621b !important;">
                        <i class="fa fa-sign-out-alt"></i> Đăng xuất
                    </button>
                </c:when>
             </c:choose>

        </nav>
    </div>
    <form action="artwork" method="GET">

        <div id="search-bar" class="container mt-2 justify-content-center" style="">
            <div class="input-group d-flex justify-content-center" style="width: 600px; top:-90px;right: 50px;">
                <input style="padding: 12px;" name="keyword" type="text" class="form-control" id="search-input"
                       placeholder="Tìm kiếm..." autocomplete="off">
                <button class="btn btn-primary" id="search-btn" style="background: #e7621b !important;">Tìm</button>
                <div style="top:50px; width: 600px" id="suggestions"></div>

            </div>

        </div>
    </form>

</header>
<div class="toast-container position-fixed bottom-0 end-0 p-3" id="toastContainer" style="z-index: 9999;"></div>


<script src="https://kit.fontawesome.com/a076d05399.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/header/search.js"></script>


</script>


<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/shopping-cart.js"></script>

