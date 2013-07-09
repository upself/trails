package com.ibm.asset.trails.domain;

import java.io.Serializable;

public abstract class AbstractDomainEntity implements Serializable {
	private static final long serialVersionUID = -6808320416080003874L;

	@Override
	public abstract boolean equals(Object obj);

	@Override
	public abstract int hashCode();
}
