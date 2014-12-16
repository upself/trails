package com.ibm.tap.sigbank.framework.email;

import org.apache.struts.action.ActionForm;

/**
 * Form bean for a Struts application. Users may access 4 fields on this form:
 * <ul>
 * <li>receiver - [your comment here]
 * <li>form - [your comment here]
 * <li>link - [your comment here]
 * <li>number - [your comment here]
 * </ul>
 * 
 * @version 1.0
 * @author
 */
public class TestForm extends ActionForm

{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String form = null;

	private String action = null;

	private String receiver = null;

	private String link = null;

	private String number = null;

	private String subject = null;

	private String content = null;

	/**
	 * @return Returns the form.
	 */
	public String getForm() {
		return form;
	}

	/**
	 * @param form
	 *            The form to set.
	 */
	public void setForm(String form) {
		this.form = form;
	}

	/**
	 * Get receiver
	 * 
	 * @return String
	 */
	public String getReceiver() {
		return receiver;
	}

	/**
	 * Set receiver
	 * 
	 * @param <code>String</code>
	 */
	public void setReceiver(String r) {
		this.receiver = r;
	}

	/**
	 * @return Returns the action.
	 */
	public String getAction() {
		return action;
	}

	/**
	 * @param action
	 *            The action to set.
	 */
	public void setAction(String action) {
		this.action = action;
	}

	/**
	 * Get link
	 * 
	 * @return String
	 */
	public String getLink() {
		return link;
	}

	/**
	 * Set link
	 * 
	 * @param <code>String</code>
	 */
	public void setLink(String l) {
		this.link = l;
	}

	/**
	 * Get number
	 * 
	 * @return String
	 */
	public String getNumber() {
		return number;
	}

	/**
	 * Set number
	 * 
	 * @param <code>String</code>
	 */
	public void setNumber(String n) {
		this.number = n;
	}

	/**
	 * @return Returns the content.
	 */
	public String getContent() {
		return content;
	}

	/**
	 * @param content
	 *            The content to set.
	 */
	public void setContent(String content) {
		this.content = content;
	}

	/**
	 * @return Returns the subject.
	 */
	public String getSubject() {
		return subject;
	}

	/**
	 * @param subject
	 *            The subject to set.
	 */
	public void setSubject(String subject) {
		this.subject = subject;
	}
}
