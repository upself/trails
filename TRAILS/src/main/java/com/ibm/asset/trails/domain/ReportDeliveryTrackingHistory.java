package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "REPORT_DELIVERY_TRACKING_H")
@NamedQueries({ @NamedQuery(name = "getRDTHistoryByRDT", query = "FROM ReportDeliveryTrackingHistory rdth WHERE rdth.reportDeliveryTracking = :reportDeliveryTracking ORDER BY rdth.recordTime DESC") })
public class ReportDeliveryTrackingHistory {

	@Id
	@Column(name = "ID")
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;

	@ManyToOne
	@JoinColumn(name = "REPORT_DELIVERY_TRACKING_ID")
	private ReportDeliveryTracking reportDeliveryTracking;

	@Column(name = "CUSTOMER_ID")
	private Long customerId;

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

	public ReportDeliveryTracking getReportDeliveryTracking() {
		return reportDeliveryTracking;
	}

	public void setReportDeliveryTracking(
			ReportDeliveryTracking reportDeliveryTracking) {
		this.reportDeliveryTracking = reportDeliveryTracking;
	}

	public Long getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
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

}
