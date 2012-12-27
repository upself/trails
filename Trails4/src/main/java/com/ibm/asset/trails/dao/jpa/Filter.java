package com.ibm.asset.trails.dao.jpa;

import java.util.ArrayList;
import java.util.List;

public class Filter {

    private final List<FilterCriteria> filterCriterias = new ArrayList<FilterCriteria>();

    public List<FilterCriteria> getFilterCriterias() {
        return filterCriterias;
    }

    public void addFilterCriteria(String path, Object value) {
        filterCriterias.add(new FilterCriteria(path, value));
    }

    public void addFilterCriteria(String path, Object value, Matcher matcher) {
        filterCriterias.add(new FilterCriteria(path, value, matcher));
    }

}
