package com.ibm.asset.trails.domain;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Basic;
import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.ibm.asset.swkbt.schema.IPLAType;

@Entity
@Table(name = "PRODUCT")
@Cacheable
public class Product extends SoftwareItem {

	private static final long serialVersionUID = 5398504922089320138L;

	@OneToMany(targetEntity = Alias.class, fetch = FetchType.EAGER)
	@JoinTable(name = "PRODUCT_ALIAS", joinColumns = { @JoinColumn(name = "PRODUCT_ID") }, inverseJoinColumns = { @JoinColumn(name = "ALIAS_ID") })
	protected Set<Alias> alias = new HashSet<Alias>();

	@Basic
	@Column(name = "PVU")
	protected Boolean pvu;

	@Basic
	@Column(name = "FUNCTION", length = 255)
	protected String function;

	@Basic
	@Column(name = "LICENSE_TYPE")
	protected Integer licenseType;

	@Basic
	@Column(name = "MANUFACTURER_ID")
	protected Long manufacturer;

	public Set<Alias> getAlias() {
		if (alias == null) {
			alias = new HashSet<Alias>();
		}
		return alias;
	}

	public void setAlias(Set<Alias> alias) {
		this.alias = alias;
	}

	public IPLAType getIpla() {
		return ipla;
	}

	public void setIpla(IPLAType ipla) {
		this.ipla = ipla;
	}

	public Boolean isPvu() {
		return pvu;
	}

	public void setPvu(Boolean pvu) {
		this.pvu = pvu;
	}

	public String getFunction() {
		return function;
	}

	public void setFunction(String function) {
		this.function = function;
	}

	public Integer getLicenseType() {
		return licenseType;
	}

	public void setLicenseType(Integer licenseType) {
		this.licenseType = licenseType;
	}

	public Long getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(Long manufacturer) {
		this.manufacturer = manufacturer;
	}

	public boolean isSubCapacityLicensing() {
		return subCapacityLicensing;
	}

	public void setSubCapacityLicensing(Boolean subCapacityLicensing) {
		this.subCapacityLicensing = subCapacityLicensing;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((alias == null) ? 0 : alias.hashCode());
		result = prime * result
				+ ((function == null) ? 0 : function.hashCode());
		result = prime * result + ((ipla == null) ? 0 : ipla.hashCode());
		result = prime * result
				+ ((licenseType == null) ? 0 : licenseType.hashCode());
		result = prime * result
				+ ((manufacturer == null) ? 0 : manufacturer.hashCode());
		result = prime * result + (pvu ? 1231 : 1237);
		result = prime * result + (subCapacityLicensing ? 1231 : 1237);
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (!super.equals(obj)) {
			return false;
		}
		if (!(obj instanceof Product)) {
			return false;
		}
		Product other = (Product) obj;
		if (alias == null) {
			if (other.alias != null) {
				return false;
			}
		} else if (!alias.equals(other.alias)) {
			return false;
		}
		if (function == null) {
			if (other.function != null) {
				return false;
			}
		} else if (!function.equals(other.function)) {
			return false;
		}
		if (ipla != other.ipla) {
			return false;
		}
		if (licenseType == null) {
			if (other.licenseType != null) {
				return false;
			}
		} else if (!licenseType.equals(other.licenseType)) {
			return false;
		}
		if (manufacturer == null) {
			if (other.manufacturer != null) {
				return false;
			}
		} else if (!manufacturer.equals(other.manufacturer)) {
			return false;
		}
		if (pvu != other.pvu) {
			return false;
		}
		if (subCapacityLicensing != other.subCapacityLicensing) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Product [alias=");
		builder.append(alias);
		builder.append(", ipla=");
		builder.append(ipla);
		builder.append(", pvu=");
		builder.append(pvu);
		builder.append(", function=");
		builder.append(function);
		builder.append(", licenseType=");
		builder.append(licenseType);
		builder.append(", manufacturer=");
		builder.append(manufacturer);
		builder.append(", subCapacityLicensing=");
		builder.append(subCapacityLicensing);
		builder.append("]");
		return builder.toString();
	}

	public Boolean getPvu() {
		return pvu;
	}

	public Boolean getSubCapacityLicensing() {
		return subCapacityLicensing;
	}

}
