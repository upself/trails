package com.ibm.asset.trails.dao.jpa;

public class FilterCriteria {

    private Matcher matcher = Matcher.EXACT;

    private final String path;

    private final Object value;

    public FilterCriteria(String path, Object value) {
        this.path = path;
        this.value = value;
    }

    public FilterCriteria(String path, Object value, Matcher matcher) {
        this.path = path;
        this.value = value;
        this.matcher = matcher;
    }

    public Matcher getMatcher() {
        return matcher;
    }

    public Object getValue() {
        return value;
    }

    public String getPath() {
        return path;
    }

}
