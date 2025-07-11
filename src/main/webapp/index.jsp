<%@ page import="com.example.web.dao.model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
%>


<!DOCTYPE html>
<html>

<head>
    <meta charset='utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>Tranh cát</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <!--  <link rel='stylesheet' type='text/css' media='screen' href='main.css'>-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="assets/css/footer.css">
    <link rel="stylesheet" href="assets/css/header.css">
    <link rel="stylesheet" href="assets/css/style.css">


</head>
<style>
    .artwork-card {
        position: relative;
    }

    .card-link {
        position: absolute;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
        z-index: 1;
    }

     .flash-sale-timer {
         border: 2px solid red;
         padding: 6px 14px;
         margin-bottom: 5px;
         border-radius: 8px;
         font-weight: bold;
         color: red;
         font-size: 1rem;
         min-width: 100px;
         display: flex;
         justify-content: center;
         align-items: center;
     }
</style>

<body>

<%--<c:choose>--%>
<%--    <c:when test="${not empty currentUser}">--%>
<%--        <%@ include file="/partials/headerAuth.jsp" %>--%>
<%--    </c:when>--%>
<%--    <c:otherwise>--%>
        <%@ include file="/partials/header.jsp" %>
<%--    </c:otherwise>--%>
<%--</c:choose>--%>



    <div id="content-wrapper">



        <div class="container_content">
            <div class="background">
                <img src="assets/images/bin1200-1572525115279852147711.jpg">

            </div>
            <div id="dark_section">
                <div class="outer1">
                    <div class="content">
                        <div class="inner">
                            <b class="count">01.</b>
                            <b class="title">TRANH CÁT CAO CẤP</b>
                            <p class="inner_content">Tranh sáng tác độc bản - Có độ bền trăm năm</p>
                        </div>
                    </div>
                </div>
                <div class="outer2">
                    <div class="content">
                        <div class="inner">
                            <b class="count">02.</b>
                            <b class="title">SỰ KHÁC BIỆT</b>
                            <p class="inner_content">Sang trọng - tinh tế - kiến tạo không gian độc đáo</p>
                        </div>
                    </div>
                </div>
                <div class="outer3">
                    <div class="content">
                        <div class="inner">
                            <b class="count">03.</b>
                            <b class="title">TƯ VẤN CHUYÊN NGHIỆP</b>
                            <p class="inner_content">Đội ngũ chuyên gia hàng đầu trong lĩnh vực kiến trúc - nội địa</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<div class="container my-5">
    <div class="row">

        <!-- Cột bên trái: Hình ảnh -->
        <div class="col-md-6">
            <div class="embed-responsive embed-responsive-16by9">
                <img class="embed-responsive-item" src="https://cdn.baogialai.com.vn/images/b6e9e273388cf373c7197a59d2310437352c2851cd5b8e027e0695c8f296f53a0dee8c8a63898b6a340dd461c8ae966c9252f6b5d04211dd131bd7838ad9cb681db38117083bbcd83eda798a95fb1371/tp-tranhcat-11-3402-5493.jpg"
                     alt="Giới thiệu tranh cát" class="img-fluid"
                     style="width: 100%; height: 100%;"></iframe>
            </div>
        </div>

        <div class="col-md-6 introduce">
            <h2 class="intro-title">Giới thiệu</h2>

            <div class="intro-section my-3">
                <h3 class="subtitle">Nội dung độc đáo</h3>
                <div class="d-flex align-items-start">
                    <div class="vertical-line"
                         style="width: 4px; background-color: orange; margin-right: 15px;"></div>
                    <p class="intro-content">Hơn 150 tác phẩm Tranh cát Cao Cấp chỉ có tại NLUER
                        Gallery, độc quyền và độc bản. Đa dạng chủ đề tranh, màu sắc, kích thước phù hợp mọi
                        không gian nội thất.</p>
                </div>
            </div>

            <div class="intro-section my-3">
                <h3 class="subtitle">Chất lượng hoàn hảo</h3>
                <div class="d-flex align-items-start">
                    <div class="vertical-line"
                         style="width: 4px; background-color: orange; margin-right: 15px;"></div>
                    <p class="intro-content">Tranh cao cấp sử dụng chất liệu nhập khẩu hoàn toàn khác biệt,
                        khung gỗ sồi tự nhiên. Được sáng tác bởi đội ngũ họa sĩ trẻ tràn đầy năng lượng,
                        không ngừng sáng tạo theo dòng chảy tư duy kết nối với lớp họa sĩ gạo cội giàu cảm
                        xúc.</p>
                </div>
            </div>
        </div>

    </div>
</div>

<c:if test="${not empty flashSaleArtworks}">
<%-- Flash sale--%>
<div id="outstanding_works_section">
    <div class="title_container">
        <div class="img_left">
            <img src="assets/images/t_left.png">
        </div>
        <h4 class="collection_title">FLASH SALE</h4>
        <div id="flash-sale-timer" class="flash-sale-timer">00:00:00</div>
        <div class="img_right">
            <img src="assets/images/t_right.png">
        </div>
    </div>
    <div class="product">
        <c:forEach var="p" items="${flashSaleArtworks}">
            <div class="col-6 col-md-3">
                <div class="card artwork-card">
                    <div class="artwork-image-wrapper">
                    <c:choose>
                        <c:when test="${not empty p.imageUrlCloud}">
                            <a href="<c:url value='/painting-detail?pid=${p.id}'/>">
                                <img loading="lazy" src="${p.imageUrlCloud}?f_auto,q_auto,w_400" class="card-img-top artwork-image" alt="${p.title}" style="width: 100%; height:180px !important;">
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/painting-detail?pid=${p.id}'/>">
                                <img loading="lazy" src="${pageContext.request.contextPath}/${p.imageUrl}" class="card-img-top artwork-image" alt="${p.title}" style="width: 100%; height:180px !important;">
                            </a>
                        </c:otherwise>
                    </c:choose>
                    </div>
                    <div class="card-body">
                        <a href="<c:url value='/painting-detail?pid=${p.id}'/>" class="text-decoration-none text-dark">
                            <h5 class="card-title">${p.title}</h5>
                        </a>
                        <p class="card-text">
                            <strong>Họa Sĩ:</strong>
                            <a href="artwork?artist=${p.artistId}" class="link-custom">${p.artistName}</a><br>
                            <strong>Chủ đề:</strong>
                            <a href="artwork?theme=${p.themeId}" class="link-custom">${p.themeName}</a><br>
                            <span class="rating-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fas fa-star ${i <= p.averageRating ? 'text-warning' : 'text-gray-200'}" style="${i > p.averageRating ? 'color: #e9ecef !important;' : ''}; font-size: 0.875rem;"></i>
                            </c:forEach>
                        </span>
                            <span class="ms-1">${p.averageRating}</span>
                        </p>

                        <div class="price-section">
                            <c:choose>
                                <c:when test="${p.discountPercentage > 0}">
                                    <div class="price-container">
                                        <div class="original-price-wrapper">
                                            <fmt:formatNumber var="originalPrice" value="${p.price}" pattern="#,##0"/>
                                    <span class="text-muted original-price">
                                        <del>${fn:replace(originalPrice, ',', '.')} ₫</del>
                                    </span>
                                            <span class="badge bg-success discount-badge">-${p.discountPercentage}%</span>
                                        </div>
                                        <div class="sale-price-wrapper">
                                            <fmt:formatNumber var="salePrice" value="${p.price * (1 - p.discountPercentage / 100)}" pattern="#,##0"/>
                                    <span class="text-danger fw-bold sale-price">
                                        ${fn:replace(salePrice, ',', '.')} ₫
                                    </span>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatNumber var="regularPrice" value="${p.price}" pattern="#,##0"/>
                                    <div class="price-container">
                                        <div class="sale-price-wrapper">
                                            <span class="fw-bold">${fn:replace(regularPrice, ',', '.')} ₫</span>
                                        </div>
                                        <div class="original-price-wrapper" style="visibility: hidden; height: 24px;">
                                            <span class="badge bg-success discount-badge">&nbsp;</span>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <form id="addToCartForm_${p.id}" class="d-flex align-items-center justify-content-between mb-2 mt-2">
                            <input type="hidden" name="productId" value="${p.id}" />
                            <div class="mb-2 d-flex">
                                <c:forEach var="size" items="${p.sizes}" varStatus="status">
                                    <div class="col-auto">
                                        <div class="form-check me-3">
                                            <input class="form-check-input" type="radio" name="size_${p.id}"
                                               id="size_${p.id}_${size.idSize}"
                                            value="${size.idSize}"
                                            data-quantity="${size.displayQuantity}"
                                                ${size.displayQuantity <= 0 ? 'disabled' : ''}
                                                ${status.index == 0 && size.displayQuantity > 0 ? 'checked' :
                                                        (status.index > 0 && p.sizes[status.index-1].displayQuantity <= 0 && size.displayQuantity > 0 ? 'checked' : '')}>
                                            <input type="hidden" name="quantity_${size.idSize}" value="${size.displayQuantity}">
                                            <label class="form-check-label" for="size_${size.sizeDescriptions}">
                                                    ${fn:substringBefore(size.sizeDescriptions, ' ')}
                                            </label>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <button type="button" class="btn btn-sm btn-primary add-to-cart-btn" data-product-id="${p.id}">
                                + <i class="fas fa-cart-plus"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<div class="view-all-container text-center my-3">
    <a href="discount_content?id=3" class="btn btn-outline-warning btn-sm view-all-btn" style="
        padding: 6px 15px;
        border: 1px solid #f39c12 !important;
        color: #f39c12 !important;
        background: transparent !important;
        font-weight: 500;
        text-transform: uppercase;
        font-size: 14px;
        letter-spacing: 0.5px;
        transition: all 0.3s ease;
        text-decoration: none;
    ">
        xem tất cả
        <i class="fas fa-angle-right ms-1"></i>
    </a>
</div>
</c:if>

<div id="outstanding_works_section">
    <div class="title_container">
        <div class="img_left">
            <img src="assets/images/t_left.png">
        </div>
        <h4 class="collection_title">TÁC PHẨM TRƯNG BÀY</h4>
        <div class="img_right">
            <img src="assets/images/t_right.png">
        </div>
    </div>
    <div class="product">
        <c:forEach var="p" items="${featuredArtworks}">
                <div class="col-6 col-md-3">
                    <div class="card artwork-card">
                    <c:choose>
                        <c:when test="${not empty p.imageUrlCloud}">
                            <a href="<c:url value='/painting-detail?pid=${p.id}'/>">
                                <img loading="lazy" src="${p.imageUrlCloud}?f_auto,q_auto,w_400" class="card-img-top artwork-image" alt="${p.title}" style="width: 100%; height:180px !important;">
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/painting-detail?pid=${p.id}'/>">
                                <img loading="lazy" src="${pageContext.request.contextPath}/${p.imageUrl}" class="card-img-top artwork-image" alt="${p.title}" style="width: 100%; height:180px !important;">
                            </a>
                        </c:otherwise>
                    </c:choose>
                        <div class="card-body">
                            <a href="<c:url value='/painting-detail?pid=${p.id}'/>" class="text-decoration-none text-dark">
                                <h5 class="card-title">${p.title}</h5>
                            </a>
                            <p class="card-text">
                                <strong>Họa Sĩ:</strong>
                                <a href="artwork?artist=${p.artistId}" class="link-custom">${p.artistName}</a><br>
                                <strong>Chủ đề:</strong>
                                <a href="artwork?theme=${p.themeId}" class="link-custom">${p.themeName}</a><br>
                                <span class="rating-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fas fa-star ${i <= p.averageRating ? 'text-warning' : 'text-gray-200'}" style="${i > p.averageRating ? 'color: #e9ecef !important;' : ''}; font-size: 0.875rem;"></i>
                            </c:forEach>
                        </span>
                                <span class="ms-1">${p.averageRating}</span>
                            </p>
                            <div class="price-section">
                                <c:choose>
                                    <c:when test="${p.discountPercentage > 0}">
                                        <div class="price-container">
                                            <div class="original-price-wrapper">
                                                <fmt:formatNumber var="originalPrice" value="${p.price}" pattern="#,##0"/>
                                                <span class="text-muted original-price">
                                        <del>${fn:replace(originalPrice, ',', '.')} ₫</del>
                                    </span>
                                                <span class="badge bg-success discount-badge">-${p.discountPercentage}%</span>
                                            </div>
                                            <div class="sale-price-wrapper">
                                                <fmt:formatNumber var="salePrice" value="${p.price * (1 - p.discountPercentage / 100)}" pattern="#,##0"/>
                                                <span class="text-danger fw-bold sale-price">
                                        ${fn:replace(salePrice, ',', '.')} ₫
                                    </span>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber var="regularPrice" value="${p.price}" pattern="#,##0"/>
                                        <div class="price-container">
                                            <div class="sale-price-wrapper">
                                                <span class="fw-bold">${fn:replace(regularPrice, ',', '.')} ₫</span>
                                            </div>
                                            <div class="original-price-wrapper" style="visibility: hidden; height: 24px;">
                                                <span class="badge bg-success discount-badge">&nbsp;</span>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <form id="addToCartForm_${p.id}" class="d-flex align-items-center justify-content-between mb-2 mt-2">
                                <input type="hidden" name="productId" value="${p.id}" />
                                <div class="mb-2 d-flex">
                                    <c:forEach var="size" items="${p.sizes}" varStatus="status">
                                        <div class="col-auto">
                                            <div class="form-check me-3">
                                                <input class="form-check-input" type="radio" name="size_${p.id}"
                                               id="size_${p.id}_${size.idSize}"
                                                value="${size.idSize}"
                                                data-quantity="${size.displayQuantity}"
                                                    ${size.displayQuantity <= 0 ? 'disabled' : ''}
                                                    ${status.index == 0 && size.displayQuantity > 0 ? 'checked' :
                                                            (status.index > 0 && p.sizes[status.index-1].displayQuantity <= 0 && size.displayQuantity > 0 ? 'checked' : '')}>
                                                <input type="hidden" name="quantity_${size.idSize}" value="${size.displayQuantity}">
                                                <label class="form-check-label" for="size_${size.sizeDescriptions}">
                                                        ${fn:substringBefore(size.sizeDescriptions, ' ')}
                                                </label>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <button type="button" class="btn btn-sm btn-primary add-to-cart-btn" data-product-id="${p.id}">
                                    + <i class="fas fa-cart-plus"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
    </div>
</div>
<div id="outstanding_works_section">
    <div class="title_container">
        <div class="img_left">
            <img src="assets/images/t_left.png">
        </div>
        <h4 class="collection_title">TÁC PHẨM MỚI NHẤT</h4>
        <div class="img_right">
            <img src="assets/images/t_right.png">
        </div>
    </div>
    <div class="product">
        <c:forEach var="p" items="${newP}">
            <div class="col-6 col-md-3">
                <div class="card artwork-card">
                    <c:choose>
                        <c:when test="${not empty p.imageUrlCloud}">
                            <a href="<c:url value='/painting-detail?pid=${p.id}'/>">
                                <img loading="lazy" src="${p.imageUrlCloud}?f_auto,q_auto,w_400" class="card-img-top artwork-image" alt="${p.title}" style="width: 100%; height:180px !important;">
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/painting-detail?pid=${p.id}'/>">
                                <img loading="lazy" src="${pageContext.request.contextPath}/${p.imageUrl}" class="card-img-top artwork-image" alt="${p.title}" style="width: 100%; height:180px !important;">
                            </a>
                        </c:otherwise>
                    </c:choose>
                    <div class="card-body">
                        <a href="<c:url value='/painting-detail?pid=${p.id}'/>" class="text-decoration-none text-dark">
                            <h5 class="card-title">${p.title}</h5>
                        </a>
                        <p class="card-text">
                            <strong>Họa Sĩ:</strong>
                            <a href="artwork?artist=${p.artistId}" class="link-custom">${p.artistName}</a><br>
                            <strong>Chủ đề:</strong>
                            <a href="artwork?theme=${p.themeId}" class="link-custom">${p.themeName}</a><br>
                            <span class="rating-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fas fa-star ${i <= p.averageRating ? 'text-warning' : 'text-gray-200'}" style="${i > p.averageRating ? 'color: #e9ecef !important;' : ''}; font-size: 0.875rem;"></i>
                            </c:forEach>
                        </span>
                            <span class="ms-1">${p.averageRating}</span>
                        </p>
                        <div class="price-section">
                            <c:choose>
                                <c:when test="${p.discountPercentage > 0}">
                                    <div class="price-container">
                                        <div class="original-price-wrapper">
                                            <fmt:formatNumber var="originalPrice" value="${p.price}" pattern="#,##0"/>
                                            <span class="text-muted original-price">
                                        <del>${fn:replace(originalPrice, ',', '.')} ₫</del>
                                    </span>
                                            <span class="badge bg-success discount-badge">-${p.discountPercentage}%</span>
                                        </div>
                                        <div class="sale-price-wrapper">
                                            <fmt:formatNumber var="salePrice" value="${p.price * (1 - p.discountPercentage / 100)}" pattern="#,##0"/>
                                            <span class="text-danger fw-bold sale-price">
                                        ${fn:replace(salePrice, ',', '.')} ₫
                                    </span>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatNumber var="regularPrice" value="${p.price}" pattern="#,##0"/>
                                    <div class="price-container">
                                        <div class="sale-price-wrapper">
                                            <span class="fw-bold">${fn:replace(regularPrice, ',', '.')} ₫</span>
                                        </div>
                                        <div class="original-price-wrapper" style="visibility: hidden; height: 24px;">
                                            <span class="badge bg-success discount-badge">&nbsp;</span>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <form id="addToCartForm_${p.id}" class="d-flex align-items-center justify-content-between mb-2 mt-2">
                            <input type="hidden" name="productId" value="${p.id}" />
                        <div class="mb-2 d-flex">
                            <c:forEach var="size" items="${p.sizes}" varStatus="status">
                                <div class="col-auto">
                                    <div class="form-check me-3">
                                        <input class="form-check-input" type="radio" name="size_${p.id}"
                                            id="size_${p.id}_${size.idSize}"
                                            value="${size.idSize}"
                                            data-quantity="${size.displayQuantity}"
                                            ${size.displayQuantity <= 0 ? 'disabled' : ''}
                                            ${status.index == 0 && size.displayQuantity > 0 ? 'checked' :
                                                    (status.index > 0 && p.sizes[status.index-1].displayQuantity <= 0 && size.displayQuantity > 0 ? 'checked' : '')}>
                                        <input type="hidden" name="quantity_${size.idSize}" value="${size.displayQuantity}">
                                        <label class="form-check-label" for="size_${size.sizeDescriptions}">
                                                ${fn:substringBefore(size.sizeDescriptions, ' ')}
                                        </label>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <button type="button" class="btn btn-sm btn-primary add-to-cart-btn" data-product-id="${p.id}">
                            + <i class="fas fa-cart-plus"></i>
                        </button>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<div class="view-all-container text-center my-3">
    <a href="artwork?snew=snew" class="btn btn-outline-warning btn-sm view-all-btn" style="
        padding: 6px 15px;
        border: 1px solid #f39c12 !important;
        color: #f39c12 !important;
        background: transparent !important;
        font-weight: 500;
        text-transform: uppercase;
        font-size: 14px;
        letter-spacing: 0.5px;
        transition: all 0.3s ease;
        text-decoration: none;
    ">
        khám phá thêm
        <i class="fas fa-angle-right ms-1"></i>
    </a>
</div>

<div id="outstanding_works_section">
    <div class="title_container">
        <div class="img_left">
            <img src="assets/images/t_left.png">
        </div>
        <h4 class="collection_title">TÁC PHẨM ĐƯỢC ĐÁNH GIÁ CAO</h4>
        <div class="img_right">
            <img src="assets/images/t_right.png">
        </div>
    </div>
    <div class="product">
        <c:forEach var="p" items="${bp}">
            <div class="col-6 col-md-3">
                <div class="card artwork-card">
                    <c:choose>
                        <c:when test="${not empty p.imageUrlCloud}">
                            <a href="<c:url value='/painting-detail?pid=${p.id}'/>">
                                <img loading="lazy" src="${p.imageUrlCloud}?f_auto,q_auto,w_400" class="card-img-top artwork-image" alt="${p.title}" style="width: 100%; height:180px !important;">
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/painting-detail?pid=${p.id}'/>">
                                <img loading="lazy" src="${pageContext.request.contextPath}/${p.imageUrl}" class="card-img-top artwork-image" alt="${p.title}" style="width: 100%; height:180px !important;">
                            </a>
                        </c:otherwise>
                    </c:choose>
                    <div class="card-body">
                        <a href="<c:url value='/painting-detail?pid=${p.id}'/>" class="text-decoration-none text-dark">
                            <h5 class="card-title">${p.title}</h5>
                        </a>
                        <p class="card-text">
                            <strong>Họa Sĩ:</strong>
                            <a href="artwork?artist=${p.artistId}" class="link-custom">${p.artistName}</a><br>
                            <strong>Chủ đề:</strong>
                            <a href="artwork?theme=${p.themeId}" class="link-custom">${p.themeName}</a><br>
                            <span class="rating-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fas fa-star ${i <= p.averageRating ? 'text-warning' : 'text-gray-200'}" style="${i > p.averageRating ? 'color: #e9ecef !important;' : ''}; font-size: 0.875rem;"></i>
                            </c:forEach>
                        </span>
                            <span class="ms-1">${p.averageRating}</span>
                        </p>
                        <div class="price-section">
                            <c:choose>
                                <c:when test="${p.discountPercentage > 0}">
                                    <div class="price-container">
                                        <div class="original-price-wrapper">
                                            <fmt:formatNumber var="originalPrice" value="${p.price}" pattern="#,##0"/>
                                            <span class="text-muted original-price">
                                        <del>${fn:replace(originalPrice, ',', '.')} ₫</del>
                                    </span>
                                            <span class="badge bg-success discount-badge">-${p.discountPercentage}%</span>
                                        </div>
                                        <div class="sale-price-wrapper">
                                            <fmt:formatNumber var="salePrice" value="${p.price * (1 - p.discountPercentage / 100)}" pattern="#,##0"/>
                                            <span class="text-danger fw-bold sale-price">
                                        ${fn:replace(salePrice, ',', '.')} ₫
                                    </span>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatNumber var="regularPrice" value="${p.price}" pattern="#,##0"/>
                                    <div class="price-container">
                                        <div class="sale-price-wrapper">
                                            <span class="fw-bold">${fn:replace(regularPrice, ',', '.')} ₫</span>
                                        </div>
                                        <div class="original-price-wrapper" style="visibility: hidden; height: 24px;">
                                            <span class="badge bg-success discount-badge">&nbsp;</span>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <form id="addToCartForm_${p.id}" class="d-flex align-items-center justify-content-between mb-2 mt-2">
                            <input type="hidden" name="productId" value="${p.id}" />
                            <div class="mb-2 d-flex">
                                <c:forEach var="size" items="${p.sizes}" varStatus="status">
                                    <div class="col-auto">
                                        <div class="form-check me-3">
                                            <input class="form-check-input" type="radio" name="size_${p.id}"
                                               id="size_${p.id}_${size.idSize}"
                                            value="${size.idSize}"
                                            data-quantity="${size.displayQuantity}"
                                                ${size.displayQuantity <= 0 ? 'disabled' : ''}
                                                ${status.index == 0 && size.displayQuantity > 0 ? 'checked' :
                                                        (status.index > 0 && p.sizes[status.index-1].displayQuantity <= 0 && size.displayQuantity > 0 ? 'checked' : '')}>
                                            <input type="hidden" name="quantity_${size.idSize}" value="${size.displayQuantity}">
                                            <label class="form-check-label" for="size_${size.sizeDescriptions}">
                                                    ${fn:substringBefore(size.sizeDescriptions, ' ')}
                                            </label>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <button type="button" class="btn btn-sm btn-primary add-to-cart-btn" data-product-id="${p.id}">
                                + <i class="fas fa-cart-plus"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<div class="view-all-container text-center my-3">
    <a href="artwork?sort=rating" class="btn btn-outline-warning btn-sm view-all-btn" style="
        padding: 6px 15px;
        border: 1px solid #f39c12 !important;
        color: #f39c12 !important;
        background: transparent !important;
        font-weight: 500;
        text-transform: uppercase;
        font-size: 14px;
        letter-spacing: 0.5px;
        transition: all 0.3s ease;
        text-decoration: none;
    ">
        khám phá thêm
        <i class="fas fa-angle-right ms-1"></i>
    </a>
</div>

<div id="collection_section">
        <div class="title_container">
            <div class="img_left">
                <img src="assets/images/t_left.png">
            </div>
            <h4 class="collection_title">CHỦ ĐỀ</h4>
            <div class="img_right">
                <img src="assets/images/t_right.png">
            </div>
        </div>
        <div class="collection_product">
            <c:forEach var="themes" items="${themes}">
                <a href="artwork?theme=${themes.id}" class="collection-link">
            <div class="collection">
                <div class="img_container">
                    <img loading="lazy" src="https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YXJ0aXN0fGVufDB8fDB8fHww"
                        class="card-img-top artwork-image" alt="${themes.themeName}">
                    <div class="collection_description">
                        <p>${themes.themeName}</p>
                    </div>
                </div>
            </div>
                </a>
            </c:forEach>
        </div>
    </div>
    <div id="icon_section">
        <div class="icon_first_col">
            <img loading="lazy" src="assets/images/fast-delivery-1.png">
            <h4>GIAO HÀNG TOÀN QUỐC</h4>
            <p>Chúng tôi nhận đóng gói và vận chuyển cho mọi khách hàng trên toàn quốc</p>
        </div>
        <div class="icon_second_col">
            <img loading="lazy" src="assets/images/quality.png">
            <h4>CHẤT LƯỢNG HÀNG ĐẦU</h4>
            <p>Chất lượng tuyệt hảo, đường nét sống động được vẽ bởi các họa sĩ sáng tạo, có tên tuổi trong giới nghệ
                thuật</p>
        </div>
        <div class="icon_third_col">
            <img loading="lazy" src="assets/images/feature-selection.png">
            <h4>SẢN PHẨM ĐA DẠNG</h4>
            <p>Chúng tôi có nhiều tác phẩm ở nhiều thể loại. Ngoài ra, cũng có nhiều lựa chọn theo yêu cầu của khách
                hàng</p>
        </div>
    </div>
    <div id="partner_section">
        <div class="partner_title">
            <img src="assets/images/t_left.png">
            <h4>CÁC ĐỐI TÁC CỦA CHÚNG TÔI</h4>
            <img src="assets/images/t_right.png">
        </div>
        <div class="logo">
            <img src="assets/images/Dong-gia.jpg">
            <img src="assets/images/Genesis-1.png">
            <img src="assets/images/GU_Bistronomy.png">
            <img src="assets/images/Hoi-MTVN.png">
            <img src="assets/images/Kenly.jpg">
            <img src="assets/images/KTSVN.png">
            <img src="assets/images/Mant.png">
            <img src="assets/images/SenDesign.jpg">
        </div>

    </div>
<%@ include file="/partials/footer.jsp" %>
<%@ include file="/partials/authModal.jsp" %>
</body>

<script src="${pageContext.request.contextPath}/assets/js/index.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/header/search.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/location.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>


<script type="text/javascript">
    function startCountdown(endTimeStr) {
        const timer = document.getElementById("flash-sale-timer");
        const endTime = new Date(endTimeStr).getTime();

        function updateTimer() {
            const now = new Date().getTime();
            const distance = endTime - now;

            if (distance < 0) {
                timer.innerHTML = "Đã kết thúc";
                clearInterval(interval);
                return;
            }

            const hours = Math.floor((distance / (1000 * 60 * 60)) % 24);
            const minutes = Math.floor((distance / (1000 * 60)) % 60);
            const seconds = Math.floor((distance / 1000) % 60);

            timer.innerHTML =
                hours.toString().padStart(2, '0') + ":" +
                minutes.toString().padStart(2, '0') + ":" +
                seconds.toString().padStart(2, '0');
        }

        updateTimer();
        const interval = setInterval(updateTimer, 1000);
    }

    // thời gian kết thúc flash sale
    const flashSaleEndTime = "${flashSaleEndDateTime}";
    debugger

    document.addEventListener("DOMContentLoaded", function() {
        startCountdown(flashSaleEndTime);
    });
</script>


</html>