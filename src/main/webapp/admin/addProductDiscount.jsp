<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sản phẩm trong chương trình giảm giá: <span>${discountName}</span></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
</head>
<body>
<div class="container mt-4">
    <h2 class="mb-4">Chọn sản phẩm để thêm vào chương trình giảm giá: <span>${discountName}</span></h2>

    <!-- Hiển thị thông báo lỗi nếu có -->
    <c:if test="${not empty param.errorMessage}">
        <div class="alert alert-danger">
                ${param.errorMessage}
        </div>
    </c:if>

    <!-- Biểu mẫu để gửi thông tin -->
    <form action="${pageContext.request.contextPath}/admin/assignDiscount" method="post">
        <input type="hidden" name="discountId" value="${discountId}">

        <!-- Kiểm tra danh sách sản phẩm -->
        <c:choose>
            <c:when test="${not empty paintingList}">
                <table id="productsTable" class="table table-bordered table-striped">
                    <thead>
                    <tr>
                        <th>Chọn</th>
                        <th>ID</th>
                        <th>Tên</th>
                        <th>Họa sĩ</th>
                        <th>Giá</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="painting" items="${paintingList}">
                        <tr>
                            <td>
                                <input type="checkbox" name="productIds" value="${painting.id}">
                            </td>
                            <td>${painting.id}</td>
                            <td>${painting.title}</td>
                            <td>${painting.artistName}</td>
                            <td>${painting.price}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <button type="submit" class="btn btn-primary">Thêm sản phẩm</button>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning" role="alert">
                    Hiện không có sản phẩm nào để thêm vào chương trình giảm giá.
                </div>
            </c:otherwise>
        </c:choose>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(document).ready(function() {
        $('#productsTable').DataTable({
            "paging": true,
            "searching": true,
            "ordering": true
        });
    });
</script>
</body>
</html>



