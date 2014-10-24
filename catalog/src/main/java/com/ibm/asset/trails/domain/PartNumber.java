package com.ibm.asset.trails.domain;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "PART_NUMBER")
public class PartNumber extends KbDefinition {

	private static final long serialVersionUID = -4193584986531881562L;

	@Basic
	@Column(name = "IS_PVU")
	protected Boolean isPVU;

	@Basic
	@Column(name = "IS_SUB_CAP")
	protected Boolean isSubCap;

	@Basic
	@Column(name = "NAME")
	protected String name;

	@Basic
	@Column(name = "PART_NUMBER")
	protected String partNumber;

	@OneToMany(targetEntity = Pid.class, cascade = { CascadeType.ALL }, fetch = FetchType.EAGER)
	@JoinTable(name = "PART_NUMBER_PID", joinColumns = { @JoinColumn(name = "PART_NUMBER_ID") }, inverseJoinColumns = { @JoinColumn(name = "PID_ID") })
	protected Set<Pid> pids = new HashSet<Pid>();

	@Basic
	@Column(name = "READ_ONLY")
	protected Boolean readOnly;

	public Boolean getIsPVU() {
		return isPVU;
	}

	public void setIsPVU(Boolean isPVU) {
		this.isPVU = isPVU;
	}

	public Boolean getIsSubCap() {
		return isSubCap;
	}

	public void setIsSubCap(Boolean isSubCap) {
		this.isSubCap = isSubCap;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPartNumber() {
		return partNumber;
	}

	public void setPartNumber(String partNumber) {
		this.partNumber = partNumber;
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

	public Boolean getReadOnly() {
		return readOnly;
	}

	public void setReadOnly(Boolean readOnly) {
		this.readOnly = readOnly;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((isPVU == null) ? 0 : isPVU.hashCode());
		result = prime * result
				+ ((isSubCap == null) ? 0 : isSubCap.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result
				+ ((partNumber == null) ? 0 : partNumber.hashCode());
		result = prime * result + ((pids == null) ? 0 : pids.hashCode());
		result = prime * result
				+ ((readOnly == null) ? 0 : readOnly.hashCode());
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
		if (!(obj instanceof PartNumber)) {
			return false;
		}
		PartNumber other = (PartNumber) obj;
		if (isPVU == null) {
			if (other.isPVU != null) {
				return false;
			}
		} else if (!isPVU.equals(other.isPVU)) {
			return false;
		}
		if (isSubCap == null) {
			if (other.isSubCap != null) {
				return false;
			}
		} else if (!isSubCap.equals(other.isSubCap)) {
			return false;
		}
		if (name == null) {
			if (other.name != null) {
				return false;
			}
		} else if (!name.equals(other.name)) {
			return false;
		}
		if (partNumber == null) {
			if (other.partNumber != null) {
				return false;
			}
		} else if (!partNumber.equals(other.partNumber)) {
			return false;
		}
		if (pids == null) {
			if (other.pids != null) {
				return false;
			}
		} else if (!pids.equals(other.pids)) {
			return false;
		}
		if (readOnly == null) {
			if (other.readOnly != null) {
				return false;
			}
		} else if (!readOnly.equals(other.readOnly)) {
			return false;
		}
		return true;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("PartNumber [isPVU=");
		builder.append(isPVU);
		builder.append(", isSubCap=");
		builder.append(isSubCap);
		builder.append(", name=");
		builder.append(name);
		builder.append(", partNumber=");
		builder.append(partNumber);
		builder.append(", pids=");
		builder.append(pids);
		builder.append(", readOnly=");
		builder.append(readOnly);
		builder.append("]");
		return builder.toString();
	}

}
