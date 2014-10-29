package com.ibm.asset.trails.domain;

import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "HARDWARE")
@org.hibernate.annotations.Entity(mutable = false)
@NamedQueries({
        @NamedQuery(name = "assetProcessorModels", query = "select distinct processorModel from Hardware h where h.mastProcessorType = :processorBrand and h.processorModel is not null and h.processorModel != ''"),
        @NamedQuery(name = "processorBrandList", query = "select distinct mastProcessorType from Hardware where mastProcessorType is not null and processorBrand != ''"),
        @NamedQuery(name = "machineTypeListForProcessorBrand", query = "SELECT distinct m FROM Hardware H join h.machineType m WHERE H.mastProcessorType = :processorBrand ORDER BY m.name") })
public class Hardware {

    @Id
    @Column(name = "ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CUSTOMER_ID")
    private Account account;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MACHINE_TYPE_ID")
    private MachineType machineType;

    @Column(name = "SERIAL")
    private String serial;

    @Column(name = "COUNTRY")
    private String country;

    @Column(name = "OWNER")
    private String owner;

    @Column(name = "CUSTOMER_NUMBER")
    private String customerNumber;

    @Column(name = "REMOTE_USER")
    private String remoteUser;

    @Column(name = "RECORD_TIME")
    private Date recordTime;

    @Column(name = "STATUS")
    private String status;

    @Column(name = "HARDWARE_STATUS")
    private String hardwareStatus;

    @Column(name = "PROCESSOR_COUNT")
    private Integer processorCount;

    @Column(name = "MODEL")
    private String processorModel;

    @Column(name = "PROCESSOR_TYPE")
    private String processorBrand;

    @Column(name = "CHIPS")
    private Integer chips;
    
    @Column(name = "CPU_MIPS")
    private Integer cpuLsprMips;
    
    @Column(name = "CPU_MSU")
    private Integer cpuMsu;
    
    @Column(name = "CPU_GARTNER_MIPS")
    private BigDecimal cpuGartnerMips;

    /**
	 * @return the cpuLsprMips
	 */
	public Integer getCpuLsprMips() {
		return cpuLsprMips;
	}

	/**
	 * @param cpuLsprMips the cpuLsprMips to set
	 */
	public void setCpuLsprMips(Integer cpuLsprMips) {
		this.cpuLsprMips = cpuLsprMips;
	}

	/**
	 * @return the cpuMsu
	 */
	public Integer getCpuMsu() {
		return cpuMsu;
	}

	/**
	 * @param cpuMsu the cpuMsu to set
	 */
	public void setCpuMsu(Integer cpuMsu) {
		this.cpuMsu = cpuMsu;
	}

	/**
	 * @return the cpuGartnerMips
	 */
	public BigDecimal getCpuGartnerMips() {
		return cpuGartnerMips;
	}

	/**
	 * @param cpuGartnerMips the cpuGartnerMips to set
	 */
	public void setCpuGartnerMips(BigDecimal cpuGartnerMips) {
		this.cpuGartnerMips = cpuGartnerMips;
	}

	@Column(name = "MAST_PROCESSOR_TYPE")
	private String mastProcessorType;
	
    @Column(name = "PROCESSOR_MANUFACTURER")
	private String processorManufacturer;
	
    @Column(name = "PROCESSOR_MODEL")
	private String mastProcessorModel;
	
    @Column(name = "NBR_CORES_PER_CHIP")
	private BigDecimal nbrCoresPerChip;
	
    @Column(name = "NBR_OF_CHIPS_MAX")
	private BigDecimal nbrOfChipsMax;
	
    @Column(name = "SHARED")
	private String shared;
	
    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getCustomerNumber() {
        return customerNumber;
    }

    public void setCustomerNumber(String customerNumber) {
        this.customerNumber = customerNumber;
    }

    public String getHardwareStatus() {
        return hardwareStatus;
    }

    public void setHardwareStatus(String hardwareStatus) {
        this.hardwareStatus = hardwareStatus;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public MachineType getMachineType() {
        return machineType;
    }

    public void setMachineType(MachineType machineType) {
        this.machineType = machineType;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
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

    public Integer getProcessorCount() {
        return processorCount;
    }

    public void setProcessorCount(Integer processorCount) {
        this.processorCount = processorCount;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public void setProcessorModel(String processorModel) {
        this.processorModel = processorModel;
    }

    public String getProcessorModel() {
        return processorModel;
    }

    public void setProcessorBrand(String processorBrand) {
        this.processorBrand = processorBrand;
    }

    public String getProcessorBrand() {
        return processorBrand;
    }

    /**
     * @return the chips
     */
    public Integer getChips() {
        return chips;
    }

    /**
     * @param chips
     *            the chips to set
     */
    public void setChips(Integer chips) {
        this.chips = chips;
    }
    
	public String getMastProcessorType() {
		return mastProcessorType;
	}

	public void setMastProcessorType(String mastProcessorType) {
		this.mastProcessorType = mastProcessorType;
	}
	
	public String getProcessorManufacturer() {
		return processorManufacturer;
	}

	public void setProcessorManufacturer(String processorManufacturer) {
		this.processorManufacturer = processorManufacturer;
	}
	
	public String getMastProcessorModel() {
		return mastProcessorModel;
	}

	public void setMastProcessorModel(String mastProcessorModel) {
		this.mastProcessorModel = mastProcessorModel;
	}
	
	public BigDecimal getNbrCoresPerChip() {
		return nbrCoresPerChip;
	}

	public void setNbrCoresPerChip(BigDecimal nbrCoresPerChip) {
		this.nbrCoresPerChip = nbrCoresPerChip;
	}
	
	public BigDecimal getNbrOfChipsMax() {
		return nbrOfChipsMax;
	}

	public void setNbrOfChipsMax(BigDecimal nbrOfChipsMax) {
		this.nbrOfChipsMax = nbrOfChipsMax;
	}
	
	public String getShared() {
		return shared;
	}

	public void setShared(String shared) {
		this.shared = shared;
	}

}
