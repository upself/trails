package com.ibm.ea.bravo.bankaccount;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.validator.ValidatorForm;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.sigbank.BankAccount;

public class FormBankAccount extends ValidatorForm {
	private static final long serialVersionUID = 1L;

	private static final Logger logger = Logger.getLogger(FormBankAccount.class);

	private Long id;

	private String connectionType;

	private String connectionStatus;

	private String name;

	private String description;

	private String type;

	private String version;

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

	private String status;
	
	private String technicalContact;
	
	private String businessContact;

	public FormBankAccount() {
		super();
	}

	public FormBankAccount(Long id) {
		super();

		if (id != null && id.intValue() != 0) {
			this.id = id;
		}
	}

	public FormBankAccount(String connectionType) {
		super();

		this.connectionType = connectionType;
		this.status = Constants.ACTIVE;
	}

	public ActionErrors init() throws Exception {
		logger.debug("FormConnectedSave.init");
		ActionErrors lActionErrors = new ActionErrors();

		// Populate the form data if there is an id
		if (getId() != null) {
			BankAccount lBankAccount = DelegateBankAccount
					.selectBankAccountDetails(getId());

			if (lBankAccount != null) {
				setName(lBankAccount.getName());
				setDescription(lBankAccount.getDescription());
				setType(lBankAccount.getType());
				setVersion(lBankAccount.getVersion());
				setDataType(lBankAccount.getDataType());
				setDatabaseType(lBankAccount.getDatabaseType());
				setDatabaseVersion(lBankAccount.getDatabaseVersion());
				setDatabaseName(lBankAccount.getDatabaseName());
				setDatabaseSchema(lBankAccount.getDatabaseSchema());
				setDatabaseIp(lBankAccount.getDatabaseIp());
				setDatabasePort(lBankAccount.getDatabasePort());
				setDatabaseUser(lBankAccount.getDatabaseUser());
				setDatabasePassword(lBankAccount.getDatabasePassword());
				setSocks(lBankAccount.getSocks());
				setTunnel(lBankAccount.getTunnel());
				setTunnelPort(lBankAccount.getTunnelPort());
				setAuthenticatedData(lBankAccount.getAuthenticatedData());
				setSyncSig(lBankAccount.getSyncSig());
				setConnectionType(lBankAccount.getConnectionType());
				setStatus(lBankAccount.getStatus());
				setTechnicalContact(lBankAccount.getTechnicalContact());
				setBusinessContact(lBankAccount.getBusinessContact());
			} else {
				logger.error("An invalid bank account id was given");
				lActionErrors.add(Constants.BANK_ACCOUNT, new ActionMessage(
						Constants.INVALID));
			}
		}

		return lActionErrors;
	}

	public String getAuthenticatedData() {
		return authenticatedData;
	}

	public void setAuthenticatedData(String authenticatedData) {
		this.authenticatedData = authenticatedData;
	}

	public String getConnectionType() {
		return connectionType;
	}

	public void setConnectionType(String connectionType) {
		this.connectionType = connectionType;
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

	public String getDatabasePassword() {
		return databasePassword;
	}

	public void setDatabasePassword(String databasePassword) {
		this.databasePassword = databasePassword;
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

	public String getDataType() {
		return dataType;
	}

	public void setDataType(String dataType) {
		this.dataType = dataType;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		if (id != null && id.intValue() != 0) {
			this.id = id;
		} else {
			this.id = null;
		}
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSocks() {
		return socks;
	}

	public void setSocks(String socks) {
		this.socks = socks;
	}

	public String getSyncSig() {
		return syncSig;
	}

	public void setSyncSig(String syncSig) {
		this.syncSig = syncSig;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getTechnicalContact() {
		return technicalContact;
	}

	public void setTechnicalContact(String technicalContact) {
		this.technicalContact = technicalContact;
	}

	public String getBusinessContact() {
		return businessContact;
	}

	public void setBusinessContact(String businessContact) {
		this.businessContact = businessContact;
	}

	@Override
	public String toString() {
		return new StringBuffer("[FormConnectedSave]\n\tid = ").append(getId())
				.append("\n\tname = '").append(getName())
				.append("'\n\tconnectionType = '").append(getConnectionType())
				.append("'\n\tconnectionStatus = '").append(getConnectionStatus())
				.append("'\n\tdescription = '").append(getDescription())
				.append("'\n\ttype = '").append(getType())
				.append("'\n\tversion = '").append(getVersion())
				.append("'\n\tdataType = '").append(getDataType())
				.append("'\n\tdatabaseType = '").append(getDatabaseType())
				.append("'\n\tdatabaseVersion = '").append(getDatabaseVersion())
				.append("'\n\tdatabaseName = '").append(getDatabaseName())
				.append("'\n\tdatabaseSchema = '").append(getDatabaseSchema())
				.append("'\n\tdatabaseIp = '").append(getDatabaseIp())
				.append("'\n\tdatabasePort = '").append(getDatabasePort())
				.append("'\n\tdatabaseUser = '").append(getDatabaseUser())
				.append("'\n\tdatabasePassword = '").append(getDatabasePassword())
				.append("'\n\tsocks = '").append(getSocks())
				.append("'\n\ttunnel = '").append(getTunnel())
				.append("'\n\ttunnelPort = '").append(getTunnelPort())
				.append("'\n\tauthenticatedData = '").append(getAuthenticatedData())
				.append("'\n\tsyncSig = '").append(getSyncSig())
				.append("'\n\tstatus = '").append(getStatus().toString())
				.append("'\n\ttechnicalContact = '").append(getTechnicalContact().toString())
				.append("'\n\tbusinessContact = '").append(getBusinessContact()).toString();
	}
}
