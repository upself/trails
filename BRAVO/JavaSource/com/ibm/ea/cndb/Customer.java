package com.ibm.ea.cndb;

import java.util.HashSet;
import java.util.Set;

import com.ibm.ea.bravo.framework.common.OrmBase;
import com.ibm.ea.bravo.secure.Bluegroup;
import com.ibm.ea.sigbank.BankAccountInclusion;

public class Customer extends OrmBase {

	/**
     * 
     */
    private static final long serialVersionUID = -2203998705895347981L;

    private Long customerId;

	private Pod pod;

	private Industry industry;

	private Long accountNumber;

	private String accountNumberStr;

	private String customerName;

	private Contact contactDPE;

	private Contact contactFA;

	private Contact contactFocalAsset;

	private Contact contactHW;

	private Contact contactSW;

	private Contact contactTransition;

	private String assetToolsBillingCode;

	private CustomerType customerType;

	private Set<Bluegroup> bluegroups = new HashSet<Bluegroup>();

	private Set<OutsourceProfile> outsource = new HashSet<OutsourceProfile>();
	
	private Set<BankAccountInclusion> bankInclusions = new HashSet<BankAccountInclusion>();

	private CountryCode countryCode;
	
	private Integer scanValidity;

	public Integer getScanValidity() {
		return scanValidity;
	}

	public void setScanValidity(Integer scanValidity) {
		this.scanValidity = scanValidity;
	}

	/**
	 * @return Returns the customerType.
	 */
	public CustomerType getCustomerType() {
		return customerType;
	}

	/**
	 * @param customerType
	 *            The customerType to set.
	 */
	public void setCustomerType(CustomerType customerType) {
		this.customerType = customerType;
	}

	/**
	 * @return Returns the accountNumber.
	 */
	public Long getAccountNumber() {
		return accountNumber;
	}

	/**
	 * @param accountNumber
	 *            The accountNumber to set.
	 */
	public void setAccountNumber(Long accountNumber) {
		this.accountNumber = accountNumber;
	}

	/**
	 * @return Returns the assetToolsBillingCode.
	 */
	public String getAssetToolsBillingCode() {
		return assetToolsBillingCode;
	}

	/**
	 * @param assetToolsBillingCode
	 *            The assetToolsBillingCode to set.
	 */
	public void setAssetToolsBillingCode(String assetToolsBillingCode) {
		this.assetToolsBillingCode = assetToolsBillingCode;
	}

	/**
	 * @return Returns the contactDPE.
	 */
	public Contact getContactDPE() {
		return contactDPE;
	}

	/**
	 * @param contactDPE
	 *            The contactDPE to set.
	 */
	public void setContactDPE(Contact contactDPE) {
		this.contactDPE = contactDPE;
	}

	/**
	 * @return Returns the contactFA.
	 */
	public Contact getContactFA() {
		return contactFA;
	}

	/**
	 * @param contactFA
	 *            The contactFA to set.
	 */
	public void setContactFA(Contact contactFA) {
		this.contactFA = contactFA;
	}

	/**
	 * @return Returns the contactFocalAsset.
	 */
	public Contact getContactFocalAsset() {
		return contactFocalAsset;
	}

	/**
	 * @param contactFocalAsset
	 *            The contactFocalAsset to set.
	 */
	public void setContactFocalAsset(Contact contactFocalAsset) {
		this.contactFocalAsset = contactFocalAsset;
	}

	/**
	 * @return Returns the contactHW.
	 */
	public Contact getContactHW() {
		return contactHW;
	}

	/**
	 * @param contactHW
	 *            The contactHW to set.
	 */
	public void setContactHW(Contact contactHW) {
		this.contactHW = contactHW;
	}

	/**
	 * @return Returns the contactSW.
	 */
	public Contact getContactSW() {
		return contactSW;
	}

	/**
	 * @param contactSW
	 *            The contactSW to set.
	 */
	public void setContactSW(Contact contactSW) {
		this.contactSW = contactSW;
	}

	/**
	 * @return Returns the contactTransition.
	 */
	public Contact getContactTransition() {
		return contactTransition;
	}

	/**
	 * @param contactTransition
	 *            The contactTransition to set.
	 */
	public void setContactTransition(Contact contactTransition) {
		this.contactTransition = contactTransition;
	}

	/**
	 * @return Returns the customerId.
	 */
	public Long getCustomerId() {
		return customerId;
	}

	/**
	 * @param customerId
	 *            The customerId to set.
	 */
	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}

	/**
	 * @return Returns the customerName.
	 */
	public String getCustomerName() {
		return customerName;
	}

	/**
	 * @param customerName
	 *            The customerName to set.
	 */
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	/**
	 * @return Returns the industry.
	 */
	public Industry getIndustry() {
		return industry;
	}

	/**
	 * @param industry
	 *            The industry to set.
	 */
	public void setIndustry(Industry industry) {
		this.industry = industry;
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

	/**
	 * @return Returns the secureBlueGroups.
	 */
	public Set<Bluegroup> getBluegroups() {
		return bluegroups;
	}

	/**
	 * @param secureBlueGroups
	 *            The secureBlueGroups to set.
	 */
	public void setBluegroups(Set<Bluegroup> bluegroups) {
		this.bluegroups = bluegroups;
	}

	public boolean isRestricted() {
		return !this.getBluegroups().isEmpty();
	}

    public Set<OutsourceProfile> getOutsource() {
        return outsource;
    }

    public void setOutsource(Set<OutsourceProfile> outsource) {
        this.outsource = outsource;
    }

	public CountryCode getCountryCode() {
		return countryCode;
	}

	public void setCountryCode(CountryCode countryCode) {
		this.countryCode = countryCode;
	}

	public void setAccountNumberStr(String accountNumberStr) {
		this.accountNumberStr = accountNumberStr;
	}

	public String getAccountNumberStr() {
		return accountNumberStr;
	}

	public Set<BankAccountInclusion> getBankInclusions() {
		return bankInclusions;
	}

	public void setBankInclusions(Set<BankAccountInclusion> bankInclusions) {
		this.bankInclusions = bankInclusions;
	}
	
	
}