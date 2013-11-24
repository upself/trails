package com.ibm.asset.trails.dao.jpa;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.DataExceptionCauseDao;
import com.ibm.asset.trails.domain.AlertCause;
import com.ibm.asset.trails.domain.AlertTypeCause;

@Transactional
@Repository
public class DataExceptionCauseDaoJpa extends AbstractDataExceptionJpa
		implements DataExceptionCauseDao {

	public void add(AlertCause pacAdd) {
		getEntityManager().persist(pacAdd);
	}

	public AlertCause find(Long plId) {
		return getEntityManager().find(AlertCause.class, plId);
	}

	public AlertCause find(String psName) {
		@SuppressWarnings("unchecked")
		List<AlertCause> results = getEntityManager()
				.createNamedQuery("findAlertCauseByName")
				.setParameter("name", psName.toUpperCase()).getResultList();
		AlertCause result;
		if (results == null || results.isEmpty()) {
			result = null;
		} else {
			result = results.get(0);
		}
		return result;
	}

	public AlertCause find(String psName, Long plId) {
		@SuppressWarnings("unchecked")
		List<AlertCause> results = getEntityManager()
				.createNamedQuery("findAlertCauseByNameNotId")
				.setParameter("name", psName).setParameter("id", plId)
				.getResultList();
		AlertCause result;
		if (results == null || results.isEmpty()) {
			result = null;
		} else {
			result = results.get(0);
		}
		return result;
	}

	@SuppressWarnings("unchecked")
	public List<AlertTypeCause> getAlertCauseListByIdList(
			List<Long> plAlertCauseId) {
		if (plAlertCauseId.size() == 0) {
			return new ArrayList<AlertTypeCause>();
		} else {
			return getEntityManager()
					.createNamedQuery("getAlertCauseListByIdList")
					.setParameter("idList", plAlertCauseId).getResultList();
		}
	}

	@SuppressWarnings("unchecked")
	public List<AlertTypeCause> getAvailableAlertCauseList(List<Long> plId) {
		if (plId.size() == 0) {
			return getEntityManager().createNamedQuery("getAlertCauseList")
					.getResultList();
		} else {
			return getEntityManager()
					.createNamedQuery("getAvailableAlertCauseList")
					.setParameter("idList", plId).getResultList();
		}
	}

	@SuppressWarnings("unchecked")
	public List<AlertTypeCause> list() {
		return getEntityManager().createNamedQuery("getAlertCauseList")
				.getResultList();
	}

	@SuppressWarnings("unchecked")
	public List<AlertTypeCause> listWithTypeJoin() {
		return getEntityManager().createNamedQuery(
				"getAlertCauseListWithTypeJoin").getResultList();
	}

	public void update(AlertCause pacUpdate) {
		getEntityManager().merge(pacUpdate);
		getEntityManager().flush();
	}
}
