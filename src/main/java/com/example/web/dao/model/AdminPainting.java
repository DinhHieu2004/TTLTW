package com.example.web.dao.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AdminPainting {
    public boolean insert(Painting f) {
        try {
            Connection con = null;
            PreparedStatement pst = con.prepareStatement("insert into Painting values(?,?,?,?,?,?,?,?,?,?)");
            pst.setInt(1, f.getId());
            pst.setString(2, f.getTitle());
            pst.setDouble(3, f.getPrice());
            pst.setString(4, f.getDescription());
            pst.setString(5, f.getImageUrl());
            pst.setString(6, f.getArtistName());
            pst.setString(7, f.getThemeName());
            pst.setString(8, f.getDiscountName());
            pst.setDouble(9, f.getDiscountPercentage());
            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Painting f) {
        try {
            Connection con=null;
            PreparedStatement pst = con.prepareStatement("update painting set paintingname=?,unit=?,price=?,priceold=?,brief=?,description=?,picture=?,createdate=?,active=? where flowerid=?");
            pst.setInt(10, f.getId());
            pst.setString(1, f.getTitle());
            pst.setDouble(3, f.getPrice());
            pst.setString(4, f.getDescription());
            pst.setString(5, f.getImageUrl());
            pst.setString(6, f.getArtistName());
            pst.setString(7, f.getThemeName());
            pst.setString(8, f.getDiscountName());
            pst.setDouble(9, f.getDiscountPercentage());
            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(String Paintingid) {
        try {
            Connection con = null;
            PreparedStatement pst = con.prepareStatement("delete from painting where flowerid=?");
            pst.setString(1, Paintingid);
            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
