package com.ibm.ea.sigbank;

public class InstalledScript {

	private String status;
    private com.ibm.ea.bravo.software.InstalledSoftware installedSoftware;
    private com.ibm.ea.sigbank.SoftwareScript softwareScript;
    private com.ibm.ea.sigbank.BankAccount bankAccount;
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public com.ibm.ea.bravo.software.InstalledSoftware getInstalledSoftware() {
		return installedSoftware;
	}
	public void setInstalledSoftware(com.ibm.ea.bravo.software.InstalledSoftware installedSoftware) {
		this.installedSoftware = installedSoftware;
	}
	public com.ibm.ea.sigbank.SoftwareScript getSoftwareScript() {
		return softwareScript;
	}
	public void setSoftwareScript(com.ibm.ea.sigbank.SoftwareScript softwareScript) {
		this.softwareScript = softwareScript;
	}
	public com.ibm.ea.sigbank.BankAccount getBankAccount() {
		return bankAccount;
	}
	public void setBankAccount(com.ibm.ea.sigbank.BankAccount bankAccount) {
		this.bankAccount = bankAccount;
	} 
	
}
