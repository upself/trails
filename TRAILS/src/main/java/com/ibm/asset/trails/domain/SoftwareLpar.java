package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "SOFTWARE_LPAR")
@org.hibernate.annotations.Entity(mutable = false)
public class SoftwareLpar {

    @Id
    @Column(name = "ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CUSTOMER_ID")
    private Account account;

    @Column(name = "NAME")
    private String name;

    @Column(name = "MODEL")
    private String model;

    @Column(name = "BIOS_SERIAL")
    private String serial;

    @Column(name = "PROCESSOR_COUNT")
    private Integer processorCount;

    @Column(name = "SCANTIME")
    private Date scanTime;

    @Column(name = "REMOTE_USER")
    private String remoteUser;

    @Column(name = "RECORD_TIME")
    private Date recordTime;

    @Column(name = "STATUS")
    private String status;

    @Column(name = "OS_NAME")
    private String osName;

    @Column(name = "EXT_ID")
    private String extId;
    
    @Column(name = "TECH_IMG_ID")
    private String techImgId;

    @OneToOne(fetch = FetchType.LAZY, optional = true)
    @JoinTable(name = "HW_SW_COMPOSITE", joinColumns = @JoinColumn(name = "SOFTWARE_LPAR_ID"), inverseJoinColumns = @JoinColumn(name = "HARDWARE_LPAR_ID"))
    private HardwareLpar hardwareLpar;

    // TODO need to map this so we don't get the n+1 problem
    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ID", referencedColumnName = "SOFTWARE_LPAR_ID", unique = true)
    private SoftwareLparEff softwareLparEff;

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getProcessorCount() {
        if (softwareLparEff != null) {
            if (softwareLparEff.getStatus().equals("ACTIVE")) {
                if (softwareLparEff.getProcessorCount() != null) {
                    return softwareLparEff.getProcessorCount();
                }
            }
        }

        return processorCount;
    }

    public void setProcessorCount(Integer processorCount) {
        this.processorCount = processorCount;
    }

    public Date getRecordTime() {
        return recordTime;
    }

    public void setRecordTime(Date recordTime) {
        this.recordTime = recordTime;
    }

    public String getRemoteUser() {
        return remoteUser;
    }

    public void setRemoteUser(String remoteUser) {
        this.remoteUser = remoteUser;
    }

    public Date getScanTime() {
        return scanTime;
    }

    public void setScanTime(Date scanTime) {
        this.scanTime = scanTime;
    }

    public String getSerial() {
        return serial;
    }

    public void setSerial(String serial) {
        this.serial = serial;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public HardwareLpar getHardwareLpar() {
        return hardwareLpar;
    }

    public void setHardwareLpar(HardwareLpar hardwareLpar) {
        this.hardwareLpar = hardwareLpar;
    }

    public SoftwareLparEff getSoftwareLparEff() {
        return softwareLparEff;
    }

    public void setSoftwareLparEff(SoftwareLparEff softwareLparEff) {
        this.softwareLparEff = softwareLparEff;
    }

    public String getOsName() {
        return osName;
    }

    public void setOsName(String osName) {
        this.osName = osName;
    }

	public String getExtId() {
		return extId;
	}

	public void setExtId(String extId) {
		this.extId = extId;
	}

	public String getTechImgId() {
		return techImgId;
	}

	public void setTechImgId(String techImgId) {
		this.techImgId = techImgId;
	}
}
