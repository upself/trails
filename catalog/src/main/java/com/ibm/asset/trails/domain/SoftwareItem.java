package com.ibm.asset.trails.domain;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.ibm.asset.swkbt.schema.IPLAType;
import com.ibm.asset.swkbt.schema.ProductRoleEnumeration;

@Entity
@Table(name = "SOFTWARE_ITEM")
public class SoftwareItem extends KbDefinition {

	private static final long serialVersionUID = 3779898114688377704L;

	@Basic
	@Column(name = "ACTIVATION_DATE")
	@Temporal(TemporalType.TIMESTAMP)
	protected Date activationDate;

	@Basic
	@Column(name = "END_OF_SUPPORT")
	@Temporal(TemporalType.TIMESTAMP)
	protected Date endOfSupportDate;

	@Basic
	@Column(name = "NAME", length = 255)
	protected String name;

	@Basic
	@Column(name = "PRODUCT_ID", length = 255)
	protected String productId;

	@OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.EAGER)
	@JoinTable(name = "SOFTWARE_ITEM_PID", joinColumns = { @JoinColumn(name = "SOFTWARE_ITEM_ID") }, inverseJoinColumns = { @JoinColumn(name = "PID_ID") })
	protected Set<Pid> pids = new HashSet<Pid>();

	@Basic
	@Column(name = "PRODUCT_ROLE", length = 255)
	@Enumerated(EnumType.STRING)
	protected ProductRoleEnumeration productRole;

	@Basic
	@Column(name = "WEBSITE", length = 255)
	protected String website;

	@Basic
	@Column(name = "SUB_CAPACITY_LICENSING")
	protected Boolean subCapacityLicensing;

	@Basic
	@Column(name = "IPLA", length = 255)
	@Enumerated(EnumType.STRING)
	protected IPLAType ipla;
// Donnie RESOLVE THIS commented out@!!!! -- uncommented
	// changed softwareItem to productInfo
	@OneToOne(mappedBy = "productInfo", cascade = CascadeType.ALL, optional = true, fetch = FetchType.EAGER)
	protected Recon recon;

	public Date getActivationDate() {
		return activationDate;
	}

	public void setActivationDate(Date activationDate) {
		this.activationDate = activationDate;
	}

	public Date getEndOfSupportDate() {
		return endOfSupportDate;
	}

	public void setEndOfSupportDate(Date endOfSupportDate) {
		this.endOfSupportDate = endOfSupportDate;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public Set<Pid> getPids() {
		if (pids == null) {
			pids = new HashSet<Pid>();
		}
		return pids;
	}

	public void setPids(Set<Pid> pids) {
		this.pids = pids;
	}

	public ProductRoleEnumeration getProductRole() {
		return productRole;
	}

	public void setProductRole(ProductRoleEnumeration productRole) {
		this.productRole = productRole;
	}

	public String getWebsite() {
		return website;
	}

	public void setWebsite(String website) {
		this.website = website;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result
				+ ((activationDate == null) ? 0 : activationDate.hashCode());
		result = prime
				* result
				+ ((endOfSupportDate == null) ? 0 : endOfSupportDate.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((pids == null) ? 0 : pids.hashCode());
		result = prime * result
				+ ((productId == null) ? 0 : productId.hashCode());
		result = prime * result
				+ ((productRole == null) ? 0 : productRole.hashCode());
		result = prime * result + ((website == null) ? 0 : website.hashCode());
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
		if (!(obj instanceof SoftwareItem)) {
			return false;
		}
		SoftwareItem other = (SoftwareItem) obj;
		if (activationDate == null) {
			if (other.activationDate != null) {
				return false;
			}
		} else if (!activationDate.equals(other.activationDate)) {
			return false;
		}
		if (endOfSupportDate == null) {
			if (other.endOfSupportDate != null) {
				return false;
			}
		} else if (!endOfSupportDate.equals(other.endOfSupportDate)) {
			return false;
		}
		if (name == null) {
			if (other.name != null) {
				return false;
			}
		} else if (!name.equals(other.name)) {
			return false;
		}
		if (pids == null) {
			if (other.pids != null) {
				return false;
			}
		} else if (!pids.equals(other.pids)) {
			return false;
		}
		if (productId == null) {
			if (other.productId != null) {
				return false;
			}
		} else if (!productId.equals(other.productId)) {
			return false;
		}
		if (productRole != other.productRole) {
			return false;
		}
		if (website == null) {
			if (other.website != null) {
				return false;
			}
		} else if (!website.equals(other.website)) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("SoftwareItem [activationDate=");
		builder.append(activationDate);
		builder.append(", endOfSupportDate=");
		builder.append(endOfSupportDate);
		builder.append(", name=");
		builder.append(name);
		builder.append(", productId=");
		builder.append(productId);
		builder.append(", pids=");
		builder.append(pids);
		builder.append(", productRole=");
		builder.append(productRole);
		builder.append(", website=");
		builder.append(website);
		builder.append("]");
		return builder.toString();
	}

	public Recon getRecon() {
		return recon;
	}

	public void setRecon(Recon recon) {
		this.recon = recon;
	}

	public Boolean getSubCapacityLicensing() {
		return subCapacityLicensing;
	}

	public void setSubCapacityLicensing(Boolean subCapacityLicensing) {
		this.subCapacityLicensing = subCapacityLicensing;
	}

	public IPLAType getIpla() {
		return ipla;
	}

	public void setIpla(IPLAType ipla) {
		this.ipla = ipla;
	}

}
