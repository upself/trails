package com.ibm.asset.trails.dao;

import java.io.Serializable;
import java.util.List;

import com.ibm.asset.trails.domain.AbstractDomainEntity;

public interface BaseEntityDAO<E extends AbstractDomainEntity, I extends Serializable>
		extends BaseDAO<E> {
	void persist(E entity);

	void remove(E entity);

	E merge(E entity);

	void refresh(E entity);

	E findById(I entityId);

	E flush(E entity);

	List<E> findAll();

	Integer removeAll();
}
