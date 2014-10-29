package com.ibm.tap.misld.gui.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.sigbank.SoftwareLpar;
import com.ibm.tap.misld.delegate.baseline.MsHardwareBaselineReadDelegate;
import com.ibm.tap.misld.delegate.baseline.MsHardwareBaselineWriteDelegate;
import com.ibm.tap.misld.delegate.cndb.CountryCodeReadDelegate;
import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.Util;
import com.ibm.tap.misld.framework.exceptions.EditNotAllowedException;
import com.ibm.tap.misld.framework.exceptions.InvalidAccessException;

/**
 * @version 1.0
 * @author
 */
public class EditHardwareAction
        extends BaseAction

{
    public ActionForward home(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        UserContainer user = getUserContainer(request);
        String remoteUser = user.getRemoteUser();

        if (!user.isLoaded()) {
            return mapping.findForward(Constants.HOME);
        }

        if (user.getCustomer() == null) {
            return mapping.findForward(Constants.HOME);
        }

        String hardware = request.getParameter("hardware");
        int id;

        if (!Util.isInt(hardware)) {
            return mapping.findForward(Constants.ERROR);
        }

        try {
            id = Integer.parseInt(hardware);
        }
        catch (Exception e) {
            return mapping.findForward(Constants.ERROR);
        }
        
		// if account is locked, the software cannot be edited
		if (user.getCustomer().getMisldAccountSettings() != null) {
			if (user.getCustomer().getMisldAccountSettings().getStatus()
					.equals(Constants.LOCKED)) {
				throw new EditNotAllowedException();
			}
		}

        SoftwareLpar softwareLpar = MsHardwareBaselineReadDelegate
                .getSoftwareLpar(id);
        softwareLpar.setUsMachines(user.getCustomer()
                .getMisldAccountSettings().isUsMachines());
        Integer countryCodeId = softwareLpar.getCountryCodeId();

        String countryCodeDefault = "66";  // United States
        if (countryCodeId != null && (countryCodeId > 0)) {
        	countryCodeDefault = countryCodeId.toString();
        }
        
        softwareLpar.setCountryCodeDefault(countryCodeDefault);
        //List countryCodeList = CountryCodeReadDelegate.getCountryCodes();
        
        //softwareLpar.setUsMachines(user.getCustomer()
         //       .getMisldAccountSettings().isUsMachines());

        if (softwareLpar == null) {
            return mapping.findForward(Constants.ERROR);
        }

        user.setLevelOneOpenLink("/PodView.do");
        user.setLevelTwoOpenLink("/Pod.do?pod="
                + user.getCustomer().getPod().getPodId());

        request.setAttribute("softwareLpar", softwareLpar);
        request.setAttribute("countryCodes", CountryCodeReadDelegate.getCountryCodes());
        request.setAttribute("countryCodeDefault", countryCodeDefault);

        return mapping.findForward(Constants.SUCCESS);
    }

    public ActionForward saveHardware(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        UserContainer user = getUserContainer(request);

        if (!user.isLoaded()) {
            return mapping.findForward(Constants.HOME);
        }

        if (user.getCustomer() == null) {
            return mapping.findForward(Constants.HOME);
        }
		
		if (user.getCustomer().getMisldAccountSettings() != null) {
			if (user.getCustomer().getMisldAccountSettings().getStatus()
					.equals(Constants.LOCKED)) {
				throw new InvalidAccessException();
			}
		}
        user.setLevelOneOpenLink("/PodView.do");
        user.setLevelTwoOpenLink("/Pod.do?pod="
                + user.getCustomer().getPod().getPodId());

        if (isCancelled(request)) {
            return mapping.findForward(Constants.CANCEL);
        }

        SoftwareLpar softwareLparForm = (SoftwareLpar) form;
        
		SoftwareLpar softwareLpar = MsHardwareBaselineReadDelegate
		.getSoftwareLpar(Integer.parseInt(softwareLparForm.getId().toString()));

        MsHardwareBaselineWriteDelegate.saveHardwareBaseline(
                softwareLparForm, softwareLpar, request.getRemoteUser());

        return mapping.findForward(Constants.SUCCESS);
    }
}