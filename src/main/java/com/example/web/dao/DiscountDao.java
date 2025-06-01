package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.Discount;
import com.example.web.dao.model.Painting;
import com.example.web.dao.model.PaintingSize;
import com.example.web.service.DiscountService;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.time.LocalDateTime;
import java.time.ZoneId;

public class DiscountDao {
    private Connection conn = DbConnect.getConnection();

    public DiscountDao() {
    }

    public List<Discount> getAllDiscount() throws SQLException {
        String sql = "SELECT * FROM discounts";
        List<Discount> list = new ArrayList<>();

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Timestamp timestamp = rs.getTimestamp("createdAt");
            LocalDateTime createdAt = timestamp != null
                    ? timestamp.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime()
                    : null;

            Discount discount = new Discount(
                    rs.getInt("id"),
                    rs.getString("imageUrl"),
                    rs.getString("imageUrlCloud"),
                    rs.getString("discountName"),
                    rs.getBigDecimal("discountPercentage"),
                    rs.getDate("startDate").toLocalDate(),
                    rs.getDate("endDate").toLocalDate(),
                    createdAt
            );
            list.add(discount);
        }

        return list;
    }
    private List<PaintingSize> getPaintingSizes(int paintingId) throws SQLException {
        List<PaintingSize> sizes = new ArrayList<>();
        String sql = "SELECT ps.displayQuantity, s.weight, s.id, s.sizeDescription " +
                "FROM painting_sizes ps JOIN sizes s ON ps.sizeId = s.id WHERE ps.paintingId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, paintingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String size = rs.getString("sizeDescription");
                    int displayQuantity = rs.getInt("displayQuantity");
                    double weight = rs.getDouble("weight");
                    PaintingSize siz = new PaintingSize(id, size, displayQuantity, weight);
                    sizes.add(siz);
                }
            }
        }
        return sizes;
    }
    public List<Painting> getPaintingsByDiscountId(
            int discountId, String searchKeyword, Double minPrice, Double maxPrice,
            String[] themes, String[] artists, String startDate, String endDate,
            boolean sortRating, int currentPage, int recordsPerPage) throws SQLException {
        List<Painting> paintingList = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT 
            p.id AS paintingId,
            p.title AS paintingTitle,
            p.price,
            p.imageUrl,
            p.imageUrlCloud,
            a.name AS artistName,
            t.themeName AS theme,
            t.id AS themeId,
            a.id AS artistId,
            IFNULL(d.discountPercentage, 0) AS discount,
            IFNULL((SELECT AVG(rating) FROM product_reviews WHERE paintingId = p.id), 0) as averageRating
        FROM paintings p
        LEFT JOIN artists a ON p.artistId = a.id
        LEFT JOIN themes t ON p.themeId = t.id
        LEFT JOIN discount_paintings dp ON p.id = dp.paintingId
        LEFT JOIN discounts d ON dp.discountId = d.id
        WHERE dp.discountId = ?
    """);

        List<Object> params = new ArrayList<>();
        params.add(discountId);

        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            sql.append(" AND p.title LIKE ?");
            params.add("%" + searchKeyword + "%");
        }
        if (minPrice != null) {
            sql.append(" AND p.price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND p.price <= ?");
            params.add(maxPrice);
        }
        if (themes != null && themes.length > 0) {
            sql.append(" AND t.id IN (").append("?,".repeat(themes.length - 1)).append("?)");
            params.addAll(Arrays.asList(themes));
        }
        if (artists != null && artists.length > 0) {
            sql.append(" AND a.id IN (").append("?,".repeat(artists.length - 1)).append("?)");
            params.addAll(Arrays.asList(artists));
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND DATE(p.createdAt) >= ?");
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND DATE(p.createdAt) <= ?");
            params.add(endDate);
        }

        if (sortRating) {
            sql.append(" ORDER BY averageRating DESC, p.createdAt DESC");
        } else {
            sql.append(" ORDER BY p.createdAt DESC");
        }
        sql.append(" LIMIT ? OFFSET ?");

        params.add(recordsPerPage);
        params.add((currentPage - 1) * recordsPerPage);

        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Painting painting = new Painting();
                    painting.setId(rs.getInt("paintingId"));
                    painting.setTitle(rs.getString("paintingTitle"));
                    painting.setImageUrl(rs.getString("imageUrl"));
                    painting.setImageUrlCloud(rs.getString("imageUrlCloud"));
                    painting.setArtistName(rs.getString("artistName"));
                    painting.setThemeName(rs.getString("theme"));
                    painting.setThemeId(rs.getInt("themeId"));
                    painting.setArtistId(rs.getInt("artistId"));
                    painting.setDiscountPercentage(rs.getDouble("discount"));
                    painting.setPrice(rs.getDouble("price"));
                    painting.setAverageRating(rs.getDouble("averageRating"));
                    painting.setSizes(getPaintingSizes(rs.getInt("paintingId")));
                    paintingList.add(painting);
                }
            }
        }

        return paintingList;
    }

    public int countPaintingsByDiscountId(
            int discountId, String keyword, Double minPrice, Double maxPrice,
            String[] themes, String[] artists, String startDate, String endDate) throws SQLException {
        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*) AS total
        FROM paintings p
        LEFT JOIN artists a ON p.artistId = a.id
        LEFT JOIN themes t ON p.themeId = t.id
        LEFT JOIN discount_paintings dp ON p.id = dp.paintingId
        WHERE dp.discountId = ?
    """);

        List<Object> params = new ArrayList<>();
        params.add(discountId);

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND p.title LIKE ?");
            params.add("%" + keyword + "%");
        }
        if (minPrice != null) {
            sql.append(" AND p.price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND p.price <= ?");
            params.add(maxPrice);
        }
        if (themes != null && themes.length > 0) {
            sql.append(" AND t.id IN (").append("?,".repeat(themes.length - 1)).append("?)");
            params.addAll(Arrays.asList(themes));
        }
        if (artists != null && artists.length > 0) {
            sql.append(" AND a.id IN (").append("?,".repeat(artists.length - 1)).append("?)");
            params.addAll(Arrays.asList(artists));
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND DATE(p.createdAt) >= ?");
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND DATE(p.createdAt) <= ?");
            params.add(endDate);
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }

        return 0;
    }
    public List<Painting> getPaintingsByDiscountIdAd(int discountId) {
        List<Painting> paintingList = new ArrayList<>();

        String sql = """
        SELECT 
            p.id AS paintingId,
            p.title AS paintingTitle,
            p.price,
            p.imageUrl,
            a.name AS artistName,
            t.themeName AS theme,
            t.id AS themeId,
            a.id AS artistId,
            IFNULL(d.discountPercentage, 0) AS discountPercentage
        FROM paintings p
        LEFT JOIN artists a ON p.artistId = a.id
        LEFT JOIN themes t ON p.themeId = t.id
        LEFT JOIN discount_paintings dp ON p.id = dp.paintingId
        LEFT JOIN discounts d ON dp.discountId = d.id
        WHERE dp.discountId = ?
    """;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, discountId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Painting painting = new Painting();
                    painting.setId(rs.getInt("paintingId"));
                    painting.setTitle(rs.getString("paintingTitle"));
                    painting.setPrice(rs.getDouble("price"));
                    painting.setImageUrl(rs.getString("imageUrl"));
                    painting.setArtistName(rs.getString("artistName"));
                    painting.setThemeName(rs.getString("theme"));
                    painting.setThemeId(rs.getInt("themeId"));
                    painting.setArtistId(rs.getInt("artistId"));
                    painting.setDiscountPercentage(rs.getDouble("discountPercentage"));
                    painting.setSizes(getPaintingSizes(rs.getInt("paintingId")));
                    paintingList.add(painting);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching paintings by discount ID", e);
        }

        return paintingList;
    }

    public List<Painting> getProductHaveNoDC() throws SQLException {
        // Câu lệnh SQL sử dụng LEFT JOIN để lấy các sản phẩm không được giảm giá
        String sql = """
        SELECT 
            p.id, 
            p.title, 
            p.price, 
            a.name AS artistName, 
            t.themeName AS themeName, 
            t.id AS themeId,
            a.id AS artistId,
            p.createdAt 
        FROM 
            paintings p
        LEFT JOIN 
            discount_paintings dp ON p.id = dp.paintingId
        JOIN 
            artists a ON p.artistId = a.id
        JOIN 
            themes t ON p.themeId = t.id
        WHERE 
            dp.paintingId IS NULL
    """;

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        List<Painting> productDcByNullDcId = new ArrayList<>();

        while (rs.next()) {
            Painting painting = new Painting();

            // Lấy dữ liệu từ kết quả ResultSet
            int paintingId = rs.getInt("id");
            String title = rs.getString("title");
            double price = rs.getDouble("price");
            String theme = rs.getString("themeName");
            Date createdAt = rs.getDate("createdAt");
            String artistName = rs.getString("artistName");
            int themeId = rs.getInt("themeId");
            int artistId = rs.getInt("artistId");


            // Gán dữ liệu vào đối tượng Painting
            painting.setId(paintingId);
            painting.setTitle(title);
            painting.setPrice(price);
            painting.setThemeName(theme);
            painting.setArtistName(artistName);
            painting.setArtistId(artistId);
            painting.setThemeId(themeId);
            painting.setCrateDate(createdAt);
            painting.setSizes(getPaintingSizes(paintingId));

            // Thêm Painting vào danh sách
            productDcByNullDcId.add(painting);
        }

        return productDcByNullDcId;
    }

    public String getDiscountNameById(int discountId) throws SQLException {
        String sql = "SELECT discountName FROM discounts WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        String result = "";
        ps.setInt(1, discountId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            result = rs.getString("discountName");
        }
        return result;
    }
    public boolean assignProductToDiscount(int productId, int discountId) throws SQLException {
        String sql = "INSERT INTO discount_paintings (discountId, paintingId) VALUES (?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, discountId); // Gán giá trị discountId
            ps.setInt(2, productId);  // Gán giá trị paintingId

            int rowsAffected = ps.executeUpdate(); // Thực thi câu lệnh
            return rowsAffected > 0; // Trả về true nếu có ít nhất một dòng được thêm
        }
    }


    public Discount getDiscountById(int discountId) {
        Discount discount = null;
        String query = "SELECT * FROM discounts WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {

            // Thiết lập tham số cho câu lệnh SQL
            stmt.setInt(1, discountId);

            // Thực thi câu lệnh và lấy kết quả
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // Lấy thông tin từ ResultSet
                    int id = rs.getInt("id");
                    String imageUrl = rs.getString("imageUrl");
                    String imageUrlCloud = rs.getString("imageUrlCloud");
                    String discountName = rs.getString("discountName");
                    BigDecimal discountPercentage = rs.getBigDecimal("discountPercentage");
                    LocalDate localStartDate = rs.getDate("startDate").toLocalDate();
                    LocalDate localEndDate = rs.getDate("endDate").toLocalDate();
                    Timestamp createdAt = rs.getTimestamp("createdAt");

                    // Chuyển đổi java.sql.Date thành LocalDate
                    LocalDateTime localCreatedAt = (createdAt != null) ? createdAt.toLocalDateTime() : null;

                    // Tạo đối tượng Discount từ kết quả truy vấn
                    discount = new Discount(id, imageUrl, imageUrlCloud, discountName, discountPercentage, localStartDate, localEndDate, localCreatedAt);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Xử lý lỗi
        }

        return discount;
    }
    public boolean removeProductFromDiscount(int productId) throws SQLException {
        String sql = "DELETE FROM discount_paintings WHERE paintingId = ?";

        try (PreparedStatement preparedStatement = conn.prepareStatement(sql)) {
            preparedStatement.setInt(1, productId);
            int rowsAffected = preparedStatement.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("Sản phẩm đã được xóa khỏi chương trình giảm giá.");
                return true; // Xóa thành công
            } else {
                System.out.println("Không tìm thấy sản phẩm trong chương trình giảm giá.");
                return false; // Không có sản phẩm nào bị xóa
            }
        }
    }

    public boolean addDiscount(Discount discount) {
        String sql = "INSERT INTO discounts (imageUrl, discountName, discountPercentage, startDate, endDate) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement statement = conn.prepareStatement(sql)) {

            // Đặt các giá trị cho các tham số trong câu lệnh SQL
            statement.setString(1, discount.getImageUrl());
            statement.setString(2, discount.getDiscountName());
            statement.setBigDecimal(3, discount.getDiscountPercentage());
            statement.setDate(4, java.sql.Date.valueOf(discount.getStartDate()));
            statement.setDate(5, java.sql.Date.valueOf(discount.getEndDate()));

            // Thực thi câu lệnh SQL
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;  // Nếu có ít nhất 1 dòng được thêm vào, trả về true
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean deleteDiscount(int discountId) {
        boolean isDeleted = false;
        String sql = "DELETE FROM discounts WHERE id = ?";
        try {
            deleteProductsByDiscountId(discountId);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, discountId);
                int rowsAffected = ps.executeUpdate();

                // Nếu có ít nhất một dòng bị xóa, trả về true
                if (rowsAffected > 0) {
                    isDeleted = true;
                }
            }
        } catch (SQLException e) {
            // Xử lý lỗi và ghi lại thông tin lỗi nếu cần
            e.printStackTrace();
        }

        return isDeleted;
    }

    // Phương thức xóa sản phẩm liên quan đến giảm giá
    private void deleteProductsByDiscountId(int discountId) throws SQLException {
        String sql = "DELETE FROM discount_paintings WHERE discountId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, discountId);
            ps.executeUpdate();
        }
    }
    public void editDiscount(Discount discount) {
        String sql = "UPDATE discounts SET discountName = ?, discountPercentage = ?, startDate = ?, endDate = ?, imageUrl = ? WHERE id = ?";
        try(PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Gán giá trị cho câu lệnh SQL
            stmt.setString(1, discount.getDiscountName());
            stmt.setBigDecimal(2, discount.getDiscountPercentage());
            stmt.setDate(3, java.sql.Date.valueOf(discount.getStartDate()));
            stmt.setDate(4, java.sql.Date.valueOf(discount.getEndDate()));
            stmt.setString(5, discount.getImageUrl());
            stmt.setInt(6, discount.getId());  // ID để xác định chương trình giảm giá cần chỉnh sửa

            // Thực thi câu lệnh cập nhật
            stmt.executeUpdate();

            // Kiểm tra xem câu lệnh có ảnh hưởng đến cơ sở dữ liệu không

        } catch (SQLException e) {
            e.printStackTrace();
            // Xử lý lỗi nếu có
            System.out.println("Lỗi khi chỉnh sửa giảm giá: " + e.getMessage());
        }
    }
    public static void main(String[] args) {
        DiscountDao dao = new DiscountDao();
        System.out.println( dao.deleteDiscount(1));
    }

}

