/*
 * Created on Feb 10, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.common;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Contact {

	private Long contactId;

	private String role;

	private String serial;

	private String fullName;

	private String remoteUser;

	private String notesMail;

	/**
	 * @return Returns the role.
	 */
	public String getRole() {
		return role;
	}

	/**
	 * @param role
	 *            The role to set.
	 */
	public void setRole(String role) {
		this.role = role;
	}

	/**
	 * @return Returns the notesMail.
	 */
	public String getNotesMail() {
		return notesMail;
	}

	/**
	 * @param notesMail
	 *            The notesMail to set.
	 */
	public void setNotesMail(String notesMail) {
		this.notesMail = notesMail;
	}

	/**
	 * @return Returns the contactId.
	 */
	public Long getContactId() {
		return contactId;
	}

	/**
	 * @param contactId
	 *            The contactId to set.
	 */
	public void setContactId(Long contactId) {
		this.contactId = contactId;
	}

	/**
	 * @return Returns the fullName.
	 */
	public String getFullName() {
		return fullName;
	}

	/**
	 * @param fullName
	 *            The fullName to set.
	 */
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	/**
	 * @return Returns the remoteUser.
	 */
	public String getRemoteUser() {
		return remoteUser;
	}

	/**
	 * @param remoteUser
	 *            The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	/**
	 * @return Returns the serial.
	 */
	public String getSerial() {
		return serial;
	}

	/**
	 * @param serial
	 *            The serial to set.
	 */
	public void setSerial(String serial) {
		this.serial = serial;
	}

}
