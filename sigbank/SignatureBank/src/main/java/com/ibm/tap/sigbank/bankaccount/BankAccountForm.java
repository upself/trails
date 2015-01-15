/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.bankaccount;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class BankAccountForm extends ValidatorActionForm {
	private static final long serialVersionUID = 1L;

	private String id;

	private String name;

	private String description;

	private String type;

	private String version;

	private String connectionType;

	private String connectionStatus;

	private String dataType;

	private String databaseType;

	private String databaseVersion;

	private String databaseName;

	private String databaseSchema;

	private String databaseIp;

	private String databasePort;

	private String databaseUser;

	private String databasePassword;

	private String socks;

	private String tunnel;

	private String tunnelPort;

	private String authenticatedData;

	private String syncSig;

	private String comments;

	private String remoteUser;

	private Date recordTime;

	private String status;

	public String getAuthenticatedData() {
		return authenticatedData;
	}

	public void setAuthenticatedData(String authenticatedData) {
		this.authenticatedData = authenticatedData;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public String getConnectionStatus() {
		return connectionStatus;
	}

	public void setConnectionStatus(String connectionStatus) {
		this.connectionStatus = connectionStatus;
	}

	public String getDatabaseIp() {
		return databaseIp;
	}

	public void setDatabaseIp(String databaseIp) {
		this.databaseIp = databaseIp;
	}

	public String getDatabaseName() {
		return databaseName;
	}

	public void setDatabaseName(String databaseName) {
		this.databaseName = databaseName;
	}

	public String getDatabasePort() {
		return databasePort;
	}

	public void setDatabasePort(String databasePort) {
		this.databasePort = databasePort;
	}

	public String getDatabaseSchema() {
		return databaseSchema;
	}

	public void setDatabaseSchema(String databaseSchema) {
		this.databaseSchema = databaseSchema;
	}

	public String getDatabaseType() {
		return databaseType;
	}

	public void setDatabaseType(String databaseType) {
		this.databaseType = databaseType;
	}

	public String getDatabaseUser() {
		return databaseUser;
	}

	public void setDatabaseUser(String databaseUser) {
		this.databaseUser = databaseUser;
	}

	public String getDatabaseVersion() {
		return databaseVersion;
	}

	public void setDatabaseVersion(String databaseVersion) {
		this.databaseVersion = databaseVersion;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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

	public String getSocks() {
		return socks;
	}

	public void setSocks(String socks) {
		this.socks = socks;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getSyncSig() {
		return syncSig;
	}

	public void setSyncSig(String syncSig) {
		this.syncSig = syncSig;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getDatabasePassword() {
		return databasePassword;
	}

	public void setDatabasePassword(String databasePassword) {
		this.databasePassword = databasePassword;
	}

	public String getConnectionType() {
		return connectionType;
	}

	public void setConnectionType(String connectionType) {
		this.connectionType = connectionType;
	}

	public String getDataType() {
		return dataType;
	}

	public void setDataType(String dataType) {
		this.dataType = dataType;
	}

	public String getTunnel() {
		return tunnel;
	}

	public void setTunnel(String tunnel) {
		this.tunnel = tunnel;
	}

	public String getTunnelPort() {
		return tunnelPort;
	}

	public void setTunnelPort(String tunnelPort) {
		this.tunnelPort = tunnelPort;
	}
}