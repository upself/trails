/*
 * Created on Feb 23, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.framework.email;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public abstract class EmailFactory {
	/**
	 * Logger for this class
	 */
	private static HashMap contentMap = new HashMap();
	
	static {
		contentMap.put(new String("createCustomer" + ":" + "requestor"),
					   new String("Your account creation request has been submitted for review.\n\nRequest Number: <requestNumber>\nAccount Name: <accountName>\n\n<link>\n"));
	}
	
	public static StringBuffer getContent(String state, String group, Map values) {
		String content = null;
		
		if (contentMap != null &&
			contentMap.get(state + ":" + group) != null) {
			
			// lookup the content based on method and group
			content = (String) contentMap.get(state + ":" + group);
			
			// attempt substitutions based on the incoming map of values
			if (values == null || values.keySet() == null)
				return new StringBuffer(content);
			
			Iterator i = values.keySet().iterator();
			while(i.hasNext()) {
				String key = (String) i.next();
				String value = (String) values.get(key);
				
				// replace any occurences of the key in content with the value
				Pattern p = Pattern.compile("<" + key + ">");
				Matcher m = p.matcher(content);
				content = m.replaceAll(value);
			}
		}
			
		return new StringBuffer(content);
	}
}
