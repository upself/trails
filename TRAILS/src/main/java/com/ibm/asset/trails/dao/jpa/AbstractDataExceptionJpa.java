package com.ibm.asset.trails.dao.jpa;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.DataException;
import com.ibm.asset.trails.domain.DataExceptionType;

public class AbstractDataExceptionJpa {

	private EntityManager em;

	@PersistenceContext
	protected void setEntityManager(EntityManager em) {
		this.em = em;
	}

	protected EntityManager getEntityManager() {
		return em;
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly = false)
	public void update(DataException alert) {
		getEntityManager().merge(alert);
		getEntityManager().flush();
	}

	@Transactional(propagation = Propagation.REQUIRED, readOnly = false)
	public void save(DataException alert) {
		getEntityManager().persist(alert);
		getEntityManager().flush();
	}

	@Transactional
	public Long getAlertQtyByAccountAlertType(Account account,
			DataExceptionType alertType) {
		Long count = (Long) getEntityManager().createNamedQuery(
				"getOpenAlertQtyByAccountAndType").setParameter("account",
				account).setParameter("alertType", alertType).getSingleResult();
		return count;
	}

}
