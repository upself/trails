package com.ibm.tap.sigbank.manufacturer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import com.ibm.asset.swkbt.domain.Manufacturer;
import com.ibm.tap.sigbank.framework.common.BaseAction;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.exceptions.InvalidAccessException;
import com.ibm.tap.sigbank.framework.navigate.NavigationController;
import com.ibm.tap.sigbank.framework.navigate.SearchForm;

import com.ibm.tap.sigbank.usercontainer.UserContainer;

/**
 * @@version 1.0
 * @@author
 */
public class ActionManufacturer extends BaseAction {

    public ActionForward manufacturer(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        UserContainer user = loadUser(request);

        if (!user.isAdminAccess()) {
            throw new InvalidAccessException();
        }

        request.setAttribute(Constants.REPORT, ManufacturerDelegate
                .getManufacturers());

        user.setLevelOneOpenLink(NavigationController.manufacturerLink);

        return mapping.findForward(Constants.SUCCESS);
    }

    public ActionForward software(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        UserContainer user = loadUser(request);

        if (!user.isAdminAccess()) {
            throw new InvalidAccessException();
        }

        String id = request.getParameter("id");

        SearchForm sf = (SearchForm) form;
        if (sf == null) {
            sf = new SearchForm();
        }
        sf.setManufacturerId(id);
        sf.setSoftwareCategoryId("");
        sf.setSoftwareName("");

        user.setLevelOneOpenLink(NavigationController.manufacturerLink);

        return mapping.findForward(Constants.SUCCESS);
    }

}