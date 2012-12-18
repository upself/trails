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
public class CountryCode implements Serializable {
	
	private static final long serialVersionUID = 1L;
    private String name;
    private Long id;
    private String code;
    private Region region;
    
    public String getDropDownName() {
        return code + " - " + name;
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
     * @return Returns the code.
     */
    public String getCode() {
        return code;
    }
    /**
     * @param code The code to set.
     */
    public void setCode(String code) {
        this.code = code;
    }
    /**
     * @return Returns the region.
     */
    public Region getRegion() {
        return region;
    }
    /**
     * @param region The region to set.
     */
    public void setRegion(Region region) {
        this.region = region;
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
