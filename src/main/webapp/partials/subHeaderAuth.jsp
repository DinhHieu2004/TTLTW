
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "f" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="../assets/css/footer.css">
    <link rel="stylesheet" href="../assets/css/header.css">
</head>
<header id="header-container" class="fixed-top">
    <div class="header-top">

    </div>
    <div class="container-fluid">
        <nav class="navbar navbar-expand-lg">
            <!-- Logo -->
            <a class="navbar-brand" href="../index.jsp">
                <img src="assets/images/z6089438426018_bba333fc15dcbab8feae6b9b8cb460bd.jpg" alt="NLUER Gallery"
                    height="60">
            </a>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarMain">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item"><a class="nav-link" href="../index.jsp">TRANG CHỦ</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/about_us.jsp" id="navbarDropdown" >GIỚI THIỆU</a>
                    </li>
                    <li class="nav-item"><a class="nav-link" href="artwork">TÁC PHẨM</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/user/discount">CHƯƠNG TRÌNH GIẢM GIÁ</a></li>
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

                <a href="${pageContext.request.contextPath}/user/personal.jsp" class="icon_items user-icon me-3">

                    <i class="fa fa-user"></i>
                </a>

                <div class="cart-icon position-relative">
                    <a href="#" class="icon_items position-relative"></a>
                          <span class="price me-2">0đ</span>
                        <a href="#" class="icon_items user-icon me-3">

                            <i class="fa fa-shopping-cart"></i> </a>

                           <span class="cart-count"></span>
                    </a>
                    <div class="cart-dropdown" id="mini-cart">
                        <div class="cart-header">Sản Phẩm Mới Thêm</div>
                        <div class="cart-items" id="mini-cart-items">
                        <c:forEach  items="${sessionScope.cart.items}" var="cp">
                            <div class="cart-item">
                                <img src="${cp.imageUrlCloud}" alt="${cp.productName}" class="cart-item-image" />
                                <div class="cart-item-details">
                                    <div class="cart-item-name-price">
                                        <span class="cart-item-name">${cp.productName}</span>
                                        <span class="cart-item-price">${cp.totalPrice}</span>
                                    </div>
                                    <div class="cart-item-size">${cp.sizeDescriptions}</div>
                                </div>
                            </div>

                            </c:forEach>
                        </div>
                        <div class="cart-footer">
                            <button class="btn btn-primary" onclick="window.location.href='show-cart'">
                                Xem Giỏ Hàng
                            </button>
                        </div>
                    </div>

                </div>
            </div>
        </nav>
    </div>

    <div id="search-bar" class="container mt-2">
        <div class="input-group">
            <input type="text" class="form-control" id="search-input" placeholder="Tìm kiếm...">
            <button class="btn btn-primary" id="search-btn">Tìm</button>
        </div>
    </div>
</header>

<script src="https://kit.fontawesome.com/a076d05399.js"></script>


</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>