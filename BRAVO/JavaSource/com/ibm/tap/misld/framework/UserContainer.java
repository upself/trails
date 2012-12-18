package com.ibm.tap.misld.framework;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import com.ibm.ea.cndb.Contact;
import com.ibm.ea.cndb.Pod;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.customerSettings.MisldAccountSettings;

/**
 * @author alexmois
 * 
 * This object is used to hold all the information a user needs while navigating
 * HART.
 */
public class UserContainer implements HttpSessionBindingListener {

	private boolean loaded = false;

	private boolean admin;

	private boolean misldAdmin;

	private boolean asset;

	private String remoteUser;

	private boolean adminAccess;

	private Customer customer;

	private String levelOneOpenLink;

	private String levelTwoOpenLink;

	private int recordsPerPage;

	private Pod pod;

	private MisldAccountSettings accountSettingsForm;

	private Contact contact;

	/**
	 * @return Returns the recordsPerPage.
	 */
	public int getRecordsPerPage() {
		return recordsPerPage;
	}

	/**
	 * @param recordsPerPage
	 *            The recordsPerPage to set.
	 */
	public void setRecordsPerPage(int recordsPerPage) {
		this.recordsPerPage = recordsPerPage;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.servlet.http.HttpSessionBindingListener#valueBound(javax.servlet.http.HttpSessionBindingEvent)
	 */
	public void valueBound(HttpSessionBindingEvent arg0) {
		// TODO Auto-generated method stub
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.servlet.http.HttpSessionBindingListener#valueUnbound(javax.servlet.http.HttpSessionBindingEvent)
	 */
	public void valueUnbound(HttpSessionBindingEvent arg0) {
		// TODO Auto-generated method stub

	}

	/**
	 * @return Returns the loaded.
	 */
	public boolean isLoaded() {
		return loaded;
	}

	/**
	 * @param loaded
	 *            The loaded to set.
	 */
	public void setLoaded(boolean loaded) {
		this.loaded = loaded;
	}

	/**
	 * @return Returns the admin.
	 */
	public boolean isAdmin() {
		return admin;
	}

	/**
	 * @param admin
	 *            The admin to set.
	 */
	public void setAdmin(boolean admin) {
		this.admin = admin;
	}

	/**
	 * @return Returns the asset.
	 */
	public boolean isAsset() {
		return asset;
	}

	/**
	 * @param asset
	 *            The asset to set.
	 */
	public void setAsset(boolean asset) {
		this.asset = asset;
	}

	/**
	 * @return Returns the remoteUser.
	 */
	public String getRemoteUser() {
		return remoteUser;
	}

	/**
	 * @param remoteUser
	 *            The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	/**
	 * @return Returns the adminAccess.
	 */
	public boolean isAdminAccess() {
		return adminAccess;
	}

	/**
	 * @param adminAccess
	 *            The adminAccess to set.
	 */
	public void setAdminAccess(boolean adminAccess) {
		this.adminAccess = adminAccess;
	}

	/**
	 * @return Returns the levelOneOpenLink.
	 */
	public String getLevelOneOpenLink() {
		return levelOneOpenLink;
	}

	/**
	 * @param levelOneOpenLink
	 *            The levelOneOpenLink to set.
	 */
	public void setLevelOneOpenLink(String levelOneOpenLink) {
		this.levelOneOpenLink = levelOneOpenLink;
	}

	/**
	 * @return Returns the levelTwoOpenLink.
	 */
	public String getLevelTwoOpenLink() {
		return levelTwoOpenLink;
	}

	/**
	 * @param levelTwoOpenLink
	 *            The levelTwoOpenLink to set.
	 */
	public void setLevelTwoOpenLink(String levelTwoOpenLink) {
		this.levelTwoOpenLink = levelTwoOpenLink;
	}

	/**
	 * @return Returns the customer.
	 */
	public Customer getCustomer() {
		return customer;
	}

	/**
	 * @param customer
	 *            The customer to set.
	 */
	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	/**
	 * @return Returns the misldAdmin.
	 */
	public boolean isMisldAdmin() {
		return misldAdmin;
	}

	/**
	 * @param misldAdmin
	 *            The misldAdmin to set.
	 */
	public void setMisldAdmin(boolean misldAdmin) {
		this.misldAdmin = misldAdmin;
	}

	public String getQuarterQuestion() {
		Date date = new Date();
		Format formatter = new SimpleDateFormat("yyyy");

		String s = formatter.format(date);
		int year = Integer.parseInt(s);

		Calendar firstQ = new GregorianCalendar(year, Calendar.APRIL, 1);
		Calendar secondQ = new GregorianCalendar(year, Calendar.JULY, 1);
		Calendar thirdQ = new GregorianCalendar(year, Calendar.OCTOBER, 1);

		Calendar today = new GregorianCalendar();

		year++;
		if (today.before(firstQ)) {
			return ("First Quarter " + year);
		} else if (today.before(secondQ)) {
			return ("Second Quarter " + year);
		} else if (today.before(thirdQ)) {
			return ("Third Quarter " + year);
		} else {
			return ("Forth Quarter " + year);
		}
	}

	/**
	 * @return Returns the accountSettingsForm.
	 */
	public MisldAccountSettings getAccountSettingsForm() {
		return accountSettingsForm;
	}

	/**
	 * @param accountSettingsForm
	 *            The accountSettingsForm to set.
	 */
	public void setAccountSettingsForm(MisldAccountSettings accountSettingsForm) {
		this.accountSettingsForm = accountSettingsForm;
	}

	/**
	 * @param contact
	 */
	public void setContact(Contact contact) {
		this.contact = contact;
	}

	/**
	 * @return Returns the contact.
	 */
	public Contact getContact() {
		return contact;
	}

	/**
	 * @return Returns the pod.
	 */
	public Pod getPod() {
		return pod;
	}

	/**
	 * @param pod
	 *            The pod to set.
	 */
	public void setPod(Pod pod) {
		this.pod = pod;
	}
}