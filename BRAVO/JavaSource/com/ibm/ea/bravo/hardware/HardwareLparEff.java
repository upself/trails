/*
 * Created on OCT 17, 2013
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.hardware;

import com.ibm.ea.bravo.framework.common.OrmBase;

/**
 * @author Tony
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class HardwareLparEff extends OrmBase {

	/**
	 * 
	 */
	private static final long serialVersionUID = 106386416805561052L;

	/**
     * 
     */
  
    private Long id;

	private HardwareLpar hardwareLpar;

	private Integer processorCount;

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
	public HardwareLpar getHardwareLpar() {
		return hardwareLpar;
	}

	/**
	 * @param HardwareLpar
	 *            The softwareLpar to set.
	 */
	public void setHardwareLpar(HardwareLpar hardwareLpar) {
		this.hardwareLpar = hardwareLpar;
	}

}