package com.ibm.asset.trails.domain;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "ALERT_CAUSE")
@NamedQueries({
		@NamedQuery(name = "findAlertCauseByName", query = "FROM AlertCause WHERE upper(name) = :name"),
		@NamedQuery(name = "findAlertCauseByNameNotId", query = "FROM AlertCause WHERE name = :name AND id != :id"),
		@NamedQuery(name = "getAlertCauseList", query = "SELECT alertTypeCauses FROM AlertCause WHERE showInGui = 1 ORDER BY name"),
		@NamedQuery(name = "getAlertCauseListWithTypeJoin", query = "SELECT cause.alertTypeCauses FROM AlertCause AS cause WHERE cause.showInGui = 1 ORDER BY cause.name"),
		@NamedQuery(name = "getAlertCauseListByIdList", query = "SELECT alertTypeCauses FROM AlertCause WHERE id IN (:idList) ORDER BY name"),
		@NamedQuery(name = "getAvailableAlertCauseList", query = "SELECT alertTypeCauses FROM AlertCause WHERE showInGui = 1 AND id NOT IN (:idList) ORDER BY name") })
public class AlertCause {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	protected Long id;

	@Column(name = "NAME")
	protected String name;

	@Column(name = "SHOW_IN_GUI")
	protected boolean showInGui;

	@ManyToOne
	@JoinColumn(name = "ALERT_CAUSE_RESPONSIBILITY_ID")
	private AlertCauseResponsibility alertCauseResponsibility;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "pk.alertCause", cascade = CascadeType.PERSIST)
	private Set<AlertTypeCause> alertTypeCauses = new HashSet<AlertTypeCause>();

	public Set<AlertTypeCause> getAlertTypeCauses() {
		return alertTypeCauses;
	}

	public void setAlertTypeCauses(Set<AlertTypeCause> alertTypeCauses) {
		this.alertTypeCauses = alertTypeCauses;
	}

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
