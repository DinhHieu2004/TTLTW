<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hủy xóa tài khoản</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>
    body {
      background-image: url("${pageContext.request.contextPath}/assets/images/pngtree-an-art-gallery-with-many-framed-paintings-in-the-background-and-picture-image_3157704.jpg");
      background-size: cover;
      background-position: center;
      height: 100vh;
      margin: 0;
    }

    .message-box {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 50%;
      height: 60%;
      padding: 30px;
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      text-align: center;
    }

    .message-box h2 {
      margin-bottom: 20px;
    }

    .message-box p {
      margin-bottom: 20px;
    }
  </style>
</head>
<body>

<div class="container">
  <div class="message-box" id="messageBox">
    <c:choose>
      <c:when test="${status == 'SUCCESS'}">
        <h2>Hủy xóa tài khoản thành công!</h2>
      </c:when>
      <c:when test="${status == 'INVALID_STATUS'}">
        <h2>Tài khoản đã được phục hồi trước đó.</h2>
      </c:when>
      <c:when test="${status == 'TOKEN_EXPIRED'}">
        <h2>Liên kết đã hết hạn.</h2>
      </c:when>
      <c:when test="${status == 'TOKEN_NOT_FOUND'|| status == 'INVALID_TOKEN'}">
        <h2>Liên kết không hợp lệ hoặc không tồn tại.</h2>
      </c:when>
      <c:when test="${status == 'UNDO_FAILED'|| status == 'ERROR'}">
        <h2>Đã xảy ra lỗi khi Hủy xóa tài khoản. Vui lòng thử lại sau.</h2>
      </c:when>
    </c:choose>
    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
  </div>
</div>
<script>
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
