/*
 * Created on May 31, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;
import java.util.Set;

import org.apache.struts.validator.ValidatorActionForm;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareLparEff extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long id;

	private SoftwareLpar softwareLpar;

	private Integer processorCount;

	private Set<SoftwareLparEffH> softwareLparEffHs;

	private String remoteUser;

	private String status;

	private Date recordTime;

	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return Returns the processorCount.
	 */
	public Integer getProcessorCount() {
		return processorCount;
	}

	/**
	 * @param processorCount
	 *            The processorCount to set.
	 */
	public void setProcessorCount(Integer processorCount) {
		this.processorCount = processorCount;
	}

	/**
	 * @return Returns the softwareLpar.
	 */
	public SoftwareLpar getSoftwareLpar() {
		return softwareLpar;
	}

	/**
	 * @param softwareLpar
	 *            The softwareLpar to set.
	 */
	public void setSoftwareLpar(SoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}

	/**
	 * @return Returns the softwareLparEffHs.
	 */
	public Set<SoftwareLparEffH> getSoftwareLparEffHs() {
		return softwareLparEffHs;
	}

	/**
	 * @param softwareLparEffHs
	 *            The softwareLparEffHs to set.
	 */
	public void setSoftwareLparEffHs(Set<SoftwareLparEffH> softwareLparEffHs) {
		this.softwareLparEffHs = softwareLparEffHs;
	}
	
	public Date getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}