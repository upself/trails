package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "ALERT_CAUSE")
@NamedQueries({
		@NamedQuery(name = "findAlertCauseByName", query = "FROM AlertCause WHERE name = :name"),
		@NamedQuery(name = "findAlertCauseByNameNotId", query = "FROM AlertCause WHERE name = :name AND id != :id"),
		@NamedQuery(name = "getAlertCauseList", query = "FROM AlertCause WHERE showInGui = 1 ORDER BY name"),
		@NamedQuery(name = "getAlertCauseListByIdList", query = "FROM AlertCause WHERE id IN (:idList) ORDER BY name"),
		@NamedQuery(name = "getAvailableAlertCauseList", query = "FROM AlertCause WHERE showInGui = 1 AND id NOT IN (:idList) ORDER BY name") })
public class AlertCause {

	@Id
	@Column(name = "ID")
	protected Long id;

	@Column(name = "NAME")
	protected String name;

	@Column(name = "SHOW_IN_GUI")
	protected boolean showInGui;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ALERT_CAUSE_RESPONSIBILITY_ID")
	private AlertCauseResponsibility alertCauseResponsibility;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean isShowInGui() {
		return showInGui;
	}

	public void setShowInGui(boolean showInGui) {
		this.showInGui = showInGui;
	}

	public AlertCauseResponsibility getAlertCauseResponsibility() {
		return alertCauseResponsibility;
	}

	public void setAlertCauseResponsibility(
			AlertCauseResponsibility alertCauseResponsibility) {
		this.alertCauseResponsibility = alertCauseResponsibility;
	}
}
