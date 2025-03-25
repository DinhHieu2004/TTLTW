document.addEventListener("DOMContentLoaded", function () {
    function getLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(sendPosition, showError);
        } else {
            console.log("Trình duyệt không hỗ trợ Geolocation.");
        }
    }

    function sendPosition(position) {
        const latitude = position.coords.latitude;
        const longitude = position.coords.longitude;

        fetch(`https://nominatim.openstreetmap.org/reverse?lat=${latitude}&lon=${longitude}&format=json`)
            .then(response => response.json())
            .then(data => {
                const address = data.display_name;

                fetch('location-servlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: `lat=${latitude}&lon=${longitude}&address=${encodeURIComponent(address)}`
                })
                    .then(response => response.text())
                    .then(data => console.log("Server response:", data))
                    .catch(error => console.error("Lỗi gửi vị trí về server:", error));
            })
            .catch(error => console.error("Lỗi lấy địa chỉ:", error));
    }

    function showError(error) {
        console.log("Lỗi khi lấy vị trí:", error.message);
    }

    getLocation();

    setInterval(getLocation, 300000);

});
