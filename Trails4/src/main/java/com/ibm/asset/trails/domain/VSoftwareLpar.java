package com.ibm.asset.trails.domain;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;


@Entity
@Table(name = "V_SOFTWARE_LPAR_PROCESSOR")
@org.hibernate.annotations.Entity(mutable = false)
public class VSoftwareLpar extends AbstractDomainEntity {

	@Id
	@Column(name = "ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CUSTOMER_ID")
	private Account account;

	@Column(name = "PROCESSOR_COUNT")
	private Integer processorCount;

	@OneToOne(fetch = FetchType.LAZY, optional = true)
	@JoinTable(name = "HW_SW_COMPOSITE", joinColumns = @JoinColumn(name = "SOFTWARE_LPAR_ID"), inverseJoinColumns = @JoinColumn(name = "HARDWARE_LPAR_ID"))
	private HardwareLpar hardwareLpar;
	
	@OneToMany(fetch=FetchType.LAZY,mappedBy="softwareLpar")
	private Set<InstalledSoftware> installedSoftwares = new HashSet<InstalledSoftware>();

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public HardwareLpar getHardwareLpar() {
		return hardwareLpar;
	}

	public void setHardwareLpar(HardwareLpar hardwareLpar) {
		this.hardwareLpar = hardwareLpar;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getProcessorCount() {
		return processorCount;
	}

	public void setProcessorCount(Integer processorCount) {
		this.processorCount = processorCount;
	}

	public Set<InstalledSoftware> getInstalledSoftwares() {
		return installedSoftwares;
	}

	public void setInstalledSoftwares(Set<InstalledSoftware> installedSoftwares) {
		this.installedSoftwares = installedSoftwares;
	}

	@Override
	public boolean equals(final Object other) {
		if (!(other instanceof VSoftwareLpar))
			return false;
		VSoftwareLpar castOther = (VSoftwareLpar) other;
		return new EqualsBuilder().append(account, castOther.account)
				.append(hardwareLpar, castOther.hardwareLpar).isEquals();
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(account).append(hardwareLpar)
				.toHashCode();
	}
}
