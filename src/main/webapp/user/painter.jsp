<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "f" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <title>Page Title</title>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <!--  <link rel='stylesheet' type='text/css' media='screen' href='main.css'>-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/painter.css">

</head>

<body>
<%@ include file="/partials/header.jsp" %>

<div class="container my-5">

    <div  class="page-title-inner">
        <h5 >Thông tin họa sĩ </h5>
    </div>
    <div class="container my-5">

        <div class="row">
            <div class="col-md-4">
                <c:choose>
                    <c:when test="${not empty data.imageUrlCloud}">
                        <img loading="lazy"
                             src="${data.imageUrlCloud}?f_auto,q_auto,w_400"
                             alt="Họa Sĩ"
                             class="artist-photo">
                    </c:when>
                    <c:otherwise>
                        <img loading="lazy"
                             src="${pageContext.request.contextPath}/${data.photoUrl}"
                             alt="Họa Sĩ"
                             class="artist-photo">
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="col-md-8">
                <div class="artist-info">
                    <h2 class="artist-name">${data.name}</h2>
                    <div class="artist-details">
                        <p><strong>Ngày Sinh:</strong>${data.birthDate}</p>
                        <p><strong>Quốc Tịch:</strong>${data.nationality}</p>
                    </div>

                    <div class="artist-bio">
                        <h5>Tiểu sử</h5>
                        <p>${data.bio}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Artist's Artworks -->
        <div class="container-product">
            <div class="row g-4 g-2 col-10" id="artworkGallery">
                <c:forEach var="p" items="${listP}">
                        <div class="col-6 col-md-3">
                            <div class="card artwork-card h-100" style="height: 380px !important;">
                                <a href="painting-detail?pid=${p.id}" class="card-link"></a>
                                <c:choose>
                                    <c:when test="${not empty p.imageUrlCloud}">
                                        <img loading="lazy"
                                             src="${p.imageUrlCloud}?f_auto,q_auto,w_400"
                                             class="card-img-top artwork-image"
                                             alt="${p.title}"
                                             style="width: 100%; height:180px !important;">
                                    </c:when>
                                    <c:otherwise>
                                        <img loading="lazy"
                                             src="${pageContext.request.contextPath}/${p.imageUrl}"
                                             class="card-img-top artwork-image"
                                             alt="${p.title}"
                                             style="width: 100%; height:180px !important;">
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body">
                                    <h5 class="card-title">${p.title}</h5>
                                    <p class="card-text">
                                        <strong>Họa Sĩ:</strong> ${p.artistName}<br>
                                        <strong>Chủ đề:</strong> ${p.themeName}<br>

                                        <span class="rating-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fas fa-star ${i <= p.averageRating ? 'text-warning' : 'text-gray-200'}" style="${i > p.averageRating ? 'color: #e9ecef !important;' : ''}; font-size: 0.875rem;"></i>
                            </c:forEach>
                        </span>
                                        <span class="ms-1">${p.averageRating}</span>
                                    </p>
                                    <c:choose>
                                        <c:when test="${p.discountPercentage > 0}">
                                            <div class="d-flex align-items-center gap-2">
                                                <del class="text-muted" style="font-size: 0.8rem;">
                                                    <f:formatNumber value="${p.price}" type="currency" currencySymbol="VNĐ"/>
                                                </del>
                                                <span class="badge bg-success" style="font-size: 0.75rem;">-${p.discountPercentage}%</span>
                                            </div>
                                            <div class="text-danger fw-bold" style="font-size: 0.925rem;">
                                                <f:formatNumber value="${p.price * (1 - p.discountPercentage / 100)}" type="currency" currencySymbol="VNĐ"/>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="fw-bold" style="font-size: 0.925rem;">
                                                <f:formatNumber value="${p.price}" type="currency" currencySymbol="VNĐ"/>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
        </div>
    </div>
        <div class="view-all-container text-center my-3">
            <a href="artwork?artist=${data.id}" class="btn btn-outline-warning btn-sm view-all-btn" style="
        padding: 6px 15px;
        border: 1px solid #f39c12;
        color: #f39c12;
        background: transparent;
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
    </div>
</div>
<%@ include file="/partials/footer.jsp" %>
<%@ include file="/partials/authModal.jsp" %>


</body>
<script src="${pageContext.request.contextPath}/assets/js/painter.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</html>