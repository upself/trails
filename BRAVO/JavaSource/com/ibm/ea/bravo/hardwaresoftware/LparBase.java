/*
 * Created on Jun 12, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.hardwaresoftware;

import com.ibm.ea.bravo.framework.common.OrmBase;
import com.ibm.ea.bravo.hardware.HardwareLpar;
import com.ibm.ea.bravo.software.SoftwareLpar;
import com.ibm.ea.cndb.Customer;
import com.ibm.ea.utils.EaUtils;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public abstract class LparBase extends OrmBase {
	/**
     * 
     */
    private static final long serialVersionUID = 3745059633112369600L;
    protected Long id;
	protected Customer customer;
	protected String name;
	
	public abstract HardwareLpar getHardwareLpar();
	public abstract SoftwareLpar getSoftwareLpar();
	public abstract String getSerial();
	public abstract String getType();
	public abstract String getHwFlag();
	public abstract String getSwFlag();
	public abstract String getHardwareStatus();
	public abstract String getMachineTypeName();
	public abstract String getCustomerNumber();
	public abstract String getScantimeDate();

	public final boolean equals(Object o) {
		
		if (o == this)
			return true;
		
		if (!(o instanceof LparBase))
			return false;
		
		LparBase lpar = (LparBase) o;
		
		if (!(this.name.equals(lpar.getName())))
			return false;
		
		if (!(this.customer.getCustomerId().equals(lpar.getCustomer().getCustomerId())))
			return false;
		
		return true;
	}
	
	public final int hashCode() {
		String key = getName();
		
		if (EaUtils.isBlank(this.name))
			key = getSerial();
		
		if (this.customer != null) {
			key = key + this.customer.getCustomerId();
		}
		
		return key.hashCode();
	}

	/**
	 * @return Returns the customer.
	 */
	public Customer getCustomer() {
		return this.customer;
	}
	/**
	 * @param customer The customer to set.
	 */
	public void setCustomer(Customer customer) {
		this.customer = customer;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return this.id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return this.name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
}
