<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix = "f" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel</title>
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
    </style>
</head>
<body>
<!-- Sidebar -->
<%@ include file="/admin/sidebar.jsp" %>

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
                        <p class="card-text fs-4 text-success"> <f:formatNumber value="${totalRevenue}" type="currency" currencySymbol="VNĐ"/></p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Tổng Đơn Hàng</h5>
                        <span class="stat-icon">🛍️</span>

                        <p class="card-text fs-4">${totalOrders}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Tổng Người Dùng</h5>
                        <span class="stat-icon">👥</span>

                        <p class="card-text fs-4">${totalUsers}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Tổng Sản Phẩm</h5>
                        <span class="stat-icon">📦</span>
                        <p class="card-text fs-4">${totalProducts}</p>
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
    const revenueByArtistData = {
        labels: [
            <c:forEach var="entry" items="${revenueByArtist}">
            "${entry.key}",
            </c:forEach>
        ],
        datasets: [{
            label: 'Doanh Thu (VNĐ)',
            data: [
                <c:forEach var="entry" items="${revenueByArtist}">
                ${entry.value / 10},
                </c:forEach>
            ],
            backgroundColor: '#007bff',
            borderColor: '#0056b3',
            borderWidth: 1
        }]
    };

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
                        text: 'Doanh Thu (VNĐ)'
                    }
                }
            }
        }
    };

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
         //   backgroundColor: ['#007bff', '#28a745', '#ffc107', '#dc3545', '#17a2b8']
            backgroundColor: ['#ffc107', '#dc3545', '#17a2b8', '#28a745', '#007bff']

        }]
    };

    const orderStatusConfig = {
        type: 'doughnut',
        data: orderStatusData,
        maintainAspectRatio: false,
        options: {
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    };



    const ratingData = {
        labels: [
            <c:forEach var="rating" items="${listRating}">
            "${rating.rating}",
            </c:forEach>
        ],
        datasets: [{
            label: 'Average Rating',
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

    const ratingConfig = {
        type: 'line', // Hoặc 'line', 'doughnut',
        data: ratingData,
        maintainAspectRatio: false,
        options: {
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
    const bestSaleData = {
        labels: [
            <c:forEach var="painting" items="${best}">
            "${painting.title}",
            </c:forEach>
        ],
        datasets: [{
            label: 'Total Sold',
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

    const bestSaleConfig = {
        type: 'bar',
        data: bestSaleData,
        options: {
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
                        text: 'Products'
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Total Sold'
                    }
                }
            }
        }
    };

    const ctxx = document.getElementById('orderStatusChart').getContext('2d');
    new Chart(ctxx, orderStatusConfig);

    const ctx = document.getElementById('bestSaleChart').getContext('2d');
    new Chart(ctx, bestSaleConfig);

    new Chart(document.getElementById('ratingChart'), ratingConfig);

    new Chart(document.getElementById('revenueByArtistChart'), revenueByArtistConfig);
    new Chart(document.getElementById('orderStatusChart'), orderStatusConfig);
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/location.js"></script>

</body>
</html>
