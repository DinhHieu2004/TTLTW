<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tranh Cát Nghệ Thuật</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/artWork.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
</head>

<body>
<%@ include file="/partials/header.jsp" %>

<div class="page-title-inner">
    <h5>Tác phẩm</h5>
</div>

<div id="content-wrapper">
    <div class="container_content">
        <!-- Bộ lọc -->
        <div class="filter-section col-3">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="filter-title m-0">Bộ lọc sản phẩm</h5>
                <span class="filter-reset" id="resetFilters">Đặt lại</span>
            </div>
            <form id="filterForm">
                <!-- Giá -->
                <div class="filter-group">
                    <h6 class="mb-3">Giá (VNĐ)</h6>
                    <div class="price-range d-flex align-items-center">
                        <div class="input-group price-input me-2">
                            <input type="number" class="form-control" id="minPrice" name="minPrice" placeholder="Từ" value="${param.minPrice}">
                            <span class="input-group-text">đ</span>
                        </div>
                        <span class="price-separator mx-2">-</span>
                        <div class="input-group price-input">
                            <input type="number" class="form-control" id="maxPrice" name="maxPrice" placeholder="Đến" value="${param.maxPrice}">
                            <span class="input-group-text">đ</span>
                        </div>
                    </div>
                </div>

                <!-- Kích thước -->
                <div class="filter-group">
                    <h6 class="mb-3">Kích thước</h6>
                    <c:forEach var="size" items="${paintingSizes}">
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" value="${size.idSize}" id="${size.idSize}" name="size"
                            <c:forEach var="checkedSize" items="${paramValues.size}">
                                   <c:if test="${checkedSize eq size.idSize}">checked</c:if>
                            </c:forEach>>
                            <label class="form-check-label" for="${size.idSize}">${size.sizeDescriptions}</label>
                        </div>
                    </c:forEach>
                </div>

                <!-- Chủ đề -->
                <div class="filter-group">
                    <h6 class="mb-3">Chủ đề</h6>
                    <c:forEach var="theme" items="${themes}">
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" value="${theme.id}" id="${theme.id}" name="theme"
                            <c:forEach var="checkedTheme" items="${paramValues.theme}">
                                   <c:if test="${checkedTheme eq theme.id}">checked</c:if>
                            </c:forEach>>
                            <label class="form-check-label" for="${theme.id}">${theme.themeName}</label>
                        </div>
                    </c:forEach>
                </div>

                <!-- Họa sĩ -->
                <div class="filter-group">
                    <h6 class="mb-3">Họa sĩ</h6>
                    <c:forEach var="artist" items="${artists}">
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" value="${artist.id}" id="${artist.id}" name="artist"
                            <c:forEach var="checkedArtist" items="${paramValues.artist}">
                                   <c:if test="${checkedArtist eq artist.id}">checked</c:if>
                            </c:forEach>>
                            <label class="form-check-label" for="${artist.id}">${artist.name}</label>
                        </div>
                    </c:forEach>
                </div>

                <!-- Đánh giá -->
                <div class="form-check mb-2">
                    <input class="form-check-input" type="checkbox" value="rating" id="sortByRating" name="sort"
                           <c:if test="${param.sort eq 'rating'}">checked</c:if>>
                    <label class="form-check-label" for="sortByRating">
                        Đánh giá cao <i class="fas fa-star text-warning"></i>
                    </label>
                </div>

                <!-- Sản phẩm mới -->
                <div class="form-check mb-2">
                    <input class="form-check-input" type="checkbox" value="snew" id="sortDate" name="snew"
                           <c:if test="${param.snew eq 'snew'}">checked</c:if>>
                    <label class="form-check-label" for="sortDate">
                        Sản phẩm mới nhất <i class="fa-solid fa-newspaper" style="color: #FFD43B;"></i>
                    </label>
                </div>

                <!-- Ngày -->
                <div class="filter-group filter-latest-products card p-3">
                    <h6 class="mb-3">Sản phẩm theo ngày</h6>
                    <div class="date-range">
                        <div class="row g-2">
                            <div class="col-6">
                                <label for="startDate" class="form-label">Từ ngày</label>
                                <input type="date" class="form-control form-control-sm" id="startDate" name="startDate" value="${param.startDate}">
                            </div>
                            <div class="col-6">
                                <label for="endDate" class="form-label">Đến ngày</label>
                                <input type="date" class="form-control form-control-sm" id="endDate" name="endDate" value="${param.endDate}">
                            </div>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn w-100">Áp dụng</button>
            </form>
        </div>

        <!-- Danh sách tác phẩm -->
        <div class="row g-4 g-2 col-10" id="artworkGallery">
        </div>
    </div>
</div>

<!-- Phân trang -->
<nav aria-label="Page navigation" class="mt-4">
    <ul class="pagination justify-content-center" id="pagination">
    </ul>
</nav>

<%@ include file="/partials/footer.jsp" %>
<%@ include file="/partials/authModal.jsp" %>

<script src="https://kit.fontawesome.com/a076d05399.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/artWork.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>
</body>
</html>