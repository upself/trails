package com.ibm.asset.trails.domain;

import java.util.Date;

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
import javax.persistence.Table;

@Entity
@Table(name = "REPORT_DELIVERY_TRACKING")
@NamedQueries({ @NamedQuery(name = "getRDTByAccount", query = "FROM ReportDeliveryTracking rdt WHERE rdt.account = :account") })
public class ReportDeliveryTracking {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CUSTOMER_ID")
	private Account account;

	@Column(name = "LAST_DELIVERY")
	private Date lastDeliveryTime;

	@Column(name = "NEXT_DELIVERY")
	private Date nextDeliveryTime;

	@Column(name = "REPORTING_CYCLE")
	private String reportingCycle;

	@Column(name = "QMX_REFERENCE")
	private String qmxReference;

	@Column(name = "RECORD_TIME")
	private Date recordTime;

	@Column(name = "REMOTE_USER")
	private String remoteUser;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public Date getLastDeliveryTime() {
		return lastDeliveryTime;
	}

	public void setLastDeliveryTime(Date lastDeliveryTime) {
		this.lastDeliveryTime = lastDeliveryTime;
	}

	public Date getNextDeliveryTime() {
		return nextDeliveryTime;
	}

	public void setNextDeliveryTime(Date nextDeliveryTime) {
		this.nextDeliveryTime = nextDeliveryTime;
	}

	public String getReportingCycle() {
		return reportingCycle;
	}

	public void setReportingCycle(String reportingCycle) {
		this.reportingCycle = reportingCycle;
	}

	public String getQmxReference() {
		return qmxReference;
	}

	public void setQmxReference(String qmxReference) {
		this.qmxReference = qmxReference;
	}

	public Date getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((account == null) ? 0 : account.hashCode());
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime
				* result
				+ ((lastDeliveryTime == null) ? 0 : lastDeliveryTime.hashCode());
		result = prime
				* result
				+ ((nextDeliveryTime == null) ? 0 : nextDeliveryTime.hashCode());
		result = prime * result
				+ ((qmxReference == null) ? 0 : qmxReference.hashCode());
		result = prime * result
				+ ((recordTime == null) ? 0 : recordTime.hashCode());
		result = prime * result
				+ ((remoteUser == null) ? 0 : remoteUser.hashCode());
		result = prime * result
				+ ((reportingCycle == null) ? 0 : reportingCycle.hashCode());
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
		ReportDeliveryTracking other = (ReportDeliveryTracking) obj;
		if (account == null) {
			if (other.account != null)
				return false;
		} else if (!account.getId().equals(other.account.getId()))
			return false;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (lastDeliveryTime == null) {
			if (other.lastDeliveryTime != null)
				return false;
		} else if (!lastDeliveryTime.equals(other.lastDeliveryTime))
			return false;
		if (nextDeliveryTime == null) {
			if (other.nextDeliveryTime != null)
				return false;
		} else if (!nextDeliveryTime.equals(other.nextDeliveryTime))
			return false;
		if (qmxReference == null) {
			if (other.qmxReference != null)
				return false;
		} else if (!qmxReference.equals(other.qmxReference))
			return false;
		if (recordTime == null) {
			if (other.recordTime != null)
				return false;
		} else if (!recordTime.equals(other.recordTime))
			return false;
		if (remoteUser == null) {
			if (other.remoteUser != null)
				return false;
		} else if (!remoteUser.equals(other.remoteUser))
			return false;
		if (reportingCycle == null) {
			if (other.reportingCycle != null)
				return false;
		} else if (!reportingCycle.equals(other.reportingCycle))
			return false;
		return true;
	}

}
