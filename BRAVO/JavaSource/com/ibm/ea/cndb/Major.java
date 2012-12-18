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
public class Major implements Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long   majorId;

    private String majorName;

    /**
     * @return Returns the majorId.
     */
    public Long getMajorId() {
        return majorId;
    }

    /**
     * @param majorId
     *            The majorId to set.
     */
    public void setMajorId(Long majorId) {
        this.majorId = majorId;
    }

    /**
     * @return Returns the majorName.
     */
    public String getMajorName() {
        return majorName;
    }

    /**
     * @param majorName
     *            The majorName to set.
     */
    public void setMajorName(String majorName) {
        this.majorName = majorName;
    }
}