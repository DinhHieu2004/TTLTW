package com.example.web.service;

import com.example.web.dao.ArtistDao;
import com.example.web.dao.model.Artist;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class ArtistService {
    private ArtistDao artistDao = new ArtistDao();

    public ArtistService() {}

    public List<Artist> getAllArtists() throws SQLException {
        return artistDao.getAllArtists();
    }
    public Artist getArtistById(int id) throws SQLException {
        return artistDao.getArtistById(id);
    }

    public static void main(String[] args) throws SQLException {
        ArtistService artistService = new ArtistService();
        for (Artist a : artistService.getAllArtists()){
            System.out.println(a);
        }
    }
    public boolean addArtist(String name, String bio, String birthday, String nationality, String photoUrl) throws SQLException, ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        Date d = sdf.parse(birthday);
        Artist artist = new Artist(name, bio, d, nationality, photoUrl);
        return artistDao.addArtist(artist);
    }
    public boolean updateArtist(Artist artist, String bd) throws SQLException {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            Date d = sdf.parse(bd);


            artist.setBirthDate(d);

            return artistDao.updateArtist(artist);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean deleteArtist(int i) throws SQLException {
        return artistDao.deleteArtist(i);
    }
    public String getCurrentImagePath(int id) throws SQLException {
        return  artistDao.getCurrentImagePath(id);
    }
}
