package com.example.web.service;

import com.example.web.controller.util.PaintingCacheManager;
import com.example.web.dao.PaintingDao;
import com.example.web.dao.model.*;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PaintingService {
    private PaintingDao paintingDao = new PaintingDao();

    public List<Painting> getPaintingList(String searchKeyword, Double minPrice, Double maxPrice, String[] themes, String[] artists, String startDate, String endDate, boolean isSortByRating, boolean snew, int currentPage, int recordsPerPage) throws SQLException {
        String cacheKey = generateKey(searchKeyword, minPrice, maxPrice, themes, artists, startDate, endDate, isSortByRating, snew, currentPage, recordsPerPage);

        List<Painting> cachedResult = PaintingCacheManager.getCached(cacheKey);
        if (cachedResult != null) {
            return cachedResult;
        }

        List<Painting> paintingList = paintingDao.getPaintingList(searchKeyword, minPrice, maxPrice, themes, artists, startDate, endDate, isSortByRating, snew, currentPage, recordsPerPage);

        PaintingCacheManager.put(cacheKey, paintingList);
        return paintingList;
    }

    private String generateKey(String kw, Double min, Double max, String[] themes, String[] artists, String start, String end, boolean rating, boolean snew, int page, int perPage) {
        return String.format("kw:%s|min:%s|max:%s|themes:%s|artists:%s|start:%s|end:%s|rating:%s|snew:%s|page:%d|perPage:%d",
                kw, min, max,
                themes != null ? String.join(",", themes) : "",
                artists != null ? String.join(",", artists) : "",
                start, end, rating, snew, page, perPage);
    }

    public int countPaintings(String keyword,Double minPrice, Double maxPrice, String[] themes, String[] artists,String startDate,String endDate) throws SQLException {
        return paintingDao.countPaintings(keyword, minPrice, maxPrice, themes, artists, startDate,endDate);
    }

    public Painting getPainting(int id) throws SQLException {
        return paintingDao.getPaintingDetail(id);
    }

    public List<Painting> getListPaintingByArtist(int id) throws SQLException {
        return paintingDao.getListPaintingByArtist(id);
    }
    public List<Painting> getRandomTopRatedPaintings() throws SQLException {
        return paintingDao.getRandomTopRatedPaintings();
    }

    public List<Painting> getPaintingListByArtist(Double minPrice, Double maxPrice, String[] sizes, String[] themes, String artist) throws SQLException {
        return paintingDao.getPaintingListByArtist(minPrice, maxPrice, sizes, themes, artist);
    }

    public List<Painting> getAll() throws SQLException {
        return paintingDao.getAll();
    }
    public List<Painting> getNewestPaintings() throws SQLException {
        return paintingDao.getNewestPaintings(4);
    }

    public List<Painting> getAllListDelete() throws SQLException {
        return paintingDao.getAllDelete();
    }


    public boolean updatePainting(int id, String title, int themeId, double price, int artistId, String description, String imageUrl, boolean isSold, boolean isFeatured) throws SQLException {

        return paintingDao.updatePainting( id, title, themeId,isSold, price, artistId, description, imageUrl, isFeatured);

    }

    public boolean updatePaintingSizes(int paintingId, List<Integer> sizeIds, List<Integer> quantities) throws SQLException {
        return paintingDao.updatePaintingSizes( paintingId, sizeIds, quantities);


    }
    public int addPainting(String title, int themeId, double price, int artistId, String description, String imageUrl, boolean isFeatured) throws SQLException {
        return paintingDao.addPainting(title, themeId, price, artistId, description, imageUrl, isFeatured);

    }

    public boolean addPaintingSizes(int paintingId, List<Integer> sizeIds, List<Integer> quantities) throws SQLException {
        return paintingDao.addPaintingSizes(paintingId, sizeIds, quantities);


    }
    public Painting getPaintingByItemId(int itemId) throws SQLException {
        return paintingDao.getPaitingByItemId(itemId);
    }


    public static void main(String[] args) throws SQLException {
        PaintingService paintingService = new PaintingService();
        System.out.println(paintingService.getAll());
    }


    public Painting getPaintingDetail(int id) throws SQLException {
        return paintingDao.getPaintingDetail(id);
    }

    public boolean deletePainting(int i) throws SQLException {
        return paintingDao.deletePainting(i);
    }

    public String getCurrentImagePath(int id) throws SQLException {
        return paintingDao.getCurrentImagePath(id);
    }


    public List<String> getPaintingSg(String keyword, int limit) throws SQLException {
        return paintingDao.getPaintingSg(keyword, limit);


    }
    public boolean applySI(List<StockInItem> items) throws SQLException {
        return paintingDao.applySI(items);
    }

    public boolean applySO(List<StockOutItem> items, boolean isDelivery) throws SQLException {
        return paintingDao.applySO(items, isDelivery);
    }

    public int getQuantity(int productId, int sizeId) {
        return paintingDao.getQuantity(productId, sizeId);
    }

    public List<Painting> getRandomPaintingsByArtist(int artistId, int id) throws SQLException {
        return paintingDao.getRandomPaintingsByArtist(artistId, id);
    }

    public List<Painting> getRandomPaintingsByTheme(int themeId, int id) throws SQLException {
        return paintingDao.getRandomPaintingsByTheme(themeId, id);
    }

    public boolean restore(int i)  throws SQLException{
        return paintingDao.restore(i);
    }
}
