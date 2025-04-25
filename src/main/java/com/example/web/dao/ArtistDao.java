package com.example.web.dao;

import com.example.web.dao.db.DbConnect;
import com.example.web.dao.model.Artist;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ArtistDao {
    private Connection con = DbConnect.getConnection();

    public ArtistDao() {

    }

    public List<Artist> getAllArtists() throws SQLException {
        List<Artist> artists = new ArrayList<Artist>();
        String sql = "select * from artists";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            String name = rs.getString("name");
            String bio = rs.getString("bio");
            Date date = rs.getDate("birthDate");
            String nationality = rs.getString("nationality");
            String photoUrl = rs.getString("photoUrl");
            String imageUrlCloud = rs.getString("imageUrlCloud");
            artists.add(new Artist(id, name, bio, date, nationality, photoUrl, imageUrlCloud));
        }
        return artists;
    }

    public Artist getArtistById(int id) throws SQLException {
        String sql = "select * from artists where id = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, id);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            String name = rs.getString("name");
            String bio = rs.getString("bio");
            Date date = rs.getDate("birthDate");
            String nationality = rs.getString("nationality");
            String photoUrl = rs.getString("photoUrl");
            String imageUrlCloud = rs.getString("imageUrlCloud");
            return new Artist(id, name, bio, date, nationality, photoUrl, imageUrlCloud);
        }
        return null;
    }



    public boolean deleteArtist(int i) throws SQLException {
        String query = "DELETE FROM artists WHERE id = ?";

        try (PreparedStatement preparedStatement = con.prepareStatement(query)) {
            preparedStatement.setInt(1, i);
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
        }
    }


    public boolean addArtist(Artist artist) throws SQLException {
        String sql = "INSERT INTO artists (name, bio, birthDate, nationality, photoUrl) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement statement = con.prepareStatement(sql);
        statement.setString(1, artist.getName());
        statement.setString(2, artist.getBio());
        statement.setDate(3, new java.sql.Date(artist.getBirthDate().getTime()));
        statement.setString(4, artist.getNationality());
        statement.setString(5, artist.getPhotoUrl());
        int rowsInserted = statement.executeUpdate();
        return rowsInserted > 0;

    }
    public boolean updateArtist(Artist artist) throws SQLException {
        String updateQuery = "UPDATE artists SET name = ?, bio = ?, birthDate = ?, nationality = ?, photoUrl = ? WHERE id = ?";
        PreparedStatement statement = con.prepareStatement(updateQuery);

        statement.setString(1, artist.getName());
        statement.setString(2, artist.getBio());
        statement.setDate(3,new java.sql.Date(artist.getBirthDate().getTime()));
        statement.setString(4, artist.getNationality());
        statement.setString(5, artist.getPhotoUrl());
        statement.setInt(6, artist.getId());

        int rowsAffected = statement.executeUpdate();

        return rowsAffected > 0;


    }
    public String getCurrentImagePath(int id) throws SQLException {
        String query = "SELECT photoUrl FROM paintings WHERE id = ?";
        String imagePath = null;
        PreparedStatement stmt = con.prepareStatement(query);
        stmt.setInt(1, id);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            imagePath = rs.getString("photoUrl");
        }
        return imagePath;
    }
}
