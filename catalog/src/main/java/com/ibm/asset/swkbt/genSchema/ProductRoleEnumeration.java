//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4-2 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2015.07.20 at 12:15:07 PM CST 
//


package com.ibm.asset.swkbt.genSchema;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for productRoleEnumeration.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="productRoleEnumeration">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="SOFTWARE_PRODUCT"/>
 *     &lt;enumeration value="COMPONENT"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "productRoleEnumeration")
@XmlEnum
public enum ProductRoleEnumeration {

    SOFTWARE_PRODUCT,
    COMPONENT;

    public String value() {
        return name();
    }

    public static ProductRoleEnumeration fromValue(String v) {
        return valueOf(v);
    }

}
