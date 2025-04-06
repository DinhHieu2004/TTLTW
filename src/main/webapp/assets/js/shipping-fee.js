function toggleBankDetails() {
    const paymentMethod = document.getElementById("paymentMethod").value;
    const bankDetails = document.getElementById("bankDetails");
    bankDetails.style.display = paymentMethod === "2" ? "block" : "none";
}
function updateFinalPrice() {
    const currentPrice = parseFloat(document.getElementById("finalPrice").textContent.replace(/[^\d]/g, ""));
    const shippingFeeText = document.getElementById("shippingFee").textContent;

    if (shippingFeeText !== 'Chưa tính' && shippingFeeText !== 'Không tính được' && shippingFeeText !== 'Lỗi tính phí') {
        const shippingFee = parseFloat(shippingFeeText.replace(/[^\d]/g, ""));

        const finalPrice = currentPrice + shippingFee;
        document.getElementById("finalPrice").textContent = finalPrice.toLocaleString('vi-VN') + ' VND';
    }
}

async function calculateShippingFee(province, district, address) {
    try {
        if (!province || !district || !address) {
            console.error("Thiếu tham số cần thiết để tính phí vận chuyển");
            document.getElementById('shippingFee').textContent = 'Thiếu thông tin';
            return;
        }

        const encodedProvince = encodeURIComponent(province);
        const encodedDistrict = encodeURIComponent(district);
        const encodedAddress = encodeURIComponent(address);

        console.log("Địa chỉ nhận hàng:", province, district, address);

        const contextPath = window.location.origin;
        const baseUrl = contextPath + "/web_war/api/shipping-fee";
        const url = `${baseUrl}?province=${encodedProvince}&district=${encodedDistrict}&address=${encodedAddress}`;

        console.log("Full URL:", url);

        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const data = await response.json();
        console.log("API Response:", data);

        if (data.success) {
            const shippingFee = data.fee.fee + (data.fee.insurance_fee || 0);
            document.getElementById('shippingFee').textContent = shippingFee.toLocaleString('vi-VN') + ' VND';

            updateFinalPrice();
        } else {
            document.getElementById('shippingFee').textContent = 'Không tính được';
            console.error("API trả về không thành công:", data.message);
        }
    } catch (error) {
        console.error('Lỗi khi tính phí vận chuyển:', error);
        document.getElementById('shippingFee').textContent = 'Lỗi tính phí';
    }
}


function handleAddressSave() {
        const province = document.getElementById('province').value.trim();
        const district = document.getElementById('district').value.trim();
        const ward = document.getElementById('ward').value.trim();
        const specificAddress = document.getElementById('specificAddress').value.trim();

        console.log("Province:", province);
        console.log("District:", district);
       console.log("Ward:", ward);
        console.log("Specific Address:", specificAddress);

        if (province &&  district  && specificAddress) {
            const fullAddress = specificAddress + ", " + district + ", " + province;
            console.log("Full Address:", fullAddress);

            document.getElementById('deliveryAddress').value = fullAddress;

            const addressModal = document.getElementById('addressModal');
            calculateShippingFee(province, district, specificAddress);

            const modal = bootstrap.Modal.getInstance(addressModal);
            if (modal) {
                modal.hide();
            } else {
                document.querySelector('#addressModal .btn-close').click();
            }
        } else {
            alert('Vui lòng điền đầy đủ thông tin địa chỉ');
        }
    }

document.addEventListener("DOMContentLoaded", function () {
    handleAddressSave();
    document.getElementById('saveAddress').addEventListener('click', function () {
        handleAddressSave();
    });
});