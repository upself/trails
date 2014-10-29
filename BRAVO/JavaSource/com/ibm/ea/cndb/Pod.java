/*
 * Created on Aug 10, 2005
 *
 * 
 * 
 */
package com.ibm.ea.cndb;


import java.io.Serializable;

import org.apache.struts.validator.ValidatorActionForm;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Pod extends ValidatorActionForm implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long podId;

	private String podName;

	/**
	 * @return Returns the podId.
	 */
	public Long getPodId() {
		return podId;
	}

	/**
	 * @param podId
	 *            The podId to set.
	 */
	public void setPodId(Long podId) {
		this.podId = podId;
	}

	/**
	 * @return Returns the podName.
	 */
	public String getPodName() {
		return podName;
	}

	/**
	 * @param podName
	 *            The podName to set.
	 */
	public void setPodName(String podName) {
		this.podName = podName;
	}
}