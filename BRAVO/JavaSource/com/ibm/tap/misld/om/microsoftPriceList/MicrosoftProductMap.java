/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.microsoftPriceList;

//Change Bravo to use Software View instead of Product Object Start
//import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.Software;
//Change Bravo to use Software View instead of Product Object End

/**
 * @author alexmois
 *  
 */
public class MicrosoftProductMap {

    private Long             microsoftProductMapId;

   //Change Bravo to use Software View instead of Product Object Start
   //private Product         software;
   private Software         software;
   //Change Bravo to use Software View instead of Product Object End

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

    //Change Bravo to use Software View instead of Product Object Start
    /**
     * @return Returns the software.
     */
    /*public Product getSoftware() {
        return software;
    }*/

    /**
     * @param software
     *            The software to set.
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
     * @param software
     *            The software to set.
     */
    public void setSoftware(Software software) {
        this.software = software;
    }
    //Change Bravo to use Software View instead of Product Object End
}