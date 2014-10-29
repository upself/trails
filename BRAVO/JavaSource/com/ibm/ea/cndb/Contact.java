package com.ibm.ea.cndb;

import java.io.Serializable;

public class Contact implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
    private Long   contactId;

    private String role;

    private String serial;

    private String fullName;

    private String remoteUser;

    private String notesMail;
	
	private boolean manager;
	
	private String managerSerial;

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
	
	public boolean isManager()
	{
		return this.manager;
	}
	
	public void setManager( boolean manager )
	{
		this.manager = manager;
	}
	
	public String getManagerSerial()
	{
		return this.managerSerial;
	}
	
	public void setManagerSerial( String managerSerial )
	{
		this.managerSerial = managerSerial;
	}

}
