/*
 * Created on Jun 25, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.account;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class AccountStatistics {

	private Long id;

	private Long accountNumber;

	private Integer softwareDiscrepancies;

	private Integer hardwareLpars;

	private Integer softwares;

	private Integer hardwareLparsWithScan;

	private Integer hardwareLparWithScanPercentage;

	private Integer hardwareLparsWithoutScan;

	private Integer softwareLparsWithoutHardwareLpar;

	public Long getAccountNumber() {
		return this.accountNumber;
	}

	public void setAccountNumber(Long accountNumber) {
		this.accountNumber = accountNumber;
	}

	public Integer getHardwareLpars() {
		return this.hardwareLpars;
	}

	public void setHardwareLpars(Integer hardwareLpars) {
		this.hardwareLpars = hardwareLpars;
	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getSoftwareDiscrepancies() {
		return this.softwareDiscrepancies;
	}

	public void setSoftwareDiscrepancies(Integer softwareDiscrepancies) {
		this.softwareDiscrepancies = softwareDiscrepancies;
	}

	public Integer getSoftwares() {
		return this.softwares;
	}

	public void setSoftwares(Integer softwares) {
		this.softwares = softwares;
	}

	public Integer getHardwareLparsWithoutScan() {
		return this.hardwareLparsWithoutScan;
	}

	public void setHardwareLparsWithoutScan(Integer hardwareLparsWithoutScan) {
		this.hardwareLparsWithoutScan = hardwareLparsWithoutScan;
	}

	public Integer getHardwareLparsWithScan() {
		return this.hardwareLparsWithScan;
	}

	public void setHardwareLparsWithScan(Integer hardwareLparsWithScan) {
		this.hardwareLparsWithScan = hardwareLparsWithScan;
	}

	public Integer getHardwareLparWithScanPercentage() {
		return this.hardwareLparWithScanPercentage;
	}

	public void setHardwareLparWithScanPercentage(
			Integer hardwareLparWithScanPercentage) {
		this.hardwareLparWithScanPercentage = hardwareLparWithScanPercentage;
	}

	public Integer getSoftwareLparsWithoutHardwareLpar() {
		return this.softwareLparsWithoutHardwareLpar;
	}

	public void setSoftwareLparsWithoutHardwareLpar(
			Integer softwareLparsWithoutHardwareLpar) {
		this.softwareLparsWithoutHardwareLpar = softwareLparsWithoutHardwareLpar;
	}
}
