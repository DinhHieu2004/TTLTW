package com.example.web.dao.model;

import java.io.Serializable;

public class BestSalePaiting implements Serializable {
        private String title;
        private int totalSold;

        public BestSalePaiting(String title, int totalSold) {
            this.title = title;
            this.totalSold = totalSold;
        }

        public String getTitle() {
            return title;
        }

        public int getTotalSold() {
            return totalSold;
        }

    @Override
    public String toString() {
        return "BestSalePaiting{" +
                "title='" + title + '\'' +
                ", totalSold=" + totalSold +
                '}';
    }
}

