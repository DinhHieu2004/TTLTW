$(document).ready(function(){
    $("#footer-container").load("../partials/footer.jsp");
    $("#header-container").load("../partials/header.jsp");

});

document.querySelectorAll('#ratingStars .fa-star').forEach(star => {
    star.addEventListener('click', function () {
      const rating = this.getAttribute('data-value');
      document.querySelectorAll('#ratingStars .fa-star').forEach(s => {
        s.classList.remove('checked');
      });
      for (let i = 0; i < rating; i++) {
        document.querySelectorAll('#ratingStars .fa-star')[i].classList.add('checked');
      }
      document.getElementById('selectedRating').value = rating; // Gán giá trị vào input ẩn
    });
  });

  document.getElementById('commentForm').addEventListener('submit', function (e) {
    e.preventDefault();
    const comment = document.getElementById('commentContent').value;
    const rating = document.getElementById('selectedRating').value;

    if (rating === "0") {
      alert("Vui lòng chọn đánh giá sao!");
      return;
    }

    const commentsList = document.getElementById('commentsList');
    const newComment = `
      <div class="comment-item">
        <strong>Khách hàng mới:</strong>
        <p>${comment}</p>
        <div class="star-rating">
          ${Array.from({ length: 5 }, (_, i) => i < rating ? '<i class="fas fa-star checked"></i>' : '<i class="fas fa-star"></i>').join('')}
        </div>
      </div>
    `;
    commentsList.insertAdjacentHTML('beforeend', newComment);

    document.getElementById('commentContent').value = '';
    document.getElementById('selectedRating').value = '0';
    document.querySelectorAll('#ratingStars .fa-star').forEach(s => s.classList.remove('checked'));
  });
