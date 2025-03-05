function renderDashboard() {
    return `
        <div class="stats-grid">
            <div class="card stat-card">
                <span class="stat-icon">$</span>
                <div>
                    <p>Tổng doanh thu</p>
                    <h3>230.000.000đ</h3>
                </div>
            </div>
            <div class="card stat-card">
                <span class="stat-icon">🛍️</span>
                <div>
                    <p>Đơn hàng</p>
                    <h3>120</h3>
                </div>
            </div>
            <div class="card stat-card">
                <span class="stat-icon">📦</span>
                <div>
                    <p>Sản phẩm</p>
                    <h3>80</h3>
                </div>
            </div>
            <div class="card stat-card">
                <span class="stat-icon">👥</span>
                <div>
                    <p>Người dùng</p>
                    <h3>450</h3>
                </div>
            </div>
        </div>

        <div class="charts-grid">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Doanh thu theo tháng</h3>
                </div>
                <div class="card-content">
                    <!-- Chart would go here -->
                    <p>Chart placeholder</p>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Doanh thu theo nghệ sĩ</h3>
                </div>
                <div class="card-content">
                    <!-- Chart would go here -->
                    <p>Chart placeholder</p>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Hoạt động gần đây</h3>
            </div>
            <div class="card-content">
                <div class="alert">Đơn hàng mới #123 từ Nguyễn Văn A</div>
                <div class="alert">Tranh "Hoàng hôn" đã được bán</div>
            </div>
        </div>
    `;
}

