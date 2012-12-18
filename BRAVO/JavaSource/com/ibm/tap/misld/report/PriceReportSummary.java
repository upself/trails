/*
 * Created on Dec 13, 2004
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.report;

import java.math.BigDecimal;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class PriceReportSummary {

    private String     sku;

    private String     softwareName;

    private int        serverCount     = 0;

    private int        processorCount  = 0;

    private int        userCount       = 0;

    private int        licenseTotal    = 0;

    private BigDecimal totalSplaPrice  = new BigDecimal(0);

    private BigDecimal totalEsplaPrice = new BigDecimal(0);

    public void addToServerCount(int count) {
        this.serverCount = this.serverCount + count;
    }

    public void addToProcessorCount(int count) {
        this.processorCount = this.processorCount + count;
    }

    public void addToUserCount(int count) {
        this.userCount = this.userCount + count;
    }

    public void addToLicenseTotal(int count) {
        this.licenseTotal = licenseTotal + count;
    }

    public void addToTotalSplaPrice(BigDecimal price) {
        this.totalSplaPrice = this.totalSplaPrice.add(price);
    }

    public void addToTotalEsplaPrice(BigDecimal price) {
        this.totalEsplaPrice = this.totalEsplaPrice.add(price);
    }

    /**
     * @return Returns the licenseTotal.
     */
    public int getLicenseTotal() {
        return licenseTotal;
    }

    /**
     * @param licenseTotal
     *            The licenseTotal to set.
     */
    public void setLicenseTotal(int licenseTotal) {
        this.licenseTotal = licenseTotal;
    }

    /**
     * @return Returns the processorCount.
     */
    public int getProcessorCount() {
        return processorCount;
    }

    /**
     * @param processorCount
     *            The processorCount to set.
     */
    public void setProcessorCount(int processorCount) {
        this.processorCount = processorCount;
    }

    /**
     * @return Returns the serverCount.
     */
    public int getServerCount() {
        return serverCount;
    }

    /**
     * @param serverCount
     *            The serverCount to set.
     */
    public void setServerCount(int serverCount) {
        this.serverCount = serverCount;
    }

    /**
     * @return Returns the sku.
     */
    public String getSku() {
        return sku;
    }

    /**
     * @param sku
     *            The sku to set.
     */
    public void setSku(String sku) {
        this.sku = sku;
    }

    /**
     * @return Returns the softwareName.
     */
    public String getSoftwareName() {
        return softwareName;
    }

    /**
     * @param softwareName
     *            The softwareName to set.
     */
    public void setSoftwareName(String softwareName) {
        this.softwareName = softwareName;
    }

    /**
     * @return Returns the totalEsplaPrice.
     */
    public BigDecimal getTotalEsplaPrice() {
        return totalEsplaPrice;
    }

    /**
     * @param totalEsplaPrice
     *            The totalEsplaPrice to set.
     */
    public void setTotalEsplaPrice(BigDecimal totalEsplaPrice) {
        this.totalEsplaPrice = totalEsplaPrice;
    }

    /**
     * @return Returns the totalSplaPrice.
     */
    public BigDecimal getTotalSplaPrice() {
        return totalSplaPrice;
    }

    /**
     * @param totalSplaPrice
     *            The totalSplaPrice to set.
     */
    public void setTotalSplaPrice(BigDecimal totalSplaPrice) {
        this.totalSplaPrice = totalSplaPrice;
    }

    /**
     * @return Returns the userCount.
     */
    public int getUserCount() {
        return userCount;
    }

    /**
     * @param userCount
     *            The userCount to set.
     */
    public void setUserCount(int userCount) {
        this.userCount = userCount;
    }
}