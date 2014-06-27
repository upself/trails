package com.ibm.asset.trails.service.impl;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.PersistenceContexts;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;

import com.ibm.asset.trails.service.DatabaseDeterminativeService;

@Service
@PersistenceContexts({
    @PersistenceContext(unitName="trailspd"),
    @PersistenceContext(unitName="trailsst")
})
public class DatabaseDeterminativeServiceImpl implements DatabaseDeterminativeService {

	private EntityManager pdEntityManager;
	private EntityManager stEntityManager;
	private EntityManager entityManager;
	private String trailspd = "TRAILSPD";
	private String trailsst = "TRAILSST";
	private Integer gapseconds;
	
	public void setGapseconds(Integer gapseconds) {
		this.gapseconds = gapseconds;
	}
	
	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	@Qualifier("trailsst")
	public boolean checkSyncTime() throws HibernateException, Exception {
		try {
		 Integer result = (Integer) ((Session) getStEntityManager()
					.getDelegate())
					.createSQLQuery(
							"SELECT ((DAYS(CURRENT TIMESTAMP) - DAYS(SYNCHTIME)) * 86400 + (MIDNIGHT_SECONDS(CURRENT TIMESTAMP) - MIDNIGHT_SECONDS(SYNCHTIME))) FROM ASN.IBMSNAP_SUBS_SET")
					.uniqueResult();
		
       if (result < gapseconds) {
    	   return true;
       } else {
		return false;
       }
       
		} catch (Exception e){		
				return false;		
		}
	}
	
	private EntityManager getPdEntityManager() {
		return pdEntityManager;
	}

	@PersistenceContext(unitName="trailspd")
	public void setPdEntityManager(EntityManager pdEntityManager) {
		this.pdEntityManager = pdEntityManager;
	}
	
	private EntityManager getStEntityManager() {
		return stEntityManager;
	}

	@PersistenceContext(unitName="trailsst")
	public void setStEntityManager(EntityManager stEntityManager) {
		this.stEntityManager = stEntityManager;
	}
	
	public EntityManager getEntityManager() {
		return entityManager;
	}

	public void setEntityManager() throws HibernateException, Exception {
		if (checkSyncTime()){
			this.entityManager = getStEntityManager();
		} else {
			this.entityManager = getPdEntityManager();
		}
	}
	
	public String getPersistenceDB() throws HibernateException, Exception{
		if (checkSyncTime()){
			return trailsst;
		} else {
			return trailspd;
		}
	}
}
