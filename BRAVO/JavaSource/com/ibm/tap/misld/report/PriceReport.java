/*
 * Created on Dec 6, 2004
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.report;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Vector;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.tap.misld.om.priceReportCycle.PriceReportArchive;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class PriceReport extends ValidatorActionForm {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String podId;

	private String pod;

	private String customerType;

	private String industry;

	private String sector;

	private Long accountNumber;

	private String customerName;

	private String customerAgreementType;

	private String qualifiedDiscount;

	private String priceLevel;

	private boolean priceLevelFlag;

	private boolean overallOsAuthFlag = false;

	private boolean overallIbmOwnFlag = false;

	private boolean overallSoftwareFlag = false;

	private boolean overallProcessorFlag = false;

	private boolean overallUserFlag = false;

	private boolean overallAgreementFlag = false;

	private boolean overallNodeOwnerFlag = false;

	public final String nodeOwnerAssumption = "Hardware was assumed to be owned by IBM";

	public final String priceLevelAssumption = "The eSPLA price level was assumed to be level 'A'...the highest price level for all eSPLA products for your account";

	public final String userAssumption = "The number of users was assumed to be 1000 on at least one server";

	public final String processorAssumption = "The number of processors was assumed to be 2 on at least on server";

	public final String ibmOwnAssumption = "Software products were assumed to be owned by IBM and are included in the pricing report";

	public final String osAuthAssumption = "OS Authentication was assumed because no authentication was initially recorded";

	public final String softwareNameAssumption = "Windows Advanced Server was assumed to be the operating system on at least one server because no operating system was initially recorded";

	private Vector assumptions = new Vector();

	private Vector details = new Vector();

	private HashMap summary;

	private BigDecimal totalSplaPrice = new BigDecimal(0);

	private BigDecimal totalEsplaPrice = new BigDecimal(0);

	private String poNumber;

	private String poDate;
	
	private ArrayList poDates;

	private String usageDate;
	
	private ArrayList usageDates;

	private String lpid;

	private ArrayList lpids;

	private HashMap lpidTotals;

	public PriceReportDetail getPriceReportDetail(int index) {
		for (int i = details.size(); i <= index; i++)
			details.add(new PriceReportDetail());
		return ((PriceReportDetail) details.elementAt(index));
	}

	public PriceReportArchive getPriceReportArchive(int index) {
		for (int i = details.size(); i <= index; i++)
			details.add(new PriceReportArchive());
		return ((PriceReportArchive) details.elementAt(index));
	}

	public boolean isAssumption() {
		if (overallOsAuthFlag || overallIbmOwnFlag || overallProcessorFlag
				|| overallUserFlag || overallAgreementFlag || priceLevelFlag
				|| overallNodeOwnerFlag) {
			return true;
		}
		return false;
	}

	public void addToDetails(PriceReportDetail priceReportDetail) {
		details.add(priceReportDetail);
	}

	public void addToDetails(PriceReportArchive priceReportArchive) {
		details.add(priceReportArchive);
	}

	/**
	 * @param splaQuarterlyPrice
	 */
	public void addToTotalSplaPrice(BigDecimal splaQuarterlyPrice) {
		if (this.totalSplaPrice == null) {
			this.totalSplaPrice = splaQuarterlyPrice;
		} else {
			this.totalSplaPrice = this.totalSplaPrice.add(splaQuarterlyPrice);
		}

	}

	/**
	 * @param esplaQuarterlyPrice
	 */
	public void addToTotalEsplaPrice(BigDecimal esplaQuarterlyPrice) {
		if (this.totalEsplaPrice == null) {
			this.totalEsplaPrice = esplaQuarterlyPrice;
		} else {
			this.totalEsplaPrice = this.totalEsplaPrice
					.add(esplaQuarterlyPrice);
		}

	}

	/**
	 * @param lpid
	 * @param decimal
	 * @param splaQuarterlyPrice
	 */
	public BigDecimal addToLpidPrice(HashMap lpidHash, String lpid,
			BigDecimal decimal) {
		if (lpidHash.get(lpid) == null) {
			return decimal;
		} else {
			BigDecimal dec = (BigDecimal) lpidHash.get(lpid);
			return dec.add(decimal);
		}
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
	 * @return Returns the assumptions.
	 */
	public Vector getAssumptions() {
		return assumptions;
	}

	/**
	 * @param assumptions
	 *            The assumptions to set.
	 */
	public void setAssumptions(Vector assumptions) {
		this.assumptions = assumptions;
	}

	/**
	 * @return Returns the customerAgreementType.
	 */
	public String getCustomerAgreementType() {
		return customerAgreementType;
	}

	/**
	 * @param customerAgreementType
	 *            The customerAgreementType to set.
	 */
	public void setCustomerAgreementType(String customerAgreementType) {
		this.customerAgreementType = customerAgreementType;
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
	 * @return Returns the customerType.
	 */
	public String getCustomerType() {
		return customerType;
	}

	/**
	 * @param customerType
	 *            The customerType to set.
	 */
	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

	/**
	 * @return Returns the details.
	 */
	public Vector getDetails() {
		return details;
	}

	/**
	 * @param details
	 *            The details to set.
	 */
	public void setDetails(Vector details) {
		this.details = details;
	}

	/**
	 * @return Returns the ibmOwnAssumption.
	 */
	public String getIbmOwnAssumption() {
		return ibmOwnAssumption;
	}

	/**
	 * @return Returns the industry.
	 */
	public String getIndustry() {
		return industry;
	}

	/**
	 * @param industry
	 *            The industry to set.
	 */
	public void setIndustry(String industry) {
		this.industry = industry;
	}

	/**
	 * @return Returns the osAuthAssumption.
	 */
	public String getOsAuthAssumption() {
		return osAuthAssumption;
	}

	/**
	 * @return Returns the overallAgreementFlag.
	 */
	public boolean isOverallAgreementFlag() {
		return overallAgreementFlag;
	}

	/**
	 * @param overallAgreementFlag
	 *            The overallAgreementFlag to set.
	 */
	public void setOverallAgreementFlag(boolean overallAgreementFlag) {
		this.overallAgreementFlag = overallAgreementFlag;
	}

	/**
	 * @return Returns the overallIbmOwnFlag.
	 */
	public boolean isOverallIbmOwnFlag() {
		return overallIbmOwnFlag;
	}

	/**
	 * @param overallIbmOwnFlag
	 *            The overallIbmOwnFlag to set.
	 */
	public void setOverallIbmOwnFlag(boolean overallIbmOwnFlag) {
		this.overallIbmOwnFlag = overallIbmOwnFlag;
	}

	/**
	 * @return Returns the overallOsAuthFlag.
	 */
	public boolean isOverallOsAuthFlag() {
		return overallOsAuthFlag;
	}

	/**
	 * @param overallOsAuthFlag
	 *            The overallOsAuthFlag to set.
	 */
	public void setOverallOsAuthFlag(boolean overallOsAuthFlag) {
		this.overallOsAuthFlag = overallOsAuthFlag;
	}

	/**
	 * @return Returns the overallProcessorFlag.
	 */
	public boolean isOverallProcessorFlag() {
		return overallProcessorFlag;
	}

	/**
	 * @param overallProcessorFlag
	 *            The overallProcessorFlag to set.
	 */
	public void setOverallProcessorFlag(boolean overallProcessorFlag) {
		this.overallProcessorFlag = overallProcessorFlag;
	}

	/**
	 * @return Returns the overallSoftwareFlag.
	 */
	public boolean isOverallSoftwareFlag() {
		return overallSoftwareFlag;
	}

	/**
	 * @param overallSoftwareFlag
	 *            The overallSoftwareFlag to set.
	 */
	public void setOverallSoftwareFlag(boolean overallSoftwareFlag) {
		this.overallSoftwareFlag = overallSoftwareFlag;
	}

	/**
	 * @return Returns the overallUserFlag.
	 */
	public boolean isOverallUserFlag() {
		return overallUserFlag;
	}

	/**
	 * @param overallUserFlag
	 *            The overallUserFlag to set.
	 */
	public void setOverallUserFlag(boolean overallUserFlag) {
		this.overallUserFlag = overallUserFlag;
	}

	/**
	 * @return Returns the pod.
	 */
	public String getPod() {
		return pod;
	}

	/**
	 * @param pod
	 *            The pod to set.
	 */
	public void setPod(String pod) {
		this.pod = pod;
	}

	/**
	 * @return Returns the priceLevel.
	 */
	public String getPriceLevel() {
		return priceLevel;
	}

	/**
	 * @param priceLevel
	 *            The priceLevel to set.
	 */
	public void setPriceLevel(String priceLevel) {
		this.priceLevel = priceLevel;
	}

	/**
	 * @return Returns the priceLevelAssumption.
	 */
	public String getPriceLevelAssumption() {
		return priceLevelAssumption;
	}

	/**
	 * @return Returns the priceLevelFlag.
	 */
	public boolean isPriceLevelFlag() {
		return priceLevelFlag;
	}

	/**
	 * @param priceLevelFlag
	 *            The priceLevelFlag to set.
	 */
	public void setPriceLevelFlag(boolean priceLevelFlag) {
		this.priceLevelFlag = priceLevelFlag;
	}

	/**
	 * @return Returns the processorAssumption.
	 */
	public String getProcessorAssumption() {
		return processorAssumption;
	}

	/**
	 * @return Returns the qualifiedDiscount.
	 */
	public String getQualifiedDiscount() {
		return qualifiedDiscount;
	}

	/**
	 * @param qualifiedDiscount
	 *            The qualifiedDiscount to set.
	 */
	public void setQualifiedDiscount(String qualifiedDiscount) {
		this.qualifiedDiscount = qualifiedDiscount;
	}

	/**
	 * @return Returns the sector.
	 */
	public String getSector() {
		return sector;
	}

	/**
	 * @param sector
	 *            The sector to set.
	 */
	public void setSector(String sector) {
		this.sector = sector;
	}

	/**
	 * @return Returns the softwareNameAssumption.
	 */
	public String getSoftwareNameAssumption() {
		return softwareNameAssumption;
	}

	/**
	 * @return Returns the summary.
	 */
	public HashMap getSummary() {
		return summary;
	}

	/**
	 * @param summary
	 *            The summary to set.
	 */
	public void setSummary(HashMap summary) {
		this.summary = summary;
	}

	/**
	 * @return Returns the totalEsplaPrice.
	 */
	public BigDecimal getTotalEsplaPrice() {
		return totalEsplaPrice.setScale(2,BigDecimal.ROUND_HALF_UP);
	}

	/**
	 * @param totalEsplaPrice
	 *            The totalEsplaPrice to set.
	 */
	public void setTotalEsplaPrice(BigDecimal totalEsplaPrice) {
		this.totalEsplaPrice = totalEsplaPrice;
	}

	/**
	 * @return Returns the totalSplaPrice.
	 */
	public BigDecimal getTotalSplaPrice() {
		return totalSplaPrice.setScale(2,BigDecimal.ROUND_HALF_UP);
	}

	/**
	 * @param totalSplaPrice
	 *            The totalSplaPrice to set.
	 */
	public void setTotalSplaPrice(BigDecimal totalSplaPrice) {
		this.totalSplaPrice = totalSplaPrice;
	}

	/**
	 * @return Returns the userAssumption.
	 */
	public String getUserAssumption() {
		return userAssumption;
	}

	/**
	 * @return Returns the poDate.
	 */
	public String getPoDate() {
		return poDate;
	}

	/**
	 * @param poDate
	 *            The poDate to set.
	 */
	public void setPoDate(String poDate) {
		this.poDate = poDate;
	}

	/**
	 * @return Returns the poDates.
	 */
	public ArrayList getPoDates() {
		return poDates;
	}

	/**
	 * @param poDates
	 *            The poDates to set.
	 */
	public void setPoDates(ArrayList poDates) {
		this.poDates = poDates;
	}

	/**
	 * @return Returns the poNumber.
	 */
	public String getPoNumber() {
		return poNumber;
	}

	/**
	 * @param poNumber
	 *            The poNumber to set.
	 */
	public void setPoNumber(String poNumber) {
		this.poNumber = poNumber;
	}

	/**
	 * @return Returns the usageDate.
	 */
	public String getUsageDate() {
		return usageDate;
	}

	/**
	 * @param usageDate
	 *            The usageDate to set.
	 */
	public void setUsageDate(String usageDate) {
		this.usageDate = usageDate;
	}

	/**
	 * @return Returns the usageDates.
	 */
	public ArrayList getUsageDates() {
		return usageDates;
	}

	/**
	 * @param usageDates
	 *            The usageDates to set.
	 */
	public void setUsageDates(ArrayList usageDates) {
		this.usageDates = usageDates;
	}

	/**
	 * @return
	 */
	public String getPodId() {
		return podId;
	}

	/**
	 * @param podId
	 *            The podId to set.
	 */
	public void setPodId(String podId) {
		this.podId = podId;
	}

	/**
	 * @return Returns the lpid.
	 */
	public String getLpid() {
		return lpid;
	}

	/**
	 * @param lpid
	 *            The lpid to set.
	 */
	public void setLpid(String lpid) {
		this.lpid = lpid;
	}

	/**
	 * @return Returns the lpids.
	 */
	public ArrayList getLpids() {
		return lpids;
	}

	/**
	 * @param lpids
	 *            The lpids to set.
	 */
	public void setLpids(ArrayList lpids) {
		this.lpids = lpids;
	}

	/**
	 * @return Returns the lpidTotals.
	 */
	public HashMap getLpidTotals() {
		return lpidTotals;
	}

	/**
	 * @param lpidTotals
	 *            The lpidTotals to set.
	 */
	public void setLpidTotals(HashMap lpidTotals) {
		this.lpidTotals = lpidTotals;
	}

	/**
	 * @return Returns the overallNodeOwnerFlag.
	 */
	public boolean isOverallNodeOwnerFlag() {
		return overallNodeOwnerFlag;
	}

	/**
	 * @param overallNodeOwnerFlag
	 *            The overallNodeOwnerFlag to set.
	 */
	public void setOverallNodeOwnerFlag(boolean overallNodeOwnerFlag) {
		this.overallNodeOwnerFlag = overallNodeOwnerFlag;
	}

	/**
	 * @return Returns the nodeOwnerAssumption.
	 */
	public String getNodeOwnerAssumption() {
		return nodeOwnerAssumption;
	}
}