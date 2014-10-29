package com.ibm.ea.bravo.software;

import org.apache.log4j.Logger;

public class SoftwareLparIPAddress {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(SoftwareLparIPAddress.class);

	private Long id;
	private String gateway;
	private Integer instanceId;
	private String ipAddress;
	private String ipDomain;
	private String ipHostName;
	private String ipSubnet;
	private String ipv6Address;
	private String isDHCP;
	private String permMacAddress;
	private String primaryDNS;
	private String secondaryDNS;
	private SoftwareLpar softwareLpar;
	public String getGateway() {
		return gateway;
	}
	public void setGateway(String gateway) {
		this.gateway = gateway;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Integer getInstanceId() {
		return instanceId;
	}
	public void setInstanceId(Integer instanceId) {
		this.instanceId = instanceId;
	}
	public String getIpAddress() {
		return ipAddress;
	}
	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}
	public String getIpDomain() {
		return ipDomain;
	}
	public void setIpDomain(String ipDomain) {
		this.ipDomain = ipDomain;
	}
	public String getIpHostName() {
		return ipHostName;
	}
	public void setIpHostName(String ipHostName) {
		this.ipHostName = ipHostName;
	}
	public String getIpSubnet() {
		return ipSubnet;
	}
	public void setIpSubnet(String ipSubnet) {
		this.ipSubnet = ipSubnet;
	}
	public String getIpv6Address() {
		return ipv6Address;
	}
	public void setIpv6Address(String ipv6Address) {
		this.ipv6Address = ipv6Address;
	}
	public String getIsDHCP() {
		return isDHCP;
	}
	public void setIsDHCP(String isDHCP) {
		this.isDHCP = isDHCP;
	}
	public String getPermMacAddress() {
		return permMacAddress;
	}
	public void setPermMacAddress(String permMacAddress) {
		this.permMacAddress = permMacAddress;
	}
	public String getPrimaryDNS() {
		return primaryDNS;
	}
	public void setPrimaryDNS(String primaryDNS) {
		this.primaryDNS = primaryDNS;
	}
	public String getSecondaryDNS() {
		return secondaryDNS;
	}
	public void setSecondaryDNS(String secondaryDNS) {
		this.secondaryDNS = secondaryDNS;
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
	
}
