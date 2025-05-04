<!DOCTYPE html>
<html lang="vi">

<head>
  <%@ page contentType="text/html; charset=UTF-8" %>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Title</title>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/about_us.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
</head>

<body>
<%@ include file="/partials/header.jsp" %>
  <div id="about_us_container">
    <div class="title">
      <h4 class="about_us_title">VỀ CHÚNG TÔI</h4>
      <div class="social-icons">
        <i class="fab fa-facebook"></i>
        <i class="fab fa-twitter"></i>
        <i class="fab fa-instagram"></i>
        <i class="fab fa-telegram"></i>
        <i class="fas fa-envelope"></i>
      </div>
    </div>

    <div class="intro">
      <div class="about_us_subtitle">NLU Gallery kính chào Quý khách!</div>
      <p class="content">Thương hiệu <strong>NLU Gallery</strong> là tâm huyết của họa sĩ, kiến trúc sư hoạt động trong
        lĩnh vực thiết kế, thi công, trang trí nội thất, đặc biệt là trong sáng tác nghệ thuật hội họa tranh sơn dầu cao
        cấp. </p>
      <img class="intro_img" src="https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514164/assets/images/tranh-cat-2-6168.jpg.webp.webp">
      <p class="source">(Nghệ nhân Ý Lan triển lãm tranh cát chủ đề "Bình an, hạnh phúc")</p>
      <p class="content">Lớn lên trong môi trường được tiếp cận với nghệ thuật từ rất sớm, theo đuổi những ngành nghề
        liên quan đến mỹ thuật ứng dụng, chúng tôi hiểu thế nào là cái đẹp và sức ảnh hưởng của nghệ thuật tới con
        người, cũng như chất lượng cuộc sống. Thức dậy trong căn phòng với một vài bức tranh treo tường dễ chịu, gợi cảm
        hứng làm cho một ngày trở nên tốt lành hơn. </p>
    </div>
    <div class="about_artist">
      <p class="about_artists_title">Về đội ngũ họa sĩ</p>
      <p class="content">NLU Gallery là nơi hội tụ của những họa sĩ tài hoa ở khắp mọi nơi trên cả nước, thuộc nhiều độ
        tuổi, trường phái hội họa khác nhau sáng tác độc bản và độc quyền theo yêu của khách hàng.</p>
      <img class="intro_img"
        src="https://res.cloudinary.com/dz32nqnp3/image/upload/v1745552379/34216279101564975300780544017440944717561856n-162692724516021952345_uzj6cw.jpg">
      <p class="source">(Hoạ sĩ Trí Đức)</p>
      <p class="content">Đội ngũ họa sĩ gạo cội với hàng chục năm kinh nghiệm đem đến những tác phẩm tranh độc bản có
        chiều sâu, giàu cảm xúc. Bên cạnh đó chúng tôi cũng có những họa sĩ trẻ, tư duy cởi mở, nhiệt huyết luôn cập
        nhật những xu hướng mới nhất. Tất cả cùng tạo nên bản sắc riêng biệt và hướng tới những giá trị nhân văn cốt
        lõi.</p>
    </div>
    <div class="staff">
      <p class="staff_title">Về đội ngũ nhân viên tư vấn – thiết kế</p>
      <p class="content">NLU Gallery luôn coi nguồn nhân lực là tài sản quý giá nhất, là chìa khóa cho sự thành công và
        phát triển trong tương lai của thương hiệu.</p>
      <img class="intro_img" src="https://res.cloudinary.com/dz32nqnp3/image/upload/v1745552380/04785d0f-3320-4c0d-9701-04a751ee923c_ly4q1s.webp">
      <p class="content">NLU Gallery cũng rất tự hào vì có được đội ngũ tư vấn thiết kế chuyên nghiệp, đều tốt nghiệp từ
        các trường đại học đào tạo mỹ thuật chính quy, là tổng hòa của kinh nghiệm dày dạn, tài năng, sức cống hiến và
        chuyên môn sâu rộng trong lĩnh vực kiến trúc – hội họa.</p>
    </div>
    <div class="mission">
      <p class="mission_title">Sứ mệnh</p>
      <p class="content">NLU Gallery ra đời với mong muốn đem nghệ thuật hội họa sơn dầu cao cấp đến với không gian ngôi
        nhà bạn, tạo nên dấu ấn và sự khác biệt tại mỗi công trình mà tác phẩm của chúng tôi hiện diện. Chúng tôi trân
        trọng và gửi gắm tâm hồn nghệ sĩ vào từng tác phẩm, tranh của NLU Gallery đều xuất thân từ những họa sĩ “có
        nghề”, am hiểu nghệ thuật, không chỉ để trang trí, mà còn nâng cao chất lượng cuộc sống của chúng ta.</p>
      <p class="content">NLU Gallery mong muốn làm đẹp cho thế giới từng chút một, từ căn phòng ta sống mỗi ngày.</p>
    </div>
    <p class="end_about_us">Trân trọng!</p>

  </div>


<%@ include file="/partials/footer.jsp" %>
<%@ include file="/partials/authModal.jsp" %>

</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/header.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/about_us.js"></script>



</html>