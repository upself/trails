//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.0-b52-fcs 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.10.19 at 09:53:30 PM EDT 
//

package com.ibm.asset.swkbt.schema;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * <p>
 * Java class for DistributedProductType complex type.
 * 
 * <p>
 * The following schema fragment specifies the expected content contained within
 * this class.
 * 
 * <pre>
 * &lt;complexType name="DistributedProductType">
 *   &lt;complexContent>
 *     &lt;extension base="{}SoftwareItemType">
 *       &lt;sequence>
 *         &lt;element name="alias" type="{}AliasType" maxOccurs="unbounded" minOccurs="0"/>
 *         &lt;element name="additional" type="{}additionalStructureType" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="IPLA" type="{}IPLAType" />
 *       &lt;attribute name="PVU" type="{http://www.w3.org/2001/XMLSchema}boolean" />
 *       &lt;attribute name="function" type="{}productFunctionEnum" />
 *       &lt;attribute name="licenseType" type="{}licenseType" />
 *       &lt;attribute name="manufacturer" use="required" type="{}GUIDType" />
 *       &lt;attribute name="subCapacityLicensing" type="{http://www.w3.org/2001/XMLSchema}boolean" />
 *     &lt;/extension>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "DistributedProductType", propOrder = { "alias", "additional" })
@XmlRootElement(name = "DistributedProduct")
public class DistributedProductType extends SoftwareItemType {

	@XmlElement(required = true)
	protected List<AliasType> alias;
	protected AdditionalStructureType additional;
	@XmlAttribute(name = "IPLA")
	protected IPLAType ipla;
	@XmlAttribute(name = "PVU")
	protected Boolean pvu;
	@XmlAttribute
	protected String function;
	@XmlAttribute
	protected Integer licenseType;
	@XmlAttribute(required = true)
	protected String manufacturer;
	@XmlAttribute
	protected Boolean subCapacityLicensing;

	/**
	 * Gets the value of the alias property.
	 * 
	 * <p>
	 * This accessor method returns a reference to the live list, not a
	 * snapshot. Therefore any modification you make to the returned list will
	 * be present inside the JAXB object. This is why there is not a
	 * <CODE>set</CODE> method for the alias property.
	 * 
	 * <p>
	 * For example, to add a new item, do as follows:
	 * 
	 * <pre>
	 * getAlias().add(newItem);
	 * </pre>
	 * 
	 * 
	 * <p>
	 * Objects of the following type(s) are allowed in the list
	 * {@link AliasType }
	 * 
	 * 
	 */
	public List<AliasType> getAlias() {
		if (alias == null) {
			alias = new ArrayList<AliasType>();
		}
		return this.alias;
	}

	/**
	 * Gets the value of the additional property.
	 * 
	 * @return possible object is {@link AdditionalStructureType }
	 * 
	 */
	public AdditionalStructureType getAdditional() {
		return additional;
	}

	/**
	 * Sets the value of the additional property.
	 * 
	 * @param value
	 *            allowed object is {@link AdditionalStructureType }
	 * 
	 */
	public void setAdditional(AdditionalStructureType value) {
		this.additional = value;
	}

	/**
	 * Gets the value of the ipla property.
	 * 
	 * @return possible object is {@link IPLAType }
	 * 
	 */
	public IPLAType getIPLA() {
		return ipla;
	}

	/**
	 * Sets the value of the ipla property.
	 * 
	 * @param value
	 *            allowed object is {@link IPLAType }
	 * 
	 */
	public void setIPLA(IPLAType value) {
		this.ipla = value;
	}

	/**
	 * Gets the value of the pvu property.
	 * 
	 * @return possible object is {@link Boolean }
	 * 
	 */
	public Boolean isPVU() {
		return pvu;
	}

	/**
	 * Sets the value of the pvu property.
	 * 
	 * @param value
	 *            allowed object is {@link Boolean }
	 * 
	 */
	public void setPVU(Boolean value) {
		this.pvu = value;
	}

	/**
	 * Gets the value of the function property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getFunction() {
		return function;
	}

	/**
	 * Sets the value of the function property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setFunction(String value) {
		this.function = value;
	}

	/**
	 * Gets the value of the licenseType property.
	 * 
	 * @return possible object is {@link Integer }
	 * 
	 */
	public Integer getLicenseType() {
		return licenseType;
	}

	/**
	 * Sets the value of the licenseType property.
	 * 
	 * @param value
	 *            allowed object is {@link Integer }
	 * 
	 */
	public void setLicenseType(Integer value) {
		this.licenseType = value;
	}

	/**
	 * Gets the value of the manufacturer property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getManufacturer() {
		return manufacturer;
	}

	/**
	 * Sets the value of the manufacturer property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setManufacturer(String value) {
		this.manufacturer = value;
	}

	/**
	 * Gets the value of the subCapacityLicensing property.
	 * 
	 * @return possible object is {@link Boolean }
	 * 
	 */
	public Boolean isSubCapacityLicensing() {
		return subCapacityLicensing;
	}

	/**
	 * Sets the value of the subCapacityLicensing property.
	 * 
	 * @param value
	 *            allowed object is {@link Boolean }
	 * 
	 */
	public void setSubCapacityLicensing(Boolean value) {
		this.subCapacityLicensing = value;
	}

}
