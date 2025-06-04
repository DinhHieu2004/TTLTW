package com.example.web.service;

import com.example.web.dao.SupplierDao;
import com.example.web.dao.model.Supplier;

import java.sql.SQLException;
import java.util.List;

public class SupplierService {
    private SupplierDao supdao = new SupplierDao();

    public List<Supplier> getAllSup() throws SQLException {
        return supdao.getAllSuppliers();
    }
    public Supplier addSupplier(Supplier sup) throws SQLException {
        return supdao.insertSupplier(sup);
    }

    public Supplier findByEmail(String email) throws SQLException {
        return supdao.findByEmail(email);
    }

    public Supplier getSupplierById(int id) throws SQLException {
        return supdao.getSupplierById(id);
    }

    public boolean updateSupplier(Supplier existing) throws SQLException {
        return supdao.updateSupplier(existing);
    }

    public boolean deleteSupplier(int id) throws SQLException {
        return supdao.deleteSupplier(id);
    }
}
