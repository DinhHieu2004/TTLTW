package com.example.web.service;

import com.example.web.dao.ReviewDao;
import com.example.web.dao.model.ProductReview;

import java.sql.SQLException;
import java.util.List;

public class PrivewService {
    private ReviewDao reviewDao = new ReviewDao();


    public boolean canReview(int userId, int paintingId, int orderItemId) throws Exception {
        return !reviewDao.hasReviewed(userId, paintingId, orderItemId);
    }
    public List<ProductReview> getReviewByItemId(int id) throws SQLException {
        return reviewDao.getReviewByItemId(id);
    }
    public List<ProductReview> getReviewByPaintingId(int id) throws SQLException {
        return reviewDao.getReviewByPaintingId(id);
    }
    public void submitReview(ProductReview review) throws Exception {
        if (canReview(review.getUserId(), review.getPaintingId(), review.getOrderItemId())) {
            reviewDao.addReview(review);
        } else {
            throw new Exception("Bạn đã đánh giá sản phẩm này từ đơn hàng này.");
        }
    }
    public List<ProductReview> getAll() throws SQLException {
        return reviewDao.getAll();
    }
    public ProductReview getReviewById(int id) throws SQLException {
        return reviewDao.getDetail(id);
    }
    public boolean deleteReviewById(int id) throws SQLException {
        return reviewDao.delete(id);

    }
    public boolean updateReview(int reviewId, int userId, int paintingId, int rating, String comment) throws SQLException {
        return reviewDao.update(reviewId, userId, paintingId,rating, comment);
    }
}
