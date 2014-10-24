package com.ibm.asset.trails.batch.swkbt.service;

import java.io.Serializable;

import com.ibm.asset.trails.domain.DomainEntity;

public interface BaseService<E extends DomainEntity, X extends Object, I extends Serializable> {

	static final int RETRY_COUNT = 5;

	public void save(X xmlEntity);

	public E findByNaturalKey(Object... key);

	public void flush();

	E update(E entity, X xmlEntity);

	public I findIdByNaturalKey(Object... key);

	E findById(I id);

	public E merge(E entity);
}
