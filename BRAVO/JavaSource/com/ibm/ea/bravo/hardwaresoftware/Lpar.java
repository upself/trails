/*
 * Created on Jun 20, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.hardwaresoftware;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;

import com.ibm.ea.bravo.hardware.HardwareLpar;
import com.ibm.ea.bravo.software.SoftwareLpar;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Lpar {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(Lpar.class);

	private HardwareLpar hardwareLpar;

	private SoftwareLpar softwareLpar;

	private String name;

	private String hwId;

	private String swId;

	public ActionErrors init() {
		logger.debug("Lpar.init");
		ActionErrors errors = new ActionErrors();

		if (this.hardwareLpar != null) {
			this.name = this.hardwareLpar.getName();
			this.hwId = this.hardwareLpar.getId().toString();
		}

		if (this.softwareLpar != null) {
			this.name = this.softwareLpar.getName();
			this.swId = this.softwareLpar.getId().toString();
		}

		return errors;
	}

	/**
	 * @return Returns the hardwareLpar.
	 */
	public HardwareLpar getHardwareLpar() {
		return this.hardwareLpar;
	}

	/**
	 * @param hardwareLpar
	 *            The hardwareLpar to set.
	 */
	public void setHardwareLpar(HardwareLpar hardwareLpar) {
		this.hardwareLpar = hardwareLpar;
	}

	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return this.name;
	}

	/**
	 * @param name
	 *            The name to set.
	 */
	public void setName(String lparName) {
		this.name = lparName;
	}

	/**
	 * @return Returns the softwareLpar.
	 */
	public SoftwareLpar getSoftwareLpar() {
		return this.softwareLpar;
	}

	/**
	 * @param softwareLpar
	 *            The softwareLpar to set.
	 */
	public void setSoftwareLpar(SoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}

	public String getHwId() {
		return this.hwId;
	}

	public void setHwId(String hwId) {
		this.hwId = hwId;
	}

	public String getSwId() {
		return this.swId;
	}

	public void setSwId(String swId) {
		this.swId = swId;
	}
}
