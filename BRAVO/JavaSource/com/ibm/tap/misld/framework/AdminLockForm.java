/*
 * Created on Apr 29, 2004
 * 
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

package com.ibm.tap.misld.framework;

import com.ibm.tap.misld.om.customerSettings.MisldAccountSettings;

public class AdminLockForm {

    private MisldAccountSettings[] misldAccountSettings;

    /**
     * @return Returns the misldAccountSettings.
     */
    public MisldAccountSettings[] getMisldAccountSettings() {
        return misldAccountSettings;
    }

    /**
     * @param misldAccountSettings
     *            The misldAccountSettings to set.
     */
    public void setMisldAccountSettings(
            MisldAccountSettings[] misldAccountSettings) {
        this.misldAccountSettings = misldAccountSettings;
    }
}

