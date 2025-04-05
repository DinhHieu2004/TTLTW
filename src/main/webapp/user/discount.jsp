<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Title</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/discount.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
</head>

<body>
<%@ include file="/partials/header.jsp" %>

    <h4 class="title">CHƯƠNG TRÌNH GIẢM GIÁ ĐẶC BIỆT</h4>
    <p class="sub_title"> Ưu đãi hấp dẫn cho các sản phẩm yêu thích của bạn</p>
    <div id="discount_list">
        <c:forEach var="discount" items="${list}">
            <a href="${pageContext.request.contextPath}/discount_content?id=${discount.id}" class="discount_item">
            <img src="${discount.imageUrl}" alt="${discount.discountName}">
            <p class="content" style="color: #e7621b"><strong>${discount.discountName}</strong></p>
            <p class="content">(Áp dụng từ ngày ${discount.startDate} đến ${discount.endDate})</p>
        </a>
        </c:forEach>
    </div>

<%@ include file="/partials/footer.jsp" %>
<%@ include file="/partials/authModal.jsp" %>

</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/discount.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>


</html>