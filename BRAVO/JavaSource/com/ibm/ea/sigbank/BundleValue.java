/*
 * Created on Sep 18, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class BundleValue {

	private Long id;
	private Bundle bundle;
	private Product software;
	
	/**
	 * @return Returns the bundle.
	 */
	public Bundle getBundle() {
		return bundle;
	}
	/**
	 * @param bundle The bundle to set.
	 */
	public void setBundle(Bundle bundle) {
		this.bundle = bundle;
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
	 * @return Returns the software.
	 */
	public Product getSoftware() {
		return software;
	}
	/**
	 * @param software The software to set.
	 */
	public void setSoftware(Product software) {
		this.software = software;
	}
}
