package com.example.web.controller.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.example.web.dao.PaintingDao;

import java.io.File;
import java.util.Map;

public class UploadImageBatchToCloudinary {

    public static void main(String[] args) {
        String localFolder = new File("src/main/webapp/assets/images/artists").getAbsolutePath();


        File folder = new File(localFolder);
        File[] files = folder.listFiles();

        if (files == null || files.length == 0) {
            System.out.println("Không tìm thấy file ảnh nào.");
            return;
        }

        Cloudinary cloudinary = ConfigCloudinary.getInstance();


        String webappPath = new File("src/main/webapp").getAbsolutePath();
        for (File file : files) {
             if (file.isFile()) {
                try {

                    String imagePath = file.getAbsolutePath();
                    String relativePath = imagePath.replace(webappPath + File.separator, "");
                    String cloudinaryFolder = relativePath
                            .substring(0, relativePath.lastIndexOf(File.separator))
                            .replace("\\", "/");

                    Map uploadResult = cloudinary.uploader().upload(file, ObjectUtils.asMap(
                            "folder", cloudinaryFolder
                    ));

                    String secureUrl = (String) uploadResult.get("secure_url");
                    String fileName = file.getName();

                    System.out.println("Uploaded " + fileName + " -> " + secureUrl);

                    PaintingDao.updateCloudImageUrl(fileName, secureUrl);

                } catch (Exception e) {
                    System.out.println("Lỗi upload ảnh " + file.getName());
                    e.printStackTrace();
                }
            }
        }
    }
}
