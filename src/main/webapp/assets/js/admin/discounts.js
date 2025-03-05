function renderDiscounts() {
    return `
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Quản lý chương trình giảm giá</h3>
                <button class="button button-primary">
                    <span>+</span> Thêm chương trình
                </button>
            </div>
             <button onclick="openAddDiscountModal()" class="btn btn-primary">
    + Thêm chương trình giảm giá
</button>
            <div class="card-content">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Tên chương trình</th>
                            <th>Phần trăm</th>
                            <th>Ngày bắt đầu</th>
                            <th>Ngày kết thúc</th>
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