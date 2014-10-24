package com.ibm.asset.trails.domain;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Table;

import com.ibm.asset.swkbt.schema.RelationshipTypeEnum;

@Entity
@Table(name = "RELATIONSHIP")
public class Relationship extends KbDefinition {

	private static final long serialVersionUID = -6853593536272541619L;

	@Basic
	@Column(name = "TYPE")
	@Enumerated(EnumType.STRING)
	protected RelationshipTypeEnum type;

	@Basic
	@Column(name = "SINK_SOFTWARE_ITEM_ID")
	protected Long sinkSoftwareItem;

	@Basic
	@Column(name = "SOURCE_SOFTWARE_ITEM_ID")
	protected Long sourceSoftwareItem;

	public Long getSinkSoftwareItemType() {
		return sinkSoftwareItem;
	}

	public void setSinkSoftwareItemType(Long sinkSoftwareItem) {
		this.sinkSoftwareItem = sinkSoftwareItem;
	}

	public Long getSourceSoftwareItemType() {
		return sourceSoftwareItem;
	}

	public void setSourceSoftwareItemType(Long sourceSoftwareItem) {
		this.sourceSoftwareItem = sourceSoftwareItem;
	}

	public RelationshipTypeEnum getType() {
		return type;
	}

	public void setType(RelationshipTypeEnum type) {
		this.type = type;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime
				* result
				+ ((sinkSoftwareItem == null) ? 0 : sinkSoftwareItem.hashCode());
		result = prime
				* result
				+ ((sourceSoftwareItem == null) ? 0 : sourceSoftwareItem
						.hashCode());
		result = prime * result + ((type == null) ? 0 : type.hashCode());
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
		if (!(obj instanceof Relationship)) {
			return false;
		}
		Relationship other = (Relationship) obj;
		if (sinkSoftwareItem == null) {
			if (other.sinkSoftwareItem != null) {
				return false;
			}
		} else if (!sinkSoftwareItem.equals(other.sinkSoftwareItem)) {
			return false;
		}
		if (sourceSoftwareItem == null) {
			if (other.sourceSoftwareItem != null) {
				return false;
			}
		} else if (!sourceSoftwareItem.equals(other.sourceSoftwareItem)) {
			return false;
		}
		if (type != other.type) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Relationship [type=");
		builder.append(type);
		builder.append(", sinkSoftwareItem=");
		builder.append(sinkSoftwareItem);
		builder.append(", sourceSoftwareItem=");
		builder.append(sourceSoftwareItem);
		builder.append("]");
		return builder.toString();
	}

}
