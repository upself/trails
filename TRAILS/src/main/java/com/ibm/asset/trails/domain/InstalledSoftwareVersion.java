package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;


@Entity
@Table(name = "V_INSTALLED_SOFTWARE_VERSION")
@org.hibernate.annotations.Entity(mutable = false)
public class InstalledSoftwareVersion {

	@Id
	@Column(name = "ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SOFTWARE_LPAR_ID")
	private VSoftwareLpar softwareLpar;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SOFTWARE_ID")
	private Product product;

	private String version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Product getSoftware() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public VSoftwareLpar getSoftwareLpar() {
		return softwareLpar;
	}

	public void setSoftwareLpar(VSoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

}
