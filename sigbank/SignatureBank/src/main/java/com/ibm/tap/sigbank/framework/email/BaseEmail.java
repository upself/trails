/*
 * Created on Feb 25, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.email;

import java.util.Date;
import java.util.List;

import com.ibm.tap.sigbank.framework.batch.email.IBatchEmail;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class BaseEmail implements IBatchEmail {

	private List recipients;

	private StringBuffer content;

	private String subject;

	private Date date;

	/**
	 * @return Returns the content.
	 */
	public StringBuffer getContent() {
		return content;
	}

	/**
	 * @param content
	 *            The content to set.
	 */
	public void setContent(StringBuffer content) {
		this.content = content;
	}

	/**
	 * @return Returns the recipients.
	 */
	public List getRecipients() {
		return recipients;
	}

	/**
	 * @param recipients
	 *            The recipients to set.
	 */
	public void setRecipients(List recipients) {
		this.recipients = recipients;
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

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.oscar.framework.batch.email.IBatchEmail#getName()
	 */
	public String getName() {
		return subject;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.oscar.framework.batch.email.IBatchEmail#getStartTime()
	 */
	public Date getStartTime() {
		return date;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.ibm.oscar.framework.batch.email.IBatchEmail#setStartTime(java.util.Date)
	 */
	public void setStartTime(Date date) {
		this.date = date;
	}
}
