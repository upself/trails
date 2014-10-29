package com.ibm.ea.bravo.contact;

import com.ibm.ea.bravo.framework.common.OrmBase;
import com.ibm.ea.bravo.hardware.HardwareLpar;

public class LparContact extends OrmBase {

	/**
     * 
     */
    private static final long serialVersionUID = -4338442970956042829L;
    private Long id;
	private ContactSupport contact;
	private HardwareLpar hardwareLpar;


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
	 * @return Returns the hardwareLpar.
	 */
	public HardwareLpar getHardwareLpar() {
		return this.hardwareLpar;
	}
	/**
	 * @param hardwareLpar The hardwareLpar to set.
	 */
	public void setHardwareLpar(HardwareLpar hardwareLpar) {
		this.hardwareLpar = hardwareLpar;
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
