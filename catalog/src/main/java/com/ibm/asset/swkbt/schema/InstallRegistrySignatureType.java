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

/**
 * <p>
 * Java class for InstallRegistrySignatureType complex type.
 * 
 * <p>
 * The following schema fragment specifies the expected content contained within
 * this class.
 * 
 * <pre>
 * &lt;complexType name="InstallRegistrySignatureType">
 *   &lt;complexContent>
 *     &lt;extension base="{}SignatureType">
 *       &lt;sequence>
 *         &lt;element name="additional" type="{}additionalStructureType" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="data" use="required" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="key" use="required" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="source" use="required" type="{}registrySourceEnum" />
 *     &lt;/extension>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "InstallRegistrySignatureType", propOrder = { "additional" })
@XmlRootElement(name = "InstallRegistrySignature")
public class InstallRegistrySignatureType extends SignatureType {

	protected AdditionalStructureType additional;
	@XmlAttribute(required = true)
	protected String data;
	@XmlAttribute(required = true)
	protected String key;
	@XmlAttribute(required = true)
	protected RegistrySourceEnum source;

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
	 * Gets the value of the data property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getData() {
		return data;
	}

	/**
	 * Sets the value of the data property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setData(String value) {
		this.data = value;
	}

	/**
	 * Gets the value of the key property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getKey() {
		return key;
	}

	/**
	 * Sets the value of the key property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setKey(String value) {
		this.key = value;
	}

	/**
	 * Gets the value of the source property.
	 * 
	 * @return possible object is {@link RegistrySourceEnum }
	 * 
	 */
	public RegistrySourceEnum getSource() {
		return source;
	}

	/**
	 * Sets the value of the source property.
	 * 
	 * @param value
	 *            allowed object is {@link RegistrySourceEnum }
	 * 
	 */
	public void setSource(RegistrySourceEnum value) {
		this.source = value;
	}

}
