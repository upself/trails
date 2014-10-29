package com.ibm.ea.bravo.software;

import org.apache.log4j.Logger;

public class SoftwareLparADC {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(SoftwareLparADC.class);

	private Long id;
	private String cust;
	private String epName;
	private String epOid;
	private String gu;
	private String ipAddress;
	private String loc;
	private String serverType;
	private String sesdrBpUsing;
	private String sesdrLocation;
	private String sesdrSystId;
	
	private SoftwareLpar softwareLpar;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public SoftwareLpar getSoftwareLpar() {
		return softwareLpar;
	}
	public void setSoftwareLpar(SoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}
	public static Logger getLogger() {
		return logger;
	}
	public String getCust() {
		return cust;
	}
	public void setCust(String cust) {
		this.cust = cust;
	}
	public String getEpName() {
		return epName;
	}
	public void setEpName(String epName) {
		this.epName = epName;
	}
	public String getEpOid() {
		return epOid;
	}
	public void setEpOid(String epOid) {
		this.epOid = epOid;
	}
	public String getGu() {
		return gu;
	}
	public void setGu(String gu) {
		this.gu = gu;
	}
	public String getIpAddress() {
		return ipAddress;
	}
	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}
	public String getLoc() {
		return loc;
	}
	public void setLoc(String loc) {
		this.loc = loc;
	}
	public String getServerType() {
		return serverType;
	}
	public void setServerType(String serverType) {
		this.serverType = serverType;
	}
	public String getSesdrBpUsing() {
		return sesdrBpUsing;
	}
	public void setSesdrBpUsing(String sesdrBpUsing) {
		this.sesdrBpUsing = sesdrBpUsing;
	}
	public String getSesdrLocation() {
		return sesdrLocation;
	}
	public void setSesdrLocation(String sesdrLocation) {
		this.sesdrLocation = sesdrLocation;
	}
	public String getSesdrSystId() {
		return sesdrSystId;
	}
	public void setSesdrSystId(String sesdrSystId) {
		this.sesdrSystId = sesdrSystId;
	}
}
