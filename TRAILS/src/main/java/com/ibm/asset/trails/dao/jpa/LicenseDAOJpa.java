package com.ibm.asset.trails.dao.jpa;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Query;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Expression;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.persistence.criteria.Subquery;

import org.hibernate.Session;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.action.ShowQuestion.LicenseFilter;
import com.ibm.asset.trails.dao.LicenseDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AccountPool;
import com.ibm.asset.trails.domain.AccountPool_;
import com.ibm.asset.trails.domain.Account_;
import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.CapacityType_;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.LicenseDisplay;
import com.ibm.asset.trails.domain.License_;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.Manufacturer_;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.ProductInfo_;
import com.ibm.asset.trails.domain.Product_;
import com.ibm.asset.trails.domain.Software_;
import com.ibm.asset.trails.domain.UsedLicense;
import com.ibm.asset.trails.domain.UsedLicense_;
import com.ibm.tap.trails.framework.DisplayTagList;

@Repository
public class LicenseDAOJpa extends AbstractGenericEntityDAOJpa<License, Long>
		implements LicenseDAO {

	public void freePoolWithoutParentPaginatedList(DisplayTagList data,
			Long accountId, int startIndex, int objectsPerPage, String sort,
			String dir) {
		Long total = findFreePoolWithoutParentTotal(accountId);
		data.setFullListSize(total.intValue());

		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		CriteriaQuery<LicenseDisplay> q = cb.createQuery(LicenseDisplay.class);
		Root<License> license = q.from(License.class);
		Join<License, Account> account = license.join(License_.account);
		Join<License, Software> software = license.join(
				License_.software, JoinType.LEFT);
		Join<License, CapacityType> capacityType = license
				.join(License_.capacityType);
		Join<License, UsedLicense> usedLicense = license.join(
				License_.usedLicenses, JoinType.LEFT);

		q.where(cb.equal(account.get(Account_.id), accountId), cb.equal(
				license.get(License_.status), "ACTIVE"), cb.or(cb.and(cb.equal(
				account.get(Account_.softwareFinancialResponsibility), "IBM"),
				cb.equal(license.get(License_.ibmOwned), true)), cb.and(cb
				.equal(account.get(Account_.softwareFinancialResponsibility),
						"CUSTOMER"), cb.equal(license.get(License_.ibmOwned),
				false)), cb.equal(
				account.get(Account_.softwareFinancialResponsibility), "BOTH"),
				cb.not(cb
						.in(account
								.get(Account_.softwareFinancialResponsibility))
						.value("IBM").value("CUSTOMER").value("BOTH"))));
		q.multiselect(
				license.get(License_.id).alias("licenseId"),
				cb.coalesce(software.get(Software_.softwareName),
						license.get(License_.fullDesc)).alias("productName"),
						software.get(Software_.softwareName),
				capacityType.get(CapacityType_.code).alias("capTypeCode"),
				capacityType.get(CapacityType_.description),
				cb.coalesce(
						cb.diff(license.get(License_.quantity),
								cb.sum(usedLicense
										.get(UsedLicense_.usedQuantity))),
						license.get(License_.quantity)).alias("availableQty"),
				license.get(License_.quantity).alias("quantity"),
				license.get(License_.expireDate).alias("expireDate"), license
						.get(License_.cpuSerial).alias("cpuSerial"), license
						.get(License_.extSrcId).alias("extSrcId"), license.get(License_.environment)
						.alias("environment"), account
						.get(Account_.account));

		q.groupBy(
				license.get(License_.id),
				cb.coalesce(software.get(Software_.softwareName),
						license.get(License_.fullDesc)),
						software.get(Software_.softwareName),
				capacityType.get(CapacityType_.code),
				capacityType.get(CapacityType_.description),
				license.get(License_.quantity),
				license.get(License_.expireDate),
				license.get(License_.cpuSerial),
				license.get(License_.extSrcId), license.get(License_.environment), account.get(Account_.account));
		q.having(cb.greaterThan(cb.coalesce(
				cb.diff(license.get(License_.quantity),
						cb.sum(usedLicense.get(UsedLicense_.usedQuantity))),
				license.get(License_.quantity)), 0));

		TypedQuery<LicenseDisplay> typedQuery = entityManager.createQuery(q);
		typedQuery.setFirstResult(startIndex);
		typedQuery.setMaxResults(objectsPerPage);
		List<LicenseDisplay> result = typedQuery.getResultList();
		data.setList(result);
	}

	private Long findFreePoolWithoutParentTotal(Long accountId) {
		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		CriteriaQuery<Long> q = cb.createQuery(Long.class);
		Root<License> licenseOuter = q.from(License.class);
		q.select(cb.count(licenseOuter.get(License_.id)));

		Subquery<Long> sq = q.subquery(Long.class);
		Root<License> license = sq.from(License.class);
		Join<License, Account> account = license.join(License_.account);
		Join<License, UsedLicense> usedLicense = license.join(
				License_.usedLicenses, JoinType.LEFT);
		sq.select(license.get(License_.id));
		sq.where(cb.equal(account.get(Account_.id), accountId), cb.equal(
				license.get(License_.status), "ACTIVE"), cb.or(cb.and(cb.equal(
				account.get(Account_.softwareFinancialResponsibility), "IBM"),
				cb.equal(license.get(License_.ibmOwned), true)), cb.and(cb
				.equal(account.get(Account_.softwareFinancialResponsibility),
						"CUSTOMER"), cb.equal(license.get(License_.ibmOwned),
				false)), cb.equal(
				account.get(Account_.softwareFinancialResponsibility), "BOTH"),
				cb.not(cb
						.in(account
								.get(Account_.softwareFinancialResponsibility))
						.value("IBM").value("CUSTOMER").value("BOTH"))));
		sq.groupBy(license.get(License_.id), license.get(License_.quantity));
		sq.having(cb.greaterThan(cb.coalesce(
				cb.diff(license.get(License_.quantity),
						cb.sum(usedLicense.get(UsedLicense_.usedQuantity))),
				license.get(License_.quantity)), 0));

		q.where(cb.in(licenseOuter.get(License_.id)).value(sq));
		return entityManager.createQuery(q).getResultList().get(0);
	}
	
	public List freePoolWithParentPaginatedList(Long accountId, int startIndex, int objectsPerPage, String sort,
			String dir, List<LicenseFilter> filters){ 
		DisplayTagList data = new DisplayTagList();
		freePoolWithParentPaginatedList( data, accountId, startIndex, objectsPerPage, sort, dir, filters);
		return data.getList();	
	}
	
	public int getLicFreePoolSizeWithoutFilters(Long accountId){
		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		CriteriaQuery<Long> sq = cb.createQuery(Long.class);
		Root<AccountPool> accountPool = sq.from(AccountPool.class);
		Join<AccountPool, Account> memberAccount = accountPool
				.join(AccountPool_.memberAccount);
		Join<AccountPool, Account> masterAccount = accountPool
				.join(AccountPool_.masterAccount);
		sq.select(masterAccount.get(Account_.id));
		sq.where(cb.equal(memberAccount.get(Account_.id), accountId),
				cb.equal(masterAccount.get(Account_.status), "ACTIVE"),
				cb.equal(masterAccount.get(Account_.swlm), "YES"),
				cb.isFalse(accountPool.get(AccountPool_.deleted)));
		TypedQuery<Long> tq = entityManager.createQuery(sq);
		List<Long> accountIds = tq.getResultList();
		accountIds.add(accountId);

		Long total = findFreePoolWithParentTotal(accountIds, accountId, null);
		return total.intValue();
	}

	public void freePoolWithParentPaginatedList(DisplayTagList data,
			Long accountId, int startIndex, int objectsPerPage, String sort,
			String dir, List<LicenseFilter> filters) {
		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		CriteriaQuery<Long> sq = cb.createQuery(Long.class);
		Root<AccountPool> accountPool = sq.from(AccountPool.class);
		Join<AccountPool, Account> memberAccount = accountPool
				.join(AccountPool_.memberAccount);
		Join<AccountPool, Account> masterAccount = accountPool
				.join(AccountPool_.masterAccount);
		sq.select(masterAccount.get(Account_.id));
		sq.where(cb.equal(memberAccount.get(Account_.id), accountId),
				cb.equal(masterAccount.get(Account_.status), "ACTIVE"),
				cb.equal(masterAccount.get(Account_.swlm), "YES"),
				cb.isFalse(accountPool.get(AccountPool_.deleted)));
		TypedQuery<Long> tq = entityManager.createQuery(sq);
		List<Long> accountIds = tq.getResultList();
		accountIds.add(accountId);

		Long total = findFreePoolWithParentTotal(accountIds, accountId, filters);
		data.setFullListSize(total.intValue());

		CriteriaQuery<LicenseDisplay> q = cb.createQuery(LicenseDisplay.class);
		Root<License> license = q.from(License.class);
		Join<License, Account> account = license.join(License_.account);
		Join<License, Software> software = license.join(
				License_.software, JoinType.LEFT);
		Join<Software, Manufacturer> manufacturer = software.join(
				Software_.manufacturer, JoinType.LEFT);
		Join<License, CapacityType> capacityType = license
				.join(License_.capacityType);
		Join<License, UsedLicense> usedLicense = license.join(
				License_.usedLicenses, JoinType.LEFT);

		List<Predicate> predicates = new ArrayList<Predicate>();

		convertFiltersToPredicates(filters, cb, license, software,
				manufacturer, capacityType, predicates);

		predicates.add(account.get(Account_.id).in(accountIds));
		predicates.add(cb.equal(license.get(License_.status), "ACTIVE"));

		predicates.add(cb.and(cb.or(
				cb.and(cb.equal(license.get(License_.pool), 0),
						cb.equal(account.get(Account_.id), accountId)),
				cb.equal(license.get(License_.pool), 1))));

		q.where(predicates.toArray(new Predicate[predicates.size()]));
		q.multiselect(
				license.get(License_.id).alias("licenseId"),
				cb.coalesce(software.get(Software_.softwareName),license.get(License_.fullDesc)).alias("productName"),
				software.get(Software_.softwareName),
				license.get(License_.fullDesc).alias("fullDesc"),license.get(License_.sku).alias("sku"),
				license.get(License_.ibmOwned).alias("ibmOwned"),
				license.get(License_.swproPID).alias("swproPID"),
				capacityType.get(CapacityType_.code).alias("capTypeCode"),
				capacityType.get(CapacityType_.description),
				cb.coalesce(
						cb.diff(license.get(License_.quantity),
								cb.sum(usedLicense.get(UsedLicense_.usedQuantity))),
						license.get(License_.quantity)).alias("availableQty")
						.alias("availableQty"), license.get(License_.quantity)
						.alias("quantity"), license.get(License_.expireDate)
						.alias("expireDate"), license.get(License_.cpuSerial)
						.alias("cpuSerial"), license.get(License_.extSrcId)
						.alias("extSrcId"), license.get(License_.environment)
						.alias("environment"), account.get(Account_.account)
						.alias("accountName"));
		q.groupBy(
				license.get(License_.id),
				cb.coalesce(software.get(Software_.softwareName),license.get(License_.fullDesc)),
				software.get(Software_.softwareName),
				license.get(License_.fullDesc), license.get(License_.sku),
				license.get(License_.ibmOwned),
				license.get(License_.swproPID),
				capacityType.get(CapacityType_.code),
				capacityType.get(CapacityType_.description),
				license.get(License_.quantity),
				license.get(License_.expireDate),
				license.get(License_.cpuSerial),
				license.get(License_.extSrcId), license.get(License_.environment), account.get(Account_.account));
		q.having(cb.greaterThan(cb.coalesce(
				cb.diff(license.get(License_.quantity),
						cb.sum(usedLicense.get(UsedLicense_.usedQuantity))),
				license.get(License_.quantity)), 0));

		Expression<Integer> expression = cb.coalesce(
				cb.diff(license.get(License_.quantity),
						cb.sum(usedLicense.get(UsedLicense_.usedQuantity))),
				license.get(License_.quantity));

		if (sort == null) {
			sort = "availableQty";
			dir = "asc";
		}

		String orderBy;
		try {
			orderBy = sort.split("\\.")[1];
		} catch (ArrayIndexOutOfBoundsException e) {
			orderBy = "";
		}
		if (sort.startsWith("account")) {
			if (dir.equalsIgnoreCase("asc")) {
				q.orderBy(cb.asc(account.get(orderBy)));
			} else {
				q.orderBy(cb.desc(account.get(orderBy)));
			}
		} else if (sort.startsWith("software")) {
			if (dir.equalsIgnoreCase("asc")) {
				q.orderBy(cb.asc(cb.coalesce(software.get(orderBy),
						license.get("fullDesc"))));
			} else {
				q.orderBy(cb.desc(cb.coalesce(software.get(orderBy),
						license.get("fullDesc"))));
			}
		} else if (sort.startsWith("license")){
			if (dir.equalsIgnoreCase("asc")) {
				q.orderBy(cb.asc(license.get(orderBy)));
			} else {
				q.orderBy(cb.desc(license.get(orderBy)));
			}
		}else if(sort.startsWith("capacityType")) {
			if (dir.equalsIgnoreCase("asc")) {
				q.orderBy(cb.asc(capacityType.get(orderBy)));
			} else {
				q.orderBy(cb.desc(capacityType.get(orderBy)));
			}
		} else {
			if (dir.equalsIgnoreCase("asc")) {
				if (sort == "availableQty") {
					q.orderBy(cb.asc(expression));
				} else {
					q.orderBy(cb.asc(license.get(sort)));
				}
			} else {
				if (sort == "availableQty") {
					q.orderBy(cb.asc(expression));
				} else {
					q.orderBy(cb.desc(expression));
				}
			}
		}

		TypedQuery<LicenseDisplay> typedQuery = entityManager.createQuery(q);
		typedQuery.setFirstResult(startIndex);
		typedQuery.setMaxResults(objectsPerPage);
		List<LicenseDisplay> result = typedQuery.getResultList();
		data.setList(result);
	}

	private void convertFiltersToPredicates(List<LicenseFilter> filters,
			CriteriaBuilder cb, Root<License> license,
			Join<License, Software> software,
			Join<Software, Manufacturer> manufacturer,
			Join<License, CapacityType> capacityType, List<Predicate> predicates) {

		if (filters != null && filters.size() > 0) {

			List<Predicate> orConnected = new ArrayList<Predicate>();
			for (LicenseFilter fltr : filters) {

				List<Predicate> andConnected = new ArrayList<Predicate>();
				Integer capcityType = fltr.getCapcityType();
				if (capcityType != -1) {
					andConnected.add(cb.equal(
							capacityType.get(CapacityType_.code), capcityType));
				}

				String fltrMnfctr = fltr.getManufacturer();
				if (fltrMnfctr != null && !"".equals(fltrMnfctr)) {
					andConnected.add(cb.like(cb.upper(manufacturer
							.get(Manufacturer_.manufacturerName)), fltrMnfctr
							.toUpperCase()));
				}

				String fltrPrdctNm = fltr.getProductName();
				if (fltrPrdctNm != null && !"".equals(fltrPrdctNm)) {
					andConnected.add(cb.like(
							cb.upper(software.get(Software_.softwareName)),
							fltrPrdctNm.toUpperCase()));
				}

				String fltrPoNo = fltr.getPoNo();
				if (fltrPoNo != null && !"".equals(fltrPoNo)) {
					andConnected.add(cb.equal(
							cb.upper(license.get(License_.poNumber)),
							fltrPoNo.toUpperCase()));
				}

				String fltrSwcmId = fltr.getSwcmId();
				if (fltrSwcmId != null && !"".equals(fltrSwcmId)) {
					andConnected.add(cb.equal(
							cb.upper(license.get(License_.extSrcId)),
							fltrSwcmId.toUpperCase()));
				}
				
				String ownershipStr = fltr.getLicenseOwner();
				if(null != ownershipStr && !"".equals(ownershipStr.trim())){
					if(Boolean.valueOf(ownershipStr)){
						andConnected.add(cb.isTrue(license.get(License_.ibmOwned)));
					}else{
						andConnected.add(cb.isFalse(license.get(License_.ibmOwned)));
					}
				}

				orConnected.add(cb.and(andConnected
						.toArray(new Predicate[andConnected.size()])));
			}

			predicates.add(cb.or(orConnected.toArray(new Predicate[orConnected
					.size()])));

		}
	}

	private Long findFreePoolWithParentTotal(List<Long> accountIds,
			Long accountId, List<LicenseFilter> filters) {
		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		CriteriaQuery<Long> q = cb.createQuery(Long.class);
		Root<License> licenseOuter = q.from(License.class);
		q.select(cb.count(licenseOuter.get(License_.id)));

		Subquery<Long> sq = q.subquery(Long.class);
		Root<License> license = sq.from(License.class);
		Join<License, Account> account = license.join(License_.account);
		Join<License, Software> software = license.join(
				License_.software, JoinType.LEFT);
		Join<Software, Manufacturer> manufacturer = software.join(
				Software_.manufacturer, JoinType.LEFT);
		Join<License, CapacityType> capacityType = license
				.join(License_.capacityType);
		Join<License, UsedLicense> usedLicense = license.join(
				License_.usedLicenses, JoinType.LEFT);

		sq.select(license.get(License_.id));

		List<Predicate> predicates = new ArrayList<Predicate>();

		convertFiltersToPredicates(filters, cb, license, software,
				manufacturer, capacityType, predicates);

		predicates.add(account.get(Account_.id).in(accountIds));
		predicates.add(cb.equal(license.get(License_.status), "ACTIVE"));
		predicates.add(cb.and(cb.or(
				cb.and(cb.equal(license.get(License_.pool), 0),
						cb.equal(account.get(Account_.id), accountId)),
				cb.equal(license.get(License_.pool), 1))));

		sq.where(predicates.toArray(new Predicate[predicates.size()]));
		sq.groupBy(license.get(License_.id), license.get(License_.quantity));
		sq.having(cb.greaterThan(cb.coalesce(
				cb.diff(license.get(License_.quantity),
						cb.sum(usedLicense.get(UsedLicense_.usedQuantity))),
				license.get(License_.quantity)), 0));

		q.where(cb.in(licenseOuter.get(License_.id)).value(sq));
		return entityManager.createQuery(q).getResultList().get(0);
	}

	@SuppressWarnings("unchecked")
	public List<CapacityType> getCapacityTypeList() {
		return entityManager.createNamedQuery("capacityTypeList")
				.getResultList();
	}

	public License getLicenseDetails(Long id) {
		Query lQuery = entityManager.createNamedQuery("licenseDetails");

		lQuery.setParameter("id", id);

		return (License) lQuery.getSingleResult();
	}

	public void paginatedList(DisplayTagList data, Long accountId,
			int startIndex, int objectsPerPage, String psSort, String psDir) {
		psSort = decodeSort(psSort) + " " + psDir;

		Query q = entityManager.createNamedQuery("licenseTotalByAccount")
				.setParameter("account", accountId);
		data.setFullListSize(((Long) q.getResultList().get(0)).intValue());

		Session session = (Session) entityManager.getDelegate();

		data.setList(session
				.createQuery(
						session.getNamedQuery("licenseBaseline")
								.getQueryString() + " order by " + psSort)
				.setParameter("account", accountId)
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP)
				.setFirstResult(startIndex).setMaxResults(objectsPerPage)
				.list());
	}
	
	@SuppressWarnings("unchecked")
	public List<License> paginatedList(Long accountId,
			int startIndex, int objectsPerPage, String psSort, String psDir) {
		psSort = decodeSort(psSort) + " " + psDir;
		List<License> licList = new ArrayList<License>();
		Session session = (Session) entityManager.getDelegate();

		licList=session.createQuery(session.getNamedQuery("licenseBaseline").getQueryString() + " order by " + psSort)
				.setParameter("account", accountId)
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP)
				.setFirstResult(startIndex).setMaxResults(objectsPerPage).list();
		return licList;
	}
	
	@SuppressWarnings("unchecked")
	public int getLicBaselineSize(Long accountId) {
		List<License> licList = new ArrayList<License>();
		Session session = (Session) entityManager.getDelegate();

		licList=session.createQuery(session.getNamedQuery("licenseBaseline").getQueryString())
				.setParameter("account", accountId)
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
		if(licList!=null){
			return licList.size();
		}
		return 0;
	}

	private String decodeSort(String psSort) {
		if (psSort.equalsIgnoreCase("productName")) {
			return "COALESCE(sw.softwareName, L.fullDesc)";
		} else if (psSort.equalsIgnoreCase("capTypeCode")) {
			return "L.capacityType.code";
		} else if (psSort.equalsIgnoreCase("availableQty")) {
			return "coalesce(L.quantity - sum(LUQV.usedQuantity),l.quantity)";
		} else {
			return new StringBuffer("L.").append(psSort).toString();
		}
	}

	@SuppressWarnings("unchecked")
	public List<Long> getLicenseIdsByReconcileId(Long reconcileId) {
		return entityManager
				.createQuery(
						"SELECT lrm.license.id FROM UsedLicense lrm join lrm.reconciles r WHERE r.id = :reconcileId")
				.setParameter("reconcileId", reconcileId).getResultList();
	}

	public List<String> getProductNameByAccount(Long accountId, String key) {
		return entityManager.createNamedQuery("productNameByAccount")
				.setParameter("accountId", accountId).setParameter("key", key)
				.getResultList();
	}

	public List<String> getManufacturerNameByAccount(Long id, String key) {
		return entityManager.createNamedQuery("manufacturerNameByAccount")
				.setParameter("accountId", id).setParameter("key", key)
				.getResultList();
	}

}
