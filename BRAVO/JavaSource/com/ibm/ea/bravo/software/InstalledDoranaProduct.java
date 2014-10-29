/*
 * Created on May 31, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import com.ibm.ea.sigbank.DoranaProduct;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class InstalledDoranaProduct extends InstalledBase {

	/**
     * 
     */
    private static final long serialVersionUID = -4020084351187725801L;
    private DoranaProduct doranaProduct;

	/**
	 * @return Returns the doranaProduct.
	 */
	public DoranaProduct getDoranaProduct() {
		return doranaProduct;
	}
	/**
	 * @param doranaProduct The doranaProduct to set.
	 */
	public void setDoranaProduct(DoranaProduct doranaProduct) {
		this.doranaProduct = doranaProduct;
	}
}
