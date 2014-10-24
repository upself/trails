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
 * Java class for RegistrySignatureType complex type.
 * 
 * <p>
 * The following schema fragment specifies the expected content contained within
 * this class.
 * 
 * <pre>
 * &lt;complexType name="RegistrySignatureType">
 *   &lt;complexContent>
 *     &lt;extension base="{}SignatureType">
 *       &lt;sequence>
 *         &lt;element name="registry" type="{}RegistryType" maxOccurs="unbounded"/>
 *         &lt;element name="additional" type="{}additionalStructureType" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="operator" type="{}signatureOperatorType" />
 *     &lt;/extension>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "RegistrySignatureType", propOrder = { "registry", "additional" })
@XmlRootElement(name = "RegistrySignature")
public class RegistrySignatureType extends SignatureType {

	@XmlElement(required = true)
	protected List<RegistryType> registry;
	protected AdditionalStructureType additional;
	@XmlAttribute
	protected SignatureOperatorType operator;

	/**
	 * Gets the value of the registry property.
	 * 
	 * <p>
	 * This accessor method returns a reference to the live list, not a
	 * snapshot. Therefore any modification you make to the returned list will
	 * be present inside the JAXB object. This is why there is not a
	 * <CODE>set</CODE> method for the registry property.
	 * 
	 * <p>
	 * For example, to add a new item, do as follows:
	 * 
	 * <pre>
	 * getRegistry().add(newItem);
	 * </pre>
	 * 
	 * 
	 * <p>
	 * Objects of the following type(s) are allowed in the list
	 * {@link RegistryType }
	 * 
	 * 
	 */
	public List<RegistryType> getRegistry() {
		if (registry == null) {
			registry = new ArrayList<RegistryType>();
		}
		return this.registry;
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
	 * Gets the value of the operator property.
	 * 
	 * @return possible object is {@link SignatureOperatorType }
	 * 
	 */
	public SignatureOperatorType getOperator() {
		return operator;
	}

	/**
	 * Sets the value of the operator property.
	 * 
	 * @param value
	 *            allowed object is {@link SignatureOperatorType }
	 * 
	 */
	public void setOperator(SignatureOperatorType value) {
		this.operator = value;
	}

}
