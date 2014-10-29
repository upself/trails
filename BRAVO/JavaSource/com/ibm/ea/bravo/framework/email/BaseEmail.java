/*
 * Created on Feb 25, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.framework.email;

import java.util.Date;
import java.util.List;

import com.ibm.ea.utils.email.IBatchEmail;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class BaseEmail implements IBatchEmail {
	
	private List<String> recipients;
	private StringBuffer content;
	private String subject;
	private Date date;
	private boolean override = false;
	
	/**
	 * @return Returns the date.
	 */
	public Date getDate() {
		return this.date;
	}
	/**
	 * @param date The date to set.
	 */
	public void setDate(Date date) {
		this.date = date;
	}
	/**
	 * @return Returns the override.
	 */
	public boolean isOverride() {
		return this.override;
	}
	/**
	 * @param override The override to set.
	 */
	public void setOverride(boolean override) {
		this.override = override;
	}
	/**
	 * @return Returns the content.
	 */
	public StringBuffer getContent() {
		return this.content;
	}
	/**
	 * @param content The content to set.
	 */
	public void setContent(StringBuffer content) {
		this.content = content;
	}
	/**
	 * @return Returns the recipients.
	 */
	public List<String> getRecipients() {
		return this.recipients;
	}
	/**
	 * @param recipients The recipients to set.
	 */
	public void setRecipients(List<String> recipients) {
		this.recipients = recipients;
	}
	/**
	 * @return Returns the subject.
	 */
	public String getSubject() {
		return this.subject;
	}
	/**
	 * @param subject The subject to set.
	 */
	public void setSubject(String subject) {
		this.subject = subject;
	}
	/* (non-Javadoc)
	 * @see com.ibm.oscar.framework.batch.email.IBatchEmail#getName()
	 */
	public String getName() {
		return this.subject;
	}
	/* (non-Javadoc)
	 * @see com.ibm.oscar.framework.batch.email.IBatchEmail#getStartTime()
	 */
	public Date getStartTime() {
		return this.date;
	}
	/* (non-Javadoc)
	 * @see com.ibm.oscar.framework.batch.email.IBatchEmail#setStartTime(java.util.Date)
	 */
	public void setStartTime(Date date) {
		this.date = date;
	}
}
