package com.ibm.asset.trails.domain;

import javax.persistence.AssociationOverride;
import javax.persistence.AssociationOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "ALERT_TYPE_CAUSE")
@AssociationOverrides({
		@AssociationOverride(name = "pk.alertType", joinColumns = @JoinColumn(name = "ALERT_TYPE_ID")),
		@AssociationOverride(name = "pk.alertCause", joinColumns = @JoinColumn(name = "ALERT_CAUSE_ID")) })
@NamedQueries({
	@NamedQuery(name = "getByATCTypeCauseId", query = "from AlertTypeCause atc where atc.pk.alertType.id=:alertTypeId and atc.pk.alertCause.id=:alertCauseId"),
	@NamedQuery(name = "getValidCauseCodesByAlertTypeId", query = "select atc.pk.alertType.name, atc.pk.alertCause.name, atc.pk.alertCause.alertCauseResponsibility.name from AlertTypeCause atc where atc.pk.alertType.id=:alertTypeId and atc.status='ACTIVE' order by atc.pk.alertCause.name asc"),
	@NamedQuery(name = "findActiveAlertCauseByNameAndTypeId", query = "select atc.pk.alertCause from AlertTypeCause atc where atc.status = 'ACTIVE' and upper(atc.pk.alertCause.name) = :alertCauseName and atc.pk.alertType.id = :alertTypeId"), 
	}) 
public class AlertTypeCause extends AbstractDomainEntity {

	private static final long serialVersionUID = 3679005612258061712L;

	@EmbeddedId
	private AlertTypeCauseId pk = new AlertTypeCauseId();

	@Column(name = "STATUS")
	private String status;

	public void setPk(AlertTypeCauseId pk) {
		this.pk = pk;
	}

	public AlertTypeCauseId getPk() {
		return pk;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((pk == null) ? 0 : pk.hashCode());
		result = prime * result + ((status == null) ? 0 : status.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		AlertTypeCause other = (AlertTypeCause) obj;
		if (pk == null) {
			if (other.pk != null)
				return false;
		} else if (!pk.equals(other.pk))
			return false;
		if (status == null) {
			if (other.status != null)
				return false;
		} else if (!status.equals(other.status))
			return false;
		return true;
	}

}
