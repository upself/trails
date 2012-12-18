/*
 * Created on Aug 9, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.framework.batch.IBatch;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.email.DelegateEmail;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareCopy implements IBatch {

    private String batchName = "Software Copy Batch";
    private StringBuffer report = new StringBuffer();
    private String email;
    private FormSoftwareCopy form;

    /**
     * @return Returns the form.
     */
    public FormSoftwareCopy getForm() {
        return form;
    }

    /**
     * @param form
     *            The form to set.
     */
    public void setForm(FormSoftwareCopy form) {
        this.form = form;
    }

    public SoftwareCopy() {

    }

    public SoftwareCopy(String email, FormSoftwareCopy copy) {
        this.email = email;
        this.form = copy;
    }

    /**
     * @return Returns the batchName.
     */
    public String getBatchName() {
        return batchName;
    }

    /**
     * @param batchName
     *            The batchName to set.
     */
    public void setBatchName(String batchName) {
        this.batchName = batchName;
    }

    /**
     * @return Returns the email.
     */
    public String getEmail() {
        return email;
    }

    /**
     * @param email
     *            The email to set.
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Logger for this class
     */
    private static final Logger logger = Logger.getLogger(SoftwareCopy.class);

    /*
     * (non-Javadoc)
     * 
     * @see com.ibm.ea.bravo.framework.batch.IBatch#validate()
     */
    public boolean validate() throws Exception {
        return true;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.ibm.ea.bravo.framework.batch.IBatch#execute()
     */
    public void execute() throws Exception {
        logger.debug("SoftwareCopy.execute - begin");

        report.append("BRAVO Software Copy: " + new Date() + "\n\n\n");

        // First extract the SoftwareLpar source object
        SoftwareLpar source = form.getSourceSoftwareLpar();

        // Retrieve list of installed software
        List<InstalledSoftware> sourceInstSoftwareList = DelegateSoftware
                .getInstalledSoftwares(source);

        HashMap<Long, InstalledSoftware> sourceMap = new HashMap<Long, InstalledSoftware>();

        // Iterate through list and pre-cache the most recent discrepancy_h
        // object

        Iterator<InstalledSoftware> sourceIterator = sourceInstSoftwareList.iterator();

        while (sourceIterator.hasNext()) {
            InstalledSoftware installedSoftware = (InstalledSoftware) sourceIterator
                    .next();

            List<SoftwareDiscrepancyH> commentList = DelegateSoftware
                    .getCommentHistory(installedSoftware.getId() + "");

            // get most recent discrepancy
            if (!commentList.isEmpty()) {
                SoftwareDiscrepancyH history = (SoftwareDiscrepancyH) commentList
                        .get(0);

                installedSoftware.setLastDiscrepancy(history);

                sourceMap.put(installedSoftware.getSoftware().getSoftwareId(),
                        installedSoftware);
            }
        }

        logger.debug("Looping through selected Lpars to apply copy.");
        for (int i = 0; i < form.getSelected().length; i++) {

            String targetId = form.getSelected()[i];

            // Retrieve each software target Lpar
            SoftwareLpar target = DelegateSoftware.getSoftwareLpar(targetId);

            report.append("Applying Copy From: " + source.getName() + " To: "
                    + target.getName() + "\n");

            // Retrieve the software list of the target system
            List<InstalledSoftware> targetInstSoftwareList = DelegateSoftware
                    .getInstalledSoftwares(target);

            if (targetInstSoftwareList.isEmpty()) {
                logger.debug("no software found for: " + target.getName());
            }
            else {
                Iterator<InstalledSoftware> targetIterator = targetInstSoftwareList.iterator();

                // Loop through each piece of software and see if there is a
                // copy to apply
                while (targetIterator.hasNext()) {
                    InstalledSoftware targetInstSoftware = (InstalledSoftware) targetIterator
                            .next();

                    Long key = targetInstSoftware.getSoftware().getSoftwareId();

                    // look for a match in the source based on software_id
                    InstalledSoftware sourceInstSoftware = (InstalledSoftware) sourceMap
                            .get(key);

                    // found a match to the source, now create and save the
                    // record
                    if (sourceInstSoftware != null) {

/*                        logger
                                .debug("target id: "
                                        + targetInstSoftware.getId());
                        logger
                                .debug("source id: "
                                        + sourceInstSoftware.getId());

                        logger.debug("Found match with: "
                                + sourceInstSoftware.getSoftware()
                                        .getSoftwareName());
                        logger.debug("\t Last history was: "
                                + sourceInstSoftware.getLastDiscrepancy()
                                        .getComment());
*/                    	

                        // only copy if ACTIVE and NONE
                        if (target.getStatus().equals(Constants.ACTIVE)
                                && targetInstSoftware.getDiscrepancyType()
                                        .getName().equals(Constants.NONE)
                                && source.getStatus().equals(Constants.ACTIVE)) {

                            DelegateSoftware.copySoftware(source,
                                    sourceInstSoftware, targetInstSoftware,
                                    email);
                        }
                    }

                    // no match found, skip it
                    else {
                        logger.debug("No match found with: "
                                + targetInstSoftware.getSoftware()
                                        .getSoftwareName());
                    }
                }
            }
        }
    }

    public void sendNotify() {
        logger.debug("\n" + report);
        DelegateEmail.sendMessage("BRAVO Software Copy", email, report);
    }

    public void sendNotifyException(Exception e) {
        logger.error(e, e);
        logger.error("\n" + report);
    }

    public String getName() {
        return batchName;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.ibm.ea.bravo.framework.batch.IBatch#getRemoteUser()
     */
    public String getRemoteUser() {
        return email;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.ibm.ea.bravo.framework.batch.IBatch#setStartTime(java.util.Date)
     */
    public void setStartTime(Date date) {
        // TODO Auto-generated method stub

    }

    /*
     * (non-Javadoc)
     * 
     * @see com.ibm.ea.bravo.framework.batch.IBatch#getStartTime()
     */
    public Date getStartTime() {
        // TODO Auto-generated method stub
        return null;
    }

}
