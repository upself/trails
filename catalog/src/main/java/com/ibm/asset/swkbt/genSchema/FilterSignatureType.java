//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4-2 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2015.07.20 at 12:15:07 PM CST 
//


package com.ibm.asset.swkbt.genSchema;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for FilterSignatureType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="FilterSignatureType">
 *   &lt;complexContent>
 *     &lt;extension base="{}SignatureType">
 *       &lt;sequence>
 *         &lt;element name="additional" type="{}additionalStructureType" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="packageName" use="required" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="packageVersion" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="packageVendor" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;anyAttribute processContents='lax'/>
 *     &lt;/extension>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "FilterSignatureType", propOrder = {
    "additional"
})
public class FilterSignatureType
    extends SignatureType
{

    protected AdditionalStructureType additional;
    @XmlAttribute(name = "packageName", required = true)
    protected String packageName;
    @XmlAttribute(name = "packageVersion")
    protected String packageVersion;
    @XmlAttribute(name = "packageVendor")
    protected String packageVendor;

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
     * Gets the value of the packageName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPackageName() {
        return packageName;
    }

    /**
     * Sets the value of the packageName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPackageName(String value) {
        this.packageName = value;
    }

    /**
     * Gets the value of the packageVersion property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPackageVersion() {
        return packageVersion;
    }

    /**
     * Sets the value of the packageVersion property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPackageVersion(String value) {
        this.packageVersion = value;
    }

    /**
     * Gets the value of the packageVendor property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPackageVendor() {
        return packageVendor;
    }

    /**
     * Sets the value of the packageVendor property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPackageVendor(String value) {
        this.packageVendor = value;
    }

}
