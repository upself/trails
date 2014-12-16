package com.ibm.tap.sigbank.usercontainer;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.tap.sigbank.bankaccount.BankAccount;
import com.ibm.tap.sigbank.framework.common.BluegroupsDelegate;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.common.Pagination;
import com.ibm.asset.swkbt.domain.Manufacturer;
import com.ibm.asset.swkbt.domain.Product;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategory;

/**
 * @@author Thomas Newton
 * 
 * This object is used to hold all the information a user needs while navigating
 * TAP.
 */
public class UserContainer extends ValidatorActionForm implements
		HttpSessionBindingListener {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long userContainerId;

	private boolean loaded = false;

	private boolean sigBankReader;

	private boolean sigBankAdmin;

	private boolean sigBankUser;

	private boolean admin;

	private boolean asset;

	private boolean adminAccess;

	private String remoteUser;

	private BankAccount bankAccount;

	private List bankAccounts;

	private Manufacturer manufacturer;

	private SoftwareCategory softwareCategory;

	private Product product;

	private Date recordTime;

	private String status;

	private Long newFilters;

	private String from;

	private Pagination pagination;

	private String lastButton;

	private String levelOneOpenLink;

	private String levelTwoOpenLink;

	/**
	 * @@return Returns the lastButton.
	 */
	public String getLastButton() {
		return lastButton;
	}

	/**
	 * @@param lastButton
	 *            The lastButton to set.
	 */
	public void setLastButton(String lastButton) {
		this.lastButton = lastButton;
	}

	/**
	 * @@return Returns the bankAccounts.
	 */
	public List getBankAccounts() {
		return bankAccounts;
	}

	/**
	 * @@param bankAccounts
	 *            The bankAccounts to set.
	 */
	public void setBankAccounts(List bankAccounts) {
		this.bankAccounts = bankAccounts;
	}

	public void valueBound(HttpSessionBindingEvent arg0) {
	}

	public void valueUnbound(HttpSessionBindingEvent arg0) {
		cleanUp();
	}

	public void cleanUp() {
	}

	/**
	 * @@return Returns the pagination.
	 */
	public Pagination getPagination() {
		return pagination;
	}

	/**
	 * @@param pagination
	 *            The pagination to set.
	 */
	public void setPagination(Pagination pagination) {
		this.pagination = pagination;
	}

	/**
	 * @@return Returns the from.
	 */
	public String getFrom() {
		return from;
	}

	/**
	 * @@param from
	 *            The from to set.
	 */
	public void setFrom(String from) {
		this.from = from;
	}

	/**
	 * @@return Returns the newFilters.
	 */
	public Long getNewFilters() {
		return newFilters;
	}

	/**
	 * @@param count
	 *            The newFilters to set.
	 */
	public void setNewFilters(Long count) {
		this.newFilters = count;
	}

	/**
	 * @@return Returns the software.
	 */
	public Product getProduct() {
		return product;
	}

	/**
	 * @@param software
	 *            The software to set.
	 */
	public void setProduct(Product product) {
		this.product = product;
	}

	/**
	 * @@return Returns the loaded.
	 */
	public boolean isLoaded() {
		return loaded;
	}

	/**
	 * @@param loaded
	 *            The loaded to set.
	 */
	public void setLoaded(boolean loaded) {
		this.loaded = loaded;
	}

	/**
	 * @@return Returns the manufacturer.
	 */
	public Manufacturer getManufacturer() {
		return manufacturer;
	}

	/**
	 * @@param manufacturer
	 *            The manufacturer to set.
	 */
	public void setManufacturer(Manufacturer manufacturer) {
		this.manufacturer = manufacturer;
	}

	/**
	 * @@return Returns the admin.
	 */
	public boolean isAdmin() {
		return admin;
	}

	/**
	 * @@param admin
	 *            The admin to set.
	 */
	public void setAdmin(boolean admin) {
		this.admin = admin;
	}

	/**
	 * @@return Returns the asset.
	 */
	public boolean isAsset() {
		return asset;
	}

	/**
	 * @@param asset
	 *            The asset to set.
	 */
	public void setAsset(boolean asset) {
		this.asset = asset;
	}

	/**
	 * @@return Returns the sigBankAdmin.
	 */
	public boolean isSigBankAdmin() {
		return sigBankAdmin;
	}

	/**
	 * @@param sigBankAdmin
	 *            The sigBankAdmin to set.
	 */
	public void setSigBankAdmin(boolean sigBankAdmin) {
		this.sigBankAdmin = sigBankAdmin;
	}

	/**
	 * @@return Returns the sigBankReader.
	 */
	public boolean isSigBankReader() {
		return sigBankReader;
	}

	/**
	 * @@param sigBankReader
	 *            The sigBankReader to set.
	 */
	public void setSigBankReader(boolean sigBankReader) {
		this.sigBankReader = sigBankReader;
	}

	/**
	 * @@return Returns the sigBankUser.
	 */
	public boolean isSigBankUser() {
		return sigBankUser;
	}

	/**
	 * @@param sigBankUser
	 *            The sigBankUser to set.
	 */
	public void setSigBankUser(boolean sigBankUser) {
		this.sigBankUser = sigBankUser;
	}

	/**
	 * @@return Returns the remoteUser.
	 */
	public String getRemoteUser() {
		return remoteUser;
	}

	/**
	 * @@param remoteUser
	 *            The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	/**
	 * @@return Returns the adminAccess.
	 */
	public boolean isAdminAccess() {
		return adminAccess;
	}

	/**
	 * @@param adminAccess
	 *            The adminAccess to set.
	 */
	public void setAdminAccess(boolean adminAccess) {
		this.adminAccess = adminAccess;
	}

	/**
	 * @@return Returns the bankAccount.
	 */
	public BankAccount getBankAccount() {
		return bankAccount;
	}

	/**
	 * @@param bankAccount
	 *            The bankAccount to set.
	 */
	public void setBankAccount(BankAccount bankAccount) {
		this.bankAccount = bankAccount;
	}

	/**
	 * @@return Returns the userContainerId.
	 */
	public Long getUserContainerId() {
		return userContainerId;
	}

	/**
	 * @@param userContainerId
	 *            The userContainerId to set.
	 */
	public void setUserContainerId(Long userContainerId) {
		this.userContainerId = userContainerId;
	}

	/**
	 * @@return Returns the recordTime.
	 */
	public Date getRecordTime() {
		return recordTime;
	}

	/**
	 * @@param recordTime
	 *            The recordTime to set.
	 */
	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	/**
	 * @@return Returns the status.
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * @@param status
	 *            The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}

	/**
	 * @@return Returns the softwareCategory.
	 */
	public SoftwareCategory getSoftwareCategory() {
		return softwareCategory;
	}

	/**
	 * @@param softwareCategory
	 *            The softwareCategory to set.
	 */
	public void setSoftwareCategory(SoftwareCategory softwareCategory) {
		this.softwareCategory = softwareCategory;
	}

	/**
	 * 
	 */
	public void setAccessLevel() {

		setAdmin(BluegroupsDelegate.isMember(remoteUser, Constants.GROUP_ADMIN));

		setSigBankAdmin(BluegroupsDelegate.isMember(remoteUser,
				Constants.GROUP_SIGBANK_ADMIN));

		setSigBankUser(BluegroupsDelegate.isMember(remoteUser,
				Constants.GROUP_SIGBANK_USER));

		if (isAdmin() || isSigBankAdmin()) {
			setAdminAccess(true);
			setSigBankUser(true);
		}

		setLoaded(true);

	}

	public String getLevelOneOpenLink() {
		return levelOneOpenLink;
	}

	public void setLevelOneOpenLink(String levelOneOpenLink) {
		this.levelOneOpenLink = levelOneOpenLink;
	}

	public String getLevelTwoOpenLink() {
		return levelTwoOpenLink;
	}

	public void setLevelTwoOpenLink(String levelTwoOpenLink) {
		this.levelTwoOpenLink = levelTwoOpenLink;
	}
}