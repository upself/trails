/*
 * Created on Apr 24, 2007
 *
 */
package com.ibm.ea.cndb;

import java.io.Serializable;
/**
 * @author newtont
 *
 */
public class Region implements Serializable {
	private static final long serialVersionUID = 1L;
    private String name;
    private Long id;
    private Geography geography;
    
    /**
     * @return Returns the geography.
     */
    public Geography getGeography() {
        return geography;
    }
    /**
     * @param geography The geography to set.
     */
    public void setGeography(Geography geography) {
        this.geography = geography;
    }
   
    /**
     * @return Returns the id.
     */
    public Long getId() {
        return id;
    }
    /**
     * @param id The id to set.
     */
    public void setId(Long id) {
        this.id = id;
    }
    /**
     * @return Returns the name.
     */
    public String getName() {
        return name;
    }
    /**
     * @param name The name to set.
     */
    public void setName(String name) {
        this.name = name;
    }
}
