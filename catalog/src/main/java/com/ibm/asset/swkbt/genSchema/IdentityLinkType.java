//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4-2 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2015.07.20 at 12:15:07 PM CST 
//


package com.ibm.asset.swkbt.genSchema;

import java.util.HashMap;
import java.util.Map;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAnyAttribute;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlType;
import javax.xml.namespace.QName;


/**
 * <p>Java class for IdentityLinkType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="IdentityLinkType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="additional" type="{}additionalStructureType" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="primary" use="required" type="{}GUIDType" />
 *       &lt;attribute name="descendant" use="required" type="{}GUIDType" />
 *       &lt;anyAttribute processContents='lax'/>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "IdentityLinkType", propOrder = {
    "additional"
})
public class IdentityLinkType {

    protected AdditionalStructureType additional;
    @XmlAttribute(name = "primary", required = true)
    protected String primary;
    @XmlAttribute(name = "descendant", required = true)
    protected String descendant;
    @XmlAnyAttribute
    private Map<QName, String> otherAttributes = new HashMap<QName, String>();

    /**
     * Gets the value of the additional property.
     * 
     * @return
     *     possible object is
     *     {@link AdditionalStructureType }
     *     
     */
    public AdditionalStructureType getAdditional() {
        return additional;
    }

    /**
     * Sets the value of the additional property.
     * 
     * @param value
     *     allowed object is
     *     {@link AdditionalStructureType }
     *     
     */
    public void setAdditional(AdditionalStructureType value) {
        this.additional = value;
    }

    /**
     * Gets the value of the primary property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPrimary() {
        return primary;
    }

    /**
     * Sets the value of the primary property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPrimary(String value) {
        this.primary = value;
    }

    /**
     * Gets the value of the descendant property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDescendant() {
        return descendant;
    }

    /**
     * Sets the value of the descendant property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDescendant(String value) {
        this.descendant = value;
    }

    /**
     * Gets a map that contains attributes that aren't bound to any typed property on this class.
     * 
     * <p>
     * the map is keyed by the name of the attribute and 
     * the value is the string value of the attribute.
     * 
     * the map returned by this method is live, and you can add new attribute
     * by updating the map directly. Because of this design, there's no setter.
     * 
     * 
     * @return
     *     always non-null
     */
    public Map<QName, String> getOtherAttributes() {
        return otherAttributes;
    }

}
