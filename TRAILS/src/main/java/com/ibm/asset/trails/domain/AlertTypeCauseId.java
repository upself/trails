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
}