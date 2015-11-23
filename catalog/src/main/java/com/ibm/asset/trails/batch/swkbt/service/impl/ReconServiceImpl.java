package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.io.Serializable;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.batch.swkbt.service.ReconService;
import com.ibm.asset.trails.dao.BaseDao;
import com.ibm.asset.trails.dao.ReconDao;
import com.ibm.asset.trails.domain.Recon;

@Service
public class ReconServiceImpl<E extends Recon, I extends Serializable> implements ReconService<E, I>{
    
	@Autowired
	private ReconDao dao;
	
	private static final Log LOG = LogFactory.getLog(ReconServiceImpl.class);

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
	public E merge(E entity) {
		return getDao().merge(entity);
	}

	@SuppressWarnings("unchecked")
	public BaseDao<E, I> getDao() {
		return (BaseDao<E, I>) dao;
	}

}
