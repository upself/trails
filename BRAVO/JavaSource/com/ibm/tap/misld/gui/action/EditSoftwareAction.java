package com.ibm.tap.misld.gui.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessages;

import com.ibm.ea.sigbank.InstalledSoftware;
import com.ibm.ea.sigbank.InstalledSoftwareEff;
import com.ibm.tap.misld.delegate.baseline.MsInstalledSoftwareBaselineReadDelegate;
import com.ibm.tap.misld.delegate.baseline.MsInstalledSoftwareBaselineWriteDelegate;
import com.ibm.tap.misld.delegate.software.SoftwareReadDelegate;
import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.ForwardParameters;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.Util;
import com.ibm.tap.misld.framework.exceptions.EditNotAllowedException;
import com.ibm.tap.misld.framework.exceptions.InvalidAccessException;
import com.ibm.tap.misld.om.baseline.MsInstalledSoftwareBaseline;

/**
 * @version 1.0
 * @author
 */
public class EditSoftwareAction extends BaseAction

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

		String hardware = request.getParameter("hardware");
		//int msHardwareBaselineId;
		int id;

		if (!Util.isInt(hardware)) {
			return mapping.findForward(Constants.ERROR);
		}

		try {
			//msHardwareBaselineId = Integer.parseInt(hardware);
			id = Integer.parseInt(hardware);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}

		List softwareList = MsInstalledSoftwareBaselineReadDelegate
				.getAllSoftware(id);


		if (softwareList == null) {
			return mapping.findForward(Constants.ERROR);
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		request.setAttribute("id", new Integer(
				id));
		request.setAttribute(Constants.SOFTWARE_LIST, softwareList);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward edit(ActionMapping mapping, ActionForm form,
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

		String software = request.getParameter("software");
		int id;

		if (!Util.isInt(software)) {
			return mapping.findForward(Constants.ERROR);
		}

		try {
			id = Integer.parseInt(software);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}	
		
		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		// if account is locked, the software cannot be edited
		if (user.getCustomer().getMisldAccountSettings() != null) {
			if (user.getCustomer().getMisldAccountSettings().getStatus()
					.equals(Constants.LOCKED)) {
				throw new EditNotAllowedException();
			}
		}
		
		InstalledSoftware installedSoftware = MsInstalledSoftwareBaselineReadDelegate
				.getInstalledSoftware(id);
		
		InstalledSoftwareEff installedSoftwareEff = installedSoftware.getInstalledSoftwareEff();
		if (installedSoftwareEff == null) {
			installedSoftwareEff = new InstalledSoftwareEff();
		}

		installedSoftwareEff
				.setSoftwareCategoryName(installedSoftware
						.getSoftware().getSoftwareCategory()
						.getSoftwareCategoryName());
		installedSoftwareEff
				.setSoftwareCategoryId(installedSoftware
						.getSoftware().getSoftwareCategory()
						.getSoftwareCategoryId().intValue());
		installedSoftwareEff
				.setSoftwareLparId(installedSoftware.getSoftwareLpar().getId());
		installedSoftwareEff
				.setSoftwareName(installedSoftware
						.getSoftware().getSoftwareName());
		
		installedSoftwareEff.setInstalledSoftware(installedSoftware);
		installedSoftwareEff.setInstalledSoftwareId(id);
		
		if (installedSoftware.getInstalledSoftwareEff() == null) {

			installedSoftwareEff.setOwner(installedSoftware.getSoftwareOwner());
			installedSoftwareEff.setUserCount(1000);
			installedSoftwareEff.setAuthenticated(installedSoftware.getAuthenticated());
			
		} 
				
		request.setAttribute("installedSoftware", installedSoftware);
		request.setAttribute("installedSoftwareEff", installedSoftwareEff);


		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward saveSoftware(ActionMapping mapping, ActionForm form,
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

		if (user.getCustomer().getMisldAccountSettings() != null) {
			if (user.getCustomer().getMisldAccountSettings().getStatus()
					.equals(Constants.LOCKED)) {
				throw new EditNotAllowedException();
			}
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		InstalledSoftwareEff installedSoftwareEffForm = (InstalledSoftwareEff) form;
		
		InstalledSoftware installedSoftware = MsInstalledSoftwareBaselineReadDelegate
												.getInstalledSoftware(installedSoftwareEffForm.getInstalledSoftwareId());

		Long softwareLparId = installedSoftwareEffForm.getSoftwareLparId();

		if (isCancelled(request)) {

			return new ForwardParameters().add("hardware",
					"" + softwareLparId).forward(
					mapping.findForward(Constants.CANCEL));
		}

		ActionErrors errors = new ActionErrors();
		errors = form.validate(mapping, request);

		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return new ActionForward(mapping.getInput());
		}

		MsInstalledSoftwareBaselineWriteDelegate.saveSoftware(
				installedSoftwareEffForm, installedSoftware,
				user.getRemoteUser());

		return new ForwardParameters().add("hardware",
				"" + softwareLparId).forward(
				mapping.findForward(Constants.SUCCESS));

	}

	public ActionForward saveOsSoftware(ActionMapping mapping, ActionForm form,
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

		if (user.getCustomer().getMisldAccountSettings() != null) {
			if (user.getCustomer().getMisldAccountSettings().getStatus()
					.equals(Constants.LOCKED)) {
				throw new InvalidAccessException();
			}
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		InstalledSoftwareEff installedSoftwareEffForm = (InstalledSoftwareEff) form;
		
		InstalledSoftware installedSoftware = MsInstalledSoftwareBaselineReadDelegate
												.getInstalledSoftware(installedSoftwareEffForm.getInstalledSoftwareId());

		Long softwareLparId = installedSoftwareEffForm.getSoftwareLparId();
		
		if (isCancelled(request)) {

			return new ForwardParameters().add("hardware",
					"" + softwareLparId).forward(
					mapping.findForward(Constants.CANCEL));
		}

		ActionErrors errors = new ActionErrors();
		errors = form.validate(mapping, request);

		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return new ActionForward(mapping.getInput());
		}

		MsInstalledSoftwareBaselineWriteDelegate.saveOsSoftware(
				installedSoftwareEffForm, installedSoftware,
				user.getRemoteUser());

		return new ForwardParameters().add("hardware",
				"" + softwareLparId).forward(
				mapping.findForward(Constants.SUCCESS));
	}

	public ActionForward add(ActionMapping mapping, ActionForm form,
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

		String hardware = request.getParameter("hardware");
		int msHardwareBaselineId;

		if (!Util.isInt(hardware)) {
			return mapping.findForward(Constants.ERROR);
		}

		try {
			msHardwareBaselineId = Integer.parseInt(hardware);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		MsInstalledSoftwareBaseline msInstalledSoftwareBaseline = new MsInstalledSoftwareBaseline();
		msInstalledSoftwareBaseline
				.setMsHardwareBaselineId(msHardwareBaselineId);

		request.setAttribute("msInstalledSoftwareBaseline",
				msInstalledSoftwareBaseline);
		request.setAttribute(Constants.SOFTWARE_LIST, SoftwareReadDelegate
				.getSoftwareNotInCategory(msHardwareBaselineId));

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward saveNewSoftware(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

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

		if (user.getCustomer().getMisldAccountSettings() != null) {
			if (user.getCustomer().getMisldAccountSettings().getStatus()
					.equals(Constants.LOCKED)) {
				throw new InvalidAccessException();
			}
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		MsInstalledSoftwareBaseline msInstalledSoftwareBaseline = (MsInstalledSoftwareBaseline) form;
		int msHardwareBaselineId = msInstalledSoftwareBaseline
				.getMsHardwareBaselineId();

		if (isCancelled(request)) {

			return new ForwardParameters().add("hardware",
					"" + msHardwareBaselineId).forward(
					mapping.findForward(Constants.CANCEL));
		}

		ActionErrors errors = new ActionErrors();
		errors = form.validate(mapping, request);

		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			request.setAttribute(Constants.SOFTWARE_LIST, SoftwareReadDelegate
					.getSoftwareNotInCategory(msHardwareBaselineId));

			return new ActionForward(mapping.getInput());
		}

		MsInstalledSoftwareBaselineWriteDelegate.addNewSoftware(
				msInstalledSoftwareBaseline, request.getRemoteUser());

		return new ForwardParameters().add("hardware",
				"" + msHardwareBaselineId).forward(
				mapping.findForward(Constants.SUCCESS));
	}
}