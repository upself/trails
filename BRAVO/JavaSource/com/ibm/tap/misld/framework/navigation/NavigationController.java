/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.framework.navigation;

import java.io.IOException;
import java.util.Iterator;
import java.util.Vector;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.tiles.ComponentContext;
import org.apache.struts.tiles.Controller;

import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.UserContainer;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class NavigationController extends BaseAction implements Controller {

	//Top Level Links
	String assetHomeLink = "https://w3-connections.ibm.com/communities/service/html/communitystart?communityUuid=85cfd34a-2938-4667-8823-bf4743894fbc";
	
	String bravoHomeLink = "/home.do";

	String misldHomeLink = "/MsWizard/Welcome.do";
	
	String helpLink = "/help/help.do";

	String podLink = "/MsWizard/Pod.do";

	String registrationStatusLink = "/MsWizard/RegistrationStatus.do";

	String reportPodLink = "/MsWizard/ReportPod.do";

	String reportGraphLink = "/MsWizard/ReportGraphs.do";

	String dpeNotificationLink = "/MsWizard/DpeNotification.do";
	
	String priceReportApprovalStatusLink = "/MsWizard/PriceReportApprovalStatus.do";
	
	String splaAccountReportLink = "/MsWizard/SPLAAccountReport.do";

	String adminPodLink = "/MsWizard/AdminPod.do";

	String adminReportLink = "/MsWizard/Administration.do";

	String adminFunctionLink = "/MsWizard/AdminFunction.do";

	String adminPriceList = "/MsWizard/PriceList.do";

	String priceUploadLink = "/MsWizard/PriceListUpload.do";

	String mappingUploadLink = "/MsWizard/MappingUpload.do";

	String systemStatusLink = "/MsWizard/SystemStatus.do";

	/**
	 * @param request
	 * @return
	 */
	private Vector createVector(HttpServletRequest request) {

		Vector levelOneVector = new Vector();
		Vector podVector = new Vector();
		Vector reportPodVector = new Vector();
		Vector adminVector = new Vector();

		UserContainer userContainer = getUserContainer(request);
		String levelOneOpenLink = userContainer.getLevelOneOpenLink();

		NavigationItem assetHomeNavigationItem = getNavigationItem(
				assetHomeLink, "Asset Home", request);
		assetHomeNavigationItem.setLink(assetHomeLink);		
		NavigationItem bravoNavigationItem = getNavigationItem(bravoHomeLink,
				"BRAVO", request);
		NavigationItem mswizNavigationItem = getNavigationItem(misldHomeLink,
				"Ms Wizard", request);
		NavigationItem helpNavigationItem = getNavigationItem(helpLink,
				"Help", request);
		NavigationItem podViewNavigationItem = getNavigationItem(podLink,
				"Asset Department", request);
		NavigationItem reportNavigationItem = getNavigationItem(reportPodLink,
				"Reports", request);
		NavigationItem systemStatusNavigationItem = getNavigationItem(
				systemStatusLink, "System Status", request);

		NavigationItem registrationStatusNavigationItem = getNavigationItem(
				registrationStatusLink, "Registration Status", request);

		NavigationItem reportGraphsNavigationItem = getNavigationItem(
				reportGraphLink, "Status", request);

		NavigationItem dpeNotificationNavigationItem = getNavigationItem(
				dpeNotificationLink, "DPE Notification", request);

		NavigationItem priceReportApprovalStatusNavigationItem = getNavigationItem(
				priceReportApprovalStatusLink, "Price Report Approvals", request);

		NavigationItem splaAccountReportLinkNavigationItem = getNavigationItem(
				splaAccountReportLink, "SPLA Quarterly Report", request);

		podVector.add(registrationStatusNavigationItem);
		reportPodVector.add(reportGraphsNavigationItem);
		reportPodVector.add(dpeNotificationNavigationItem);
		reportPodVector.add(priceReportApprovalStatusNavigationItem);
		reportPodVector.add(splaAccountReportLinkNavigationItem);

		podViewNavigationItem.setChildren(podVector);
		reportNavigationItem.setChildren(reportPodVector);

		levelOneVector.add(assetHomeNavigationItem);
		levelOneVector.add(bravoNavigationItem);
		levelOneVector.add(mswizNavigationItem);
		levelOneVector.add(helpNavigationItem);
		levelOneVector.add(reportNavigationItem);
		levelOneVector.add(systemStatusNavigationItem);
		levelOneVector.add(podViewNavigationItem);

		if (userContainer.isAdminAccess()) {
			NavigationItem adminNavigationItem = getNavigationItem(
					adminPodLink, "Administration", request);

			NavigationItem adminReportNavigationItem = getNavigationItem(
					adminReportLink, "Reports", request);

			NavigationItem adminFunctionNavigationItem = getNavigationItem(
					adminFunctionLink, "Functions", request);

			NavigationItem adminPriceListNavigationItem = getNavigationItem(
					adminPriceList, "Price List", request);

			adminVector.add(adminReportNavigationItem);
			adminVector.add(adminFunctionNavigationItem);
			adminVector.add(adminPriceListNavigationItem);

			adminNavigationItem.setChildren(adminVector);

			levelOneVector.add(adminNavigationItem);
		}

		if (levelOneOpenLink != null) {
			setOpenLink(levelOneVector, levelOneOpenLink);
		}
			
		return levelOneVector;

	}

	/**
	 * @param link
	 * @param vector
	 */
	private void setOpenLink(Vector vector, String link) {

		Iterator it = vector.iterator();
		while (it.hasNext()) {
			NavigationItem navigationItem = (NavigationItem) it.next();

			if (navigationItem.getLink().equals(Constants.PATH + link)) {
				navigationItem.setOpen(true);
			}
		}
	}

	/**
	 * @param link
	 * @param string
	 * @param request
	 * @return
	 */
	private NavigationItem getNavigationItem(String link, String string,
			HttpServletRequest request) {

		String compare;

		NavigationItem navigationItem = new NavigationItem();
		navigationItem.setValue(string);
		navigationItem.setLink(Constants.PATH + link);

		if (request.getQueryString() != null) {
			compare = request.getRequestURL().toString() + "?"
					+ request.getQueryString();
		} else {
			compare = request.getRequestURL().toString();
		}

		if (compare.equals(Constants.PATH + link)) {
			navigationItem.setActive(true);
		}

		return navigationItem;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.apache.struts.tiles.Controller#perform(org.apache.struts.tiles.ComponentContext,
	 *      javax.servlet.http.HttpServletRequest,
	 *      javax.servlet.http.HttpServletResponse,
	 *      javax.servlet.ServletContext)
	 */
	public void perform(ComponentContext context, HttpServletRequest request,
			HttpServletResponse arg2, ServletContext arg3)
			throws ServletException, IOException {

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.apache.struts.tiles.Controller#execute(org.apache.struts.tiles.ComponentContext,
	 *      javax.servlet.http.HttpServletRequest,
	 *      javax.servlet.http.HttpServletResponse,
	 *      javax.servlet.ServletContext)
	 */
	public void execute(ComponentContext context, HttpServletRequest request,
			HttpServletResponse arg2, ServletContext arg3) throws Exception {

		Vector navVector = createVector(request);

		request.setAttribute("navigation", navVector);
	}

}