function updateMiniCart() {
    fetch('cart')
        .then(response => response.json())
        .then(data => {
            document.querySelector('#mini-cart').innerHTML = `
                <p>Số lượng: ${data.totalQuantity} sản phẩm</p>
                <p>Tổng giá: ${data.totalPrice.toLocaleString()} VND</p>
                <a href="cart">Xem giỏ hàng</a>
            `;
        });
}

