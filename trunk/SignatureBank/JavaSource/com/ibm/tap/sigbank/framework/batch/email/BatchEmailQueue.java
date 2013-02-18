package com.ibm.tap.sigbank.framework.batch.email;

import java.util.Date;
import java.util.LinkedList;

/**
 * 
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class BatchEmailQueue {

	// This "static" is the key to the whole thing
	// because this data structure is static, anything that creates
	// an instance of BatchEmailQueue gets to use the same data structure
	private static LinkedList<IBatchEmail> q = new LinkedList<IBatchEmail>();

	public void addEmail(IBatchEmail email) {
		// set the email's date
		email.setStartTime(new Date());

		// add the email to the queue
		q.add(email);
	}

	public IBatchEmail getEmail() {
		if (q.isEmpty()) {
			return null;
		}
		return (IBatchEmail) q.getFirst();
	}

	public boolean isEmpty() {
		return q.isEmpty();
	}

	public IBatchEmail popEmail() {
		if (q.isEmpty())
			return null;

		return (IBatchEmail) q.removeFirst();
	}

}