package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.PaintingSize;
import com.example.web.dao.model.Theme;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SizeDao {
    static Connection conn = DbConnect.getConnection();

    public SizeDao() {}

    public List<PaintingSize> getAllSizes() throws SQLException {
        List<PaintingSize> sizes = new ArrayList<PaintingSize>();
        String sql = "select * from sizes";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            String size = rs.getString("sizeDescription");
            PaintingSize siz = new PaintingSize(id, size);
            sizes.add(siz);
        }
        return sizes;
    }
    public  PaintingSize getSizeById(int idSize) {
        PaintingSize size = null;
        try {
            String sql = "SELECT * FROM sizes WHERE id = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setInt(1, idSize);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                size = new PaintingSize();
                size.setIdSize(resultSet.getInt("id"));
                size.setSizeDescriptions(resultSet.getString("sizeDescription"));
                size.setWeight(resultSet.getDouble("weight"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return size;
    }
    public boolean addSize(String description) throws SQLException {
        String sql = "INSERT INTO sizes (sizeDescription) VALUES (?)";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setString(1, description);
        int rowsInserted = statement.executeUpdate();
        return rowsInserted > 0;

    }
    public int getLastInsertedId() throws SQLException {
        String query = "SELECT MAX(id) FROM sizes";

        try (
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    public boolean updateSize(int id, String  sizeDescription) throws SQLException {
        String updateQuery = "UPDATE sizes SET sizeDescription = ? WHERE id = ?";
        PreparedStatement statement = conn.prepareStatement(updateQuery);
        statement.setString(1,sizeDescription);
        statement.setInt(2, id);

        int rowsAffected = statement.executeUpdate();

        return rowsAffected > 0;


    }

    public boolean deleteSize(int i) throws SQLException {
        String query = "delete from sizes where id = ?";
        try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
            preparedStatement.setInt(1, i);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        }
    }


}
