package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

@Entity
@Table(name = "SCARLET_RECONCILE")
@PrimaryKeyJoinColumn(name = "ID")
public class ScarletReconcile extends Reconcile {
	private static final long serialVersionUID = -1570160658765275811L;

	@Column(name = "LAST_VALIDATE_TIME")
	private Date lastValidateTime;

	@Column(name = "RECONCILE_MD5_HEX")
	private String reconcileMd5Hex;

	public ScarletReconcile() {

	}

	public ScarletReconcile(Long id, Date lastValidateTime) {
		this.setId(id);
		this.lastValidateTime = lastValidateTime;
	}

	public ScarletReconcile(Long id, Date lastValidateTime,
			String reconcileMd5Hex) {
		this.setId(id);
		this.lastValidateTime = lastValidateTime;
		this.reconcileMd5Hex = reconcileMd5Hex;
	}

	public Date getLastValidateTime() {
		return lastValidateTime;
	}

	public void setLastValidateTime(Date lastValidateTime) {
		this.lastValidateTime = lastValidateTime;
	}

	public String getReconcileMd5Hex() {
		return reconcileMd5Hex;
	}

	public void setReconcileMd5Hex(String reconcileMd5Hex) {
		this.reconcileMd5Hex = reconcileMd5Hex;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime
				* result
				+ ((lastValidateTime == null) ? 0 : lastValidateTime.hashCode());
		result = prime * result
				+ ((reconcileMd5Hex == null) ? 0 : reconcileMd5Hex.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!super.equals(obj))
			return false;
		if (getClass() != obj.getClass())
			return false;
		ScarletReconcile other = (ScarletReconcile) obj;
		if (lastValidateTime == null) {
			if (other.lastValidateTime != null)
				return false;
		} else if (!lastValidateTime.equals(other.lastValidateTime))
			return false;
		if (reconcileMd5Hex == null) {
			if (other.reconcileMd5Hex != null)
				return false;
		} else if (!reconcileMd5Hex.equals(other.reconcileMd5Hex))
			return false;
		return true;
	}

}
