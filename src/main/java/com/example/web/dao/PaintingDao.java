package com.example.web.dao;

import com.example.web.controller.util.PaintingCacheManager;
import com.example.web.dao.cart.CartPainting;
import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

import static com.example.web.dao.db.DbConnect.getConnection;

public class PaintingDao {
    private static final Connection con = getConnection();

    public PaintingDao() {
    }

    public static void updateCloudImageUrl(String fileName, String cloudUrl) throws SQLException {
        String sql = "update paintings set imageUrlCloud = ? where imageUrl like ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, cloudUrl);
        ps.setString(2,"%" + fileName);
        int rows = ps.executeUpdate();
        if(rows > 0) {
            System.out.println("Đã cập nhật " + fileName + " thành công");
        }else {
            System.out.println("không tìm thấy ảnh trùng " + fileName);
        }
    }

    public boolean deletePainting(int id) throws SQLException {
        String sql = "UPDATE paintings SET isDelete = 1 WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);

        PaintingCacheManager.clearAll();

        return ps.executeUpdate() > 0;


    }
    //add
    public int addPainting(String title, int themeId, double price, int artistId, String description, String imageUrl, boolean isFeatured) throws SQLException {
        String sql = "INSERT INTO paintings (title, themeId, price, artistId, description, imageUrl, isFeatured) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, title);
            ps.setInt(2, themeId);
            ps.setDouble(3, price);
            ps.setInt(4, artistId);
            ps.setString(5, description);
            ps.setString(6, imageUrl);
            ps.setBoolean(7, isFeatured);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); // Trả về ID của tranh
                }
            }
        }

        PaintingCacheManager.clearAll();

        return -1;
    }

    public boolean addPaintingSizes(int paintingId, List<Integer> sizeIds, List<Integer> quantities) throws SQLException {
        if (sizeIds.size() != quantities.size()) {
            throw new IllegalArgumentException("Size of sizeIds and quantities lists must be the same.");
        }
        String sql = "INSERT INTO painting_sizes (paintingId, sizeId, quantity) VALUES (?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        for (int i = 0; i < sizeIds.size(); i++) {
            ps.setInt(1, paintingId);
            ps.setInt(2, sizeIds.get(i));
            ps.setInt(3, quantities.get(i));
            ps.addBatch();
        }
        int[] updateCounts = ps.executeBatch();
        for (int count : updateCounts) {
            if (count != 1) {
                return false;
            }
        }
        PaintingCacheManager.clearAll();

        return true;

    }


    //update
    public boolean updatePainting(int paintingId, String title, int themeId, boolean isSold, double price, int artistId, String description, String imageUrl, boolean isFeatured) throws SQLException {
        String sql = "UPDATE paintings SET title = ?, themeId = ?, price = ?, artistId = ?, description = ?, imageUrl = ?, isSold =?, isFeatured = ? WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setInt(2, themeId);
            ps.setDouble(3, price);
            ps.setInt(4, artistId);
            ps.setString(5, description);
            ps.setString(6, imageUrl);
            ps.setBoolean(7, isSold);
            ps.setBoolean(8, isFeatured);
            ps.setInt(9, paintingId);
            int rowsUpdated = ps.executeUpdate();

            PaintingCacheManager.clearAll();


            return rowsUpdated > 0;
        }
    }

    public boolean updatePaintingSizes(int paintingId, List<Integer> sizeIds, List<Integer> quantities) throws SQLException {
        String updateSql = "UPDATE painting_sizes SET displayQuantity = ? WHERE paintingId = ? AND sizeId = ?";
        try (PreparedStatement psUpdate = con.prepareStatement(updateSql)) {
            for (int i = 0; i < sizeIds.size(); i++) {
                psUpdate.setInt(1, quantities.get(i));
                psUpdate.setInt(2, paintingId);
                psUpdate.setInt(3, sizeIds.get(i));
                psUpdate.addBatch();
            }
            int[] updateCounts = psUpdate.executeBatch();
            for (int count : updateCounts) {
                if (count != 1) {
                    return false;
                }
            }
        }

        PaintingCacheManager.clearAll();

        return true;
    }


    public List<Painting> getAll() throws SQLException {
        String sql = """ 
                        SELECT p.id,
                        p.title,
                        p.description,
                        p.imageUrl,
                        p.imageUrlCloud,
                        a.name AS artistName,
                        p.artistId,
                        t.themeName AS themeName,
                        p.themeId,
                        p.price,
                        p.createdAt,
                        p.isSold
                FROM paintings p
                JOIN artists a ON p.artistId = a.id
                JOIN themes t ON p.themeId = t.id 
                        WHERE p.isDelete = 0

""";

        PreparedStatement stmt = con.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();
        List<Painting> paintingList = new ArrayList<>();
        while (rs.next()) {
            Painting painting = new Painting();
            int paintingId = rs.getInt("id");
            String title = rs.getString("title");
            double price = rs.getDouble("price");
            String imageUrl = rs.getString("imageUrl");
            String imageUrlCloud = rs.getString("imageUrlCloud");
            String theme = rs.getString("themeName");
            int themeId = rs.getInt("themeId");
            int artistId = rs.getInt("artistId");
            Date createdAt = rs.getDate("createdAt");
            String artistName = rs.getString("artistName");
            boolean available = rs.getBoolean("isSold");
            painting.setId(paintingId);
            painting.setTitle(title);
            painting.setPrice(price);
            painting.setImageUrl(imageUrl);
            painting.setImageUrlCloud(imageUrlCloud);
            painting.setThemeName(theme);
            painting.setArtistName(artistName);
            painting.setThemeId(themeId);
            painting.setArtistId(artistId);
            painting.setCreateDate(createdAt);
            painting.setAvailable(available);
            painting.setDescription(rs.getString("description"));
            painting.setSizes(getPaintingSizes(paintingId));
            paintingList.add(painting);
        }
        return paintingList;
    }

    public List<Painting> getAllDelete() throws SQLException {
        String sql = """ 
                        SELECT p.id,
                        p.title,
                        p.description,
                        p.imageUrl,
                        p.imageUrlCloud,
                        a.name AS artistName,
                        p.artistId,
                        t.themeName AS themeName,
                        p.themeId,
                        p.price,
                        p.createdAt,
                        p.isSold
                FROM paintings p
                JOIN artists a ON p.artistId = a.id
                JOIN themes t ON p.themeId = t.id 
                        WHERE p.isDelete = 1

""";

        PreparedStatement stmt = con.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();
        List<Painting> paintingList = new ArrayList<>();
        while (rs.next()) {
            Painting painting = new Painting();
            int paintingId = rs.getInt("id");
            String title = rs.getString("title");
            double price = rs.getDouble("price");
            String imageUrl = rs.getString("imageUrl");
            String imageUrlCloud = rs.getString("imageUrlCloud");
            String theme = rs.getString("themeName");
            int themeId = rs.getInt("themeId");
            int artistId = rs.getInt("artistId");
            Date createdAt = rs.getDate("createdAt");
            String artistName = rs.getString("artistName");
            boolean available = rs.getBoolean("isSold");
            painting.setId(paintingId);
            painting.setTitle(title);
            painting.setPrice(price);
            painting.setImageUrl(imageUrl);
            painting.setImageUrlCloud(imageUrlCloud);
            painting.setThemeName(theme);
            painting.setArtistName(artistName);
            painting.setThemeId(themeId);
            painting.setArtistId(artistId);
            painting.setCreateDate(createdAt);
            painting.setAvailable(available);
            painting.setDescription(rs.getString("description"));
            painting.setSizes(getPaintingSizes(paintingId));
            paintingList.add(painting);
        }
        return paintingList;
    }

    private List<PaintingSize> getPaintingSizes(int paintingId) throws SQLException {
        List<PaintingSize> sizes = new ArrayList<>();
        String sql = "SELECT ps.displayQuantity, s.weight, s.id, s.sizeDescription " +
                "FROM painting_sizes ps JOIN sizes s ON ps.sizeId = s.id WHERE ps.paintingId = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
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
    public Painting getPaintingDetail(int paintingId) throws SQLException {
        Painting paintingDetail = null;
        String sql = """
                SELECT 
                    p.id AS paintingId,
                    p.title AS paintingTitle,
                    p.price,
                    p.isSold,
                    p.description,
                    p.createdAt,
                    p.isFeatured,
                    p.imageUrl,
                    p.imageUrlCloud,
                    a.name AS artistName,
                    t.themeName,
                    p.themeId,
                    p.artistId,
                    d.discountName,
                    IF (NOW() BETWEEN d.startDate AND d.endDate, d.discountPercentage, 0) AS discountPercentage,
                    s.sizeDescription,
                    s.weight,
                    s.id AS idSize,
                    ps.totalQuantity,
                    ps.reservedQuantity,
                    ps.displayQuantity,
                    dp.discountId
                FROM paintings p
                LEFT JOIN artists a ON p.artistId = a.id
                LEFT JOIN themes t ON p.themeId = t.id
                LEFT JOIN discount_paintings dp ON p.id = dp.paintingId
                LEFT JOIN discounts d ON dp.discountId = d.id
                LEFT JOIN painting_sizes ps ON p.id = ps.paintingId
                LEFT JOIN sizes s ON ps.sizeId = s.id
                WHERE p.id = ?;
            """;

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, paintingId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    if (paintingDetail == null) {
                        paintingDetail = new Painting(
                                rs.getInt("paintingId"),
                                rs.getString("paintingTitle"),
                                rs.getDouble("price"),
                                rs.getString("description"),
                                rs.getString("imageUrl"),
                                rs.getString("imageUrlCloud"),
                                rs.getInt("artistId"),
                                rs.getInt("themeId"),
                                rs.getString("artistName"),
                                rs.getString("themeName"),
                                rs.getBoolean("isFeatured"),
                                rs.getDate("createdAt"),
                                getPaintingRating(rs.getInt("paintingId")),
                                rs.getBoolean("isSold")
                        );
                    }

                    int idSize = rs.getInt("idSize");
                    double weight = rs.getDouble("weight");
                    String sizeDescription = rs.getString("sizeDescription");
                    int totalQuantity = rs.getInt("totalQuantity");
                    int reservedQuantity = rs.getInt("reservedQuantity");
                    int displayQuantity = rs.getInt("displayQuantity");
                    paintingDetail.addSize(idSize, sizeDescription, totalQuantity, reservedQuantity, displayQuantity, weight);

                    double discountPercentage = rs.getDouble("discountPercentage");
                    if (discountPercentage > 0) {
                        paintingDetail.setDiscount(rs.getString("discountName"), discountPercentage);
                    }
                }
            }
        }
        return paintingDetail;
    }

    public List<Painting> getRandomTopRatedPaintings() throws SQLException {
        List<Painting> paintingList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                    WITH TopRatedPaintings AS (
                        SELECT 
                            p.id AS paintingId,
                            p.title AS paintingTitle,
                            p.price,
                            p.imageUrl,
                            p.imageUrlCloud,
                            a.name AS artistName,
                            t.themeName AS theme,
                            p.themeId,
                            p.artistId,
                            IF(NOW() BETWEEN d.startDate AND d.endDate, d.discountPercentage, 0) AS discount,
                            COALESCE(AVG(r.rating), 0) as avgRating
                        FROM paintings p
                        LEFT JOIN artists a ON p.artistId = a.id
                        LEFT JOIN themes t ON p.themeId = t.id
                        LEFT JOIN discount_paintings dp ON p.id = dp.paintingId
                        LEFT JOIN discounts d ON dp.discountId = d.id
                        LEFT JOIN product_reviews r ON p.id = r.paintingId
                        GROUP BY p.id, p.title, p.price, p.imageUrl, a.name, t.themeName, d.startDate, d.endDate, d.discountPercentage
                        HAVING avgRating > 0
                        ORDER BY avgRating DESC
                        LIMIT 20
                    )
                    SELECT * FROM TopRatedPaintings
                    ORDER BY RAND()
                    LIMIT 4
                """);

        try (PreparedStatement stmt = con.prepareStatement(sql.toString())) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("paintingId");
                    Painting painting = new Painting();
                    painting.setId(id);
                    painting.setTitle(rs.getString("paintingTitle"));
                    painting.setImageUrl(rs.getString("imageUrl"));
                    painting.setImageUrlCloud(rs.getString("imageUrlCloud"));
                    painting.setArtistId(rs.getInt("artistId"));
                    painting.setThemeId(rs.getInt("themeId"));
                    painting.setArtistName(rs.getString("artistName"));
                    painting.setThemeName(rs.getString("theme"));
                    painting.setDiscountPercentage(rs.getDouble("discount"));
                    painting.setPrice(rs.getDouble("price"));
                    painting.setAverageRating(rs.getDouble("avgRating"));
                    painting.setSizes(getPaintingSizes(id));
                    paintingList.add(painting);
                }
            }
        }

        return paintingList;
    }

    public List<Painting> getPaintingList(String searchKeyword, Double minPrice, Double maxPrice, String[] themes, String[] artists, String startDate, String endDate, boolean sortRating, boolean snew, int currentPage, int recordsPerPage) throws SQLException {
        List<Painting> paintingList = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
                SELECT\s
                        p.id AS paintingId,
                        p.title AS paintingTitle,
                        p.price,
                        p.imageUrl,
                        p.imageUrlCloud,
                        a.name AS artistName,
                        t.themeName AS theme,
                        p.themeId,
                        p.artistId,
                        IF (
                            d.startDate IS NOT NULL AND d.endDate IS NOT NULL\s
                            AND NOW() BETWEEN d.startDate AND d.endDate,
                            d.discountPercentage,
                            0
                        ) AS discountPercentage,
                        IFNULL((SELECT AVG(rating) FROM product_reviews WHERE paintingId = p.id), 0) AS averageRating
                    FROM paintings p
                    LEFT JOIN artists a ON p.artistId = a.id
                    LEFT JOIN themes t ON p.themeId = t.id
                    LEFT JOIN discount_paintings dp ON p.id = dp.paintingId
                    LEFT JOIN discounts d ON dp.discountId = d.id
                    WHERE 1=1 AND p.isSold = 0
            """);

        List<Object> params = new ArrayList<>();

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
            params.addAll(List.of(themes));
        }
        if (artists != null && artists.length > 0) {
            sql.append(" AND a.id IN (").append("?,".repeat(artists.length - 1)).append("?)");
            params.addAll(List.of(artists));
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND DATE(p.createdAt) >= ?");
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND DATE(p.createdAt) <= ?");
            params.add(endDate);
        }

        if (sortRating && snew) {
            sql.append(" ORDER BY averageRating DESC, p.createdAt DESC");
        } else if (sortRating) {
            sql.append(" ORDER BY averageRating DESC");
        } else if (snew) {
            sql.append(" ORDER BY p.createdAt DESC");
        } else {
            sql.append(" ");
        }
        sql.append(" LIMIT ? OFFSET ?");

        params.add(recordsPerPage);
        params.add((currentPage - 1) * recordsPerPage);

        try (PreparedStatement stmt = con.prepareStatement(sql.toString())) {
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
                    painting.setArtistId(rs.getInt("artistId"));
                    painting.setThemeId(rs.getInt("themeId"));
                    painting.setArtistName(rs.getString("artistName"));
                    painting.setThemeName(rs.getString("theme"));
                    painting.setDiscountPercentage(rs.getDouble("discountPercentage"));
                    painting.setPrice(rs.getDouble("price"));
                    painting.setAverageRating(getPaintingRating(painting.getId()));
                    painting.setSizes(getPaintingSizes(rs.getInt("paintingId")));

                    paintingList.add(painting);
                }
            }
        }

        return paintingList;
    }




    public double getPaintingRating(int paintingId) throws SQLException {
        String sql = """
        SELECT 
            IFNULL(AVG(rating), 0) as averageRating
        FROM product_reviews
        WHERE paintingId = ?
    """;

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, paintingId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("averageRating");
                }
            }
        }

        return 0.0;
    }

    private List<Painting> getRandomPaintingsByCondition(String whereClause, List<Object> params, Integer limit) throws SQLException {
        Map<Integer, Painting> paintingMap = new HashMap<>();
        List<Painting> paintings = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT 
                p.id AS paintingId,
                p.title AS paintingTitle,
                p.price,
                p.imageUrl,
                p.imageUrlCloud,
                a.name AS artistName,
                t.themeName AS theme,
                p.themeId,
                p.artistId,
                IFNULL(d.discountPercentage, 0) AS discount
            FROM paintings p
            LEFT JOIN artists a ON p.artistId = a.id
            LEFT JOIN themes t ON p.themeId = t.id
            LEFT JOIN discount_paintings dp ON p.id = dp.paintingId
            LEFT JOIN discounts d ON dp.discountId = d.id
            WHERE """ + whereClause + """
            ORDER BY RAND()
        """);

        if (limit != null && limit > 0) {
            sql.append(" LIMIT ?");
        }

        try (PreparedStatement statement = con.prepareStatement(sql.toString())) {
            int index = 1;
            for (Object param : params) {
                statement.setObject(index++, param);
            }
            if (limit != null && limit > 0) {
                statement.setInt(index, limit);
            }

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    int paintingId = rs.getInt("paintingId");

                    if (!paintingMap.containsKey(paintingId)) {
                        Painting painting = new Painting();
                        painting.setId(paintingId);
                        painting.setArtistId(rs.getInt("artistId"));
                        painting.setThemeId(rs.getInt("themeId"));
                        painting.setArtistName(rs.getString("artistName"));
                        painting.setTitle(rs.getString("paintingTitle"));
                        painting.setImageUrl(rs.getString("imageUrl"));
                        painting.setImageUrlCloud(rs.getString("imageUrlCloud"));
                        painting.setThemeName(rs.getString("theme"));
                        painting.setDiscountPercentage(rs.getDouble("discount"));
                        painting.setPrice(rs.getDouble("price"));
                        painting.setSizes(getPaintingSizes(paintingId));
                        paintingMap.put(paintingId, painting);
                    }
                }
            }
        }

        paintings.addAll(paintingMap.values());
        return paintings;
    }
    public List<Painting> getListPaintingByArtist(int artistId) throws SQLException {
        String where = " p.artistId = ?";
        List<Object> params = Collections.singletonList(artistId);
        return getRandomPaintingsByCondition(where, params, 8);
    }
    public List<Painting> getRandomPaintingsByTheme(int themeId, int id) throws SQLException {
        String where = " p.themeId = ? AND p.id != ?";
        List<Object> params = Arrays.asList(themeId, id);
        return getRandomPaintingsByCondition(where, params, 5);
    }
    public List<Painting> getRandomPaintingsByArtist(int artistId, int id) throws SQLException {
        String where = " p.artistId = ? AND p.id != ?";
        List<Object> params = Arrays.asList(artistId, id);
        return getRandomPaintingsByCondition(where, params, 5);
    }



    // danh sach tranh theo từng họa sĩ .
    public List<Painting> getPaintingListByArtist(Double minPrice, Double maxPrice, String[] sizes, String[] themes, String artistId) throws SQLException {
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
                                        p.themeId,
                                        p.artistId,
                                        IFNULL(d.discountPercentage, 0) AS discount
                                    FROM paintings p
                                    LEFT JOIN artists a ON p.artistId = a.id
                                    LEFT JOIN themes t ON p.themeId = t.id
                                    LEFT JOIN discount_paintings dp ON p.id = dp.paintingId
                                    LEFT JOIN discounts d ON dp.discountId = d.id
                                     WHERE artistId = ?;
                """);

        List<Object> params = new ArrayList<>();
        params.add(artistId);

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
            params.addAll(List.of(themes));
        }


        try (PreparedStatement stmt = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int paintingId = rs.getInt("paintingId");

                    Painting painting = new Painting();
                    painting.setId(paintingId);
                    painting.setTitle(rs.getString("paintingTitle"));
                    painting.setImageUrl(rs.getString("imageUrl"));
                    painting.setImageUrlCloud(rs.getString("imageUrlCloud"));
                    painting.setArtistId(rs.getInt("artistId"));
                    painting.setThemeId(rs.getInt("themeId"));
                    painting.setArtistName(rs.getString("artistName"));
                    painting.setThemeName(rs.getString("theme"));
                    painting.setDiscountPercentage(rs.getDouble("discount"));
                    painting.setPrice(rs.getDouble("price"));
                    painting.setSizes(getPaintingSizes(paintingId));
                    paintingList.add(painting);

                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Lỗi khi lấy danh sách tranh có lọc", e);
        }

        return paintingList;
    }

    public void updateQuanity(int paintingId, int sizeId, int quantity) throws SQLException {
        con.setAutoCommit(false);
        try {
            String sql = "UPDATE painting_sizes SET displayQuantity = displayQuantity - ?,  reservedQuantity = IFNULL(reservedQuantity, 0) + ? WHERE paintingId = ? AND sizeId = ?";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setInt(1, quantity);
                stmt.setInt(2, quantity);
                stmt.setInt(3, paintingId);
                stmt.setInt(4, sizeId);
                stmt.executeUpdate();
            }

            PaintingCacheManager.clearAll();

            con.commit();
        } catch (Exception e) {
            con.rollback();
            e.printStackTrace();
            throw new SQLException("Error updating quantity with transaction", e);
        } finally {
            con.setAutoCommit(true);
        }
    }
    public void returnQuantity(List<OrderItem> orderItems) throws SQLException {
        String sql = "UPDATE painting_sizes SET displayQuantity = displayQuantity + ?, reservedQuantity = reservedQuantity - ? WHERE paintingId = ? AND sizeId = ?";
        con.setAutoCommit(false);

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (OrderItem item : orderItems) {
                ps.setInt(1, item.getQuantity());
                ps.setInt(2, item.getQuantity());
                ps.setInt(3, item.getPaintingId());
                ps.setInt(4, item.getSizeId());
                ps.addBatch();
            }
            ps.executeBatch();
            con.commit();
        } catch (SQLException e) {
            con.rollback();
            throw new SQLException("Lỗi khi hoàn trả số lượng vào kho: " + e.getMessage(), e);
        } finally {
            con.setAutoCommit(true);
        }
    }

    public List<Painting> getFeaturedArtworks() {
        String sql = "SELECT p.id, p.title, p.imageUrl, p.imageUrlCloud, ar.name AS artist_name, t.themeName, p.themeId,\n" +
                "                        p.artistId, p.price, " +
                "IF(NOW() BETWEEN d.startDate AND d.endDate, d.discountPercentage, 0) AS discount, " +
                "(SELECT AVG(r.rating) FROM product_reviews r WHERE r.paintingId = p.id) AS average_rating " +
                "FROM paintings p " +
                "JOIN artists ar ON p.artistId = ar.id " +
                "JOIN themes t ON p.themeId = t.id " +
                "LEFT JOIN discount_paintings dp ON p.id = dp.paintingId " +
                "LEFT JOIN discounts d ON dp.discountId = d.id " +
                "WHERE p.isFeatured = true AND p.isSold = false";
        List<Painting> featuredArtworks = new ArrayList<>();

        try (PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Painting painting = new Painting();
                int id = rs.getInt("id");
                painting.setId(id);
                painting.setTitle(rs.getString("title"));
                painting.setImageUrl(rs.getString("imageUrl"));
                painting.setImageUrlCloud(rs.getString("imageUrlCloud"));
                painting.setArtistId(rs.getInt("artistId"));
                painting.setThemeId(rs.getInt("themeId"));
                painting.setThemeName(rs.getString("themeName"));
                painting.setArtistName(rs.getString("artist_name"));
                painting.setPrice(rs.getDouble("price"));
                painting.setDiscountPercentage(rs.getDouble("discount"));
                painting.setAverageRating(getPaintingRating(id));
                painting.setSizes(getPaintingSizes(id));
                featuredArtworks.add(painting);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return featuredArtworks;
    }

    public List<Painting> getFlashSaleArtworks() {
        String sql = "SELECT p.id, p.title, p.imageUrl, p.imageUrlCloud, ar.name AS artist_name, t.themeName, p.themeId, " +
                "p.artistId, p.price, IF(NOW() BETWEEN d.startDate AND d.endDate, d.discountPercentage, 0) AS discount, " +
                "(SELECT AVG(r.rating) FROM product_reviews r WHERE r.paintingId = p.id) AS average_rating " +
                "FROM paintings p " +
                "JOIN artists ar ON p.artistId = ar.id " +
                "JOIN themes t ON p.themeId = t.id " +
                "JOIN discount_paintings dp ON p.id = dp.paintingId " +
                "JOIN discounts d ON dp.discountId = d.id " +
                "WHERE d.id = 3 AND NOW() BETWEEN d.startDate AND d.endDate";
        List<Painting> flashSaleArtworks = new ArrayList<>();

        try (PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Painting painting = new Painting();
                int id = rs.getInt("id");
                painting.setId(id);
                painting.setTitle(rs.getString("title"));
                painting.setImageUrl(rs.getString("imageUrl"));
                painting.setImageUrlCloud(rs.getString("imageUrlCloud"));
                painting.setArtistId(rs.getInt("artistId"));
                painting.setThemeId(rs.getInt("themeId"));
                painting.setThemeName(rs.getString("themeName"));
                painting.setArtistName(rs.getString("artist_name"));
                painting.setPrice(rs.getDouble("price"));
                painting.setDiscountPercentage(rs.getDouble("discount"));
                painting.setAverageRating(getPaintingRating(id));
                painting.setSizes(getPaintingSizes(id));
                flashSaleArtworks.add(painting);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return flashSaleArtworks;
    }

    public List<Theme> getTheme() throws SQLException {
        String sql = "SELECT * FROM themes";
        List<Theme> theme = new ArrayList<>();
        PreparedStatement stmt = con.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            theme.add(new Theme(rs.getInt(1), rs.getString(2)));
        }

        return theme;
    }



    public int countPaintings(String keyword,Double minPrice, Double maxPrice, String[] themes, String[] artists,
                              String startDate, String endDate) throws SQLException {
        StringBuilder sql = new StringBuilder("""
                    SELECT COUNT(*) AS total
                    FROM paintings p
                    LEFT JOIN artists a ON p.artistId = a.id
                    LEFT JOIN themes t ON p.themeId = t.id
                    WHERE 1=1
            """);

        List<Object> params = new ArrayList<>();

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
            params.addAll(Arrays.stream(themes)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList()));
        }
        if (artists != null && artists.length > 0) {
            sql.append(" AND a.id IN (").append("?,".repeat(artists.length - 1)).append("?)");
            params.addAll(Arrays.stream(artists)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList()));
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND DATE(p.createdAt) >= ?");
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND DATE(p.createdAt) <= ?");
            params.add(endDate);
        }

        try (PreparedStatement stmt = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Lỗi khi đếm số lượng tranh", e);
        }

        return 0;
    }
    public Painting getPaitingByItemId(int itemId) throws SQLException {
            Painting paintingDetail = null;
            String sql = """
                    SELECT 
                        p.id AS paintingId,
                        p.title AS paintingTitle,
                        p.price,
                        p.description,
                        p.createdAt,
                        p.isFeatured,
                        p.imageUrl,
                        p.imageUrlCloud,
                        a.name AS artistName,
                        t.themeName,
                        p.themeId,
                        p.artistId,
                        d.discountName,
                        d.discountPercentage,
                        s.sizeDescription,
                        s.id AS idSize,
                        s.weight,       
                        ps.displayQuantity,
                        dp.discountId
                
                    FROM paintings p
                    LEFT JOIN artists a ON p.artistId = a.id
                    LEFT JOIN themes t ON p.themeId = t.id
                    LEFT JOIN discount_paintings dp ON p.id = dp.paintingId
                    LEFT JOIN discounts d ON dp.discountId = d.id
                    LEFT JOIN painting_sizes ps ON p.id = ps.paintingId
                    LEFT JOIN sizes s ON ps.sizeId = s.id
                    WHERE p.id IN ( SELECT paintingId FROM order_items WHERE id = ?
                       );
                """;

            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setInt(1, itemId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        if (paintingDetail == null) {
                            // Initialize the PaintingDetail object
                            paintingDetail = new Painting(rs.getInt("paintingId"), rs.getString("paintingTitle"), rs.getDouble("price"), rs.getString("description"),
                                    rs.getString("imageUrl"), rs.getString("imageUrlCloud"),
                                    rs.getInt("artistId"), rs.getInt("themeId"), rs.getString("artistName"), rs.getString("themeName"),
                                    rs.getBoolean("isFeatured"), rs.getDate("createdAt"),
                                    getPaintingRating(rs.getInt("paintingId")));
                        }

                        // Add size and quantity to the painting detail
                        int idSize = rs.getInt("idSize");
                        double weight = rs.getDouble("weight");
                        String sizeDescription = rs.getString("sizeDescription");
                        int displayQuantity = rs.getInt("displayQuantity");
                        paintingDetail.addSize(idSize, sizeDescription, displayQuantity, weight);

                        // Add discount information if exists
                        if (rs.getString("discountName") != null) {
                            paintingDetail.setDiscount(rs.getString("discountName"), rs.getDouble("discountPercentage"));
                        }
                    }
                }
            }
            return paintingDetail;


    }



    public String getCurrentImagePath(int id) throws SQLException {
        String query = "SELECT imageUrl FROM paintings WHERE id = ?";
        String imagePath = null;
        PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                imagePath = rs.getString("imageUrl");
            }
        return imagePath;
    }

    public List<Painting> getNewestPaintings(int limit) throws SQLException {
        List<Painting> paintingList = new ArrayList<>();

        String sql = """
                    SELECT 
                        p.id AS paintingId,
                        p.title AS paintingTitle,
                        p.price,
                        p.imageUrl,
                        p.imageUrlCloud,
                        a.name AS artistName,
                        t.themeName AS theme,
                       p.themeId,
                        p.artistId,
                        IF(NOW() BETWEEN d.startDate AND d.endDate, d.discountPercentage, 0) AS discount,
                        IFNULL((SELECT AVG(rating) FROM product_reviews WHERE paintingId = p.id), 0) as averageRating
                    FROM paintings p
                    LEFT JOIN artists a ON p.artistId = a.id
                    LEFT JOIN themes t ON p.themeId = t.id
                    LEFT JOIN discount_paintings dp ON p.id = dp.paintingId
                    LEFT JOIN discounts d ON dp.discountId = d.id
                    ORDER BY p.createdAt DESC
                    LIMIT ?
                """;


        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Painting painting = new Painting();
                    painting.setId(rs.getInt("paintingId"));
                    painting.setTitle(rs.getString("paintingTitle"));
                    painting.setImageUrl(rs.getString("imageUrl"));
                    painting.setImageUrlCloud(rs.getString("imageUrlCloud"));
                    painting.setArtistId(rs.getInt("artistId"));
                    painting.setThemeId(rs.getInt("themeId"));
                    painting.setArtistName(rs.getString("artistName"));
                    painting.setThemeName(rs.getString("theme"));
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
    public List<String> getPaintingSg(String keyword, int limit) throws SQLException {
        List<String> suggestions = new ArrayList<>();
        String query = "SELECT DISTINCT title FROM paintings WHERE title LIKE ? LIMIT ?";
             PreparedStatement stmt = con.prepareStatement(query);

            stmt.setString(1, "%" + keyword + "%");
            stmt.setInt(2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    suggestions.add(rs.getString("title"));
                }
            }

        return suggestions;

    }

    public Painting getInventory(CartPainting cartPainting) throws SQLException {
        Painting paintingDetail = null;
        String sql = """
                    SELECT 
                        p.id AS paintingId,
                        p.title AS paintingTitle,
                        p.price,
                        s.sizeDescription,
                        s.weight,
                        s.id AS idSize,
                        ps.displayQuantity 
                    FROM paintings p
                    LEFT JOIN painting_sizes ps ON p.id = ps.paintingId
                    LEFT JOIN sizes s ON ps.sizeId = s.id
                    WHERE p.id = ?;
                """;

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, cartPainting.getProductId());
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    if (paintingDetail == null) {
                        paintingDetail = new Painting(rs.getInt("paintingId"), rs.getString("paintingTitle"), rs.getDouble("price"));
                    }
                    int idSize = rs.getInt("idSize");
                    double weight = rs.getDouble("weight");
                    String sizeDescription = rs.getString("sizeDescription");
                    int displayQuantity = rs.getInt("displayQuantity");
                    paintingDetail.addSize(idSize, sizeDescription, displayQuantity, weight);

                }
            }
        }
        return paintingDetail;
    }

    public static void main(String[] args) throws SQLException {
        PaintingDao paintingDao = new PaintingDao();

        String[] sizes = null;
        String[] themes = {"1"};
        /**
         int paintingId = paintingDao.addPainting(
         "Sunset Overdrive",
         1,
         150.0,
         2,
         "A beautiful sunset painting.",
         "sunset.jpg",
         true
         );

         System.out.println(paintingId);
         **/

      //  int paintingId = 11;
      //  List<Integer> sizeIds = Arrays.asList(1, 2, 3);
      //  List<Integer> quantities = Arrays.asList(5, 3, 2);

       // System.out.println(paintingDao.getPaintingDetail(5));

        //    System.out.println(paintingDao.getPaintingList(null,null,null,null,null,null,null,1,10));
        //  System.out.println(paintingDao.getPaintingRating(5));
        //System.out.println(paintingDao.getPaintingRating(6));

      //  System.out.println(paintingDao.getPaintingSg("hoa", 3));

        CartPainting cartPainting = new CartPainting();
        cartPainting.setProductId(1);
        cartPainting.setProductName("Tranh cảnh biển");
        cartPainting.setQuantity(2);

        System.out.println(paintingDao.getAllDelete());
    }

    public boolean applySI(List<StockInItem> items) throws SQLException {
        String updateSql = "UPDATE painting_sizes SET displayQuantity = IFNULL(displayQuantity, 0) + ?, totalQuantity = IFNULL(totalQuantity, 0) + ? WHERE paintingId = ? AND sizeId = ?";
        String insertSql = "INSERT INTO painting_sizes (displayQuantity, totalQuantity, paintingId, sizeId) VALUES (?, ?, ?, ?)";

        boolean originalAutoCommit = con.getAutoCommit();
        con.setAutoCommit(false);

        try (PreparedStatement updateStmt = con.prepareStatement(updateSql);
             PreparedStatement insertStmt = con.prepareStatement(insertSql)) {

            for (StockInItem item : items) {
                updateStmt.setInt(1, item.getQuantity());
                updateStmt.setInt(2, item.getQuantity());
                updateStmt.setInt(3, item.getProductId());
                updateStmt.setInt(4, item.getSizeId());
                int updated = updateStmt.executeUpdate();

                if (updated == 0) {
                    insertStmt.setInt(1, item.getQuantity());
                    insertStmt.setInt(2, item.getQuantity());
                    insertStmt.setInt(3, item.getProductId());
                    insertStmt.setInt(4, item.getSizeId());
                    insertStmt.executeUpdate();
                }
            }
            con.commit();
            return true;
        } catch (SQLException e) {
            con.rollback();
            throw new SQLException("Lỗi khi áp dụng phiếu nhập kho: " + e.getMessage(), e);
        } finally {
            con.setAutoCommit(originalAutoCommit);
        }
    }

    public boolean applySO(List<StockOutItem> items, boolean isDelivery) throws SQLException {
        con.setAutoCommit(false);
        try {
            for (StockOutItem item : items) {
                String selectSql = "SELECT displayQuantity, reservedQuantity, totalQuantity FROM painting_sizes WHERE paintingId = ? AND sizeId = ?";
                int display = 0, reserved = 0, total = 0;

                try (PreparedStatement stmt = con.prepareStatement(selectSql)) {
                    stmt.setInt(1, item.getProductId());
                    stmt.setInt(2, item.getSizeId());
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            display = rs.getInt("displayQuantity");
                            reserved = rs.getInt("reservedQuantity");
                            total = rs.getInt("totalQuantity");
                        } else {
                            throw new SQLException("Không tìm thấy bản ghi cho paintingId " + item.getProductId());
                        }
                    }
                }

                String updateSql = isDelivery
                        ? "UPDATE painting_sizes SET totalQuantity = totalQuantity - ?, reservedQuantity = reservedQuantity - ? WHERE paintingId = ? AND sizeId = ?"
                        : "UPDATE painting_sizes SET totalQuantity = totalQuantity - ? WHERE paintingId = ? AND sizeId = ?";

                try (PreparedStatement stmt = con.prepareStatement(updateSql)) {
                    stmt.setInt(1, item.getQuantity());
                    if (isDelivery) {
                        stmt.setInt(2, item.getQuantity());
                    }
                    stmt.setInt(isDelivery ? 3 : 2, item.getProductId());
                    stmt.setInt(isDelivery ? 4 : 3, item.getSizeId());
                    stmt.executeUpdate();
                }

                if (!isDelivery) {
                    int remainingTotal = total - item.getQuantity();
                    if (display > remainingTotal) {
                        display = remainingTotal;
                    }

                    String adjustSql = "UPDATE painting_sizes SET displayQuantity = ? WHERE paintingId = ? AND sizeId = ?";
                    try (PreparedStatement stmt = con.prepareStatement(adjustSql)) {
                        stmt.setInt(1, display);
                        stmt.setInt(2, item.getProductId());
                        stmt.setInt(3, item.getSizeId());
                        stmt.executeUpdate();
                    }
                }
            }

            con.commit();
            return true;
        } catch (Exception e) {
            con.rollback();
            e.printStackTrace();
            throw new SQLException("Lỗi khi áp dụng xuất kho", e);
        } finally {
            con.setAutoCommit(true);
        }
    }



    public int getQuantity(int productId, int sizeId) {
        String sql = "SELECT totalQuantity FROM painting_sizes WHERE paintingId = ? AND sizeId = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            stmt.setInt(2, sizeId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("totalQuantity");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean restore(int i) throws SQLException {
        String sql = "UPDATE paintings SET isDelete = 0 WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, i);

        PaintingCacheManager.clearAll();

        return ps.executeUpdate() > 0;
    }
}