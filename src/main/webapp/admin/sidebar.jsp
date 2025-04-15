<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="sidebar">
  <h3>Admin Panel</h3>

  <c:set var="allRolePermission" value="${sessionScope.user.allRolePermission}" />
  <c:set var="isAdmin" value="${fn:contains(allRolePermission, 'ROLE_ADMIN')}" />

  <c:if test="${not empty sessionScope.user and (isAdmin or fn:contains(allRolePermission, 'VIEW_PRODUCTS'))}">
    <a href="${pageContext.request.contextPath}/admin">Tổng quan</a>
  </c:if>

  <c:if test="${not empty sessionScope.user and (isAdmin or fn:contains(allRolePermission, 'VIEW_PRODUCTS'))}">
    <a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a>
  </c:if>

  <c:if test="${not empty sessionScope.user and (isAdmin or fn:contains(allRolePermission, 'VIEW_STOCKS'))}">
    <a href="${pageContext.request.contextPath}/admin/inventoryTrans">Quản lý nhập/xuất kho hàng</a>
  </c:if>

  <c:if test="${not empty sessionScope.user and (isAdmin or fn:contains(allRolePermission, 'VIEW_ORDERS'))}">
    <a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a>
  </c:if>

  <c:if test="${not empty sessionScope.user and (isAdmin or fn:contains(allRolePermission, 'VIEW_USERS'))}">
    <a href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng</a>
  </c:if>

  <c:if test="${not empty sessionScope.user and (isAdmin or fn:contains(allRolePermission, 'VIEW_ARTISTS'))}">
    <a href="${pageContext.request.contextPath}/admin/artists">Quản lý họa sĩ</a>
  </c:if>

  <c:if test="${not empty sessionScope.user and (isAdmin or fn:contains(allRolePermission, 'VIEW_REVIEWS'))}">
    <a href="${pageContext.request.contextPath}/admin/reviews">Quản lý đánh giá</a>
  </c:if>

  <c:if test="${not empty sessionScope.user and (isAdmin or fn:contains(allRolePermission, 'VIEW_DISCOUNTS'))}">
    <a href="${pageContext.request.contextPath}/admin/discount">Quản lý giảm giá</a>
  </c:if>

  <c:if test="${not empty sessionScope.user and (isAdmin or fn:contains(allRolePermission, 'VIEW_VOUCHERS'))}">
    <a href="${pageContext.request.contextPath}/admin/vouchers">Quản lý voucher</a>
  </c:if>

  <c:if test="${not empty sessionScope.user and (isAdmin or fn:contains(allRolePermission, 'VIEW_LOGS'))}">
    <a href="${pageContext.request.contextPath}/admin/logs">Quản lý log</a>
  </c:if>

</div>
<script src="${pageContext.request.contextPath}/assets/js/location.js"></script>