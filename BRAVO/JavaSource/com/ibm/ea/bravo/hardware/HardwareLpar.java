package com.ibm.ea.bravo.hardware;

import java.util.Date;
import java.util.Set;

import com.ibm.asset.bravo.domain.AuthorizedProduct;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.software.SoftwareLpar;
import com.ibm.ea.bravo.software.SoftwareLparEff;
import com.ibm.ea.cndb.Customer;

public class HardwareLpar {
	private Long id;

	private String name;

	private Customer customer;

	private Hardware hardware;

	private String remoteUser;

	private Date recordTime;

	private String status;

	private SoftwareLpar softwareLpar;

	private String extId;

	private String techImageId;

	private String serverType;

	private Integer partMIPS;

	private Integer partMSU;
	
	private String lparStatus;
	
	private String spla;
	
	private String sysplex;
	
	private String internetIccFlag;
	
	private Set<AuthorizedProduct> authorizedProducts;
	
	private HardwareLparEff hardwareLparEff;

	public HardwareLparEff getHardwareLparEff() {
		return hardwareLparEff;
	}

	public void setHardwareLparEff(HardwareLparEff hardwareLparEff) {
		this.hardwareLparEff = hardwareLparEff;
	}
	
	public String getServerType() {
		return serverType;
	}

	public void setServerType(String serverType) {
		this.serverType = serverType;
	}

	public String getLparStatus() {
		return lparStatus;
	}

	public void setLparStatus(String lparStatus) {
		this.lparStatus = lparStatus;
	}
	
	public Integer getPartMIPS() {
		return partMIPS;
	}
	
	public void setPartMIPS(Integer partMIPS) {
		this.partMIPS = partMIPS;
	}

	public Integer getPartMSU() {
		return partMSU;
	}
	
	public void setPartMSU(Integer partMSU) {
		this.partMSU = partMSU;
	}

	public Customer getCustomer() {
		return this.customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	public Hardware getHardware() {
		return this.hardware;
	}

	public void setHardware(Hardware hardware) {
		this.hardware = hardware;
	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getRecordTime() {
		return this.recordTime;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	public String getRemoteUser() {
		return this.remoteUser;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public SoftwareLpar getSoftwareLpar() {
		return this.softwareLpar;
	}

	public void setSoftwareLpar(SoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}

	public String getSpla() {
		return this.spla;
	}

	public void setSpla(String spla) {
		this.spla = spla;
	}
	
	public String getSysplex() {
		return this.sysplex;
	}

	public void setSysplex(String sysplex) {
		this.sysplex = sysplex;
	}
	
	public String getInternetIccFlag() {
		return this.internetIccFlag;
	}

	public void setInternetIccFlag(String internetIccFlag) {
		this.internetIccFlag = internetIccFlag;
	}
	
	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getUrl() {
		if (this == null)
			return "<a href=\"/BRAVO/hardware/lpar/create.do?accountId="
					+ this.customer.getAccountNumber() + "&lparName="
					+ this.name + "\">No Hardware Record</a>";

		return "<a href=\"/BRAVO/lpar/view.do?accountId="
				+ this.customer.getAccountNumber() + "&lparName=" + this.name
				+ "\">View Details</a>";
	}

	public String getStatusImage() {
		if (this.status.equals(Constants.ACTIVE))
			return "<img alt=\"" + Constants.ACTIVE + "\" src=\""
					+ Constants.ICON_SYSTEM_STATUS_OK
					+ "\" width=\"12\" height=\"10\"/>";
		else
			return "<img alt=\"" + Constants.INACTIVE + "\" src=\""
					+ Constants.ICON_SYSTEM_STATUS_NA
					+ "\" width=\"12\" height=\"10\"/>";
	}

	public String getStatusIcon() {
		if (this.status.equals(Constants.ACTIVE))
			return Constants.ICON_SYSTEM_STATUS_OK;
		else
			return Constants.ICON_SYSTEM_STATUS_NA;
	}

	public String getExtId() {
		return extId;
	}

	public void setExtId(String extId) {
		this.extId = extId;
	}

	public String getTechImageId() {
		return techImageId;
	}

	public void setTechImageId(String techImageId) {
		this.techImageId = techImageId;
	}

	public void setAuthorizedProducts(Set<AuthorizedProduct> authorizedProducts) {
		this.authorizedProducts = authorizedProducts;
	}

	public Set<AuthorizedProduct> getAuthorizedProducts() {
		return authorizedProducts;
	}

}