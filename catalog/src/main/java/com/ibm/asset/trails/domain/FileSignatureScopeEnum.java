//
// This file was generated by the JavaTM Architecture for 
// See <a href="http://java.sun.com/
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.09.28 at 11:19:21 AM EDT 
//

package com.ibm.asset.trails.domain;

public enum FileSignatureScopeEnum {

	BOTH, MONITORING, RECOGNITION;

	public String value() {
		return name();
	}

	public static FileSignatureScopeEnum fromValue(String v) {
		return valueOf(v);
	}

}
