<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix = "f" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
            margin-bottom: 30px;
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

        #loadingSpinner {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
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
<div id="loadingSpinner" class="d-none">
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
                        <f:formatNumber var="formattedRevenue" value="${totalRevenue}" pattern="#,##0" />
                        <p id="totalRevenue" class="card-text fs-4 text-success">
                            ${fn:replace(formattedRevenue, ',', '.')} ₫
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Tổng Đơn Hàng</h5>
                        <span class="stat-icon">🛍️</span>
                        <p id="totalOrders" class="card-text fs-4">${totalOrders}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Tổng Người Dùng</h5>
                        <span class="stat-icon">👥</span>
                        <p id="totalUsers" class="card-text fs-4">${totalUsers}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Tổng Sản Phẩm</h5>
                        <span class="stat-icon">📦</span>
                        <p id="totalProducts" class="card-text fs-4">${totalProducts}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="row">
            <!-- Revenue by Artist Chart -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Doanh Thu Theo Nghệ Sĩ</h5>
                        <div class="chart-container">
                            <canvas id="revenueByArtistChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Status Chart -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Trạng Thái Đơn Hàng</h5>
                        <div class="chart-container">
                            <canvas id="orderStatusChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Rating Chart -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Thống Kê Đánh Giá</h5>
                        <div class="chart-container">
                            <canvas id="ratingChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Best Sellers Chart -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Sản Phẩm Bán Chạy</h5>
                        <div class="chart-container">
                            <canvas id="bestSaleChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let revenueByArtistChart;
    let orderStatusChart;
    let ratingChart;
    let bestSaleChart;

    function formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND',
            maximumFractionDigits: 0
        }).format(amount);
    }

    // Hàm để phá hủy biểu đồ hiện có nếu đã tồn tại
    function destroyChartIfExists(chart) {
        if (chart) {
            chart.destroy();
        }
    }

    function initCharts() {
        destroyChartIfExists(revenueByArtistChart);
        destroyChartIfExists(orderStatusChart);
        destroyChartIfExists(ratingChart);
        destroyChartIfExists(bestSaleChart);


        const revenueCanvas = document.getElementById('revenueByArtistChart');
        if (revenueCanvas) {
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

            revenueByArtistChart = new Chart(revenueCanvas.getContext('2d'), revenueByArtistConfig);
        } else {
            console.error('Không tìm thấy canvas revenueByArtistChart');
        }

        const orderStatusCanvas = document.getElementById('orderStatusChart');
        if (orderStatusCanvas) {
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

            orderStatusChart = new Chart(orderStatusCanvas.getContext('2d'), orderStatusConfig);
        } else {
            console.error('Không tìm thấy canvas orderStatusChart');
        }

        const ratingCanvas = document.getElementById('ratingChart');
        if (ratingCanvas) {
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

            ratingChart = new Chart(ratingCanvas.getContext('2d'), ratingConfig);
        } else {
            console.error('Không tìm thấy canvas ratingChart');
        }

        const bestSaleCanvas = document.getElementById('bestSaleChart');
        if (bestSaleCanvas) {
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

            bestSaleChart = new Chart(bestSaleCanvas.getContext('2d'), bestSaleConfig);
        } else {
            console.error('Không tìm thấy canvas bestSaleChart');
        }
    }

    function updateRevenueByArtistChart(data) {
        destroyChartIfExists(revenueByArtistChart);

        const canvas = document.getElementById('revenueByArtistChart');
        if (!canvas) {
            console.error('Không tìm thấy canvas revenueByArtistChart');
            return;
        }

        const ctx = canvas.getContext('2d');
        const labels = Object.keys(data);
        const values = Object.values(data).map(val => val / 1000000); // Chuyển sang triệu VNĐ

        revenueByArtistChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh Thu (Triệu VNĐ)',
                    data: values,
                    backgroundColor: '#007bff',
                    borderColor: '#0056b3',
                    borderWidth: 1
                }]
            },
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
        });
    }

    function updateOrderStatusChart(data) {
        destroyChartIfExists(orderStatusChart);

        const canvas = document.getElementById('orderStatusChart');
        if (!canvas) {
            console.error('Không tìm thấy canvas orderStatusChart');
            return;
        }

        const ctx = canvas.getContext('2d');
        const labels = Object.keys(data);
        const values = Object.values(data);

        orderStatusChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: values,
                    backgroundColor: ['#ffc107', '#dc3545', '#17a2b8', '#28a745', '#007bff']
                }]
            },
            options: {
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }

    function updateRatingChart(data) {
        destroyChartIfExists(ratingChart);

        const canvas = document.getElementById('ratingChart');
        if (!canvas) {
            console.error('Không tìm thấy canvas ratingChart');
            return;
        }

        const ctx = canvas.getContext('2d');
        const labels = data.map(item => item.rating);
        const values = data.map(item => item.count);

        ratingChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Số lượt đánh giá',
                    data: values,
                    backgroundColor: ['#007bff', '#28a745', '#ffc107', '#dc3545'],
                    borderColor: '#0056b3',
                    borderWidth: 1
                }]
            },
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
        });
    }

    function updateBestSaleChart(data) {
        destroyChartIfExists(bestSaleChart);

        const canvas = document.getElementById('bestSaleChart');
        if (!canvas) {
            console.error('Không tìm thấy canvas bestSaleChart');
            return;
        }

        const ctx = canvas.getContext('2d');
        const labels = data.map(item => item.title);
        const values = data.map(item => item.totalSold);

        bestSaleChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Số lượng bán ra',
                    data: values,
                    backgroundColor: [
                        '#007bff', '#28a745', '#ffc107', '#dc3545', '#17a2b8'
                    ],
                    borderColor: '#0056b3',
                    borderWidth: 1
                }]
            },
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
        });
    }

    function updateStats(data) {
        document.getElementById('totalRevenue').textContent = formatCurrency(data.totalRevenue);
        document.getElementById('totalOrders').textContent = data.totalOrders;
        document.getElementById('totalUsers').textContent = data.totalUsers;
        document.getElementById('totalProducts').textContent = data.totalProducts;

        if (data.revenueByArtist) {
            updateRevenueByArtistChart(data.revenueByArtist);
        }

        if (data.orderStatusCount) {
            updateOrderStatusChart(data.orderStatusCount);
        }

        if (data.listRating) {
            updateRatingChart(data.listRating);
        }

        if (data.best) {
            updateBestSaleChart(data.best);
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        console.log('Kiểm tra các phần tử canvas trước khi khởi tạo biểu đồ:');
        checkCanvasElements();

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
            const spinner = document.getElementById('loadingSpinner');
            if (spinner) {
                spinner.style.display = 'flex';
            }

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

                    // Ẩn spinner
                    if (spinner) {
                        spinner.style.display = 'none';
                    }


                },
                error: function(xhr, status, error) {
                    // Ẩn spinner
                    if (spinner) {
                        spinner.style.display = 'none';
                    }

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

    function checkCanvasElements() {
        const canvasIds = ['revenueByArtistChart', 'orderStatusChart', 'ratingChart', 'bestSaleChart'];

        canvasIds.forEach(id => {
            const canvas = document.getElementById(id);
            if (canvas) {
                console.log(`Canvas ${id} tồn tại`);
            } else {
                console.error(`Canvas ${id} KHÔNG tồn tại`);
            }
        });
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/checkSession.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/location.js"></script>

</body>
</html>