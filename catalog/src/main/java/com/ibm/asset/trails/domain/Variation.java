package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "VARIATION")
public class Variation extends KbDefinition {

	private static final long serialVersionUID = 6816035310102204051L;

	@Basic
	@Column(name = "ACTIVATION_DATE")
	@Temporal(TemporalType.TIMESTAMP)
	protected Date activationDate;

	@Basic
	@Column(name = "RELEASE_ID")
	protected Long release;

	@Basic
	@Column(name = "VARIATION")
	protected String variation;

	public Date getActivationDate() {
		return activationDate;
	}

	public void setActivationDate(Date activationDate) {
		this.activationDate = activationDate;
	}

	public Long getRelease() {
		return release;
	}

	public void setRelease(Long release) {
		this.release = release;
	}

	public String getVariation() {
		return variation;
	}

	public void setVariation(String variation) {
		this.variation = variation;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result
				+ ((activationDate == null) ? 0 : activationDate.hashCode());
		result = prime * result + ((release == null) ? 0 : release.hashCode());
		result = prime * result
				+ ((variation == null) ? 0 : variation.hashCode());
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
		if (!(obj instanceof Variation)) {
			return false;
		}
		Variation other = (Variation) obj;
		if (activationDate == null) {
			if (other.activationDate != null) {
				return false;
			}
		} else if (!activationDate.equals(other.activationDate)) {
			return false;
		}
		if (release == null) {
			if (other.release != null) {
				return false;
			}
		} else if (!release.equals(other.release)) {
			return false;
		}
		if (variation == null) {
			if (other.variation != null) {
				return false;
			}
		} else if (!variation.equals(other.variation)) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Variation [activationDate=");
		builder.append(activationDate);
		builder.append(", release=");
		builder.append(release);
		builder.append(", variation=");
		builder.append(variation);
		builder.append("]");
		return builder.toString();
	}

}
