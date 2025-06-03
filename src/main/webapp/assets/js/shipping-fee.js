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

function renderCurrency(selector, value) {
    $(selector).text(
        new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(value)
    );
}

async function calculateShippingFee(province, district, address) {
    try {
        if (!province || !district || !address) {
            console.error("Thiếu địa chỉ");
            document.getElementById('shippingFee').textContent = 'Thiếu thông tin';
            return;
        }

        const encodedProvince = encodeURIComponent(province);
        const encodedDistrict = encodeURIComponent(district);
        const encodedAddress = encodeURIComponent(address);

        const pathname = window.location.pathname;
        const contextPath = pathname.substring(0, pathname.indexOf("/", 1));
        const baseUrl = contextPath + "/api/shipping-fee";


        const url = `${baseUrl}?province=${encodedProvince}&district=${encodedDistrict}&address=${encodedAddress}`;

        const response = await fetch(url);
        if (!response.ok) throw new Error("GHTK error");

        const data = await response.json();

        if (data.success) {
            const shippingFee = data.fee.fee + (data.fee.insurance_fee || 0);

            document.getElementById('shippingFee').textContent =
                shippingFee.toLocaleString('vi-VN') + ' VND';

            const hasShippingVoucher = Array.from(
                document.querySelectorAll("input[name='voucherOption']:checked")
            ).some(el => el.dataset.type === "shipping");

            if (hasShippingVoucher) {
                const selectedVoucherIds = Array.from(
                    document.querySelectorAll("input[name='voucherOption']:checked")
                ).map(el => el.value);

                $.ajax({
                    url: "applyVoucher",
                    type: "POST",
                    traditional: true,
                    data: { vid: selectedVoucherIds },
                    dataType: "json",
                    success: function (response) {
                        const productPrice = parseFloat(response.finalPrice) || 0;
                        const shipping = parseFloat(response.shippingFee ?? shippingFee) || 0;

                        const total = productPrice + shipping;
                        renderCurrency("#finalPrice", total);

                        document.querySelectorAll("input[name='voucherOption']:checked").forEach(el => {
                            el.dispatchEvent(new Event("change"));
                        });
                    },
                    error: function () {
                        alert("Lỗi khi áp dụng lại voucher sau khi tính phí.");
                    }
                });
            } else {
                let productPrice = 0;

                if ($("#finalPrice").data("original-price")) {
                    productPrice = parseFloat($("#finalPrice").data("original-price"));
                } else if ($("#total-price").length) {
                    productPrice = parseFloat($("#total-price").text().replace(/[^\d]/g, ""));
                }
                const total = productPrice + parseFloat(shippingFee);;
                renderCurrency("#finalPrice", total);
                debugger
            }
        } else {
            document.getElementById('shippingFee').textContent = 'Không tính được';
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