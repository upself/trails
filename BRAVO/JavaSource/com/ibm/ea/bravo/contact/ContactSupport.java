package com.ibm.ea.bravo.contact;

import com.ibm.ea.bravo.framework.common.OrmBase;

public class ContactSupport extends OrmBase {

	/**
     * 
     */
    private static final long serialVersionUID = -2216443952083159478L;
    private Long id;
	private String name;
	private String email;
	private String serial;
	private String serialMgr1;
	private String serialMgr2;
	private String serialMgr3;
	private String isManager;
	


	
	/**
	 * @return Returns the email.
	 */
	public String getEmail() {
		return this.email;
	}
	/**
	 * @param email The email to set.
	 */
	public void setEmail(String email) {
		this.email = email;
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
	/**
	 * @return Returns the isManager.
	 */
	public String getIsManager() {
		return this.isManager;
	}
	/**
	 * @param isManager The isManager to set.
	 */
	public void setIsManager(String isManager) {
		this.isManager = isManager;
	}
	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return this.name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return Returns the serial.
	 */
	public String getSerial() {
		return this.serial;
	}
	/**
	 * @param serial The serial to set.
	 */
	public void setSerial(String serial) {
		this.serial = serial;
	}
	/**
	 * @return Returns the serialMgr1.
	 */
	public String getSerialMgr1() {
		return this.serialMgr1;
	}
	/**
	 * @param serialMgr1 The serialMgr1 to set.
	 */
	public void setSerialMgr1(String serialMgr1) {
		this.serialMgr1 = serialMgr1;
	}
	/**
	 * @return Returns the serialMgr2.
	 */
	public String getSerialMgr2() {
		return this.serialMgr2;
	}
	/**
	 * @param serialMgr2 The serialMgr2 to set.
	 */
	public void setSerialMgr2(String serialMgr2) {
		this.serialMgr2 = serialMgr2;
	}
	/**
	 * @return Returns the serialMgr3.
	 */
	public String getSerialMgr3() {
		return this.serialMgr3;
	}
	/**
	 * @param serialMgr3 The serialMgr3 to set.
	 */
	public void setSerialMgr3(String serialMgr3) {
		this.serialMgr3 = serialMgr3;
	}
}
