package com.ibm.tap.misld.gui.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.tap.misld.delegate.baseline.MsHardwareBaselineReadDelegate;
import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.exceptions.InvalidAccessException;

/**
 * @version 1.0
 * @author
 */
public class HardwareBaselineAction
        extends BaseAction

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

        if (user.getCustomer() == null) {
            return mapping.findForward(Constants.HOME);
        }

        user.setLevelOneOpenLink("/PodView.do");
        user.setLevelTwoOpenLink("/Pod.do?pod="
                + user.getCustomer().getPod().getPodId());

       request.setAttribute(Constants.HARDWARE_LIST,
                MsHardwareBaselineReadDelegate.getMsHardwareBaseline(user
                        .getCustomer()));

        return mapping.findForward(Constants.SUCCESS);
    }
}