function renderPaintings() {
    return `
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Quản lý tranh</h3>
                <button class="button button-primary">
                    <span>+</span> Thêm tranh mới
                </button>
            </div>
            <div class="card-content">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Tên tranh</th>
                            <th>Họa sĩ</th>
                            <th>Giá</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                 
                    </tbody>
                </table>
            </div>
        </div>
    `;
}
