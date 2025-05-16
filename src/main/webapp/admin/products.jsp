<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix = "f" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Panel</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f8f9fa; /* Nền sáng */
    }

    .sidebar {
      height: 100vh;
      position: fixed;
      top: 0;
      left: 0;
      width: 250px;
      background-color: #343a40; /* Sidebar màu xám đậm */
      color: white;
      padding: 20px 10px;
    }

    .sidebar a {
      color: white;
      text-decoration: none;
      display: block;
      padding: 10px;
      margin-bottom: 5px;
      border-radius: 5px;
    }

    .sidebar a:hover {
      background-color: #495057;
    }

    .content {
      margin-left: 260px;
      padding: 20px;
    }
    .container{
      margin: 0;
      padding: 0;
    }
    .card {
      border: none;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    .gap-4 {
      gap: 1.5rem;
    }
    .chart-container {
      height: 300px;
    }
    .chart-container {
      width: 100%;
      max-width: 500px;
      height: 300px;
      margin: auto;
    }
    .form-control.input-sm {
      padding: 0.25rem;
      font-size: 0.875rem;
    }

    .btn.btn-sm {
      font-size: 0.875rem;
      padding: 0.4rem 0.75rem;
    }

    .align-items-end {
      align-items: flex-end !important; /* Canh dưới cùng */
    }

    /* Spinner for loading indicator */
    .spinner-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 9999;
      display: none;
    }

    .spinner-border {
      width: 3rem;
      height: 3rem;
    }
  </style>
</head>
<body>
<!-- Sidebar -->
<%@ include file="/admin/sidebar.jsp" %>

<!-- Loading Spinner -->
<div class="spinner-overlay" id="loadingSpinner">
  <div class="spinner-border text-light" role="status">
    <span class="visually-hidden">Loading...</span>
  </div>
</div>

<!-- Main Content -->
<div class="content">

  <div class="row mb-4 align-items-end" style="display: flex !important;">
    <div class="col-md-4">
      <label for="startDate" class="form-label"><strong>Từ ngày:</strong></label>
      <input type="date" id="startDate" class="form-control input-sm">
    </div>
    <div class="col-md-4">
      <label for="endDate" class="form-label"><strong>Đến ngày:</strong></label>
      <input type="date" id="endDate" class="form-control input-sm">
    </div>
    <div class="col-md-4 text-end">
      <button id="filterBtn" class="btn btn-primary btn-sm">Lọc thống kê</button>
    </div>
  </div>

  <div class="container">
    <h2 class="mb-4">Tổng quan</h2>

    <div class="row mb-4">
      <div class="col-md-3">
        <div class="card text-center">
          <div class="card-body">
            <h5 class="card-title">Tổng Doanh Thu</h5>
            <span class="stat-icon">💰</span>
            <p class="card-text fs-4 text-success" id="totalRevenue"><f:formatNumber value="${totalRevenue}" type="currency" currencySymbol="VNĐ"/></p>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card text-center">
          <div class="card-body">
            <h5 class="card-title">Tổng Đơn Hàng</h5>
            <span class="stat-icon">🛍️</span>
            <p class="card-text fs-4" id="totalOrders">${totalOrders}</p>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card text-center">
          <div class="card-body">
            <h5 class="card-title">Tổng Người Dùng</h5>
            <span class="stat-icon">👥</span>
            <p class="card-text fs-4" id="totalUsers">${totalUsers}</p>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card text-center">
          <div class="card-body">
            <h5 class="card-title">Tổng Sản Phẩm</h5>
            <span class="stat-icon">📦</span>
            <p class="card-text fs-4" id="totalProducts">${totalProducts}</p>
          </div>
        </div>
      </div>
    </div>

    <div class="row mb-4">
      <div class="col-md-6">
        <h4 class="mb-3">Doanh Thu Theo Nghệ Sĩ</h4>
        <div class="chart-container">
          <canvas id="revenueByArtistChart"></canvas>
        </div>
      </div>

      <div class="col-md-6">
        <h4 class="mb-3">Trạng Thái Đơn Hàng</h4>
        <div class="chart-container">
          <canvas id="orderStatusChart" width="200" height="200"></canvas>
        </div>
      </div>

      <div class="col-md-6">
        <h4 class="mb-3">Trung bình mỗi rating</h4>
        <div class="chart-container">
          <canvas id="ratingChart" width="400" height="300"></canvas>
        </div>
      </div>
      <div class="col-md-6">
        <h4 class="mb-3">Sản phẩm bán chạy </h4>
        <div class="chart-container">
          <canvas id="bestSaleChart"></canvas>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  // Định nghĩa các biến toàn cục cho biểu đồ
  let revenueByArtistChart;
  let orderStatusChart;
  let ratingChart;
  let bestSaleChart;

  // Hàm định dạng số thành tiền tệ VND
  function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND',
      maximumFractionDigits: 0
    }).format(amount);
  }

  // Khởi tạo các biểu đồ ban đầu
  function initCharts() {
    // Dữ liệu biểu đồ doanh thu theo nghệ sĩ
    const revenueByArtistData = {
      labels: [
        <c:forEach var="entry" items="${revenueByArtist}">
        "${entry.key}",
        </c:forEach>
      ],
      datasets: [{
        label: 'Doanh Thu (Triệu VNĐ)',
        data: [
          <c:forEach var="entry" items="${revenueByArtist}">
          ${entry.value / 1000000},
          </c:forEach>
        ],
        backgroundColor: '#007bff',
        borderColor: '#0056b3',
        borderWidth: 1
      }]
    };

    // Cấu hình biểu đồ doanh thu theo nghệ sĩ
    const revenueByArtistConfig = {
      type: 'bar',
      data: revenueByArtistData,
      options: {
        maintainAspectRatio: false,
        responsive: true,
        plugins: {
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Nghệ Sĩ'
            }
          },
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Doanh Thu (Triệu VNĐ)'
            }
          }
        }
      }
    };

    // Dữ liệu biểu đồ trạng thái đơn hàng
    const orderStatusData = {
      labels: [
        <c:forEach var="status" items="${orderStatusCount}">
        "${status.key}",
        </c:forEach>
      ],
      datasets: [{
        data: [
          <c:forEach var="status" items="${orderStatusCount}">
          ${status.value},
          </c:forEach>
        ],
        backgroundColor: ['#ffc107', '#dc3545', '#17a2b8', '#28a745', '#007bff']
      }]
    };

    // Cấu hình biểu đồ trạng thái đơn hàng
    const orderStatusConfig = {
      type: 'doughnut',
      data: orderStatusData,
      options: {
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom'
          }
        }
      }
    };

    // Dữ liệu biểu đồ đánh giá
    const ratingData = {
      labels: [
        <c:forEach var="rating" items="${listRating}">
        "${rating.rating}",
        </c:forEach>
      ],
      datasets: [{
        label: 'Số lượt đánh giá',
        data: [
          <c:forEach var="rating" items="${listRating}">
          ${rating.count},
          </c:forEach>
        ],
        backgroundColor: ['#007bff', '#28a745', '#ffc107', '#dc3545'],
        borderColor: '#0056b3',
        borderWidth: 1
      }]
    };

    // Cấu hình biểu đồ đánh giá
    const ratingConfig = {
      type: 'line',
      data: ratingData,
      options: {
        maintainAspectRatio: false,
        responsive: true,
        plugins: {
          legend: {
            display: true
          }
        },
        scales: {
          x: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Rating'
            }
          },
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Số lượt đánh giá'
            }
          }
        }
      }
    };

    // Dữ liệu biểu đồ sản phẩm bán chạy
    const bestSaleData = {
      labels: [
        <c:forEach var="painting" items="${best}">
        "${painting.title}",
        </c:forEach>
      ],
      datasets: [{
        label: 'Số lượng bán ra',
        data: [
          <c:forEach var="painting" items="${best}">
          ${painting.totalSold},
          </c:forEach>
        ],
        backgroundColor: [
          '#007bff', '#28a745', '#ffc107', '#dc3545', '#17a2b8'
        ],
        borderColor: '#0056b3',
        borderWidth: 1
      }]
    };

    // Cấu hình biểu đồ sản phẩm bán chạy
    const bestSaleConfig = {
      type: 'bar',
      data: bestSaleData,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true
          }
        },
        scales: {
          x: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Sản phẩm'
            }
          },
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: 'Số lượng bán ra'
            }
          }
        }
      }
    };

    // Khởi tạo các biểu đồ
    revenueByArtistChart = new Chart(
            document.getElementById('revenueByArtistChart').getContext('2d'),
            revenueByArtistConfig
    );

    orderStatusChart = new Chart(
            document.getElementById('orderStatusChart').getContext('2d'),
            orderStatusConfig
    );

    ratingChart = new Chart(
            document.getElementById('ratingChart').getContext('2d'),
            ratingConfig
    );

    bestSaleChart = new Chart(
            document.getElementById('bestSaleChart').getContext('2d'),
            bestSaleConfig
    );
  }

  // Hàm cập nhật biểu đồ doanh thu theo nghệ sĩ
  function updateRevenueByArtistChart(data) {
    const labels = Object.keys(data);
    const values = Object.values(data).map(val => val / 1000000); // Chuyển sang triệu VNĐ

    revenueByArtistChart.data.labels = labels;
    revenueByArtistChart.data.datasets[0].data = values;
    revenueByArtistChart.update();
  }

  // Hàm cập nhật biểu đồ trạng thái đơn hàng
  function updateOrderStatusChart(data) {
    const labels = Object.keys(data);
    const values = Object.values(data);

    orderStatusChart.data.labels = labels;
    orderStatusChart.data.datasets[0].data = values;
    orderStatusChart.update();
  }

  function updateRatingChart(data) {
    const labels = data.map(item => item.rating);
    const values = data.map(item => item.count);

    ratingChart.data.labels = labels;
    ratingChart.data.datasets[0].data = values;
    ratingChart.update();
  }

  function updateBestSaleChart(data) {
    const labels = data.map(item => item.title);
    const values = data.map(item => item.totalSold);

    bestSaleChart.data.labels = labels;
    bestSaleChart.data.datasets[0].data = values;
    bestSaleChart.update();
  }

  function updateStats(data) {
    document.getElementById('totalRevenue').textContent = formatCurrency(data.totalRevenue);
    document.getElementById('totalOrders').textContent = data.totalOrders;
    document.getElementById('totalUsers').textContent = data.totalUsers;
    document.getElementById('totalProducts').textContent = data.totalProducts;

    // Cập nhật các biểu đồ
    updateRevenueByArtistChart(data.revenueByArtist);
    updateOrderStatusChart(data.orderStatusCount);
    updateRatingChart(data.listRating);
    updateBestSaleChart(data.best);
  }

  document.addEventListener('DOMContentLoaded', function() {
    initCharts();

    document.getElementById('filterBtn').addEventListener('click', function() {
      const startDate = document.getElementById('startDate').value;
      const endDate = document.getElementById('endDate').value;

      if (!startDate || !endDate) {
        Swal.fire({
          icon: 'error',
          title: 'Lỗi',
          text: 'Vui lòng chọn đầy đủ ngày bắt đầu và kết thúc!',
        });
        return;
      }

      if (new Date(startDate) > new Date(endDate)) {
        Swal.fire({
          icon: 'error',
          title: 'Lỗi',
          text: 'Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc!',
        });
        return;
      }

      // Hiển thị spinner
      document.getElementById('loadingSpinner').style.display = 'flex';

      // Gửi yêu cầu Ajax để lấy dữ liệu thống kê
      $.ajax({
        url: '${pageContext.request.contextPath}/admin/stats-by-date',
        type: 'GET',
        data: {
          startDate: startDate,
          endDate: endDate
        },
        dataType: 'json',
        success: function(response) {
          updateStats(response);

          document.getElementById('loadingSpinner').style.display = 'none';

          Swal.fire({
            icon: 'success',
            title: 'Thành công',
            text: 'Dữ liệu thống kê đã được cập nhật!',
            timer: 1500,
            showConfirmButton: false
          });
        },
        error: function(xhr, status, error) {

          document.getElementById('loadingSpinner').style.display = 'none';

          Swal.fire({
            icon: 'error',
            title: 'Lỗi',
            text: 'Đã xảy ra lỗi khi lấy dữ liệu thống kê. Vui lòng thử lại sau!',
          });
          console.error('Ajax error:', error);
        }
      });
    });
  });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/checkSession.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/location.js"></script>

</body>
</html>