//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.0-b52-fcs 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.10.19 at 09:53:30 PM EDT 
//

package com.ibm.asset.swkbt.schema;

import java.util.HashMap;
import java.util.Map;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAnyAttribute;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;
import javax.xml.namespace.QName;

/**
 * <p>
 * Java class for KbDefinitionType complex type.
 * 
 * <p>
 * The following schema fragment specifies the expected content contained within
 * this class.
 * 
 * <pre>
 * &lt;complexType name="KbDefinitionType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;attribute name="active" type="{http://www.w3.org/2001/XMLSchema}boolean" />
 *       &lt;attribute name="created" type="{}dateTimeType" />
 *       &lt;attribute name="customField1" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="customField2" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="customField3" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="dataInput" type="{}dataInputType" />
 *       &lt;attribute name="definitionSource" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="deleted" type="{http://www.w3.org/2001/XMLSchema}boolean" />
 *       &lt;attribute name="description" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="externalId" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="guid" use="required" type="{}GUIDType" />
 *       &lt;attribute name="modified" type="{}dateTimeType" />
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "KbDefinitionType")
public class KbDefinitionType {

	@XmlAttribute
	protected Boolean active;
	@XmlAttribute
	protected XMLGregorianCalendar created;
	@XmlAttribute
	protected String customField1;
	@XmlAttribute
	protected String customField2;
	@XmlAttribute
	protected String customField3;
	@XmlAttribute
	protected Integer dataInput;
	@XmlAttribute
	protected String definitionSource;
	@XmlAttribute
	protected Boolean deleted;
	@XmlAttribute
	protected String description;
	@XmlAttribute
	protected String externalId;
	@XmlAttribute(required = true)
	protected String guid;
	@XmlAttribute
	protected XMLGregorianCalendar modified;
	@XmlAnyAttribute
	private Map<QName, String> otherAttributes = new HashMap<QName, String>();

	/**
	 * Gets the value of the active property.
	 * 
	 * @return possible object is {@link Boolean }
	 * 
	 */
	public Boolean isActive() {
		return active;
	}

	/**
	 * Sets the value of the active property.
	 * 
	 * @param value
	 *            allowed object is {@link Boolean }
	 * 
	 */
	public void setActive(Boolean value) {
		this.active = value;
	}

	/**
	 * Gets the value of the created property.
	 * 
	 * @return possible object is {@link XMLGregorianCalendar }
	 * 
	 */
	public XMLGregorianCalendar getCreated() {
		return created;
	}

	/**
	 * Sets the value of the created property.
	 * 
	 * @param value
	 *            allowed object is {@link XMLGregorianCalendar }
	 * 
	 */
	public void setCreated(XMLGregorianCalendar value) {
		this.created = value;
	}

	/**
	 * Gets the value of the customField1 property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getCustomField1() {
		return customField1;
	}

	/**
	 * Sets the value of the customField1 property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setCustomField1(String value) {
		this.customField1 = value;
	}

	/**
	 * Gets the value of the customField2 property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getCustomField2() {
		return customField2;
	}

	/**
	 * Sets the value of the customField2 property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setCustomField2(String value) {
		this.customField2 = value;
	}

	/**
	 * Gets the value of the customField3 property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getCustomField3() {
		return customField3;
	}

	/**
	 * Sets the value of the customField3 property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setCustomField3(String value) {
		this.customField3 = value;
	}

	/**
	 * Gets the value of the dataInput property.
	 * 
	 * @return possible object is {@link Integer }
	 * 
	 */
	public Integer getDataInput() {
		return dataInput;
	}

	/**
	 * Sets the value of the dataInput property.
	 * 
	 * @param value
	 *            allowed object is {@link Integer }
	 * 
	 */
	public void setDataInput(Integer value) {
		this.dataInput = value;
	}

	/**
	 * Gets the value of the definitionSource property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getDefinitionSource() {
		return definitionSource;
	}

	/**
	 * Sets the value of the definitionSource property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setDefinitionSource(String value) {
		this.definitionSource = value;
	}

	/**
	 * Gets the value of the deleted property.
	 * 
	 * @return possible object is {@link Boolean }
	 * 
	 */
	public Boolean isDeleted() {
		return deleted;
	}

	/**
	 * Sets the value of the deleted property.
	 * 
	 * @param value
	 *            allowed object is {@link Boolean }
	 * 
	 */
	public void setDeleted(Boolean value) {
		this.deleted = value;
	}

	/**
	 * Gets the value of the description property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * Sets the value of the description property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setDescription(String value) {
		this.description = value;
	}

	/**
	 * Gets the value of the externalId property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getExternalId() {
		return externalId;
	}

	/**
	 * Sets the value of the externalId property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setExternalId(String value) {
		this.externalId = value;
	}

	/**
	 * Gets the value of the guid property.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getGuid() {
		return guid;
	}

	/**
	 * Sets the value of the guid property.
	 * 
	 * @param value
	 *            allowed object is {@link String }
	 * 
	 */
	public void setGuid(String value) {
		this.guid = value;
	}

	/**
	 * Gets the value of the modified property.
	 * 
	 * @return possible object is {@link XMLGregorianCalendar }
	 * 
	 */
	public XMLGregorianCalendar getModified() {
		return modified;
	}

	/**
	 * Sets the value of the modified property.
	 * 
	 * @param value
	 *            allowed object is {@link XMLGregorianCalendar }
	 * 
	 */
	public void setModified(XMLGregorianCalendar value) {
		this.modified = value;
	}

	/**
	 * Gets a map that contains attributes that aren't bound to any typed
	 * property on this class.
	 * 
	 * <p>
	 * the map is keyed by the name of the attribute and the value is the string
	 * value of the attribute.
	 * 
	 * the map returned by this method is live, and you can add new attribute by
	 * updating the map directly. Because of this design, there's no setter.
	 * 
	 * 
	 * @return always non-null
	 */
	public Map<QName, String> getOtherAttributes() {
		return otherAttributes;
	}

}
