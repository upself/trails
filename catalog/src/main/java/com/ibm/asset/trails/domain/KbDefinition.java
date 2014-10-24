package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "KB_DEFINITION")
@Inheritance(strategy = InheritanceType.JOINED)
public class KbDefinition extends DomainEntity {

	private static final long serialVersionUID = 4697760399260100994L;

	@Id
	@Column(name = "ID")
	@GeneratedValue(strategy = GenerationType.AUTO)
	protected Long id;

	@Basic
	@Column(name = "ACTIVE")
	protected Boolean active;

	@Basic
	@Column(name = "CREATION_TIME")
	@Temporal(TemporalType.TIMESTAMP)
	protected Date createdDate;

	@Basic
	@Column(name = "CUSTOM_1", length = 16)
	protected String customField1;

	@Basic
	@Column(name = "CUSTOM_2", length = 16)
	protected String vendorManaged;

	@Basic
	@Column(name = "CUSTOM_3", length = 16)
	protected String customField3;

	@Basic
	@Column(name = "DATA_INPUT", precision = 20, scale = 10)
	protected Integer dataInput;

	@Basic
	@Column(name = "DEFINITION_SOURCE", length = 16)
	protected String definitionSource;

	@Basic
	@Column(name = "DELETED")
	protected Boolean deleted;

	@Basic
	@Column(name = "DESCRIPTION", length = 16)
	protected String description;

	@Basic
	@Column(name = "EXTERNAL_ID", length = 16)
	protected String externalId;

	@Basic
	@Column(name = "GUID", length = 32)
	protected String guid;

	@Basic
	@Column(name = "MODIFICATION_TIME")
	@Temporal(TemporalType.TIMESTAMP)
	protected Date modifiedDate;

	@Override
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Boolean getActive() {
		return active;
	}

	public void setActive(Boolean active) {
		this.active = active;
	}

	public Date getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}

	public String getCustomField1() {
		return customField1;
	}

	public void setCustomField1(String customField1) {
		this.customField1 = customField1;
	}

	public String getVendorManaged() {
		return vendorManaged;
	}

	public void setVendorManaged(String vendorManaged) {
		this.vendorManaged = vendorManaged;
	}

	public String getCustomField3() {
		return customField3;
	}

	public void setCustomField3(String customField3) {
		this.customField3 = customField3;
	}

	public Integer getDataInput() {
		return dataInput;
	}

	public void setDataInput(Integer dataInput) {
		this.dataInput = dataInput;
	}

	public String getDefinitionSource() {
		return definitionSource;
	}

	public void setDefinitionSource(String definitionSource) {
		this.definitionSource = definitionSource;
	}

	public Boolean getDeleted() {
		return deleted;
	}

	public void setDeleted(Boolean deleted) {
		this.deleted = deleted;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getExternalId() {
		return externalId;
	}

	public void setExternalId(String externalId) {
		this.externalId = externalId;
	}

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

	public Date getModifiedDate() {
		return modifiedDate;
	}

	public void setModifiedDate(Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((active == null) ? 0 : active.hashCode());
		result = prime * result
				+ ((createdDate == null) ? 0 : createdDate.hashCode());
		result = prime * result
				+ ((customField1 == null) ? 0 : customField1.hashCode());
		result = prime * result
				+ ((vendorManaged == null) ? 0 : vendorManaged.hashCode());
		result = prime * result
				+ ((customField3 == null) ? 0 : customField3.hashCode());
		result = prime * result
				+ ((dataInput == null) ? 0 : dataInput.hashCode());
		result = prime
				* result
				+ ((definitionSource == null) ? 0 : definitionSource.hashCode());
		result = prime * result + ((deleted == null) ? 0 : deleted.hashCode());
		result = prime * result
				+ ((description == null) ? 0 : description.hashCode());
		result = prime * result
				+ ((externalId == null) ? 0 : externalId.hashCode());
		result = prime * result + ((guid == null) ? 0 : guid.hashCode());
		result = prime * result
				+ ((modifiedDate == null) ? 0 : modifiedDate.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (!(obj instanceof KbDefinition)) {
			return false;
		}
		KbDefinition other = (KbDefinition) obj;
		if (active == null) {
			if (other.active != null) {
				return false;
			}
		} else if (!active.equals(other.active)) {
			return false;
		}
		if (createdDate == null) {
			if (other.createdDate != null) {
				return false;
			}
		} else if (!createdDate.equals(other.createdDate)) {
			return false;
		}
		if (customField1 == null) {
			if (other.customField1 != null) {
				return false;
			}
		} else if (!customField1.equals(other.customField1)) {
			return false;
		}
		if (vendorManaged == null) {
			if (other.vendorManaged != null) {
				return false;
			}
		} else if (!vendorManaged.equals(other.vendorManaged)) {
			return false;
		}
		if (customField3 == null) {
			if (other.customField3 != null) {
				return false;
			}
		} else if (!customField3.equals(other.customField3)) {
			return false;
		}
		if (dataInput == null) {
			if (other.dataInput != null) {
				return false;
			}
		} else if (!dataInput.equals(other.dataInput)) {
			return false;
		}
		if (definitionSource == null) {
			if (other.definitionSource != null) {
				return false;
			}
		} else if (!definitionSource.equals(other.definitionSource)) {
			return false;
		}
		if (deleted == null) {
			if (other.deleted != null) {
				return false;
			}
		} else if (!deleted.equals(other.deleted)) {
			return false;
		}
		if (description == null) {
			if (other.description != null) {
				return false;
			}
		} else if (!description.equals(other.description)) {
			return false;
		}
		if (externalId == null) {
			if (other.externalId != null) {
				return false;
			}
		} else if (!externalId.equals(other.externalId)) {
			return false;
		}
		if (guid == null) {
			if (other.guid != null) {
				return false;
			}
		} else if (!guid.equals(other.guid)) {
			return false;
		}
		if (modifiedDate == null) {
			if (other.modifiedDate != null) {
				return false;
			}
		} else if (!modifiedDate.equals(other.modifiedDate)) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("KbDefinition [id=");
		builder.append(id);
		builder.append(", active=");
		builder.append(active);
		builder.append(", createdDate=");
		builder.append(createdDate);
		builder.append(", customField1=");
		builder.append(customField1);
		builder.append(", customField2=");
		builder.append(vendorManaged);
		builder.append(", customField3=");
		builder.append(customField3);
		builder.append(", dataInput=");
		builder.append(dataInput);
		builder.append(", definitionSource=");
		builder.append(definitionSource);
		builder.append(", deleted=");
		builder.append(deleted);
		builder.append(", description=");
		builder.append(description);
		builder.append(", externalId=");
		builder.append(externalId);
		builder.append(", guid=");
		builder.append(guid);
		builder.append(", modifiedDate=");
		builder.append(modifiedDate);
		builder.append("]");
		return builder.toString();
	}

}
