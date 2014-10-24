/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.navigate;

import org.apache.struts.validator.ValidatorForm;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SearchForm extends ValidatorForm {

	private static final long serialVersionUID = 1L;

	private String softwareName;

	private String manufacturerId;

	private String softwareCategoryId;

	public String getSoftwareName() {
		return softwareName;
	}

	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

	public String getManufacturerId() {
		return manufacturerId;
	}

	public void setManufacturerId(String manufacturerId) {
		this.manufacturerId = manufacturerId;
	}

	public String getSoftwareCategoryId() {
		return softwareCategoryId;
	}

	public void setSoftwareCategoryId(String softwareCategoryId) {
		this.softwareCategoryId = softwareCategoryId;
	}

}