$("#search-input").on("input", function () {
        let keyword = $(this).val().trim();

        if (keyword.length > 2) {
            $.ajax({
                url: "artwork/suggestions",
                method: "GET",
                dataType: "json",
                data: { keyword: keyword },
                success: function (response) {
                    console.log("API response:", response); // Debug dữ liệu trả về

                    $("#suggestions").empty().show(); // Hiển thị box gợi ý

                    if (Array.isArray(response) && response.length > 0) {
                        let suggestionList = "<ul class='list-group'>";
                        response.forEach(function (item) {
                            suggestionList += `<li class='list-group-item suggestion-item' style="cursor: pointer;">${item}</li>`;
                        });
                        suggestionList += "</ul>";
                        $("#suggestions").html(suggestionList);
                    } else {
                        $("#suggestions").hide(); // Ẩn nếu không có gợi ý
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Lỗi khi gửi yêu cầu API:", error);
                    $("#suggestions").hide();
                }
            });
        } else {
            $("#suggestions").empty().hide();
        }
});

$(document).on("click", ".suggestion-item", function () {
    $("#search-input").val($(this).text());
    $("#suggestions").empty();
    });