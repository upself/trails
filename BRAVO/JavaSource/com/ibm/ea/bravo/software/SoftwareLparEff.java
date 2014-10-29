/*
 * Created on May 31, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import java.util.Set;

import com.ibm.ea.bravo.framework.common.OrmBase;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareLparEff extends OrmBase {

	/**
     * 
     */
    private static final long serialVersionUID = 7055072448906954061L;

    private Long id;

	private SoftwareLpar softwareLpar;

	private Integer processorCount;

	private Set<SoftwareLparEffH> softwareLparEffHs;

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
}