package com.ibm.asset.trails.service;

import javax.persistence.EntityManager;

import org.hibernate.HibernateException;

public interface DatabaseDeterminativeService {
	
	EntityManager getEntityManager() ;
	void setEntityManager() throws HibernateException, Exception;
	String getPersistenceDB() throws HibernateException, Exception;
}
