package com.example.web.dao.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Log implements Serializable {
    private int id;
    private Level level;
    private LocalDateTime logTime;
    private String logWhere;
    private String resource;
    private String who;
    private String preData;
    private String flowData;

    public Log(final int id, final Level level, final LocalDateTime logTime, final String logWhere, final String resource, final String who, final String preData,final String flowData) {

        this.id = id;
        this.level = level;
        this.logTime = logTime;
        this.logWhere = logWhere;
        this.resource = resource;
        this.who = who;
        this.preData = preData;
        this.flowData = flowData;
    }
    public Log (){}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLevel() {
        return String.valueOf(level);
    }

    public void setLevel(Level level) {
        this.level = level;
    }

    public LocalDateTime getLogTime() {
        return logTime;
    }

    public void setLogTime(LocalDateTime logTime) {
        this.logTime = logTime;
    }

    public String getLogWhere() {
        return logWhere;
    }

    public void setLogWhere(String logWhere) {
        this.logWhere = logWhere;
    }

    public String getResource() {
        return resource;
    }

    public void setResource(String resource) {
        this.resource = resource;
    }

    public String getWho() {
        return who;
    }

    public void setWho(String who) {
        this.who = who;
    }

    public String getPreData() {
        return preData;
    }

    public void setPreData(String preData) {
        this.preData = preData;
    }

    public String getFlowData() {
        return flowData;
    }

    public void setFlowData(String flowData) {
        this.flowData = flowData;
    }

    @Override
    public String toString() {
        return "Log [id=" + id + ", level=" + level + ", logTime=" + logTime;
    }
}

