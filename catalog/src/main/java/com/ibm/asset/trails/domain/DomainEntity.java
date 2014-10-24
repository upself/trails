package com.ibm.asset.trails.domain;

import java.io.Serializable;

public abstract class DomainEntity implements Serializable {
	private static final long serialVersionUID = 9053320543075980416L;

	public abstract Long getId();

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("DomainEntity []");
		return builder.toString();
	}

	@Override
	public boolean equals(Object obj) {
		return true;
	}
}
