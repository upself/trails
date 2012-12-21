/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

public class SoftwareItem extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long id;
	private String name;
	private Date endOfSupport;
	private String productId;
	private String webSite;
	private Date activationDate;
	private String productRole;
	private String ipla;
	private Integer subCapacityLicensing;
	private MainframeVersion mainframeVersion;
	private MainframeFeature mainframeFeature;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getEndOfSupport() {
		return endOfSupport;
	}

	public void setEndOfSupport(Date endOfSupport) {
		this.endOfSupport = endOfSupport;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getWebSite() {
		return webSite;
	}

	public void setWebSite(String webSite) {
		this.webSite = webSite;
	}

	public Date getActivationDate() {
		return activationDate;
	}

	public void setActivationDate(Date activationDate) {
		this.activationDate = activationDate;
	}

	public String getProductRole() {
		return productRole;
	}

	public void setProductRole(String productRole) {
		this.productRole = productRole;
	}

	public String getIpla() {
		return ipla;
	}

	public void setIpla(String ipla) {
		this.ipla = ipla;
	}

	public Integer getSubCapacityLicensing() {
		return subCapacityLicensing;
	}

	public void setSubCapacityLicensing(Integer subCapacityLicensing) {
		this.subCapacityLicensing = subCapacityLicensing;
	}

	public MainframeVersion getMainframeVersion() {
		return mainframeVersion;
	}

	public void setMainframeVersion(MainframeVersion mainframeVersion) {
		this.mainframeVersion = mainframeVersion;
	}

	public MainframeFeature getMainframeFeature() {
		return mainframeFeature;
	}

	public void setMainframeFeature(MainframeFeature mainframeFeature) {
		this.mainframeFeature = mainframeFeature;
	}
}