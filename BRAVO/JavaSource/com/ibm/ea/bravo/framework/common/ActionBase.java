/*
 * Created on Mar 16, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.framework.common;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.actions.MappingDispatchAction;

import com.ibm.ea.bravo.framework.batch.BatchQueue;
import com.ibm.ea.bravo.framework.batch.IBatch;
import com.ibm.ea.bravo.framework.user.UserContainer;
import com.ibm.ea.utils.EaUtils;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ActionBase extends MappingDispatchAction {

	protected void saveErrors(HttpServletRequest request, ActionErrors errors) {
		saveErrors(request, (ActionMessages) errors);
	}

	protected String getParameter(HttpServletRequest request, String name) {
		String parameter = new String();

		parameter = request.getParameter(name);
		if (EaUtils.isBlank(parameter)) {
			Object o = request.getAttribute(name);
			if (o != null) {
				parameter = (String) o;
			}
		}

		return parameter;
	}

	protected UserContainer getUserContainer(HttpServletRequest request) {

		HttpSession session = request.getSession();

		UserContainer existingContainer = (UserContainer) session
				.getAttribute(Constants.USER_CONTAINER);

		if (existingContainer == null) {
			existingContainer = new UserContainer();
		}

		return existingContainer;
	}

	protected void setUserContainer(HttpServletRequest request,
			UserContainer userContainer) {

		HttpSession session = request.getSession();

		session.setAttribute(Constants.USER_CONTAINER, userContainer);
	}

	protected UserContainer loadUser(HttpServletRequest request) {
		// store the user container object in the session
		UserContainer user = getUserContainer(request);
		setUserContainer(request, user);

		user.setRemoteUser(request.getRemoteUser().toLowerCase().trim());

		return user;

	}

	protected String convertListToString(List<Object> lst, String delim) {
		if (lst == null) {
			return "list is null";
		}

		// Object[] oArray = lst.toArray();
		Object[] oArray = (Object[]) lst.toArray(new Object[lst.size()]);
		StringBuffer strBuf = new StringBuffer();

		try {
			if (oArray.length > 0) {
				strBuf.append(oArray[0].toString());
			}
		} catch (ClassCastException cce) {
			// error handling here
			return "ClassCastException - Length of ArrayList is: "
					+ String.valueOf(oArray.length);
		}

		for (int i = 1; i < oArray.length; i++) {
			strBuf.append(delim + oArray[i].toString());
		}
		return strBuf.toString();
	}

	protected void addBatch(IBatch batch) {
		BatchQueue queue = new BatchQueue();
		queue.addBatch(batch);
	}
}
