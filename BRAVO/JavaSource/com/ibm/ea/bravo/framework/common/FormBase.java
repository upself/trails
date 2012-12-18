package com.ibm.ea.bravo.framework.common;

import java.util.HashMap;
import java.util.Map;

import org.apache.struts.action.ActionForm;

public class FormBase extends ActionForm {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String remoteUser;
	private String locked;
	private String formTitle;
	private String formAction;
	private String buttonType;
	private String formButtons;
	protected Map<String,String> readOnly = new HashMap<String, String>();

    public void createButtons(String[] buttonList) throws Exception {
    	String button="";
    	String buttons="";

    	String bsubmitOpen = "<input type=\"submit\" name=\"action\" value=\"";
    	String bsubmitClose ="\"/>";
    	
    	for(int i=0;i<buttonList.length;i++){
    		button = bsubmitOpen + buttonList[i] + bsubmitClose;
    		buttons = buttons + button;
    	}
    	
    	
    	this.setFormButtons(buttons);
    	
    }




	/**
	 * @return Returns the readOnly.
	 */
	public Map<String,String> getReadOnly() {
		return this.readOnly;
	}
	/**
	 * @param readOnly The readOnly to set.
	 */
	public void setReadOnly(Map<String,String> readOnly) {
		this.readOnly = readOnly;
	}
	/**
	 * @return Returns the buttonType.
	 */
	public String getButtonType() {
		return this.buttonType;
	}
	/**
	 * @param buttonType The buttonType to set.
	 */
	public void setButtonType(String buttonType) {
		this.buttonType = buttonType;
	}
	/**
	 * @return Returns the formAction.
	 */
	public String getFormAction() {
		return this.formAction;
	}
	/**
	 * @param formAction The formAction to set.
	 */
	public void setFormAction(String formAction) {
		this.formAction = formAction;
	}
	/**
	 * @return Returns the formButtons.
	 */
	public String getFormButtons() {
		return this.formButtons;
	}
	/**
	 * @param formButtons The formButtons to set.
	 */
	public void setFormButtons(String formButtons) {
		this.formButtons = formButtons;
	}
	/**
	 * @return Returns the formTitle.
	 */
	public String getFormTitle() {
		return this.formTitle;
	}
	/**
	 * @param formTitle The formTitle to set.
	 */
	public void setFormTitle(String formTitle) {
		this.formTitle = formTitle;
	}
	/**
	 * @return Returns the locked.
	 */
	public String getLocked() {
		return this.locked;
	}
	/**
	 * @param locked The locked to set.
	 */
	public void setLocked(String locked) {
		this.locked = locked;
	}
	/**
	 * @return Returns the remoteUser.
	 */
	public String getRemoteUser() {
		return this.remoteUser;
	}
	/**
	 * @param remoteUser The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}
}
