/*
 * Created on May 26, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.sigbank.framework.batch;

import java.util.Date;

import org.apache.log4j.Logger;

/**
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class BatchBase {

	private Date startTime;

	private StringBuffer body = new StringBuffer();

	static Logger logger = Logger.getLogger(BatchBase.class);

	public String[] getStringFields(String row) {

		String patternStr = "	";
		String[] fields = row.split(patternStr);

		return fields;
	}

	/**
	 * @return Returns the startTime.
	 */
	public Date getStartTime() {
		return startTime;
	}

	/**
	 * @param startTime
	 *            The startTime to set.
	 */
	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	/**
	 * @return Returns the body.
	 */
	public StringBuffer getBody() {
		return body;
	}

	/**
	 * @param body
	 *            The body to set.
	 */
	public void setBody(StringBuffer body) {
		this.body = body;
	}

	public void addBodyln(String line) {
		body.append(line);
	}
}