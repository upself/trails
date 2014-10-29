package com.ibm.asset.trails.domain;

import javax.persistence.Embeddable;
import javax.persistence.ManyToOne;

@Embeddable
public class AlertTypeCauseId implements java.io.Serializable {

	private static final long serialVersionUID = 726019436682077528L;

	@ManyToOne
	private AlertType alertType;

	@ManyToOne
	private AlertCause alertCause;

	public AlertType getAlertType() {
		return alertType;
	}

	public void setAlertType(AlertType alertType) {
		this.alertType = alertType;
	}

	public AlertCause getAlertCause() {
		return alertCause;
	}

	public void setAlertCause(AlertCause alertCause) {
		this.alertCause = alertCause;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((alertCause == null) ? 0 : alertCause.hashCode());
		result = prime * result
				+ ((alertType == null) ? 0 : alertType.hashCode());
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
		AlertTypeCauseId other = (AlertTypeCauseId) obj;
		if (alertCause == null) {
			if (other.alertCause != null)
				return false;
		} else if (!alertCause.equals(other.alertCause))
			return false;
		if (alertType == null) {
			if (other.alertType != null)
				return false;
		} else if (!alertType.equals(other.alertType))
			return false;
		return true;
	}

}