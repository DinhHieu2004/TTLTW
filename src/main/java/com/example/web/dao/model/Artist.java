package com.example.web.dao.model;

import java.io.Serializable;
import java.util.Date;

public class Artist implements Serializable {
    private int id;
    private String name;
    private String bio;
    private Date birthDate;
    private String nationality;
    private String photoUrl;


    public Artist() {}
    public Artist(int id, String name, String bio, Date birthDate, String nationality, String photoUrl) {
        this.id = id;
        this.name = name;
        this.bio = bio;
        this.birthDate = birthDate;
        this.nationality = nationality;
        this.photoUrl = photoUrl;
    }
    public Artist( String name, String bio, Date birthDate, String nationality, String photoUrl) {
        this.name = name;
        this.bio = bio;
        this.birthDate = birthDate;
        this.nationality = nationality;
        this.photoUrl = photoUrl;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public String getNationality() {
        return nationality;
    }

    public void setNationality(String nationality) {
        this.nationality = nationality;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    @Override
    public String toString() {
        return "Artist{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", bio='" + bio + '\'' +
                ", birthDate=" + birthDate +
                ", nationality='" + nationality + '\'' +
                ", photoUrl='" + photoUrl + '\'' +
                '}';
    }
}
