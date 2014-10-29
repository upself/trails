/*
 * Created on Aug 25, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.report;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class RegistrationStatus {

	private String podName;

	private String status;

	private Long count;

	public RegistrationStatus(String podName, String status, Long count) {
		this.podName = podName;
		this.status = status;
		this.count = count;
	}

	/**
	 * @return Returns the count.
	 */
	public Long getCount() {
		return count;
	}

	/**
	 * @param count
	 *            The count to set.
	 */
	public void setCount(Long count) {
		this.count = count;
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

	/**
	 * @return Returns the registrationStatus.
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * @param registrationStatus
	 *            The registrationStatus to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}
}
