/*
 * Created on Mar 24, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.filter;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.asset.swkbt.domain.Product;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareFilterInput extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long softwareFilterId;

	private Product product;

	private String softwareName;

	private String softwareVersion;

	private String mapSoftwareVersion;

	private String osType;

	private String packageId;

	private String nativId;

	private String registryKey;

	/**
	 * @return Returns the mapSoftwareVersion.
	 */
	public String getMapSoftwareVersion() {
		return mapSoftwareVersion;
	}

	/**
	 * @param mapSoftwareVersion
	 *            The mapSoftwareVersion to set.
	 */
	public void setMapSoftwareVersion(String mapSoftwareVersion) {
		this.mapSoftwareVersion = mapSoftwareVersion;
	}

	/**
	 * @return Returns the nativId.
	 */
	public String getNativId() {
		return nativId;
	}

	/**
	 * @param nativId
	 *            The nativId to set.
	 */
	public void setNativId(String nativId) {
		this.nativId = nativId;
	}

	/**
	 * @return Returns the osType.
	 */
	public String getOsType() {
		return osType;
	}

	/**
	 * @param osType
	 *            The osType to set.
	 */
	public void setOsType(String osType) {
		this.osType = osType;
	}

	/**
	 * @return Returns the packageId.
	 */
	public String getPackageId() {
		return packageId;
	}

	/**
	 * @param packageId
	 *            The packageId to set.
	 */
	public void setPackageId(String packageId) {
		this.packageId = packageId;
	}

	/**
	 * @return Returns the software.
	 */
	public Product getProduct() {
		return product;
	}

	/**
	 * @param software
	 *            The software to set.
	 */
	public void setProduct(Product product) {
		this.product = product;
	}

	/**
	 * @return Returns the softwareFilterId.
	 */
	public Long getSoftwareFilterId() {
		return softwareFilterId;
	}

	/**
	 * @param softwareFilterId
	 *            The softwareFilterId to set.
	 */
	public void setSoftwareFilterId(Long softwareFilterId) {
		this.softwareFilterId = softwareFilterId;
	}

	/**
	 * @return Returns the softwareName.
	 */
	public String getSoftwareName() {
		return softwareName;
	}

	/**
	 * @param softwareName
	 *            The softwareName to set.
	 */
	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

	/**
	 * @return Returns the softwareVersion.
	 */
	public String getSoftwareVersion() {
		return softwareVersion;
	}

	/**
	 * @param softwareVersion
	 *            The softwareVersion to set.
	 */
	public void setSoftwareVersion(String softwareVersion) {
		this.softwareVersion = softwareVersion;
	}

	/**
	 * @return Returns the registryKey.
	 */
	public String getRegistryKey() {
		return registryKey;
	}

	/**
	 * @param registryKey
	 *            The registryKey to set.
	 */
	public void setRegistryKey(String registryKey) {
		this.registryKey = registryKey;
	}
}
