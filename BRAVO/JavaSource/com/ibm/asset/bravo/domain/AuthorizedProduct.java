package com.ibm.asset.bravo.domain;

import java.io.Serializable;
import java.util.Date;

import com.ibm.ea.bravo.hardware.HardwareLpar;

public class AuthorizedProduct extends InstalledProduct implements Serializable {

    private static final long serialVersionUID = -7107425149830867648L;
    private HardwareLpar      hardwareLpar;
    private String            changeNumber;
    private Date              changeDate;

    public HardwareLpar getHardwareLpar() {
        return hardwareLpar;
    }

    public void setHardwareLpar(HardwareLpar hardwareLpar) {
        this.hardwareLpar = hardwareLpar;
    }

    public String getChangeNumber() {
        return changeNumber;
    }

    public void setChangeNumber(String changeNumber) {
        this.changeNumber = changeNumber;
    }

    public Date getChangeDate() {
        return changeDate;
    }

    public void setChangeDate(Date changeDate) {
        this.changeDate = changeDate;
    }
}
