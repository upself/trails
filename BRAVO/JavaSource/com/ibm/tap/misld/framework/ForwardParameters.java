package com.ibm.tap.misld.framework;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.struts.action.ActionForward;

/**
 * Encupsulates parameters for ActionForward.
 */
public class ForwardParameters {
	private Map params = new HashMap();

	public ForwardParameters add(String paramName, String paramValue) {
		params.put(paramName, paramValue);
		return this;
	}

	/**
	 * Add parameters to provided ActionForward
	 * 
	 * @param forward
	 *            ActionForward to add parameters to
	 * @return ActionForward with added parameters to URL
	 */
	public ActionForward forward(ActionForward forward) {
		StringBuffer path = new StringBuffer(forward.getPath());
		Iterator iter = params.entrySet().iterator();
		if (iter.hasNext()) {
			//add first parameter, if avaliable
			Map.Entry entry = (Map.Entry) iter.next();
			path.append("?" + entry.getKey() + "=" + entry.getValue());
			//add other parameters
			while (iter.hasNext()) {
				entry = (Map.Entry) iter.next();
				path.append("&" + entry.getKey() + "=" + entry.getValue());
			}
		}

		return new ActionForward(path.toString(), true);
	}
}