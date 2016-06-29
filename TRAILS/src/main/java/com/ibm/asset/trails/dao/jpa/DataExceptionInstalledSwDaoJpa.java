package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.FetchMode;
import org.hibernate.Session;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.DataExceptionDao;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.DataExceptionSoftwareLpar;
import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.domain.DataExceptionInstalledSw;

@Transactional
@Repository
public class DataExceptionInstalledSwDaoJpa extends AbstractDataExceptionJpa implements DataExceptionDao {

	private String alertTypecode;

	public String getAlertTypeCode() {
		return alertTypecode;
	}

	public void setAlertTypeCode(String alertTypecode) {
		this.alertTypecode = alertTypecode;
	}

	public DataExceptionInstalledSw getById(Long id) {
		return getEntityManager().find(DataExceptionInstalledSw.class, id);
	}

	@SuppressWarnings("unchecked")
	public List<DataExceptionInstalledSw> paginatedList(Account account, int firstResult, int maxResults, String sortBy, String sortDirection) {

		AlertType alertType = (AlertType) getEntityManager().createNamedQuery("getAlertTypeByCode").setParameter("code", alertTypecode).getSingleResult();

		Session session = (Session) getEntityManager().getDelegate();
		Criteria criteria = session.createCriteria(DataExceptionInstalledSw.class);
		criteria.add(Restrictions.eq("open", true));
		criteria.add(Restrictions.eq("account", account));
		criteria.add(Restrictions.eq("alertType", alertType));

		String[] associations = sortBy.split("\\.");

		if (associations.length > 1) {

			Criteria subCriteria = null;

			for (int i = 0; i < associations.length - 1; i++) {
				if (subCriteria == null) {
					subCriteria = criteria.createCriteria(associations[i]);
				} else {
					subCriteria = subCriteria.createCriteria(associations[i]);
				}
			}
			addOrder(associations[associations.length - 1], sortDirection, subCriteria);
		} else {
			addOrder(sortBy, sortDirection, criteria);
		}
		criteria.setFirstResult(firstResult);
		criteria.setMaxResults(maxResults);
		criteria.setFetchMode("installedSw", FetchMode.JOIN);
		criteria.setFetchMode("installedSw.software", FetchMode.JOIN);
		criteria.setFetchMode("installedSw.softwareLpar", FetchMode.JOIN);

		return criteria.list();
	}

	private void addOrder(String sortBy, String sortDirection, Criteria criteria) {
		if ("asc".equalsIgnoreCase(sortDirection)) {
			criteria.addOrder(Order.asc(sortBy));
		} else {
			criteria.addOrder(Order.desc(sortBy));
		}
	}

}
