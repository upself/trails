/*
 * Created on Aug 8, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import com.ibm.ea.bravo.framework.common.FormBase;

/**
 * @author Thomas
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FormSoftwareCopy extends FormBase {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String[] selected;
    private String lparId;
    private SoftwareLpar sourceSoftwareLpar;
    
    
    
    /**
     * @return Returns the sourceSoftwareLpar.
     */
    public SoftwareLpar getSourceSoftwareLpar() {
        return sourceSoftwareLpar;
    }
    /**
     * @param sourceSoftwareLpar The sourceSoftwareLpar to set.
     */
    public void setSourceSoftwareLpar(SoftwareLpar sourceSoftwareLpar) {
        this.sourceSoftwareLpar = sourceSoftwareLpar;
    }
    /**
     * @return Returns the lparId.
     */
    public String getLparId() {
        return lparId;
    }
    /**
     * @param lparId The lparId to set.
     */
    public void setLparId(String lparId) {
        this.lparId = lparId;
    }
    /**
     * @return Returns the selected.
     */
    public String[] getSelected() {
        return selected;
    }
    /**
     * @param selected The selected to set.
     */
    public void setSelected(String[] selected) {
        this.selected = selected;
    }
}
