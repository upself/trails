package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity(name = "AlertHardwareLparNew")
@Table(name = "ALERT_HARDWARE_LPAR")
public class DataExceptionHardwareLpar extends DataException implements
		Serializable {

	/**
     * 
     */
	private static final long serialVersionUID = 1L;

	@ManyToOne
	@JoinColumn(name = "HARDWARE_LPAR_ID")
	protected HardwareLpar hardwareLpar;

	/**
	 * @return the hardwareLpar
	 */
	public HardwareLpar getHardwareLpar() {
		return hardwareLpar;
	}

	/**
	 * @param hardwareLpar
	 *            the hardwareLpar to set
	 */
	public void setHardwareLpar(HardwareLpar hardwareLpar) {
		this.hardwareLpar = hardwareLpar;
	}

}
