/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.navigate;

import java.io.IOException;
import java.util.Iterator;
import java.util.Vector;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.tiles.ComponentContext;
import org.apache.struts.tiles.Controller;
import org.hibernate.HibernateException;

import com.ibm.tap.sigbank.framework.common.BaseAction;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.usercontainer.UserContainer;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class NavigationController extends BaseAction implements Controller {

	// Top Level Links
	// TODO pull this link dynamically
	public static final String assetHomeLink = "http://tap.raleigh.ibm.com/";

	public static final String sigHomeLink = "/Welcome.do";

	// Admin Only Links
	public static final String manufacturerLink = "/Manufacturer.do";

	public static final String softwareCategoryLink = "/SoftwareCategory.do";

	public static final String bankAccountLink = "/BankAccount.do";

	public static final String uploadLink = "/Upload.do";

	// Sigbank user links
	public static final String softwareLink = "/Software.do";

	public static final String reportsLink = "/Reports.do";

	// Software Links
	public static final String searchSoftwareLink = "/SoftwareSearchSetup.do";

	public static final String addSoftwareLink = "/AddSoftware.do";

	// Manufacturer Links
	public static final String addManufacturerLink = "/AddManufacturer.do";

	// Software Category Links
	public static final String addSoftwareCategoryLink = "/AddSoftwareCategory.do";

	// UploadLinks
	public static final String uploadFiltersLink = "/UploadFilters.do";

	public static final String uploadSignaturesLink = "/UploadSignatures.do";

	public static final String templatesLink = "/Templates.do";

	// Bank Account Links
	public static final String connectedLink = "/Connected.do";

	public static final String addConnectedBankAccountLink = "/AddConnectedBankAccount.do";

	public static final String connectedStatusLink = "/ConnectedStatus.do";

	public static final String disconnectedLink = "/Disconnected.do";

	public static final String addDisconnectedBankAccountLink = "/AddDisconnectedBankAccount.do";

	public static final String disconnectedStatusLink = "/DisconnectedStatus.do";

	// Reports Links
	public static final String historyLink = "/History.do";

	public static final String manHistoryLink = "/ManufacturerHistoryReport.do";

	public static final String swCatHistoryLink = "/SoftwareCategoryHistoryReport.do";

	public static final String softwareHistoryLink = "/SoftwareHistoryReport.do";

	public static final String signatureHistoryLink = "/SoftwareSignatureHistoryReport.do";

	public static final String filterHistoryLink = "/SoftwareFilterHistoryReport.do";

	public static final String helpLink = "/help/help.do";

	/**
	 * @param request
	 * @return
	 * @throws Exception
	 * @throws HibernateException
	 */
	private Vector createVector(HttpServletRequest request)
			throws HibernateException, Exception {

		Vector<NavigationItem> levelOneVector = new Vector<NavigationItem>();
		Vector<NavigationItem> softwareVector = new Vector<NavigationItem>();
		Vector<NavigationItem> manufacturerVector = new Vector<NavigationItem>();
		Vector<NavigationItem> softwareCategoryVector = new Vector<NavigationItem>();
		Vector<NavigationItem> uploadVector = new Vector<NavigationItem>();
		Vector<NavigationItem> bankAccountVector = new Vector<NavigationItem>();
		Vector<NavigationItem> connectedVector = new Vector<NavigationItem>();
		Vector<NavigationItem> disconnectedVector = new Vector<NavigationItem>();
		Vector<NavigationItem> historyVector = new Vector<NavigationItem>();
		Vector<NavigationItem> reportVector = new Vector<NavigationItem>();

		UserContainer user = getUserContainer(request);

		String levelOneOpenLink = user.getLevelOneOpenLink();
		String levelTwoOpenLink = user.getLevelTwoOpenLink();

		// Software link
		NavigationItem softwareNavigationItem = getNavigationItem(softwareLink,
				"Software", request);
		softwareVector.add(getNavigationItem(searchSoftwareLink,
				"Search Software", request));

		if (user.isAdminAccess()) {
			softwareVector.add(getNavigationItem(addSoftwareLink,
					"Add Software", request));
		}

		softwareNavigationItem.setChildren(softwareVector);

		// Manufacturer link
		NavigationItem manufacturerNavigationItem = getNavigationItem(
				manufacturerLink, "Manufacturer", request);
		manufacturerVector.add(getNavigationItem(addManufacturerLink,
				"Add Manufacturer", request));
		manufacturerNavigationItem.setChildren(manufacturerVector);

		// Software Category link
		NavigationItem scNavigationItem = getNavigationItem(
				softwareCategoryLink, "Software Category", request);
		softwareCategoryVector.add(getNavigationItem(addSoftwareCategoryLink,
				"Add Software Category", request));
		scNavigationItem.setChildren(softwareCategoryVector);

		// Upload link
		NavigationItem uploadNavigationItem = getNavigationItem(uploadLink,
				"Upload", request);
		uploadVector.add(getNavigationItem(uploadFiltersLink, "Filters",
				request));
		uploadVector.add(getNavigationItem(uploadSignaturesLink, "Signatures",
				request));
		uploadVector
				.add(getNavigationItem(templatesLink, "Templates", request));
		uploadNavigationItem.setChildren(uploadVector);

		// Bank Account Link
		/*
		NavigationItem bankNavigationItem = getNavigationItem(bankAccountLink,
				"Bank Accounts", request);
		*/

		// Create the main links
		levelOneVector.add(getNavigationItem(assetHomeLink, "Asset Home",
				request));
		levelOneVector.add(getNavigationItem(sigHomeLink, "Signature Bank",
				request));

		if (user.isAdminAccess()) {
			levelOneVector.add(manufacturerNavigationItem);
			levelOneVector.add(scNavigationItem);

			connectedVector.add(getNavigationItem(addConnectedBankAccountLink,
					"Add", request));
			disconnectedVector.add(getNavigationItem(
					addDisconnectedBankAccountLink, "Add", request));

			NavigationItem historyNavItem = getNavigationItem(historyLink,
					"History", request);

			historyVector.add(getNavigationItem(manHistoryLink, "Manufacturer",
					request));
			historyVector.add(getNavigationItem(swCatHistoryLink,
					"Software Category", request));
			historyVector.add(getNavigationItem(softwareHistoryLink,
					"Software", request));
			historyVector.add(getNavigationItem(filterHistoryLink,
					"Software Filter", request));
			historyVector.add(getNavigationItem(signatureHistoryLink,
					"Software Signature", request));

			historyNavItem.setChildren(historyVector);
			reportVector.add(historyNavItem);
		}

		NavigationItem connectedNavItem = getNavigationItem(connectedLink,
				"Connected", request);
		NavigationItem disconnectedNavItem = getNavigationItem(
				disconnectedLink, "Disconnected", request);
		connectedVector.add(getNavigationItem(connectedStatusLink, "Status",
				request));
		disconnectedVector.add(getNavigationItem(disconnectedStatusLink,
				"Status", request));

		connectedNavItem.setChildren(connectedVector);
		disconnectedNavItem.setChildren(disconnectedVector);

		bankAccountVector.add(connectedNavItem);
		bankAccountVector.add(disconnectedNavItem);

		if (levelTwoOpenLink != null) {
			setOpenLink(bankAccountVector, levelTwoOpenLink);
			setOpenLink(reportVector, levelTwoOpenLink);
		}

		//bankNavigationItem.setChildren(bankAccountVector);

		levelOneVector.add(softwareNavigationItem);

		/*
		if (user.isSigBankUser()) {
			levelOneVector.add(bankNavigationItem);
		}
		*/

		NavigationItem reportNavItem = getNavigationItem(reportsLink,
				"Reports", request);

		if (user.isAdminAccess()) {
			levelOneVector.add(uploadNavigationItem);
			reportNavItem.setChildren(reportVector);
		}

		levelOneVector.add(reportNavItem);

		NavigationItem helpNavItem = this.getNavigationItem(helpLink, "Help",
				request);
		levelOneVector.add(helpNavItem);

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

		// TLN: Check for absolute links vs relative links
		if (link.startsWith("http://") || link.startsWith("https://")) {
			navigationItem.setLink(link);
		} else {
			navigationItem.setLink(Constants.PATH + link);
		}

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