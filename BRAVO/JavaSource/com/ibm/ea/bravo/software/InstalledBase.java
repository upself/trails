/*
 * Created on Jun 20, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import com.ibm.ea.bravo.framework.common.OrmBase;
import com.ibm.ea.sigbank.BankAccount;
import com.ibm.ea.sigbank.DoranaProduct;
import com.ibm.ea.sigbank.SaProduct;
import com.ibm.ea.sigbank.SoftwareScript;
import com.ibm.ea.sigbank.VmProduct;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class InstalledBase extends OrmBase {

	/**
     * 
     */
    private static final long serialVersionUID = -555646828662753249L;
    protected Long id;
	protected InstalledSoftware installedSoftware;
	protected BankAccount bankAccount;
	/* The next two will be overwritten depending
	 * on the type of class we implement
	 */
	private SaProduct saProduct;
	private VmProduct vmProduct;
	private DoranaProduct doranaProduct;
	private SoftwareScript softwareScript;
	/**
	 * @return Returns the bankAccount.
	 */
	public BankAccount getBankAccount() {
		return bankAccount;
	}
	/**
	 * @param bankAccount The bankAccount to set.
	 */
	public void setBankAccount(BankAccount bankAccount) {
		this.bankAccount = bankAccount;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return Returns the installedSoftware.
	 */
	public InstalledSoftware getInstalledSoftware() {
		return installedSoftware;
	}
	/**
	 * @param installedSoftware The installedSoftware to set.
	 */
	public void setInstalledSoftware(InstalledSoftware installedSoftware) {
		this.installedSoftware = installedSoftware;
	}
	/**
	 * @return Returns the saProduct.
	 */
	public SaProduct getSaProduct() {
		return saProduct;
	}
	/**
	 * @param saProduct The saProduct to set.
	 */
	public void setSaProduct(SaProduct saProduct) {
		this.saProduct = saProduct;
	}
	/**
	 * @return Returns the vmProduct.
	 */
	public VmProduct getVmProduct() {
		return vmProduct;
	}
	/**
	 * @param vmProduct The vmProduct to set.
	 */
	public void setVmProduct(VmProduct vmProduct) {
		this.vmProduct = vmProduct;
	}
	/**
	 * @return Returns the softwareScript.
	 */
	public SoftwareScript getSoftwareScript() {
		return softwareScript;
	}
	/**
	 * @param softwareScript The softwareScritp to set.
	 */
	public void setSoftwareScript(SoftwareScript softwareScript) {
		this.softwareScript = softwareScript;
	}
	
	public DoranaProduct getDoranaProduct() {
		return doranaProduct;
	}
	public void setDoranaProduct(DoranaProduct doranaProduct) {
		this.doranaProduct = doranaProduct;
	}
	
	
}
