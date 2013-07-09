package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity(name = "AlertCause")
@Table(name = "ALERT_CAUSE")
@NamedQueries({
	@NamedQuery(name = "findAlertCauseByName", query = "FROM AlertCause WHERE name = :name"),
	@NamedQuery(name = "findAlertCauseByNameNotId", query = "FROM AlertCause WHERE name = :name AND id != :id"),
	@NamedQuery(name = "getAlertCauseList", query = "FROM AlertCause WHERE showInGui = 1 ORDER BY name"),
	@NamedQuery(name = "getAlertCauseListByIdList", query = "FROM AlertCause WHERE id IN (:idList) ORDER BY name"),
	@NamedQuery(name = "getAvailableAlertCauseList", query = "FROM AlertCause WHERE showInGui = 1 AND id NOT IN (:idList) ORDER BY name")
})
public class DataExceptionCause implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ID")
	@GeneratedValue(strategy = GenerationType.AUTO)
	protected Long id;

	@Basic
	@Column(name = "NAME")
	protected String name;

	@Basic
	@Column(name = "SHOW_IN_GUI")
	protected boolean showInGui;

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
}
