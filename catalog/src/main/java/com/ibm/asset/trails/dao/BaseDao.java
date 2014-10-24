package com.ibm.asset.trails.dao;

import java.io.Serializable;

import com.ibm.asset.trails.domain.DomainEntity;

public interface BaseDao<E extends DomainEntity, I extends Serializable> {
	public void persist(E entity);

	public E merge(E entity);

	public void refresh(E entity);

	public E findById(I id);

	public void flush();

	public Class<E> getEntityClass();

	public E findByNaturalKey(Object... key);

	public I findIdByNaturalKey(Object... key);
}
