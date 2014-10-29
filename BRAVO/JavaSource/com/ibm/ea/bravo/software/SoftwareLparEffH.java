/*
 * Created on Jun 3, 2006
 * 
 * TODO To change the template for this generated file go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import com.ibm.ea.bravo.framework.common.OrmBase;

public class SoftwareLparEffH extends OrmBase {

	/**
     * 
     */
    private static final long serialVersionUID = -204191009302057700L;

    private Long id;

	private Integer processorCount;

	private String action;

	private SoftwareLparEff softwareLparEff;

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
	 * @return Returns the action.
	 */
	public String getAction() {
		return action;
	}

	/**
	 * @param action
	 *            The action to set.
	 */
	public void setAction(String action) {
		this.action = action;
	}

	public SoftwareLparEff getSoftwareLparEff() {
		return softwareLparEff;
	}

	public void setSoftwareLparEff(SoftwareLparEff softwareLparEff) {
		this.softwareLparEff = softwareLparEff;
	}
}
