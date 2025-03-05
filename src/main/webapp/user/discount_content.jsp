<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="vi">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tranh Cát Nghệ Thuật</title>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/artWork.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
</head>

<body>
<%@ include file="/partials/header.jsp" %>

<div class="page-title-inner">
  <h5> Chi tiết giảm giá </h5>

</div>

<div id="content-wrapper">
  <div class="container_content">
    <!-- Bộ lọc -->
    <div class="filter-section col-3">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="filter-title m-0">Bộ lọc sản phẩm</h5>
        <span class="filter-reset" id="resetFilters">Đặt lại</span>
      </div>
      <form id="filterForm" method="GET" action="discount_content">
        <input type="hidden" name="id" value="${discount.id}" />
        <!-- Giá -->
        <div class="filter-group">
          <h6 class="mb-3">Giá (VNĐ)</h6>
          <div class="price-range d-flex align-items-center">
            <div class="input-group price-input me-2">
              <input type="number" class="form-control"
                     id="minPrice"
                     name="minPrice"
                     placeholder="Từ"
                     value="${param.minPrice}">
              <span class="input-group-text">đ</span>
            </div>
            <span class="price-separator mx-2">-</span>
            <div class="input-group price-input">
              <input type="number" class="form-control"
                     id="maxPrice"
                     name="maxPrice"
                     placeholder="Đến"
                     value="${param.maxPrice}">
              <span class="input-group-text">đ</span>
            </div>
          </div>
        </div>

        <div class="filter-group">
          <h6 class="mb-3">Kích thước</h6>
          <c:forEach var="size" items="${paintingSizes}">
            <div class="form-check mb-2">
              <input class="form-check-input" type="checkbox"
                     value="${size.idSize}"
                     id="${size.idSize}"
                     name="size"

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
              <input class="form-check-input" type="checkbox"
                     value="${theme.id}"
                     id="${theme.id}"
                     name="theme"
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
              <input class="form-check-input" type="checkbox"
                     value="${artist.id}"
                     id="${artist.id}"
                     name="artist"
              <c:forEach var="checkedArtist" items="${paramValues.artist}">
                     <c:if test="${checkedArtist eq artist.id}">checked</c:if>
              </c:forEach>>
              <label class="form-check-label" for="${artist.id}">${artist.name}</label>
            </div>
          </c:forEach>
        </div>
        <!--đánh giá tốt-->
        <div class="form-check mb-2">
          <input class="form-check-input" type="checkbox"
                 value="rating"
                 id="sortByRating"
                 name="sort"
                 <c:if test="${param.sort eq 'rating'}">checked</c:if>>
          <label class="form-check-label" for="sortByRating">
            Đánh giá tốt nhất
            <i class="fas fa-star text-warning"></i>
          </label>
        </div>

        <!-- Lọc Sản phẩm mới nhất -->
        <div class="filter-group filter-latest-products card p-3">
          <h6 class="mb-3">Sản phẩm mới nhất</h6>
          <div class="filter-content">


            <!-- Ngày -->
            <div class="date-range">
              <div class="row g-2">
                <div class="col-6">
                  <label for="startDate" class="form-label">Từ ngày</label>
                  <input type="date" class="form-control form-control-sm"
                         id="startDate"
                         name="startDate"
                         value="${param.startDate}">
                </div>
                <div class="col-6">
                  <label for="endDate" class="form-label">Đến ngày</label>
                  <input type="date" class="form-control form-control-sm"
                         id="endDate"
                         name="endDate"
                         value="${param.endDate}">
                </div>
              </div>
            </div>
          </div>
        </div>

        <button class="btn w-100" id="">Áp dụng</button>
      </form>
    </div>

    <!-- Danh sách tác phẩm -->
    <div class="row g-4 g-2 col-10" id="artworkGallery">


      <c:forEach var="p" items="${data}">
        <div class="col-6 col-md-3">
          <div class="card artwork-card h-100" style="height: 380px !important;">
            <a href="painting-detail?pid=${p.id}" class="card-link"></a>
            <img src="${pageContext.request.contextPath}/${p.imageUrl}" class="card-img-top artwork-image" alt="${p.title}" style="width: 100%; height:180px !important;">
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
</div>

<!-- Phân trang -->
<nav aria-label="Page navigation" class="mt-4">
  <c:set var="queryParams" value="" />

  <c:if test="${not empty param.minPrice}">
    <c:set var="queryParams" value="${queryParams}minPrice=${param.minPrice}&" />
  </c:if>
  <c:if test="${not empty param.maxPrice}">
    <c:set var="queryParams" value="${queryParams}maxPrice=${param.maxPrice}&" />
  </c:if>

  <c:forEach var="size" items="${paramValues.size}">
    <c:set var="queryParams" value="${queryParams}size=${size}&" />
  </c:forEach>

  <c:forEach var="theme" items="${paramValues.theme}">
    <c:set var="queryParams" value="${queryParams}theme=${theme}&" />
  </c:forEach>

  <c:forEach var="artist" items="${paramValues.artist}">
    <c:set var="queryParams" value="${queryParams}artist=${artist}&" />
  </c:forEach>
  <c:forEach var="sort" items="${paramValues.sort}">
    <c:set var="queryParams" value="${queryParams}sort=${sort}&" />
  </c:forEach>

  <ul class="pagination justify-content-center">
    <c:if test="${currentPage > 1}">
      <li class="page-item">
        <a class="page-link" href="discount_content?id=${discount.id}&page=${currentPage + 1}">&raquo;</a>
      </li>
    </c:if>

    <c:forEach var="i" begin="1" end="${totalPages}">
      <li class="page-item ${i == currentPage ? 'active' : ''}">
        <a class="page-link" href="artwork?${queryParams}page=${i}">${i}</a>
      </li>
    </c:forEach>

    <c:if test="${currentPage < totalPages}">
      <li class="page-item">
        <a class="page-link" href="artwork?${queryParams}page=${currentPage + 1}">&raquo;</a>
      </li>
    </c:if>
  </ul>
</nav>
<p class="text-center text-muted">(Ưu đãi áp dụng từ ${discount.startDate} đến hết ngày ${discount.endDate})</p>


<%@ include file="/partials/footer.jsp" %>
<%@ include file="/partials/authModal.jsp" %>
</body>

<script src="https://kit.fontawesome.com/a076d05399.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.getElementById('resetFilters').addEventListener('click', function() {
    document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
      checkbox.checked = false;
    });

    document.getElementById('minPrice').value = '';
    document.getElementById('maxPrice').value = '';

    document.getElementById('filterForm').submit();


  });

  document.addEventListener("DOMContentLoaded", function () {
    const endDateInput = document.getElementById("endDate");
    if (!endDateInput.value) {
      const today = new Date().toISOString().split('T')[0];
      endDateInput.value = today;
    }
  });
</script>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>
</html>