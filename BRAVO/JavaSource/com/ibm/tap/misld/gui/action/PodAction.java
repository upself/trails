package com.ibm.tap.misld.gui.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.cndb.Pod;
import com.ibm.tap.misld.delegate.cndb.CustomerReadDelegate;
import com.ibm.tap.misld.delegate.cndb.PodReadDelegate;
import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.exceptions.InvalidAccessException;

/**
 * @version 1.0
 * @author
 */
public class PodAction extends BaseAction

{
	public ActionForward home(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}

		if (!user.isAsset()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Pod.do");

		Pod podForm = (Pod) form;

		if (podForm.getPodId() != null) {
			Pod pod = PodReadDelegate.getPod(podForm.getPodId());
			user.setPod(pod);
			setUserContainer(request, user);
		} else {
			request.setAttribute("pod", user.getPod());
		}

		request.setAttribute(Constants.POD_LIST, PodReadDelegate.getPods());

		request.setAttribute(Constants.CUSTOMER_LIST, CustomerReadDelegate
				.getCustomersByPod(user.getPod()));

		return mapping.findForward(Constants.SUCCESS);
	}
	
	public ActionForward registrationStatus(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}

		if (!user.isAsset()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Pod.do");

		return mapping.findForward(Constants.SUCCESS);
	}
}