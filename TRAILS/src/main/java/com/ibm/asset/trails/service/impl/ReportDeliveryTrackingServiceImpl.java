package com.ibm.asset.trails.service.impl;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.ReportDeliveryTracking;
import com.ibm.asset.trails.domain.ReportDeliveryTrackingHistory;
import com.ibm.asset.trails.service.ReportDeliveryTrackingService;

@Service
public class ReportDeliveryTrackingServiceImpl implements
		ReportDeliveryTrackingService {

	private EntityManager em;

	@PersistenceContext(unitName = "trailspd")
	public void setEntityManager(EntityManager em) {
		this.em = em;
	}

	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ReportDeliveryTracking getByAccount(Account account) {
		List<ReportDeliveryTracking> results = em
				.createNamedQuery("getRDTByAccount")
				.setParameter("account", account).getResultList();

		return results.size() == 0 ? null : results.get(0);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	@SuppressWarnings("unchecked")
	public List<ReportDeliveryTrackingHistory> getHistory(
			ReportDeliveryTracking reportDeliveryTracking) {
		return em.createNamedQuery("getRDTHistoryByRDT")
				.setParameter("reportDeliveryTracking", reportDeliveryTracking)
				.getResultList();

	}

	@Transactional(readOnly = false, isolation = Isolation.DEFAULT)
	public int merge(ReportDeliveryTracking reportDeliveryTracking) {
		ReportDeliveryTracking temp = getByAccount(reportDeliveryTracking
				.getAccount());
		int code = ERROR;
		if (temp == null) {
			em.persist(reportDeliveryTracking);
			code = ADD;
		} else if (!temp.equals(reportDeliveryTracking)) {

			// create history.
			ReportDeliveryTrackingHistory history = buildHistory(temp);
			em.persist(history);

			// update existing one.
			reportDeliveryTracking.setId(temp.getId());
			em.merge(reportDeliveryTracking);
			code = UPDATE;
		}

		return code;
	}

	private ReportDeliveryTrackingHistory buildHistory(
			ReportDeliveryTracking reportDeliveryTracking) {
		ReportDeliveryTrackingHistory history = new ReportDeliveryTrackingHistory();

		history.setRecordTime(reportDeliveryTracking.getRecordTime());
		history.setRemoteUser(reportDeliveryTracking.getRemoteUser());
		history.setQmxReference(reportDeliveryTracking.getQmxReference());
		history.setNextDeliveryTime(reportDeliveryTracking
				.getNextDeliveryTime());
		history.setReportingCycle(reportDeliveryTracking.getReportingCycle());
		history.setLastDeliveryTime(reportDeliveryTracking
				.getLastDeliveryTime());
		history.setCustomerId(reportDeliveryTracking.getAccount().getId());
		history.setReportDeliveryTracking(reportDeliveryTracking);

		return history;

	}
}
