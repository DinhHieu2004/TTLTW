$(document).ready(function () {
    // Xử lý khi click vào icon search
    $('#search-icon').click(function (event) {
        $('#search-bar').toggle();
        $('#search-input').focus();
        event.stopPropagation(); // Ngăn chặn sự kiện lan sang document
    });

    // Xử lý khi click ra ngoài
    $(document).click(function (event) {
        // Kiểm tra xem click có nằm ngoài phạm vi của search bar không
        if (!$(event.target).closest('#search-bar, #search-icon').length) {
            $('#search-bar').hide();
        }
    });
});
document.addEventListener("DOMContentLoaded", function () {
    const cartItemsTable = document.getElementById("cart-items");
    const totalPriceElement = document.getElementById("total-price");

    function renderCart() {
        let cart = JSON.parse(localStorage.getItem("cart")) || [];
        cartItemsTable.innerHTML = ""; // Xóa dữ liệu cũ
        let totalPrice = 0; // Khởi tạo tổng tiền

        cart.forEach((item, index) => {
            totalPrice += item.discountedPrice;

            // Tạo dòng mới cho sản phẩm
            const row = document.createElement("tr");
            row.innerHTML = `
                    <td>${index + 1}</td>
                    <td><img src="${item.image}" alt="${item.title}" class="img-thumbnail" style="max-width: 100px;"></td>
                    <td>${item.title}</td>
                    <td>
                        <p class="text-muted" style="text-decoration: line-through;">${formatCurrencyVND(item.originalPrice)}</p>
                        <p class="text-danger">${formatCurrencyVND(item.discountedPrice)}</p>
                    </td>
                    <td>
                        <button class="btn btn-danger btn-sm remove-item" data-index="${index}">Xóa</button>
                    </td>
                `;
            cartItemsTable.appendChild(row); // Thêm dòng vào bảng
        });
        console.log(totalPrice)

        // Cập nhật tổng tiền
        totalPriceElement.innerText = formatCurrencyVND(totalPrice);
    }

    function formatCurrencyVND(amount) {
        if (typeof amount !== 'number') amount = parseFloat(amount);
        if (isNaN(amount)) return '0 ₫';
        return amount.toLocaleString('vi-VN') + ' ₫';
    }

    // Xử lý khi xóa sản phẩm
    cartItemsTable.addEventListener("click", function (e) {
        if (e.target.classList.contains("remove-item")) {
            const index = e.target.getAttribute("data-index");
            let cart = JSON.parse(localStorage.getItem("cart")) || [];
            cart.splice(index, 1); // Xóa sản phẩm
            localStorage.setItem("cart", JSON.stringify(cart)); // Lưu lại giỏ hàng
            renderCart(); // Render lại giao diện
        }
    });

    renderCart(); // Gọi hàm khi tải trang
});