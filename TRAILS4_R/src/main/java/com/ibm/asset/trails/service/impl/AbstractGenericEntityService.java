package com.ibm.asset.trails.service.impl;

import java.io.Serializable;
import java.util.List;

import com.ibm.asset.trails.dao.BaseEntityDAO;
import com.ibm.asset.trails.domain.AbstractDomainEntity;
import com.ibm.asset.trails.service.BaseEntityService;

public abstract class AbstractGenericEntityService<E extends AbstractDomainEntity, I extends Serializable>
		implements BaseEntityService<E, I> {

	protected abstract BaseEntityDAO<E, I> getDao();

	public E findById(final I entityId) {
		return getDao().findById(entityId);
	}

	public List<E> findAll() {
		return getDao().findAll();
	}
	
	public E update(final E entity) {
		return getDao().merge(entity);
	}
}
