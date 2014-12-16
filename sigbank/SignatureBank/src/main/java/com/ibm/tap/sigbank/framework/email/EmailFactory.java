/*
 * Created on Feb 23, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.email;

import java.text.MessageFormat;

import org.apache.struts.util.MessageResources;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public abstract class EmailFactory {

	public static String debugMessage = "{0} subject = {1}, requestor = {2}, description = {3}";

	public static String getSubject(MessageResources resources, String form,
			String action, String receiver, Object[] args) {
		if (resources == null)
			return null;

		String key = form + "." + action + "." + receiver + "." + "subject";
		String message = resources.getMessage(key);

		return MessageFormat.format(message, args);
	}

	public static String getContent(MessageResources resources, String form,
			String action, String receiver, Object[] args) {
		if (resources == null)
			return null;

		String key = form + "." + action + "." + receiver + "." + "content";
		String message = resources.getMessage(key);

		return MessageFormat.format(message, args);
	}
}
