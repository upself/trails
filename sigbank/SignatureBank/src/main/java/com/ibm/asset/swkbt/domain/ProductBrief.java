package com.ibm.asset.swkbt.domain;

import java.math.BigInteger;

public class ProductBrief {
	private Long id;
	private String name;
	
	public ProductBrief() {
		
	}

	public ProductBrief(Long id, String name) {
		this.id = id;
		this.name = name;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	//To avoid old version hibernate issue
	public void setID(BigInteger id) {
		this.id = id.longValue();
	}
	
	public void setNAME(String name) {
		this.name = name;
	}
}
