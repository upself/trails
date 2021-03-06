/*
 * Created on Aug 10, 2005
 *
 * 
 * 
 */
package com.ibm.ea.cndb;

import java.io.Serializable;
/**
 * @author newtont
 *
 * 
 * 
 */
public class Industry implements Serializable {
	private static final long serialVersionUID = 1L;
    private Long   industryId;
    private String industryName;

    /**
     * @return Returns the industryId.
     */
    public Long getIndustryId() {
        return industryId;
    }

    /**
     * @param industryId
     *            The industryId to set.
     */
    public void setIndustryId(Long industryId) {
        this.industryId = industryId;
    }

    /**
     * @return Returns the industryName.
     */
    public String getIndustryName() {
        return industryName;
    }

    /**
     * @param industryName
     *            The industryName to set.
     */
    public void setIndustryName(String industryName) {
        this.industryName = industryName;
    }
}