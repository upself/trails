package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.io.Serializable;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.batch.swkbt.service.BaseService;
import com.ibm.asset.trails.dao.BaseDao;
import com.ibm.asset.trails.domain.DomainEntity;

public abstract class GenericService<E extends DomainEntity, X extends Object, I extends Serializable>
		implements BaseService<E, X, I> {
	private static final Log LOG = LogFactory.getLog(GenericService.class);

	protected abstract BaseDao<E, I> getDao();

	public abstract E update(E entity, X xmlEntity);

	public E findById(I id) {
		return getDao().findById(id);
	}

	public void flush() {
		getDao().flush();
	}

	public synchronized E findByNaturalKey(Object... key) {
		if (LOG.isDebugEnabled()) {
			// changed back to debug from LOG.trace
			for (Object obj : key) {
				LOG.debug("Looking for: " + obj);
			}
		}
		return getDao().findByNaturalKey(key);
	}

	public synchronized I findIdByNaturalKey(Object... key) {
		if (LOG.isDebugEnabled()) {
			// changed to LOG.trace as it generates too much information
			for (Object obj : key) {
				LOG.debug("Looking for: " + obj);
			}
		}
		return getDao().findIdByNaturalKey(key);
	}

	@Transactional(readOnly = false, propagation = Propagation.MANDATORY)
	protected void save(E entity, X xmlEntity) {
		entity = update(entity, xmlEntity);
		merge(entity);
	}

	@Transactional(readOnly = false, propagation = Propagation.MANDATORY)
	public E merge(E entity) {
		return getDao().merge(entity);
	}
}
