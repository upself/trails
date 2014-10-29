/*
 * Created on Aug 10, 2005
 *
 * 
 * 
 */
package com.ibm.ea.cndb;

import java.io.Serializable;
/**
 * @author newtont
 * 
 * 
 * Preferences - Java - Code Style - Code Templates
 */
public class CustomerType implements Serializable {
	private static final long serialVersionUID = 1L;
    private Long customerTypeId;

    private String customerTypeName;

    /**
     * @return Returns the customerTypeId.
     */
    public Long getCustomerTypeId() {
        return customerTypeId;
    }

    /**
     * @param customerTypeId
     *            The customerTypeId to set.
     */
    public void setCustomerTypeId(Long customerTypeId) {
        this.customerTypeId = customerTypeId;
    }

    /**
     * @return Returns the customerTypeName.
     */
    public String getCustomerTypeName() {
        return customerTypeName;
    }

    /**
     * @param customerTypeName
     *            The customerTypeName to set.
     */
    public void setCustomerTypeName(String customerTypeName) {
        this.customerTypeName = customerTypeName;
    }
}