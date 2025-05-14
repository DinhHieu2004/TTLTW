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
    Connection conn = DbConnect.getConnection();

    public SizeDao() {}

    public List<PaintingSize> getAllSizes() throws SQLException {
        List<PaintingSize> sizes = new ArrayList<PaintingSize>();
        String sql = "select * from sizes";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            String size = rs.getString("sizeDescription");
            double weight = rs.getDouble("weight");

            PaintingSize siz = new PaintingSize(id, size, weight);
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
    public boolean addSize(String description, String sizeWeight) throws SQLException {


        String sql = "INSERT INTO sizes (sizeDescription, weight) VALUES (?, ?)";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setString(1, description);
        statement.setDouble(2, Double.parseDouble(sizeWeight));

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

    public boolean updateSize(int id, String  sizeDescription, String weight) throws SQLException {
        String updateQuery = "UPDATE sizes SET sizeDescription = ?,  weight = ? WHERE id = ?";
        PreparedStatement statement = conn.prepareStatement(updateQuery);
        statement.setString(1,sizeDescription);
        statement.setDouble(2,Double.parseDouble(weight));

        statement.setInt(3, id);

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
