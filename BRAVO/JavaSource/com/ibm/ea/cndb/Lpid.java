/*
 * Created on Feb 11, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.cndb;

import java.io.Serializable;



/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Lpid implements Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long   lpidId;

    private String lpidName;

    private Major  major;

    /**
     * @return Returns the lpidId.
     */
    public Long getLpidId() {
        return lpidId;
    }

    /**
     * @param lpidId
     *            The lpidId to set.
     */
    public void setLpidId(Long lpidId) {
        this.lpidId = lpidId;
    }

    /**
     * @return Returns the lpidName.
     */
    public String getLpidName() {
        return lpidName;
    }

    /**
     * @param lpidName
     *            The lpidName to set.
     */
    public void setLpidName(String lpidName) {
        this.lpidName = lpidName;
    }

    /**
     * @return Returns the major.
     */
    public Major getMajor() {
        return major;
    }

    /**
     * @param major
     *            The major to set.
     */
    public void setMajor(Major major) {
        this.major = major;
    }
}