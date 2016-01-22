package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

@Entity
@Table(name = "ALERT")
@Inheritance(strategy = InheritanceType.JOINED)
@NamedQueries({
		@NamedQuery(name = "getOpenAlertQtyByAccountAndType", query = "SELECT COUNT(*) FROM DataException alert WHERE alert.open=1 AND alert.account=:account AND alert.alertType=:alertType"),
		@NamedQuery(name = "getAlertCountReportByAccount", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(alert.alertType.id, alert.alertType.name, COUNT(*), COUNT(*), alert.alertType) FROM DataException alert WHERE alert.account=:account and alert.open=1 GROUP BY alert.alertType.id, alert.alertType.name, alert.alertType order by alert.alertType.id"),
		@NamedQuery(name = "getAlertOverviewReportByAccount", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(alert.alertType.id, alert.alertType.name, sum(case when alert.assignee is not null and alert.assignee <>'' then 1 else 0 end) as assigned, COUNT(*), alert.alertType) FROM DataException alert WHERE alert.account=:account and alert.open=1 GROUP BY alert.alertType.id, alert.alertType.name, alert.alertType order by alert.alertType.id"),
		@NamedQuery(name = "getGeographyReport", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(g.id, g.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account.countryCode.region.geography g where a.open=1 GROUP BY g.id, g.name, a.alertType"),
		@NamedQuery(name = "getRegionReport", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(r.id, r.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account.countryCode.region r where a.open=1 GROUP BY r.id, r.name, a.alertType"),
		@NamedQuery(name = "getRegionReportByGeography", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(r.id, r.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType)FROM  DataException a inner join a.account.countryCode.region r where a.open=1 and r.geography =:geography GROUP BY r.id, r.name, a.alertType"),
		@NamedQuery(name = "getCountryReport", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(c.id, c.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account.countryCode c where a.open=1 GROUP BY c.id, c.name, a.alertType"),
		@NamedQuery(name = "getCountryReportBYGeographyRegion", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(c.id, c.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType)FROM  DataException a inner join a.account.countryCode c where a.open=1 and c.region.geography =:geography and c.region=:region GROUP BY c.id, c.name, a.alertType"),
		@NamedQuery(name = "getCountryReportByGeography", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(c.id, c.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account.countryCode c where a.open=1 and c.region.geography =:geography GROUP BY c.id, c.name, a.alertType"),
		@NamedQuery(name = "getCountryReportByRegion", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(c.id, c.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account.countryCode c where a.open=1 and  c.region=:region GROUP BY c.id, c.name, a.alertType"),
		@NamedQuery(name = "getSectorReport", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(s.id, s.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account.sector s where a.open=1 GROUP BY s.id, s.name, a.alertType"),
		@NamedQuery(name = "getSectorReportByGeographyRegionCountryCode", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(s.id, s.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType)FROM  DataException a inner join a.account.sector s where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode.region=:region and a.account.countryCode=:countryCode GROUP BY s.id, s.name, a.alertType"),
		@NamedQuery(name = "getSectorReportByGeographyRegion", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(s.id, s.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account.sector s where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode.region=:region GROUP BY s.id, s.name, a.alertType"),
		@NamedQuery(name = "getSectorReportByGeographyCountryCode", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(s.id, s.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account.sector s where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode=:countryCode GROUP BY s.id, s.name, a.alertType"),
		@NamedQuery(name = "getSectorReportByRegionCountryCode", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(s.id, s.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account.sector s where a.open=1 and a.account.countryCode.region=:region and a.account.countryCode=:countryCode GROUP BY s.id, s.name, a.alertType"),
		@NamedQuery(name = "getSectorReportByGeography", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(s.id, s.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType)FROM  DataException a inner join a.account.sector s where a.open=1 and a.account.countryCode.region.geography =:geography GROUP BY s.id, s.name, a.alertType"),
		@NamedQuery(name = "getSectorReportByRegion", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(s.id, s.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account.sector s where a.open=1 and a.account.countryCode.region=:region GROUP BY s.id, s.name, a.alertType"),
		@NamedQuery(name = "getSectorReportByCountryCode", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(s.id, s.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account.sector s where a.open=1 and a.account.countryCode=:countryCode GROUP BY s.id, s.name, a.alertType"),
		@NamedQuery(name = "getDepartmentReport", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(d.id, d.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account.department d where a.open=1 GROUP BY d.id, d.name, a.alertType"),
		@NamedQuery(name = "getDepartmentReportByGeographyRegionCountryCode", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(d.id, d.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType)FROM  DataException a inner join a.account.department d where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode.region=:region and a.account.countryCode=:countryCode GROUP BY d.id, d.name, a.alertType"),
		@NamedQuery(name = "getDepartmentReportByGeographyRegion", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(d.id, d.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a join a.account.department d where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode.region=:region GROUP BY d.id, d.name, a.alertType"),
		@NamedQuery(name = "getDepartmentReportByGeographyCountryCode", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(d.id, d.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a join a.account.department d where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode=:countryCode GROUP BY d.id, d.name, a.alertType"),
		@NamedQuery(name = "getDepartmentReportByRegionCountryCode", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(d.id, d.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a join a.account.department d where a.open=1 and a.account.countryCode.region=:region and a.account.countryCode=:countryCode GROUP BY d.id, d.name, a.alertType"),
		@NamedQuery(name = "getDepartmentReportByGeography", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(d.id, d.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType)FROM  DataException a join a.account.department d where a.open=1 and a.account.countryCode.region.geography =:geography GROUP BY d.id, d.name, a.alertType"),
		@NamedQuery(name = "getDepartmentReportByRegion", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(d.id, d.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a join a.account.department d where a.open=1 and a.account.countryCode.region=:region GROUP BY d.id, d.name, a.alertType"),
		@NamedQuery(name = "getDepartmentReportByCountryCode", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(d.id, d.name, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a join a.account.department d where a.open=1 and a.account.countryCode=:countryCode GROUP BY d.id, d.name, a.alertType"),
		@NamedQuery(name = "getAccountReportByGeographyRegionCountryCodeDepartment", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode.region=:region and a.account.countryCode=:countryCode and a.account.department = :department GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByGeographyRegionCountryCodeSector", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode.region=:region and a.account.countryCode=:countryCode and a.account.sector = :sector GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByGeographyRegionCountryCode", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode.region=:region and a.account.countryCode=:countryCode GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByGeographyRegionDepartment", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType)FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode.region=:region and a.account.department = :department GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByGeographyRegionSector", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode.region=:region and a.account.sector = :sector GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByRegionCountryCodeDepartment", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region=:region and a.account.countryCode=:countryCode and a.account.department = :department GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByRegionCountryCodeSector", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region=:region and a.account.countryCode=:countryCode and a.account.sector = :sector GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByGeographyCountryCodeDepartment", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode=:countryCode and a.account.department = :department GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByGeographyCountryCodeSector", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode=:countryCode and a.account.sector = :sector GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByGeographyCountryCode", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType)FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.countryCode=:countryCode GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByRegionCountryCode", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region=:region and a.account.countryCode=:countryCode GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByCountryCodeDepartment", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode=:countryCode and a.account.department = :department GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByCountryCodeSector", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode=:countryCode and a.account.sector = :sector GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByRegionDepartment", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region=:region and a.account.department = :department GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByRegionSector", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region=:region and a.account.sector = :sector GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByGeographyDepartment", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType)FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.department = :department GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByGeographySector", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode.region.geography =:geography and a.account.sector = :sector GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByCountryCode", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.countryCode=:countryCode GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportBySector", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.sector = :sector GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getAccountReportByDepartment", query = "SELECT new com.ibm.asset.trails.form.DataExceptionReportActionForm(a.account, sum(case when a.assignee!=null then 1 else 0 end) as assigned, COUNT(*), a.alertType) FROM  DataException a inner join a.account c where a.open=1 and a.account.department = :department GROUP BY a.account, a.alertType"),
		@NamedQuery(name = "getOpenAlertIdsByCustomerIdAndAlertTypeId", query = "SELECT alert.id FROM DataException alert WHERE alert.open=1 AND alert.account.id =:customerId AND alert.alertType.id =:alertTypeId")
})
@Cacheable
public class DataException extends AbstractDomainEntity {

	/**
     * 
     */
	private static final long serialVersionUID = 1L;

	@ManyToOne
	@JoinColumn(name = "CUSTOMER_ID", nullable = false)
	protected Account account;

	@ManyToOne
	@JoinColumn(name = "ALERT_TYPE_ID")
	protected AlertType alertType;

	@ManyToOne
	@JoinColumn(name = "ALERT_CAUSE_ID")
	protected AlertCause alertCause;

	@Basic
	@Column(name = "open")
	protected boolean open;

	@Id
	@Column(name = "ID")
	@GeneratedValue(strategy = GenerationType.AUTO)
	protected Long id;

	@Basic
	@Column(name = "CREATION_TIME")
	protected Date creationTime;

	@Basic
	@Column(name = "RECORD_TIME")
	protected Date recordTime;

	@Basic
	@Column(name = "REMOTE_USER", length = 32)
	protected String remoteUser;

	@Basic
	@Column(name = "ASSIGNEE")
	protected String assignee;

	@Basic
	@Column(name = "COMMENT", length = 255)
	protected String comment;

	/**
	 * @return the account
	 */
	public Account getAccount() {
		return account;
	}

	/**
	 * @param account
	 *            the account to set
	 */
	public void setAccount(Account account) {
		this.account = account;
	}

	/**
	 * @return the alertType
	 */
	public AlertType getAlertType() {
		return alertType;
	}

	/**
	 * @param alertType
	 *            the alertType to set
	 */
	public void setAlertType(AlertType alertType) {
		this.alertType = alertType;
	}

	/**
	 * @return the alertCause
	 */
	public AlertCause getAlertCause() {
		return alertCause;
	}

	/**
	 * @param alertCause
	 *            the alertCause to set
	 */
	public void setAlertCause(AlertCause alertCause) {
		this.alertCause = alertCause;
	}

	/**
	 * @return the open
	 */
	public boolean isOpen() {
		return open;
	}

	/**
	 * @param open
	 *            the open to set
	 */
	public void setOpen(boolean open) {
		this.open = open;
	}

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the creationTime
	 */
	public Date getCreationTime() {
		return creationTime;
	}

	/**
	 * @param creationTime
	 *            the creationTime to set
	 */
	public void setCreationTime(Date creationTime) {
		this.creationTime = creationTime;
	}

	/**
	 * @return the recordTime
	 */
	public Date getRecordTime() {
		return recordTime;
	}

	/**
	 * @param recordTime
	 *            the recordTime to set
	 */
	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	/**
	 * @return the remoteUser
	 */
	public String getRemoteUser() {
		return remoteUser;
	}

	/**
	 * @param remoteUser
	 *            the remoteUser to set
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	/**
	 * @return the assignee
	 */
	public String getAssignee() {
		return assignee;
	}

	/**
	 * @param assignee
	 *            the assignee to set
	 */
	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	/**
	 * @return the comment
	 */
	public String getComment() {
		return comment;
	}

	/**
	 * @param comment
	 *            the comment to set
	 */
	public void setComment(String comment) {
		this.comment = comment;
	}

	@Override
	public boolean equals(final Object other) {
		boolean result;
		if (other instanceof DataException) {
			final DataException castOther = (DataException) other;
			result = new EqualsBuilder().append(open, castOther.open)
					.append(creationTime, castOther.creationTime)
					.append(recordTime, castOther.recordTime)
					.append(remoteUser, castOther.remoteUser)
					.append(assignee, castOther.assignee)
					.append(comment, castOther.comment)
					.append(account, castOther.account)
					.append(alertType, castOther.alertType).isEquals();
		} else {
			result = false;
		}
		return result;
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(open).append(creationTime)
				.append(recordTime).append(remoteUser).append(assignee)
				.append(comment).append(account).append(alertType).toHashCode();
	}

}
