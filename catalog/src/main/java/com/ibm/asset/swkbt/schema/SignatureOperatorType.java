//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.0-b52-fcs 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.10.19 at 09:53:30 PM EDT 
//

package com.ibm.asset.swkbt.schema;

import javax.xml.bind.annotation.XmlEnum;

/**
 * <p>
 * Java class for signatureOperatorType.
 * 
 * <p>
 * The following schema fragment specifies the expected content contained within
 * this class.
 * <p>
 * 
 * <pre>
 * &lt;simpleType name="signatureOperatorType">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="AND"/>
 *     &lt;enumeration value="OR"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlEnum
public enum SignatureOperatorType {

	AND, OR;

	public String value() {
		return name();
	}

	public static SignatureOperatorType fromValue(String v) {
		return valueOf(v);
	}

}
