package com.ibm.asset.trails.batch.swkbt.service;

import java.io.Serializable;

import com.ibm.asset.trails.dao.BaseDao;
import com.ibm.asset.trails.domain.DomainEntity;

public interface ReconService<E extends DomainEntity, I extends Serializable> {
	
	static final int RETRY_COUNT = 5;
	
	abstract BaseDao<E, I> getDao();

	public E findByNaturalKey(Object... key);

	public void flush();

	public I findIdByNaturalKey(Object... key);

	E findById(I id);

	public E merge(E entity);
}
