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

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "ALERT_CAUSE")
@org.hibernate.annotations.Entity
@NamedQueries({
		@NamedQuery(name = "findAlertCauseByName", query = "FROM AlertCause WHERE upper(name) = :name and showInGui = 1"),
		@NamedQuery(name = "findAlertCauseByNameAndResponsibility", query = "FROM AlertCause WHERE upper(name) = :name and alertCauseResponsibility = :responsibility and showInGui = 1"),
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
	
	@JsonIgnore
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

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime
				* result
				+ ((alertCauseResponsibility == null) ? 0
						: alertCauseResponsibility.hashCode());
		result = prime * result
				+ ((alertTypeCauses == null) ? 0 : alertTypeCauses.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + (showInGui ? 1231 : 1237);
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
		AlertCause other = (AlertCause) obj;
		if (alertCauseResponsibility == null) {
			if (other.alertCauseResponsibility != null)
				return false;
		} else if (!alertCauseResponsibility
				.equals(other.alertCauseResponsibility))
			return false;
		if (alertTypeCauses == null) {
			if (other.alertTypeCauses != null)
				return false;
		} else if (!alertTypeCauses.equals(other.alertTypeCauses))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (showInGui != other.showInGui)
			return false;
		return true;
	}

}
