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
public class Sector implements Serializable {
	
	private static final long serialVersionUID = 1L;

	private Long   sectorId;

    private String sectorName;

    /**
     * @return Returns the sectorId.
     */
    public Long getSectorId() {
        return sectorId;
    }

    /**
     * @param sectorId
     *            The sectorId to set.
     */
    public void setSectorId(Long sectorId) {
        this.sectorId = sectorId;
    }

    /**
     * @return Returns the sectorName.
     */
    public String getSectorName() {
        return sectorName;
    }

    /**
     * @param sectorName
     *            The sectorName to set.
     */
    public void setSectorName(String sectorName) {
        this.sectorName = sectorName;
    }
}
