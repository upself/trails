/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.om.microsoftPriceList;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.tap.misld.om.licenseAgreementType.LicenseAgreementType;
import com.ibm.tap.misld.om.priceLevel.PriceLevel;
import com.ibm.tap.misld.om.qualifiedDiscount.QualifiedDiscount;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MicrosoftPriceList extends ValidatorActionForm {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long microsoftPriceListId;

	private Long microsoftProductId;

	private MicrosoftProduct microsoftProduct;

	private Long licenseAgreementTypeId;

	private LicenseAgreementType licenseAgreementType;

	private String sku;

	private String authenticated;

	private Long priceLevelId;

	private PriceLevel priceLevel;

	private Long qualifiedDiscountId;

	private QualifiedDiscount qualifiedDiscount;

	private Long licenseTypeId;

	private LicenseType licenseType;

	private int unit;

	private Float unitPrice;

	private String remoteUser;

	private Date recordTime;

	private String status;

	/**
	 * @return Returns the licenseType.
	 */
	public LicenseType getLicenseType() {
		return licenseType;
	}

	/**
	 * @param licenseType
	 *            The licenseType to set.
	 */
	public void setLicenseType(LicenseType licenseType) {
		this.licenseType = licenseType;
	}

	/**
	 * @return Returns the microsoftPriceListId.
	 */
	public Long getMicrosoftPriceListId() {
		return microsoftPriceListId;
	}

	/**
	 * @param microsoftPriceListId
	 *            The microsoftPriceListId to set.
	 */
	public void setMicrosoftPriceListId(Long microsoftPriceListId) {
		this.microsoftPriceListId = microsoftPriceListId;
	}

	/**
	 * @return Returns the microsoftProduct.
	 */
	public MicrosoftProduct getMicrosoftProduct() {
		return microsoftProduct;
	}

	/**
	 * @param microsoftProduct
	 *            The microsoftProduct to set.
	 */
	public void setMicrosoftProduct(MicrosoftProduct microsoftProduct) {
		this.microsoftProduct = microsoftProduct;
	}

	/**
	 * @return Returns the qualifiedDiscount.
	 */
	public QualifiedDiscount getQualifiedDiscount() {
		return qualifiedDiscount;
	}

	/**
	 * @param qualifiedDiscount
	 *            The qualifiedDiscount to set.
	 */
	public void setQualifiedDiscount(QualifiedDiscount qualifiedDiscount) {
		this.qualifiedDiscount = qualifiedDiscount;
	}

	/**
	 * @return Returns the recordTime.
	 */
	public Date getRecordTime() {
		return recordTime;
	}

	/**
	 * @param recordTime
	 *            The recordTime to set.
	 */
	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
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
	 * @return Returns the status.
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * @param status
	 *            The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}

	/**
	 * @return Returns the unit.
	 */
	public int getUnit() {
		return unit;
	}

	/**
	 * @param unit
	 *            The unit to set.
	 */
	public void setUnit(int unit) {
		this.unit = unit;
	}

	/**
	 * @return Returns the unitPrice.
	 */
	public Float getUnitPrice() {
		return unitPrice;
	}

	/**
	 * @param unitPrice
	 *            The unitPrice to set.
	 */
	public void setUnitPrice(Float unitPrice) {
		this.unitPrice = unitPrice;
	}

	/**
	 * @return Returns the priceLevel.
	 */
	public PriceLevel getPriceLevel() {
		return priceLevel;
	}

	/**
	 * @param priceLevel
	 *            The priceLevel to set.
	 */
	public void setPriceLevel(PriceLevel priceLevel) {
		this.priceLevel = priceLevel;
	}

	/**
	 * @return Returns the licenseAgreementType.
	 */
	public LicenseAgreementType getLicenseAgreementType() {
		return licenseAgreementType;
	}

	/**
	 * @param licenseAgreementType
	 *            The licenseAgreementType to set.
	 */
	public void setLicenseAgreementType(
			LicenseAgreementType licenseAgreementType) {
		this.licenseAgreementType = licenseAgreementType;
	}

	/**
	 * @return Returns the sku.
	 */
	public String getSku() {
		return sku;
	}

	/**
	 * @param sku
	 *            The sku to set.
	 */
	public void setSku(String sku) {
		this.sku = sku;
	}

	/**
	 * @return Returns the authenticated.
	 */
	public String getAuthenticated() {
		return authenticated;
	}

	/**
	 * @param authenticated
	 *            The authenticated to set.
	 */
	public void setAuthenticated(String authenticated) {
		this.authenticated = authenticated;
	}

	/**
	 * @return Returns the licenseAgreementId.
	 */
	public Long getLicenseAgreementTypeId() {
		return licenseAgreementTypeId;
	}

	/**
	 * @param licenseAgreementId
	 *            The licenseAgreementId to set.
	 */
	public void setLicenseAgreementTypeId(Long licenseAgreementTypeId) {
		this.licenseAgreementTypeId = licenseAgreementTypeId;
	}

	/**
	 * @return Returns the licenseTypeId.
	 */
	public Long getLicenseTypeId() {
		return licenseTypeId;
	}

	/**
	 * @param licenseTypeId
	 *            The licenseTypeId to set.
	 */
	public void setLicenseTypeId(Long licenseTypeId) {
		this.licenseTypeId = licenseTypeId;
	}

	/**
	 * @return Returns the microsoftProdductId.
	 */
	public Long getMicrosoftProductId() {
		return microsoftProductId;
	}

	/**
	 * @param microsoftProdductId
	 *            The microsoftProdductId to set.
	 */
	public void setMicrosoftProductId(Long microsoftProductId) {
		this.microsoftProductId = microsoftProductId;
	}

	/**
	 * @return Returns the priceLevelId.
	 */
	public Long getPriceLevelId() {
		return priceLevelId;
	}

	/**
	 * @param priceLevelId
	 *            The priceLevelId to set.
	 */
	public void setPriceLevelId(Long priceLevelId) {
		this.priceLevelId = priceLevelId;
	}

	/**
	 * @return Returns the qualifiedDiscountId.
	 */
	public Long getQualifiedDiscountId() {
		return qualifiedDiscountId;
	}

	/**
	 * @param qualifiedDiscountId
	 *            The qualifiedDiscountId to set.
	 */
	public void setQualifiedDiscountId(Long qualifiedDiscountId) {
		this.qualifiedDiscountId = qualifiedDiscountId;
	}
}