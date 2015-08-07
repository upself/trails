package com.ibm.asset.trails.ws.common;

import java.text.SimpleDateFormat;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.hibernate3.Hibernate3Module;

public class HibernateAwareObjectMapper extends ObjectMapper {

    public HibernateAwareObjectMapper() {
    	registerModule(new Hibernate3Module());
    	setDateFormat(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"));
    }
}