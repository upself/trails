/*
 * Created on Feb 23, 2005
 *
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.framework.email;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.apache.log4j.Logger;

import com.ibm.ea.common.bluegroups.DelegateBluegroups;
import com.ibm.ea.utils.email.BatchEmailQueue;

public abstract class DelegateEmail {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(DelegateEmail.class);
	
		
	public static void sendMessage(String subject, String recipient, StringBuffer content) {
		boolean override = false;
		sendMessage(subject, recipient, content, override);
	}

	public static void sendMessage(String subject, String recipient, StringBuffer content, boolean override) {
		if (recipient == null) {
			logger.error("missing recipients");
			return;
		}
		
		BaseEmail email = new BaseEmail();
		BatchEmailQueue queue = new BatchEmailQueue();
		
		// if we're to ignore the config file entry for email enablement, do so
		email.setOverride(override);
			
		// set the content & subject
		email.setContent(content);
		email.setSubject(subject);
		
		// determine the recipients
		List<String> emailRecipients = determineRecipients(recipient);
		
		// remove any dupes
		Set<String> emailSet = new TreeSet<String>(emailRecipients);
		emailRecipients = new ArrayList<String>(emailSet);

		// add the recepients
		email.setRecipients(emailRecipients);
		logger.debug("sendMessage recipients = " + emailRecipients);
		
		// if the recipient list is not empty
		// send the message through the email Processor
		if (! emailRecipients.isEmpty())
			queue.addEmail(email);
    }

	public static void sendMessage(String subject, List<String> recipients, StringBuffer content) {
		boolean override = false;
		sendMessage(subject, recipients, content, override);
	}
	
	public static void sendMessage(String subject, List<String> recipients, StringBuffer content, boolean override) {

		if (recipients == null) {
			logger.error("missing recipients");
			return;
		}
		
		List<String> emailRecipients = new ArrayList<String>();
		
		BaseEmail email = new BaseEmail();
		BatchEmailQueue queue = new BatchEmailQueue();
		
		// if we're to ignore the config file entry for email enablement, do so
		email.setOverride(override);
			
		// set the content & subject
		email.setContent(content);
		email.setSubject(subject);
		
		// process each member of the list
		Iterator<String> i = recipients.iterator();
		while(i.hasNext()) {
			String recipient = (String) i.next();
			
			emailRecipients.addAll(determineRecipients(recipient));
		}

		// remove any dupes
		Set<String> emailSet = new TreeSet<String>(emailRecipients);
		emailRecipients = new ArrayList<String>(emailSet);

		// add the recepients
		email.setRecipients(emailRecipients);
		logger.debug("sendMessage recipients = " + emailRecipients);
		
		// if the recipient list is not empty
		// send the message through the email Processor
		if (! emailRecipients.isEmpty())
			queue.addEmail(email);
    }
	
	private static List<String> determineRecipients(String recipient) {
		List<String> recipients = new ArrayList<String>();
		
		// if the contact has an @ in it, its a single contact
		if (recipient.indexOf('@') != -1) {
			recipients.add(recipient);
		
		// otherwise, we need to go to bluegroups and figure out the recipients
		} else {
			try {
				recipients = DelegateBluegroups.listMemberEmails(recipient);
			} catch (Exception e) {
				logger.error("sendMessage ", e);
			}
		}
		
		return recipients;
	}
}
