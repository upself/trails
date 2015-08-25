package com.ibm.asset.trails.dao.jpa;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.DataExceptionTypeDao;
import com.ibm.asset.trails.domain.AlertType;

@Repository
public class DataExceptionTypeDaoJpa extends
		AbstractGenericEntityDAOJpa<AlertType, Long> implements
		DataExceptionTypeDao {

	public AlertType findWithCauses(Long plId) {
		return (AlertType) entityManager.createNamedQuery("findAlertTypeById")
				.setParameter("id", plId).getSingleResult();
	}

	public AlertType getAlertTypeByCode(String code) {
		return (AlertType) entityManager.createNamedQuery("getAlertTypeByCode")
				.setParameter("code", code).getSingleResult();
	}

	@SuppressWarnings("unchecked")
	public List<AlertType> list() {
		return entityManager.createNamedQuery("getAlertTypeList")
				.getResultList();
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, String>> summary(final Long accountId,
			final String alertTypeType) {
		List<Map<String, String>> result;
		if (alertTypeType.equals("DATA_EXCEPTION")) {
			result = entityManager
					.createQuery(
							"select new map('DATA_EXCEPTION' as type, a.alertType.code as code, a.alertType.name as name, count(a.id) as total) from DataException a where a.account.id = :account and a.open = 1 group by 1, a.alertType.code, a.alertType.name order by count(a.id) desc")
					.setParameter("account", accountId)
					.setHint("org.hibernate.cacheable", Boolean.TRUE)
					.getResultList();
		} else {
			result = entityManager
					.createQuery(
							"select new map('ALERT' as type, a.type as code, a.displayName as name, count(a.id) as total) from AlertView a where UCASE(a.displayName) not like ('%SOM%') and a.account.id = :account and a.open = 1 group by 1, a.type, a.displayName order by count(a.id) desc")
							// commented out the original version, needs to be switched back when all SOMs are present ! Current query ommits everything "SOM" from aLert summary view
							//"select new map('ALERT' as type, a.type as code, a.displayName as name, count(a.id) as total) from AlertView a where a.account.id = :account and a.open = 1 group by 1, a.type, a.displayName order by count(a.id) desc")
					.setParameter("account", accountId)
					.setHint("org.hibernate.cacheable", Boolean.TRUE)
					.getResultList();

			// test to try out when the query is reverted back
			
//			System.out.println("result before: " + result);
//			for (int i = 0; i < result.size(); i++) {
//				System.out.println("result.get(i).contains(\"SOM\") " + i + " " + result.get(i).get("name").contains("SOM"));
//				if (result.get(i).get("name").contains("SOM")) {
//					result.remove(i);
//				}
//			}
//			System.out.println("result after : " + result);
			
		}
		return result;
	}
}
