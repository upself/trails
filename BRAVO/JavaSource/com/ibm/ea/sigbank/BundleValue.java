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
	//Change Bravo to use Software View instead of Product Object Start
	//private Product software;
	private Software software;
	//Change Bravo to use Software View instead of Product Object End
	
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
	
	//Change Bravo to use Software View instead of Product Object Start
	/**
	 * @return Returns the software.
	 */
	/*public Product getSoftware() {
		return software;
	}*/
	/**
	 * @param software The software to set.
	 */
	/*public void setSoftware(Product software) {
		this.software = software;
	}*/
	
	
	/**
	 * @return Returns the software.
	 */
	public Software getSoftware() {
		return software;
	}
	/**
	 * @param software The software to set.
	 */
	public void setSoftware(Software software) {
		this.software = software;
	}
	//Change Bravo to use Software View instead of Product Object End
}
