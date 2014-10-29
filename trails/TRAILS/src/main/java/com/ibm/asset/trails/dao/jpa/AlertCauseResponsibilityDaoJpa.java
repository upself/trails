package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.AlertCauseResponsibilityDao;
import com.ibm.asset.trails.domain.AlertCauseResponsibility;

@Repository
public class AlertCauseResponsibilityDaoJpa extends
		AbstractGenericEntityDAOJpa<AlertCauseResponsibility, Long> implements
		AlertCauseResponsibilityDao {

	@SuppressWarnings("unchecked")
	public List<AlertCauseResponsibility> list() {
		return entityManager
				.createNamedQuery("getAlertCauseResponsibilityList")
				.getResultList();
	}
}