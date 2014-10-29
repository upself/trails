package com.ibm.tap.misld.gui.action;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;

import com.ibm.tap.misld.delegate.licenseAgreementType.LicenseAgreementTypeReadDelegate;
import com.ibm.tap.misld.delegate.licenseType.LicenseTypeReadDelegate;
import com.ibm.tap.misld.delegate.microsoftPriceList.MicrosoftPriceListReadDelegate;
import com.ibm.tap.misld.delegate.microsoftPriceList.MicrosoftPriceListWriteDelegate;
import com.ibm.tap.misld.delegate.microsoftPriceList.MicrosoftProductMapReadDelegate;
import com.ibm.tap.misld.delegate.microsoftPriceList.MicrosoftProductMapWriteDelegate;
import com.ibm.tap.misld.delegate.microsoftPriceList.MicrosoftProductReadDelegate;
import com.ibm.tap.misld.delegate.microsoftPriceList.MicrosoftProductWriteDelegate;
import com.ibm.tap.misld.delegate.priceLevel.PriceLevelReadDelegate;
import com.ibm.tap.misld.delegate.qualifiedDiscount.QualifiedDiscountReadDelegate;
import com.ibm.tap.misld.delegate.software.SoftwareReadDelegate;
import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.ForwardParameters;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.Util;
import com.ibm.tap.misld.framework.exceptions.InvalidParameterException;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftPriceList;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftProduct;

/**
 * @version 1.0
 * @author
 */
public class PriceListAction extends BaseAction

{
	public ActionForward home(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		request.setAttribute("priceList", MicrosoftPriceListReadDelegate
				.getPriceList());

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		String priceListIdAsStr = request.getParameter("priceList");

		if (Util.isBlankString(priceListIdAsStr)) {
			throw new InvalidParameterException();
		}

		Long priceListId = new Long(priceListIdAsStr);

		MicrosoftPriceList microsoftPriceList = MicrosoftPriceListReadDelegate
				.getMicrosoftPriceListById(priceListId);
		microsoftPriceList.setLicenseAgreementTypeId(microsoftPriceList
				.getLicenseAgreementType().getLicenseAgreementTypeId());
		microsoftPriceList.setLicenseTypeId(microsoftPriceList.getLicenseType()
				.getLicenseTypeId());
		microsoftPriceList.setMicrosoftProductId(microsoftPriceList
				.getMicrosoftProduct().getMicrosoftProductId());
		microsoftPriceList.setPriceLevelId(microsoftPriceList.getPriceLevel()
				.getPriceLevelId());
		microsoftPriceList.setQualifiedDiscountId(microsoftPriceList
				.getQualifiedDiscount().getQualifiedDiscountId());

		request.setAttribute("product.list", MicrosoftProductReadDelegate
				.getMicrosoftProducts());

		request.setAttribute("licenseAgreement.list",
				LicenseAgreementTypeReadDelegate.getLicenseAgreementTypes());

		request.setAttribute("licenseType.list", LicenseTypeReadDelegate
				.getLicenseTypes());

		request.setAttribute("priceLevel.list", PriceLevelReadDelegate
				.getPriceLevels());

		request.setAttribute("qualifiedDiscount.list",
				QualifiedDiscountReadDelegate.getQualifiedDiscounts());

		request.setAttribute("microsoftPriceList", microsoftPriceList);

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		ActionErrors errors = new ActionErrors();
		errors = form.validate(mapping, request);

		MicrosoftPriceList microsoftPriceList = (MicrosoftPriceList) form;

		MicrosoftPriceList microsoftPriceListCheck = MicrosoftPriceListWriteDelegate
				.setUpMicrosoftPriceListForm(microsoftPriceList, request
						.getRemoteUser());

		if (microsoftPriceListCheck == null) {
			ActionMessages messages = new ActionMessages();
			messages.add("errors.required", new ActionMessage(
					"errors.required", "A Unique price list object"));
			errors.add(messages);
		} else {
			microsoftPriceList = microsoftPriceListCheck;
		}

		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			request.setAttribute("product.list", MicrosoftProductReadDelegate
					.getMicrosoftProducts());

			request
					.setAttribute("licenseAgreement.list",
							LicenseAgreementTypeReadDelegate
									.getLicenseAgreementTypes());

			request.setAttribute("licenseType.list", LicenseTypeReadDelegate
					.getLicenseTypes());

			request.setAttribute("priceLevel.list", PriceLevelReadDelegate
					.getPriceLevels());

			request.setAttribute("qualifiedDiscount.list",
					QualifiedDiscountReadDelegate.getQualifiedDiscounts());

			return new ActionForward(mapping.getInput());
		}

		MicrosoftPriceListWriteDelegate
				.saveMicrosoftPriceList(microsoftPriceList);

		user.setLevelOneOpenLink("/MsWizard/AdminiPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		MicrosoftPriceList microsoftPriceList = (MicrosoftPriceList) form;

		MicrosoftPriceListWriteDelegate
				.deleteMicrosoftPriceList(microsoftPriceList);

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward editProduct(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		String productIdAsStr = request.getParameter("product");

		if (Util.isBlankString(productIdAsStr)) {
			throw new InvalidParameterException();
		}

		Long microsoftProductId = new Long(productIdAsStr);

		List microsoftProductMapList = MicrosoftProductMapReadDelegate
				.getMicrosoftProductMapByProduct(microsoftProductId);
		List softwareList = SoftwareReadDelegate.getUnassignedSoftware();
		MicrosoftProduct microsoftProduct = MicrosoftProductReadDelegate
				.getFullMicrosoftProduct(microsoftProductId);

		request.setAttribute("productList", microsoftProductMapList);
		request.setAttribute("softwareList", softwareList);
		request.setAttribute("microsoftProduct", microsoftProduct);

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward removeProductMap(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		String microsoftProductMapIdAsStr = request
				.getParameter("microsoftProductMapId");
		String microsoftProductIdAsStr = request
				.getParameter("microsoftProductId");

		if (Util.isBlankString(microsoftProductMapIdAsStr)
				|| Util.isBlankString(microsoftProductIdAsStr)) {
			throw new InvalidParameterException();
		}

		Long microsoftProductMapId = new Long(microsoftProductMapIdAsStr);

		MicrosoftProductMapWriteDelegate
				.deleteMicrosoftProductMap(microsoftProductMapId);

		return new ForwardParameters().add("product", microsoftProductIdAsStr)
				.forward(mapping.findForward(Constants.SUCCESS));
	}

	public ActionForward addProductMap(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		String productIdAsStr = request.getParameter("microsoftProductId");
		String softwareIdAsStr = request.getParameter("softwareId");

		if (Util.isBlankString(productIdAsStr)
				|| Util.isBlankString(softwareIdAsStr)) {
			throw new InvalidParameterException();
		}

		Long microsoftProductId = new Long(productIdAsStr);
		Long softwareId = new Long(softwareIdAsStr);

		MicrosoftProductMapWriteDelegate.addMicrosoftProductMap(
				microsoftProductId, softwareId);

		return new ForwardParameters().add("product", productIdAsStr).forward(
				mapping.findForward(Constants.SUCCESS));
	}

	public ActionForward addMicrosoftProduct(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward saveNewMicrosoftProduct(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		ActionErrors errors = new ActionErrors();
		errors = form.validate(mapping, request);

		MicrosoftProduct microsoftProduct = (MicrosoftProduct) form;

		MicrosoftProduct microsoftProductCheck = MicrosoftProductReadDelegate
				.getMicrosoftProductByName(microsoftProduct
						.getProductDescription());

		if (microsoftProductCheck != null) {
			ActionMessages messages = new ActionMessages();
			messages.add("errors.required", new ActionMessage(
					"errors.required", "A Unique product description"));
			errors.add(messages);
		}

		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return new ActionForward(mapping.getInput());
		}

		microsoftProduct.setRecordTime(new Date());
		microsoftProduct.setRemoteUser(request.getRemoteUser());
		microsoftProduct.setStatus(Constants.ACTIVE);
		microsoftProduct.setProductDescription(microsoftProduct
				.getProductDescription().toUpperCase());
		MicrosoftProductWriteDelegate.saveMicrosoftProduct(microsoftProduct);

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward addMicrosoftPriceList(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		request.setAttribute("product.list", MicrosoftProductReadDelegate
				.getMicrosoftProducts());

		request.setAttribute("licenseAgreement.list",
				LicenseAgreementTypeReadDelegate.getLicenseAgreementTypes());

		request.setAttribute("licenseType.list", LicenseTypeReadDelegate
				.getLicenseTypes());

		request.setAttribute("priceLevel.list", PriceLevelReadDelegate
				.getPriceLevels());

		request.setAttribute("qualifiedDiscount.list",
				QualifiedDiscountReadDelegate.getQualifiedDiscounts());

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward saveNewMicrosoftPriceList(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		ActionErrors errors = new ActionErrors();
		errors = form.validate(mapping, request);

		MicrosoftPriceList microsoftPriceList = (MicrosoftPriceList) form;

		MicrosoftPriceList microsoftPriceListCheck = MicrosoftPriceListWriteDelegate
				.setUpMicrosoftPriceListForm(microsoftPriceList, request
						.getRemoteUser());

		if (microsoftPriceListCheck == null) {
			ActionMessages messages = new ActionMessages();
			messages.add("errors.required", new ActionMessage(
					"errors.required", "A Unique price list object"));
			errors.add(messages);
		} else {
			microsoftPriceList = microsoftPriceListCheck;
		}

		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			request.setAttribute("product.list", MicrosoftProductReadDelegate
					.getMicrosoftProducts());

			request
					.setAttribute("licenseAgreement.list",
							LicenseAgreementTypeReadDelegate
									.getLicenseAgreementTypes());

			request.setAttribute("licenseType.list", LicenseTypeReadDelegate
					.getLicenseTypes());

			request.setAttribute("priceLevel.list", PriceLevelReadDelegate
					.getPriceLevels());

			request.setAttribute("qualifiedDiscount.list",
					QualifiedDiscountReadDelegate.getQualifiedDiscounts());

			return new ActionForward(mapping.getInput());
		}

		MicrosoftPriceListWriteDelegate
				.saveMicrosoftPriceList(microsoftPriceList);
		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}

}