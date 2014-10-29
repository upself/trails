/*
 * Created on Feb 5, 2009
 */
package com.ibm.ea.bravo.swasset;

import java.math.BigInteger;

/**
 * @author jain
 * 
 * Note:  Since mapping to a native sql query instead of hibernate, 
 * the attributes had to be in CAPS.
 */
public class Swasset {
	private BigInteger ID;
	private String NAME;
	private String STATUS;
	private String TYPE;
	
	public String getTYPE() {
		return TYPE;
	}
	public void setTYPE(String type) {
		TYPE = type;
	}
	public String getNAME() {
		return NAME;
	}
	public void setNAME(String name) {
		NAME = name;
	}
	public BigInteger getID() {
		return ID;
	}
	public void setID(BigInteger id) {
		ID = id;
	}
	public String getSTATUS() {
		return STATUS;
	}
	public void setSTATUS(String status) {
		STATUS = status;
	}
}
