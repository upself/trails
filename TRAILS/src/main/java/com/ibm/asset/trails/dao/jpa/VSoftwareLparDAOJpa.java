package com.ibm.asset.trails.dao.jpa;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.ScrollableResults;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.VSoftwareLparDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.ReconSetting;
import com.ibm.asset.trails.domain.ReconWorkspace;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.VSoftwareLpar;
import com.ibm.tap.trails.framework.DisplayTagList;

@Repository
public class VSoftwareLparDAOJpa extends
		AbstractGenericEntityDAOJpa<VSoftwareLpar, Long> implements
		VSoftwareLparDAO {
	
	@Override
	public Long total(Account account, ReconSetting reconSetting) {
		// TODO Auto-generated method stub
		Criteria criteria = getHibernateSessionCriteria();

		criteria.createAlias("hardwareLpar", "hl")
				.createAlias("hl.hardwareLparEff", "hle", CriteriaSpecification.LEFT_JOIN)
				.createAlias("hl.hardware", "h")
				.createAlias("h.machineType", "mt")
				.createAlias("installedSoftwares", "is")
				.createAlias("is.softwareLpar", "sl")
				.createAlias("is.alert", "aus")
				.createAlias("aus.reconcile", "r",
						CriteriaSpecification.LEFT_JOIN)
				.createAlias("r.reconcileType", "rt",
						CriteriaSpecification.LEFT_JOIN)
				.createAlias("is.software", "sw")
				.add(Restrictions.eq("account", account));

		if (reconSetting.getReconcileType() != null) {
			criteria.add(Restrictions.eq("rt.id",
					reconSetting.getReconcileType()));
		}

		if (StringUtils.isNotBlank(reconSetting.getAlertStatus())) {
			boolean open = false;
			if (reconSetting.getAlertStatus().equals("OPEN")) {
				open = true;
				criteria.add(Restrictions.eq("aus.open", open));
			} else {
				criteria.add(Restrictions.and(Restrictions
						.eq("aus.open", false), Restrictions.eqProperty(
						"is.id", "r.installedSoftware.id")));
			}

		} else {
			criteria.add(Restrictions.or(Restrictions.eq("aus.open", true),
					Restrictions.and(Restrictions.eq("aus.open", false),
							Restrictions.eqProperty("is.id",
									"r.installedSoftware.id"))));
		}

		if (StringUtils.isNotBlank(reconSetting.getAlertColor())) {
			if (reconSetting.getAlertColor().equals("Green")) {
				criteria.add(Restrictions.lt("aus.alertAge", 45));
			} else if (reconSetting.getAlertColor().equals("Yellow")) {
				criteria.add(Restrictions.between("aus.alertAge", 45, 90));
			} else if (reconSetting.getAlertColor().equals("Red")) {
				criteria.add(Restrictions.gt("aus.alertAge", 90));
			}
		}

		if (StringUtils.isNotBlank(reconSetting.getAssigned())) {
			if (reconSetting.getAssigned().equals("Assigned")) {
				criteria.add(Restrictions.ne("aus.remoteUser", "STAGING"));
			}
			if (reconSetting.getAssigned().equals("Unassigned")) {
				criteria.add(Restrictions.eq("aus.remoteUser", "STAGING"));
			}
		}

		if (StringUtils.isNotBlank(reconSetting.getAssignee())) {
			criteria.add(Restrictions.eq("aus.remoteUser",
					reconSetting.getAssignee()).ignoreCase());
		}

		if (StringUtils.isNotBlank(reconSetting.getOwner())) {
			if (reconSetting.getOwner().equalsIgnoreCase("IBM")) {
				criteria.add(Restrictions
						.eq("h.owner", reconSetting.getOwner()).ignoreCase());
			} else if (reconSetting.getOwner().equalsIgnoreCase("Customer")) {
				ArrayList<String> lalOwner = new ArrayList<String>();

				lalOwner.add("CUST");
				lalOwner.add("CUSTO");
				criteria.add(Restrictions.in("h.owner", lalOwner));
			}
		}

		// I'm not sure why the heck we aren't just getting a list of strings?
		if (reconSetting.getCountries().length > 0) {
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < reconSetting.getCountries().length; i++) {
				if (StringUtils.isNotBlank(reconSetting.getCountries()[i])) {
					list.add(reconSetting.getCountries()[i].toUpperCase());
				}
			}

			if (list.size() > 0) {
				criteria.add(Restrictions.in("h.country", list));
			}
		}

		if (reconSetting.getNames().length > 0) {
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < reconSetting.getNames().length; i++) {
				if (StringUtils.isNotBlank(reconSetting.getNames()[i])) {
					list.add(reconSetting.getNames()[i].toUpperCase());
				}
			}

			if (list.size() > 0) {
				criteria.add(Restrictions.in("hl.name", list));
			}
		}

		if (reconSetting.getSerialNumbers().length > 0) {
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < reconSetting.getSerialNumbers().length; i++) {
				if (StringUtils.isNotBlank(reconSetting.getSerialNumbers()[i])) {
					list.add(reconSetting.getSerialNumbers()[i].toUpperCase());
				}
			}

			if (list.size() > 0) {
				criteria.add(Restrictions.in("h.serial", list));
			}
		}

		if (reconSetting.getProductInfoNames().length > 0) {
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < reconSetting.getProductInfoNames().length; i++) {
				if (StringUtils
						.isNotBlank(reconSetting.getProductInfoNames()[i])) {
					list.add(reconSetting.getProductInfoNames()[i]);
				}
			}

			if (list.size() > 0) {
				criteria.add(Restrictions.in("sw.softwareName", list));
			}
		}
		criteria.setProjection(Projections.projectionList().add(Projections.rowCount()));
		
		Long total = (Long)criteria.uniqueResult();
		return total;
	}

	public void paginatedList(DisplayTagList data, Account account,
			ReconSetting reconSetting, int startIndex, int objectsPerPage,
			String sort, String dir) {
		Criteria criteria = getHibernateSessionCriteria();

		criteria.createAlias("hardwareLpar", "hl")
				.createAlias("hl.hardwareLparEff", "hle", CriteriaSpecification.LEFT_JOIN)
				.createAlias("hl.hardware", "h")
				.createAlias("h.machineType", "mt")
				.createAlias("installedSoftwares", "is")
				.createAlias("is.softwareLpar", "sl")
				.createAlias("is.alert", "aus")
				.createAlias("aus.reconcile", "r",
						CriteriaSpecification.LEFT_JOIN)
				.createAlias("r.reconcileType", "rt",
						CriteriaSpecification.LEFT_JOIN)
				.createAlias("is.software", "sw")
				.createAlias("sw.manufacturer", "mf", CriteriaSpecification.LEFT_JOIN)
				.add(Restrictions.eq("account", account));

		if (reconSetting.getReconcileType() != null) {
			criteria.add(Restrictions.eq("rt.id",
					reconSetting.getReconcileType()));
		}

		if (StringUtils.isNotBlank(reconSetting.getAlertStatus())) {
			boolean open = false;
			if (reconSetting.getAlertStatus().equals("OPEN")) {
				open = true;
				criteria.add(Restrictions.eq("aus.open", open));
			} else {
				criteria.add(Restrictions.and(Restrictions
						.eq("aus.open", false), Restrictions.eqProperty(
						"is.id", "r.installedSoftware.id")));
			}

		} else {
			criteria.add(Restrictions.or(Restrictions.eq("aus.open", true),
					Restrictions.and(Restrictions.eq("aus.open", false),
							Restrictions.eqProperty("is.id",
									"r.installedSoftware.id"))));
		}

		if (StringUtils.isNotBlank(reconSetting.getAlertColor())) {
			if (reconSetting.getAlertColor().equals("Green")) {
				criteria.add(Restrictions.lt("aus.alertAge", 45));
			} else if (reconSetting.getAlertColor().equals("Yellow")) {
				criteria.add(Restrictions.between("aus.alertAge", 45, 90));
			} else if (reconSetting.getAlertColor().equals("Red")) {
				criteria.add(Restrictions.gt("aus.alertAge", 90));
			}
		}

		if (StringUtils.isNotBlank(reconSetting.getAssigned())) {
			if (reconSetting.getAssigned().equals("Assigned")) {
				criteria.add(Restrictions.ne("aus.remoteUser", "STAGING"));
			}
			if (reconSetting.getAssigned().equals("Unassigned")) {
				criteria.add(Restrictions.eq("aus.remoteUser", "STAGING"));
			}
		}

		if (StringUtils.isNotBlank(reconSetting.getAssignee())) {
			criteria.add(Restrictions.eq("aus.remoteUser",
					reconSetting.getAssignee()).ignoreCase());
		}

		if (StringUtils.isNotBlank(reconSetting.getOwner())) {
			if (reconSetting.getOwner().equalsIgnoreCase("IBM")) {
				criteria.add(Restrictions
						.eq("h.owner", reconSetting.getOwner()).ignoreCase());
			} else if (reconSetting.getOwner().equalsIgnoreCase("Customer")) {
				ArrayList<String> lalOwner = new ArrayList<String>();

				lalOwner.add("CUST");
				lalOwner.add("CUSTO");
				criteria.add(Restrictions.in("h.owner", lalOwner));
			}
		}

		// I'm not sure why the heck we aren't just getting a list of strings?
		if (reconSetting.getCountries().length > 0) {
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < reconSetting.getCountries().length; i++) {
				if (StringUtils.isNotBlank(reconSetting.getCountries()[i])) {
					list.add(reconSetting.getCountries()[i].toUpperCase());
				}
			}

			if (list.size() > 0) {
				criteria.add(Restrictions.in("h.country", list));
			}
		}

		if (reconSetting.getNames().length > 0) {
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < reconSetting.getNames().length; i++) {
				if (StringUtils.isNotBlank(reconSetting.getNames()[i])) {
					list.add(reconSetting.getNames()[i].toUpperCase());
				}
			}

			if (list.size() > 0) {
				criteria.add(Restrictions.in("hl.name", list));
			}
		}

		if (reconSetting.getSerialNumbers().length > 0) {
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < reconSetting.getSerialNumbers().length; i++) {
				if (StringUtils.isNotBlank(reconSetting.getSerialNumbers()[i])) {
					list.add(reconSetting.getSerialNumbers()[i].toUpperCase());
				}
			}

			if (list.size() > 0) {
				criteria.add(Restrictions.in("h.serial", list));
			}
		}

		if (reconSetting.getProductInfoNames().length > 0) {
			List<String> list = new ArrayList<String>();
			for (int i = 0; i < reconSetting.getProductInfoNames().length; i++) {
				if (StringUtils
						.isNotBlank(reconSetting.getProductInfoNames()[i])) {
					list.add(reconSetting.getProductInfoNames()[i]);
				}
			}

			if (list.size() > 0) {
				criteria.add(Restrictions.in("sw.softwareName", list));
			}
		}

		criteria.setProjection(Projections
				.projectionList()
				.add(Projections.property("aus.id").as("alertId"))
				.add(Projections.property("r.id").as("reconcileId"))
				.add(Projections.property("aus.alertAge").as("alertAgeI"))
				.add(Projections.property("is.id").as("installedSoftwareId"))
				.add(Projections.property("hl.name").as("hostname"))
				.add(Projections.property("sl.name").as("sl_hostname"))
				.add(Projections.property("hl.spla").as("spla"))
				.add(Projections.property("hl.sysplex").as("sysplex"))
				.add(Projections.property("hl.internetIccFlag").as("internetIccFlag"))
				.add(Projections.property("h.serial").as("serial"))
				.add(Projections.property("h.country").as("country"))
				.add(Projections.property("h.owner").as("owner"))
				.add(Projections.property("h.mastProcessorType").as("mastProcessorType"))
				.add(Projections.property("h.processorManufacturer").as("processorManufacturer"))
				.add(Projections.property("h.mastProcessorModel").as("mastProcessorModel"))
				.add(Projections.property("h.nbrCoresPerChip").as("nbrCoresPerChip"))
				.add(Projections.property("h.nbrOfChipsMax").as("nbrOfChipsMax"))
				.add(Projections.property("h.cpuLsprMips").as("cpuLsprMips"))
				.add(Projections.property("h.cpuIfl").as("cpuIFL"))
				.add(Projections.property("hl.partLsprMips").as("partLsprMips"))
				.add(Projections.property("h.cpuGartnerMips").as("cpuGartnerMips"))
				.add(Projections.property("hl.partGartnerMips").as("partGartnerMips"))
				.add(Projections.property("hl.effectiveThreads").as("effectiveThreads"))
				.add(Projections.property("h.cpuMsu").as("cpuMsu"))
				.add(Projections.property("hl.partMsu").as("partMsu"))
				.add(Projections.property("hl.serverType").as("lparServerType"))
				.add(Projections.property("h.shared").as("shared"))
				.add(Projections.property("mt.type").as("assetType"))
				.add(Projections.property("mt.name").as("assetName"))
				.add(Projections.property("h.hardwareStatus").as("hardwareStatus"))
				.add(Projections.property("hl.lparStatus").as("lparStatus"))
				.add(Projections.property("processorCount").as("processorCount"))
				.add(Projections.property("sw.softwareName").as("productInfoName"))
				.add(Projections.property("sw.softwareId").as("productInfoId"))
				.add(Projections.property("sw.pid").as("pid"))
				.add(Projections.property("mf.manufacturerName").as("manufacturerName"))
				.add(Projections.property("rt.name").as("reconcileTypeName"))
				.add(Projections.property("rt.id").as("reconcileTypeId"))
				.add(Projections.property("aus.remoteUser").as("assignee"))
				.add(Projections.property("h.processorCount").as("hardwareProcessorCount"))
				.add(Projections.property("hle.processorCount").as("hwLparEffProcessorCount"))
				.add(Projections.property("hl.osType").as("osType"))
				.add(Projections.property("hle.status").as("hwLparEffProcessorStatus"))
				.add(Projections.property("h.chips").as("chips")));
		criteria.setResultTransformer(new AliasToBeanResultTransformer(
				ReconWorkspace.class));

		criteria.addOrder(Order.desc("aus.open"));

		if (dir.equalsIgnoreCase("ASC")) {
			criteria.addOrder(Order.asc(sort));
		} else {
			criteria.addOrder(Order.desc(sort));
		}

		ArrayList<ReconWorkspace> list = new ArrayList<ReconWorkspace>();
		
		
		ScrollableResults itemCursor = criteria.scroll();
		itemCursor.beforeFirst();
		if (itemCursor.next()) {
			itemCursor.scroll(startIndex);
			int i = 0;

			while (objectsPerPage > i++) {
				ReconWorkspace rw = (ReconWorkspace)itemCursor.get(0);
				if(null != rw.getHwLparEffProcessorStatus() && rw.getHwLparEffProcessorStatus().equalsIgnoreCase("INACTIVE")){
					rw.setHwLparEffProcessorCount(0);
				}
				list.add(rw);
				if (!itemCursor.next())
					break;
			}

			data.setList(list);
			itemCursor.last();
			data.setFullListSize(itemCursor.getRowNumber() + 1);
			itemCursor.close();
			
			addSchedulef2List(account,data.getList());
		} else {
			data.setList(null);
			data.setFullListSize(0);
			itemCursor.close();
		}
		
	}
	
	private void addSchedulef2List(Account account, List<ReconWorkspace> list){
		for(ReconWorkspace rw:list){
			ScheduleF sf = getScheduleFItem(account, rw.getProductInfoName(), rw.getSl_hostname(), rw.getOwner(), rw.getAssetName(), rw.getSerial(), rw.getManufacturerName());
			if(sf!=null){
				rw.setScope(sf.getScope().getDescription());
				rw.setScopeId(sf.getScope().getId());
				rw.setLevel(sf.getLevel());
			}else{
				rw.setScope("Not specified");
				rw.setScopeId(null);
				rw.setLevel("Not specified");
			}
		}
	}
	
	private EntityManager em;

	@PersistenceContext(unitName = "trailspd")
	public void setEntityManager(EntityManager em) {
		this.em = em;
	}

	private EntityManager getEntityManager() {
		return em;
	}
	
	@Override
	public ScheduleF getHostnameLevelScheduleF(Account account, String swname, String hostname) {
		// TODO Auto-generated method stub
		
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createQuery(
						" from ScheduleF a where a.status.description='ACTIVE' and a.level = 'HOSTNAME' and a.account =:account and a.softwareName =:swname and a.hostname =:hostname")
				.setParameter("account", account)
				.setParameter("swname", swname)
				.setParameter("hostname", hostname)
				.getResultList();
		
		if(null != results && results.size() > 0){
			return results.get(0);
		}
		
		return null;
	}

	@Override
	public ScheduleF getMachineLevelScheduleF(Account account, String swname,
			String hwOwner, String machineType, String serial,
			String manufacturerName) {
	
		// HOSTNAME,HWBOX, HWOWNER,PRODUCT
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createQuery(
						" from ScheduleF a where a.status.description='ACTIVE' and a.level <> 'HOSTNAME' and a.account =:account and a.softwareName =:swname")
				.setParameter("account", account)
				.setParameter("swname", swname).getResultList();
		
		boolean isExist = false;

		List<ScheduleF> hwboxLevel = new ArrayList<ScheduleF>();
		List<ScheduleF> hwOwnerLevel = new ArrayList<ScheduleF>();
		List<ScheduleF> proudctLevel = new ArrayList<ScheduleF>();
		

		for (ScheduleF sf : results) {
			String level = sf.getLevel();
			if ("HWBOX".equals(level)) {
				hwboxLevel.add(sf);
			} else if ("HWOWNER".equals(level)) {
				hwOwnerLevel.add(sf);
			} else if("PRODUCT".equals(level)) {
				proudctLevel.add(sf);
			} else {
				
			}
		}

		for (ScheduleF sf : hwboxLevel) {
			if (null != sf.getSerial() 
					&& sf.getSerial().equals(serial)
					&& null != sf.getMachineType() 
					&& sf.getMachineType().equals(machineType)) {
				isExist = true;
				return sf;
			}
		}

		for (ScheduleF sf : hwOwnerLevel) {
			if (null != sf.getHwOwner() && sf.getHwOwner().equals(hwOwner)) {
				isExist = true;
				return sf;
			}
		}

		for (ScheduleF sf : proudctLevel) {
			if (null != sf.getSoftwareName() && sf.getSoftwareName().equals(swname)) {
				isExist = true;
				return sf;
			}
		}
		
		// Manufacture level
		if(!isExist){
			@SuppressWarnings("unchecked")
			List<ScheduleF> manufactureResults = getEntityManager()
					.createQuery(
							" from ScheduleF a where a.status.description='ACTIVE' and a.account =:account and a.manufacturer =:manufacturerName and a.level = 'MANUFACTURER' ")
					.setParameter("account", account)
					.setParameter("manufacturerName", manufacturerName)
					.getResultList();
			
			if(null == manufactureResults || manufactureResults.size() == 0){
				return null;
			}else{
				return manufactureResults.get(0);
			}
		}

		return null;
	}

	public ScheduleF getScheduleFItem(Account account, String swname,
			String hostName, String hwOwner, String machineType, String serial, String manufacturerName) {
	
		// HOSTNAME,HWBOX, HWOWNER,PRODUCT
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createQuery(
						" from ScheduleF a where a.status.description='ACTIVE' and a.account =:account and a.softwareName =:swname")
				.setParameter("account", account)
				.setParameter("swname", swname).getResultList();
		
		boolean isExist = false;

		List<ScheduleF> hostNameLevel = new ArrayList<ScheduleF>();
		List<ScheduleF> hwboxLevel = new ArrayList<ScheduleF>();
		List<ScheduleF> hwOwnerLevel = new ArrayList<ScheduleF>();
		List<ScheduleF> proudctLevel = new ArrayList<ScheduleF>();
		

		for (ScheduleF sf : results) {
			String level = sf.getLevel();
			if ("HOSTNAME".equals(level)) {
				hostNameLevel.add(sf);
			} else if ("HWBOX".equals(level)) {
				hwboxLevel.add(sf);
			} else if ("HWOWNER".equals(level)) {
				hwOwnerLevel.add(sf);
			} else if("PRODUCT".equals(level)) {
				proudctLevel.add(sf);
			} else {
				
			}
		}

		for (ScheduleF sf : hostNameLevel) {
			if (null != sf.getHostname() && sf.getHostname().equals(hostName)) {
				isExist = true;
				return sf;
			}
		}

		for (ScheduleF sf : hwboxLevel) {
			if (null != sf.getSerial() 
					&& sf.getSerial().equals(serial)
					&& null != sf.getMachineType() 
					&& sf.getMachineType().equals(machineType)) {
				isExist = true;
				return sf;
			}
		}

		for (ScheduleF sf : hwOwnerLevel) {
			if (null != sf.getHwOwner() && sf.getHwOwner().equals(hwOwner)) {
				isExist = true;
				return sf;
			}
		}

		for (ScheduleF sf : proudctLevel) {
			if (null != sf.getSoftwareName() && sf.getSoftwareName().equals(swname)) {
				isExist = true;
				return sf;
			}
		}
		
		// Manufacture level
		if(!isExist){
			@SuppressWarnings("unchecked")
			List<ScheduleF> manufactureResults = getEntityManager()
					.createQuery(
							" from ScheduleF a where a.status.description='ACTIVE' and a.account =:account and a.manufacturer =:manufacturerName and a.level = 'MANUFACTURER' ")
					.setParameter("account", account)
					.setParameter("manufacturerName", manufacturerName)
					.getResultList();
			
			if(null == manufactureResults || manufactureResults.size() == 0){
				return null;
			}else{
				return manufactureResults.get(0);
			}
		}

		return null;
	}
	
}
