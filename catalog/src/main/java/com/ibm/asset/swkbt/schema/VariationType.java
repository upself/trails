//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.0-b52-fcs 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.10.19 at 09:53:30 PM EDT 
//

package com.ibm.asset.swkbt.schema;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;

/**
 * <p>
 * Java class for VariationType complex type.
 * 
 * <p>
 * The following schema fragment specifies the expected content contained within
 * this class.
 * 
 * <pre>
 * &lt;complexType name="VariationType">
 *   &lt;complexContent>
 *     &lt;extension base="{}KbDefinitionType">
 *       &lt;sequence>
 *         &lt;element name="additional" type="{}additionalStructureType" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="activationDate" type="{}dateTimeType" />
 *       &lt;attribute name="release" use="required" type="{}GUIDType" />
 *       &lt;attribute name="variation" use="required" type="{http://www.w3.org/2001/XMLSchema}string" />
 *     &lt;/extension>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "VariationType", propOrder = { "additional" })
@XmlRootElement(name = "Variation")
public class VariationType extends KbDefinitionType {

	protected AdditionalStructureType additional;
	@XmlAttribute
	protected XMLGregorianCalendar activationDate;
	@XmlAttribute(required = true)
	protected String release;
	@XmlAttribute(required = true)
	protected String variation;

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
	 * Gets the value of the activationDate property.
	 * 
	 * @return possible object is {@link XMLGregorianCalendar }
	 * 
	 */
	public XMLGregorianCalendar getActivationDate() {
		return activationDate;
	}

	/**
	 * Sets the value of the activationDate property.
	 * 
	 * @param value
	 *            allowed object is {@link XMLGregorianCalendar }
	 * 
	 */
	public void setActivationDate(XMLGregorianCalendar value) {
		this.activationDate = value;
	}

	/**
	 * Gets the value of the release property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getRelease() {
		return release;
	}

	/**
	 * Sets the value of the release property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setRelease(String value) {
		this.release = value;
	}

	/**
	 * Gets the value of the variation property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getVariation() {
		return variation;
	}

	/**
	 * Sets the value of the variation property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setVariation(String value) {
		this.variation = value;
	}

}
