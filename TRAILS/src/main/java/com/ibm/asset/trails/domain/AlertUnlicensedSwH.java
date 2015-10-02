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
@Table(name = "ALERT_UNLICENSED_SW_H")
@NamedQueries({ @NamedQuery(name = "alertUnlicensedSwHistory", query = "select new com.ibm.asset.trails.form.AlertHistoryReport(AUSH.comments, AUSH.type, AUSH.remoteUser, AUSH.creationTime, AUSH.recordTime, AUSH.open) FROM AlertUnlicensedSwH AUSH WHERE AUSH.alertUnlicensedSw.id = :id") })
public class AlertUnlicensedSwH {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ALERT_UNLICENSED_SW_ID")
    private AlertUnlicensedSw alertUnlicensedSw;

    @Column(name = "COMMENTS")
    private String comments;
    
    @Column(name = "TYPE")
    private String type;

    @Column(name = "REMOTE_USER")
    private String remoteUser;

    @Column(name = "CREATION_TIME")
    private Date creationTime;

    @Column(name = "RECORD_TIME")
    private Date recordTime;

    @Column(name = "OPEN")
    private boolean open;

    public AlertUnlicensedSw getAlertUnlicensedSw() {
        return alertUnlicensedSw;
    }

    public String getComments() {
        return comments;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public Long getId() {
        return id;
    }

    public boolean isOpen() {
        return open;
    }

    public Date getRecordTime() {
        return recordTime;
    }

    public String getRemoteUser() {
        return remoteUser;
    }

    public void setAlertUnlicensedSw(AlertUnlicensedSw alertUnlicensedSw) {
        this.alertUnlicensedSw = alertUnlicensedSw;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setOpen(boolean open) {
        this.open = open;
    }

    public void setRecordTime(Date recordTime) {
        this.recordTime = recordTime;
    }

    public void setRemoteUser(String remoteUser) {
        this.remoteUser = remoteUser;
    }

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
}
