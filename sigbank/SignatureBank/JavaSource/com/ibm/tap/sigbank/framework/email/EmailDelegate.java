/*
 * Created on Feb 23, 2005
 *
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.email;

import java.util.ArrayList;

import org.apache.log4j.Logger;

import com.ibm.tap.sigbank.framework.batch.email.BatchEmailQueue;

public abstract class EmailDelegate {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(EmailDelegate.class);

	public static void sendMessage(String subject, String recipient,
			StringBuffer content) {

		if (recipient == null) {
			logger.error("missing recipients");
			return;
		}

		BaseEmail email = new BaseEmail();
		BatchEmailQueue queue = new BatchEmailQueue();

		// set the content & subject
		email.setContent(content);
		email.setSubject(subject);

		// remove any dupes
		ArrayList<String> emailRecipients = new ArrayList<String>();
		emailRecipients.add(recipient);

		// add the recepients
		email.setRecipients(emailRecipients);
		logger.debug("sendMessage recipients = " + emailRecipients);

		// if the recipient list is not empty
		// send the message through the email Processor
		if (!emailRecipients.isEmpty())
			queue.addEmail(email);
	}
	
}
