/*
 * Created on Feb 23, 2005
 * 
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.framework.email;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.apache.log4j.Logger;

import com.ibm.tap.delegate.acl.BluegroupsDelegate;
import com.ibm.tap.misld.framework.batch.email.BatchEmailQueue;

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

		// determine the recipients
		List emailRecipients = determineRecipients(recipient);

		// remove any dups
		Set emailSet = new TreeSet(emailRecipients);
		emailRecipients = new ArrayList(emailSet);

		// add the recipients
		email.setToRecipients(emailRecipients);
		logger.debug("sendMessage recipients = " + emailRecipients);

		// if the recipient list is not empty
		// send the message through the email Processor
		if (!emailRecipients.isEmpty())
			queue.addEmail(email);
	}

	public static void sendMessage(String subject, List torecipients,
			List ccrecipients, StringBuffer content) {

		if (torecipients == null) {
			logger.error("missing recipients");
			return;
		}

		List emailToRecipients = new ArrayList();
		List emailCcRecipients = new ArrayList();

		BaseEmail email = new BaseEmail();
		BatchEmailQueue queue = new BatchEmailQueue();

		// set the content & subject
		email.setContent(content);
		email.setSubject(subject);

		// process each member of the To list
		Iterator i = torecipients.iterator();
		while (i.hasNext()) {
			String recipient = (String) i.next();
			// System.out.println("recipient = " + recipient);
			emailToRecipients.addAll(determineRecipients(recipient));
		}

		// remove any dups
		Set emailSet = new TreeSet(emailToRecipients);
		emailToRecipients = new ArrayList(emailSet);

		// add the To recipients
		email.setToRecipients(emailToRecipients);
		logger.debug("sendMessage recipients = " + emailToRecipients);

		// process each member of the Cc list
		Iterator j = ccrecipients.iterator();
		while (j.hasNext()) {
			String recipient = (String) j.next();
			// System.out.println("recipient = " + recipient);
			if (recipient != null)
				emailCcRecipients.addAll(determineRecipients(recipient));
		}

		// remove any dups
		Set emailCcSet = new TreeSet(emailCcRecipients);
		emailCcRecipients = new ArrayList(emailCcSet);

		// add the Cc recipients
		email.setCcRecipients(emailCcRecipients);
		logger.debug("sendMessage Cc recipients = " + emailCcRecipients);

		// if the To recipient list is not empty
		// send the message through the email Processor
		if (!emailToRecipients.isEmpty())
			queue.addEmail(email);
	}

	private static List determineRecipients(String recipient) {
		List recipients = new ArrayList();

		// if the contact has an @ in it, its a single contact
		if (recipient.indexOf('@') != -1) {
			recipients.add(recipient);

			// otherwise, we need to go to bluegroups and figure out the
			// recipients
		} else {
			try {
				recipients = BluegroupsDelegate.listMemberEmails(recipient);
			} catch (Exception e) {
				logger.error("sendMessage ", e);
			}
		}

		return recipients;
	}
}
