package com.example.web.service;

import com.example.web.dao.SizeDao;
import com.example.web.dao.model.Painting;
import com.example.web.dao.model.PaintingSize;

import java.sql.SQLException;
import java.util.List;

public class SizeService {
    private SizeDao sizeDao = new SizeDao();

    public SizeService (){

    }
    public List<PaintingSize> getAllSize() throws SQLException {
        return sizeDao.getAllSizes();
    }
    public PaintingSize getSizeById(int id) throws SQLException {
        return sizeDao.getSizeById(id);
    }
    public boolean updateSize(int id, String description, String sizeWeight) throws SQLException {
        return sizeDao.updateSize(id, description, sizeWeight);
    }
    public boolean addSize( String description, String sizeWeight) throws SQLException {
        return sizeDao.addSize( description, sizeWeight);
    }
    public boolean deleteSize(int id) throws SQLException {
        return sizeDao.deleteSize(id);
    }

    public int getLastInsertedId() throws SQLException {
        return sizeDao.getLastInsertedId();
    }



    public static void main(String[] args) throws SQLException {
        SizeService sizeService = new SizeService();
        System.out.println(sizeService.getSizeById(1));
    }
}
