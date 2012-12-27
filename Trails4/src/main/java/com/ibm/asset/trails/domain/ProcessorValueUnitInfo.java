package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "PVU_INFO")
@org.hibernate.annotations.Entity(mutable = false)
public class ProcessorValueUnitInfo {

    @Id
    @Column(name = "ID")
    private Long               id;

    @ManyToOne
    @JoinColumn(name = "PVU_ID", nullable = false)
    private ProcessorValueUnit processorValueUnit;

    @Column(name = "PROCESSOR_TYPE", nullable = false)
    private String             processorType;

    @Column(name = "VALUE_UNITS_PER_CORE", nullable = false)
    private Integer            valueUnitsPerCore;

    @Column(name = "STATUS", nullable = false)
    private String             status;

    @Column(name = "PROCESSOR_ARCHITECTURES", nullable = false)
    private String             processorArchitecture;

    @Column(name = "SERVER_VENDOR", nullable = false)
    private String             serverVendor;

    @Column(name = "SERVER_BRAND", nullable = false)
    private String             serverBrand;

    @Column(name = "PROCESSOR_VENDOR", nullable = false)
    private String             processorVendor;

    @Column(name = "START_DATE", nullable = false)
    private Date               startDate;

    @Column(name = "END_DATE", nullable = false)
    private Date               endDate;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id
     *            the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the processorValueUnit
     */
    public ProcessorValueUnit getProcessorValueUnit() {
        return processorValueUnit;
    }

    /**
     * @param processorValueUnit
     *            the processorValueUnit to set
     */
    public void setProcessorValueUnit(ProcessorValueUnit processorValueUnit) {
        this.processorValueUnit = processorValueUnit;
    }

    /**
     * @return the processorType
     */
    public String getProcessorType() {
        return processorType;
    }

    /**
     * @param processorType
     *            the processorType to set
     */
    public void setProcessorType(String processorType) {
        this.processorType = processorType;
    }

    /**
     * @return the valueUnitsPerCore
     */
    public Integer getValueUnitsPerCore() {
        return valueUnitsPerCore;
    }

    /**
     * @param valueUnitsPerCore
     *            the valueUnitsPerCore to set
     */
    public void setValueUnitsPerCore(Integer valueUnitsPerCore) {
        this.valueUnitsPerCore = valueUnitsPerCore;
    }

    /**
     * @return the status
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status
     *            the status to set
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * @return the processorArchitecture
     */
    public String getProcessorArchitecture() {
        return processorArchitecture;
    }

    /**
     * @param processorArchitecture
     *            the processorArchitecture to set
     */
    public void setProcessorArchitecture(String processorArchitecture) {
        this.processorArchitecture = processorArchitecture;
    }

    /**
     * @return the serverVendor
     */
    public String getServerVendor() {
        return serverVendor;
    }

    /**
     * @param serverVendor
     *            the serverVendor to set
     */
    public void setServerVendor(String serverVendor) {
        this.serverVendor = serverVendor;
    }

    /**
     * @return the serverBrand
     */
    public String getServerBrand() {
        return serverBrand;
    }

    /**
     * @param serverBrand
     *            the serverBrand to set
     */
    public void setServerBrand(String serverBrand) {
        this.serverBrand = serverBrand;
    }

    /**
     * @return the processorVendor
     */
    public String getProcessorVendor() {
        return processorVendor;
    }

    /**
     * @param processorVendor
     *            the processorVendor to set
     */
    public void setProcessorVendor(String processorVendor) {
        this.processorVendor = processorVendor;
    }

    /**
     * @return the startDate
     */
    public Date getStartDate() {
        return startDate;
    }

    /**
     * @param startDate
     *            the startDate to set
     */
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    /**
     * @return the endDate
     */
    public Date getEndDate() {
        return endDate;
    }

    /**
     * @param endDate
     *            the endDate to set
     */
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    @Override
    public int hashCode() {
        return this.processorValueUnit.hashCode()
                + this.processorType.hashCode()
                + this.processorArchitecture.hashCode()
                + this.serverVendor.hashCode() + this.serverBrand.hashCode()
                + this.processorVendor.hashCode();
    }

    @Override
    public boolean equals(Object other) {
        if (this == other)
            return true;
        if (!(other instanceof ProcessorValueUnitInfo))
            return false;
        final ProcessorValueUnitInfo that = (ProcessorValueUnitInfo) other;
        if (!this.processorValueUnit.equals(that.getProcessorValueUnit()))
            return false;
        if (!this.processorType.equals(that.getProcessorType()))
            return false;
        if (!this.processorArchitecture.equals(that.getProcessorArchitecture()))
            return false;
        if (!this.serverVendor.equals(that.getServerVendor()))
            return false;
        if (!this.serverBrand.equals(that.getServerBrand()))
            return false;
        if (!this.processorVendor.equals(that.getProcessorVendor()))
            return false;
        return true;
    }
}
