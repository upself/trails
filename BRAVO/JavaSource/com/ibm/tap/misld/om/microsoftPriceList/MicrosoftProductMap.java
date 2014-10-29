/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.microsoftPriceList;

import com.ibm.ea.sigbank.Product;

/**
 * @author alexmois
 *  
 */
public class MicrosoftProductMap {

    private Long             microsoftProductMapId;

    private Product         software;

    private MicrosoftProduct microsoftProduct;

    /**
     * @return Returns the microsoftProduct.
     */
    public MicrosoftProduct getMicrosoftProduct() {
        return microsoftProduct;
    }

    /**
     * @param microsoftProduct
     *            The microsoftProduct to set.
     */
    public void setMicrosoftProduct(MicrosoftProduct microsoftProduct) {
        this.microsoftProduct = microsoftProduct;
    }

    /**
     * @return Returns the microsoftProductMapId.
     */
    public Long getMicrosoftProductMapId() {
        return microsoftProductMapId;
    }

    /**
     * @param microsoftProductMapId
     *            The microsoftProductMapId to set.
     */
    public void setMicrosoftProductMapId(Long microsoftProductMapId) {
        this.microsoftProductMapId = microsoftProductMapId;
    }

    /**
     * @return Returns the software.
     */
    public Product getSoftware() {
        return software;
    }

    /**
     * @param software
     *            The software to set.
     */
    public void setSoftware(Product software) {
        this.software = software;
    }
}