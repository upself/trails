package com.ibm.ea.bravo.contact;

import com.ibm.ea.bravo.framework.common.OrmBase;
import com.ibm.ea.bravo.hardware.Hardware;

public class HardwareContact extends OrmBase {

	/**
     * 
     */
    private static final long serialVersionUID = -157819433323250296L;
    private Long id;
	private ContactSupport contact;
	private Hardware hardware;
	
	/**
	 * @return Returns the contact.
	 */
	public ContactSupport getContact() {
		return this.contact;
	}
	/**
	 * @param contact The contact to set.
	 */
	public void setContact(ContactSupport contact) {
		this.contact = contact;
	}
	/**
	 * @return Returns the hardware.
	 */
	public Hardware getHardware() {
		return this.hardware;
	}
	/**
	 * @param hardware The hardware to set.
	 */
	public void setHardware(Hardware hardware) {
		this.hardware = hardware;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return this.id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
}
