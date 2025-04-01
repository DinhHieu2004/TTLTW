<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="sidebar">
  <h3>Admin Panel</h3>

  <%-- Tổng quan: Hiển thị nếu có quyền MANAGE_PRODUCT hoặc role ADMIN --%>
  <c:set var="hasManageProduct" value="false" />
  <c:set var="isAdmin" value="false" />
  <c:forEach var="role" items="${sessionScope.user.roles}">
    <c:if test="${role.name == 'ADMIN'}">
      <c:set var="isAdmin" value="true" />
    </c:if>
    <c:forEach var="permission" items="${role.permissions}">
      <c:if test="${permission.name == 'MANAGE_PRODUCT'}">
        <c:set var="hasManageProduct" value="true" />
      </c:if>
    </c:forEach>
  </c:forEach>
  <c:if test="${not empty sessionScope.user and (isAdmin or hasManageProduct)}">
    <a href="${pageContext.request.contextPath}/admin">Tổng quan</a>
  </c:if>

  <%-- Quản lý sản phẩm: Hiển thị nếu có quyền MANAGE_PRODUCT hoặc role ADMIN --%>
  <c:if test="${not empty sessionScope.user and (isAdmin or hasManageProduct)}">
    <a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a>
  </c:if>

  <%-- Quản lý đơn hàng: Hiển thị nếu có quyền MANAGE_ORDER hoặc role ADMIN --%>
  <c:set var="hasManageOrder" value="false" />
  <c:forEach var="role" items="${sessionScope.user.roles}">
    <c:forEach var="permission" items="${role.permissions}">
      <c:if test="${permission.name == 'MANAGE_ORDER'}">
        <c:set var="hasManageOrder" value="true" />
      </c:if>
    </c:forEach>
  </c:forEach>
  <c:if test="${not empty sessionScope.user and (isAdmin or hasManageOrder)}">
    <a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a>
  </c:if>

  <%-- Quản lý người dùng: Hiển thị nếu có quyền MANAGE_USER hoặc role ADMIN --%>
  <c:set var="hasManageUser" value="false" />
  <c:forEach var="role" items="${sessionScope.user.roles}">
    <c:forEach var="permission" items="${role.permissions}">
      <c:if test="${permission.name == 'MANAGE_USER'}">
        <c:set var="hasManageUser" value="true" />
      </c:if>
    </c:forEach>
  </c:forEach>
  <c:if test="${not empty sessionScope.user and (isAdmin or hasManageUser)}">
    <a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a>
  </c:if>

  <%-- Quản lý họa sĩ: Hiển thị nếu có role ADMIN --%>
  <c:if test="${not empty sessionScope.user and isAdmin}">
    <a href="${pageContext.request.contextPath}/admin/artists">Quản lý họa sĩ</a>
  </c:if>

  <%-- Quản lý đánh giá: Hiển thị nếu có quyền MANAGE_PREVIEW hoặc role ADMIN --%>
  <c:set var="hasManagePreview" value="false" />
  <c:forEach var="role" items="${sessionScope.user.roles}">
    <c:forEach var="permission" items="${role.permissions}">
      <c:if test="${permission.name == 'MANAGE_PREVIEW'}">
        <c:set var="hasManagePreview" value="true" />
      </c:if>
    </c:forEach>
  </c:forEach>
  <c:if test="${not empty sessionScope.user and (isAdmin or hasManagePreview)}">
    <a href="${pageContext.request.contextPath}/admin/reviews">Quản lý đánh giá</a>
  </c:if>

  <%-- Quản lý giảm giá: Hiển thị nếu có role ADMIN --%>
  <c:if test="${not empty sessionScope.user and isAdmin}">
    <a href="${pageContext.request.contextPath}/admin/discount">Quản lý giảm giá</a>
  </c:if>

  <%-- Quản lý voucher: Hiển thị nếu có role ADMIN --%>
  <c:if test="${not empty sessionScope.user and isAdmin}">
    <a href="${pageContext.request.contextPath}/admin/vouchers">Quản lý voucher</a>
  </c:if>

</div>
<script src="${pageContext.request.contextPath}/assets/js/location.js"></script>