package com.ibm.asset.trails.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.AlertUnlicensedSoftwareDAO;
import com.ibm.asset.trails.dao.ReconLicenseDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.AlertUnlicensedSwH;
import com.ibm.asset.trails.domain.AllocationMethodology;
import com.ibm.asset.trails.domain.InstalledSoftware;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.Recon;
import com.ibm.asset.trails.domain.ReconInstalledSoftware;
import com.ibm.asset.trails.domain.ReconLicense;
import com.ibm.asset.trails.domain.Reconcile;
import com.ibm.asset.trails.domain.ReconcileH;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.UsedLicense;
import com.ibm.asset.trails.domain.UsedLicenseHistory;
import com.ibm.asset.trails.service.AllocationMethodologyService;
import com.ibm.asset.trails.service.ReconService;

@Service
public class ReconServiceImpl implements ReconService {
	// TODO need to make sure I update alert history
	private static final Log log = LogFactory.getLog(ReconServiceImpl.class);

	private EntityManager em;

	// AB added, flag used for export the validate result to reconWorkspaceImpl
	// Story 26012
	private List<String> ScheduleFDefInRecon;
	
	@Autowired
	private ReconLicenseDAO reconLicenseDAO;

	public List<String> getScheduleFDefInRecon() {
		return ScheduleFDefInRecon;
	}

	public void setScheduleFDefInRecon(String result) {
		if (result != null) {
			if (ScheduleFDefInRecon == null || ScheduleFDefInRecon.isEmpty()) {
				ScheduleFDefInRecon = new ArrayList<String>();
				ScheduleFDefInRecon.add(result);
			} else {
				if (!ScheduleFDefInRecon.contains(result)) {
					ScheduleFDefInRecon.add(result);
				}
			}
		} else {
			ScheduleFDefInRecon = null;
		}

	}

	@Autowired
	private AllocationMethodologyService allocationMethodologyService;

	@PersistenceContext(unitName = "trailspd")
	public void setEntityManager(EntityManager em) {
		this.em = em;
	}

	private EntityManager getEntityManager() {
		return em;
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public AlertUnlicensedSw breakReconcileByAlert(Long alertId,
			Account account, String remoteUser, Set<UsedLicenseHistory> usedLicHis) {
		AlertUnlicensedSw alert = findAlertById(alertId);
		Reconcile reconcile = findReconcile(alert);
		clearUsedLicenses(reconcile, remoteUser);
		ReconcileH reconcileH = findReconcileHistory(alert);
		breakReconcileHistory(reconcile, reconcileH, alert, remoteUser, usedLicHis);
		createAlertHistory(alert);
		alert = openAlert(alert);
		breakReconcile(alert.getReconcile(), account, remoteUser);
		return alert;
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void reconcileByAlert(Long alertId,
			InstalledSoftware parentInstalledSoftware, Recon reconRequest,
			String remoteUser, String comments, Account account) {
		AlertUnlicensedSw alert = findAlertById(alertId);
		boolean bReconcileValidation = reconcileValidate(alert);
		if (bReconcileValidation) {
			Reconcile reconcile = findReconcile(alert);
			clearUsedLicenses(reconcile, remoteUser);
			ReconcileH reconcileH = findReconcileHistory(alert);
			clearUsedLicenseHistories(reconcileH);
			reconcile = updateReconcile(reconRequest, reconcile, alert,
					remoteUser, new HashSet<UsedLicense>());
			reconcileH = updateReconcileH(reconcile, reconcileH, alert,
					new HashSet<UsedLicenseHistory>());
			alert.setReconcile(reconcile);
			alert.setReconcileH(reconcileH);
			closeAlert(alert);
		}
	}

	private boolean reconcileValidate(AlertUnlicensedSw alert) {
		String hwStatus = alert.getInstalledSoftware().getSoftwareLpar()
				.getHardwareLpar().getHardware().getHardwareStatus();
		String lparStatus = alert.getInstalledSoftware().getSoftwareLpar()
				.getHardwareLpar().getLparStatus();
		if (hwStatus.equalsIgnoreCase("ACTIVE")) {
			if (lparStatus.equalsIgnoreCase("ACTIVE")
					|| lparStatus.equalsIgnoreCase("INACTIVE")
					|| lparStatus.equalsIgnoreCase(null)) {
				return true;
			}
		}
		return false;
	}

	private boolean reconcileValidate(AlertUnlicensedSw alert, Recon lrecon,
			int totalUsedlicenses) {
		String hwStatus = alert.getInstalledSoftware().getSoftwareLpar()
				.getHardwareLpar().getHardware().getHardwareStatus();
		String lparStatus = alert.getInstalledSoftware().getSoftwareLpar()
				.getHardwareLpar().getLparStatus();
		if (hwStatus.equalsIgnoreCase("ACTIVE")) {
			if (lparStatus.equalsIgnoreCase("ACTIVE")
					|| lparStatus.equalsIgnoreCase("INACTIVE")
					|| lparStatus.equalsIgnoreCase(null)) {

				if (lrecon.getPer().equalsIgnoreCase("HWGARTMIPS")
						&& totalUsedlicenses < Integer.valueOf(alert
								.getInstalledSoftware().getSoftwareLpar()
								.getHardwareLpar().getHardware()
								.getCpuGartnerMips().intValue())) {
					return false;
				}
				if (lrecon.getPer().equalsIgnoreCase("LPARGARTMIPS")
						&& totalUsedlicenses < Integer.valueOf(alert
								.getInstalledSoftware().getSoftwareLpar()
								.getHardwareLpar().getPartGartnerMips()
								.intValue())) {
					return false;
				}
				if (lrecon.getPer().equalsIgnoreCase("HWLSPRMIPS")
						&& totalUsedlicenses < Integer.valueOf(alert
								.getInstalledSoftware().getSoftwareLpar()
								.getHardwareLpar().getHardware()
								.getCpuLsprMips().intValue())) {
					return false;
				}
				if (lrecon.getPer().equalsIgnoreCase("LPARLSPRMIPS")
						&& totalUsedlicenses < Integer
								.valueOf(alert.getInstalledSoftware()
										.getSoftwareLpar().getHardwareLpar()
										.getPartLsprMips().intValue())) {
					return false;
				}
				if (lrecon.getPer().equalsIgnoreCase("HWMSU")
						&& totalUsedlicenses < Integer.valueOf(alert
								.getInstalledSoftware().getSoftwareLpar()
								.getHardwareLpar().getHardware().getCpuMsu()
								.intValue())) {
					return false;
				}
				if (lrecon.getPer().equalsIgnoreCase("LPARMSU")
						&& totalUsedlicenses < Integer.valueOf(alert
								.getInstalledSoftware().getSoftwareLpar()
								.getHardwareLpar().getPartMsu().intValue())) {
					return false;
				}
				return true;
			}
		}
		return false;
	}

	// AB added2
	public int validateScheduleFowner(AlertUnlicensedSw alert, Recon recon) {
		ScheduleF scheduleF = getScheduleFItem(alert.getInstalledSoftware()
				.getSoftwareLpar().getAccount(), alert.getInstalledSoftware()
				.getSoftware().getSoftwareName(), alert.getInstalledSoftware()
				.getSoftwareLpar().getName(), alert.getInstalledSoftware()
				.getSoftwareLpar().getHardwareLpar().getHardware().getOwner(),
				alert.getInstalledSoftware().getSoftwareLpar()
						.getHardwareLpar().getHardware().getMachineType()
						.getName(), alert.getInstalledSoftware()
						.getSoftwareLpar().getHardwareLpar().getHardware()
						.getSerial(),alert.getInstalledSoftware().getSoftware()
						.getManufacturerId().getManufacturerName());
		int owner = 2;
		if (scheduleF != null) {
			String[] scDesParts = scheduleF.getScope().getDescription()
					.split(",");

			// AB added2
			/**
			 * manualAllocation, reconType=1, Schedule F scope must be xxxIBM
			 * Managed customerOwned, reconType=2, Schedule F scope must be
			 * Customer owned Customer managed. altPurchase, reconType=3,
			 * Schedule F scope must be xxxIBM Managed Included, reconType=4,
			 * Schedule F scope must be xxxIBM Managed enterpriseAgreement,
			 * reconType=13, Schedule F scope must be IBM Ownedxxx
			 */
			int reconType = recon.getReconcileType().getId().intValue();
			if (reconType != 0) {
				if (reconType == 1 || reconType == 3 || reconType == 4) {
					if (!scDesParts[1].contains("IBM managed")) {
						return owner;
					}
				} else if (reconType == 2) {
					if (!scDesParts[0].contains("Customer owned")
							|| !scDesParts[1].contains("Customer managed")) {
						return owner;
					}
				} else if (reconType == 13) {
					if (!scDesParts[0].contains("IBM owned")) {
						return owner;
					}
				}
			}

			if (scDesParts[0].contains("IBM owned")) {
				owner = 1;
			} else if (scDesParts[0].contains("Customer owned")) {
				owner = 0;
			}
		}
		return owner;
	}

	// User Story - 17236 - Manual License Allocation at HW level can
	// automatically close Alerts on another account on the same Shared HW as
	// requested by users Start
	// This method is used to judge if alert is a cross account alert or not
	private boolean isCrossAccountAlert(Account alertExistedAccount,
			Account currentWorkingAccount) {
		boolean crossAccountAlertFlag = false;
		if (alertExistedAccount != null
				&& currentWorkingAccount != null
				&& alertExistedAccount.getAccount().intValue() != currentWorkingAccount
						.getAccount().intValue()) {
			crossAccountAlertFlag = true;
		}
		return crossAccountAlertFlag;
	}

	// This method is used to judge if there is one validate schdeduleF record
	// defined for current working alert and cross account alert
	// 1. SCHEDULE_F.SCOPE_ID = 3(IBM owned, IBM managed)
	// 2. SCHEDULE_F.LEVEL != 'HOSTNAME'(The value can be
	// 'HWBOX','HWOWNER','PRODUCT')
	private boolean validateScheduleF4WorkingAlertAndCrossAccountAlert(
			AlertUnlicensedSw workingAlert, AlertUnlicensedSw relatedAlert) {
		boolean validateScheduleF4WorkingAlertAndCrossAccountAlertFlag = false;

		ScheduleF scheduleF4WorkingAlert = getScheduleFItem(workingAlert
				.getInstalledSoftware().getSoftwareLpar().getAccount(),
				workingAlert.getInstalledSoftware().getSoftware()
						.getSoftwareName(), workingAlert.getInstalledSoftware()
						.getSoftwareLpar().getName(), workingAlert
						.getInstalledSoftware().getSoftwareLpar()
						.getHardwareLpar().getHardware().getOwner(),
				workingAlert.getInstalledSoftware().getSoftwareLpar()
						.getHardwareLpar().getHardware().getMachineType()
						.getName(), workingAlert.getInstalledSoftware()
						.getSoftwareLpar().getHardwareLpar().getHardware()
						.getSerial(), 
				workingAlert.getInstalledSoftware().getSoftware()
						.getManufacturerId()
						.getManufacturerName());

		ScheduleF scheduleF4RelatedAlert = getScheduleFItem(relatedAlert
				.getInstalledSoftware().getSoftwareLpar().getAccount(),
				relatedAlert.getInstalledSoftware().getSoftware()
						.getSoftwareName(), relatedAlert.getInstalledSoftware()
						.getSoftwareLpar().getName(), relatedAlert
						.getInstalledSoftware().getSoftwareLpar()
						.getHardwareLpar().getHardware().getOwner(),
				relatedAlert.getInstalledSoftware().getSoftwareLpar()
						.getHardwareLpar().getHardware().getMachineType()
						.getName(), relatedAlert.getInstalledSoftware()
						.getSoftwareLpar().getHardwareLpar().getHardware()
						.getSerial(),
				relatedAlert.getInstalledSoftware().getSoftware()
						.getManufacturerId()
						.getManufacturerName());

		if (scheduleF4WorkingAlert != null && scheduleF4RelatedAlert != null) {
			Long scopeId4WorkingAlert = scheduleF4WorkingAlert.getScope()
					.getId();
			Long scopeId4RelatedAlert = scheduleF4RelatedAlert.getScope()
					.getId();

			if (scopeId4WorkingAlert.intValue() == 3// Working Alert Scope must
													// be IBM owned, IBM managed
					&& scheduleF4WorkingAlert.getLevel() != null
					&& !scheduleF4WorkingAlert.getLevel().trim()
							.equals("HOSTNAME")// Working Alert Level must be
												// great than "HOSTNAME"(The
												// value can be
												// 'HWBOX','HWOWNER','PRODUCT')
					&& scopeId4RelatedAlert.intValue() == 3// Cross Account
															// Alert Scope must
															// be IBM owned, IBM
															// managed
					&& scheduleF4RelatedAlert.getLevel() != null
					&& !scheduleF4RelatedAlert.getLevel().trim()
							.equals("HOSTNAME")// Cross Account Alert Level must
												// be great than "HOSTNAME"(The
												// value can be
												// 'HWBOX','HWOWNER','PRODUCT')
			) {
				validateScheduleF4WorkingAlertAndCrossAccountAlertFlag = true;
			}
		}

		return validateScheduleF4WorkingAlertAndCrossAccountAlertFlag;
	}

	// User Story - 17236 - Manual License Allocation at HW level can
	// automatically close Alerts on another account on the same Shared HW as
	// requested by users End

	private ScheduleF getScheduleFItem(Account account, String swname,
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
							" from ScheduleF a where a.status.description='ACTIVE' and a.account =:account and a.manufacturerName =:manufacturerName")
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

	private void closeAlert(AlertUnlicensedSw alert) {
		if (alert.isOpen()) {
			createAlertHistory(alert);
			alert.setOpen(false);
			alert.setRecordTime(new Date());
			alert.setComments("Manual Close");
			getEntityManager().merge(alert);
		}
	}

	private Reconcile updateReconcile(Recon reconRequest, Reconcile reconcile,
			AlertUnlicensedSw alert, String remoteUser,
			Set<UsedLicense> usedLics) {
		if (reconRequest.getInstalledSoftware() == null) {
			reconcile.setParentInstalledSoftware(alert.getInstalledSoftware());
		} else {
			reconcile.setParentInstalledSoftware(reconRequest
					.getInstalledSoftware());
		}
		reconcile.setComments(reconRequest.getComments());
		reconcile.setInstalledSoftware(alert.getInstalledSoftware());
		reconcile.setMachineLevel(0);
		reconcile.setReconcileType(reconRequest.getReconcileType());
		reconcile.setRecordTime(new Date());
		reconcile.setRemoteUser(remoteUser);
		reconcile.setUsedLicenses(usedLics);
		if (reconRequest.getPer() != null) {
			AllocationMethodology allocationMethodology = allocationMethodologyService
					.findByCode(reconRequest.getPer().toUpperCase());
			reconcile.setAllocationMethodology(allocationMethodology);
		}
		return getEntityManager().merge(reconcile);
	}

	private ReconcileH updateReconcileH(Reconcile reconcile,
			ReconcileH reconcileH, AlertUnlicensedSw alert,
			Set<UsedLicenseHistory> usedLicHis) {
		reconcileH.setComments(reconcile.getComments());
		reconcileH.setInstalledSoftware(alert.getInstalledSoftware());
		reconcileH.setMachineLevel(reconcile.getMachineLevel());
		reconcileH.setManualBreak(false);
		reconcileH.setParentInstalledSoftware(reconcile
				.getParentInstalledSoftware());
		reconcileH.setReconcileType(reconcile.getReconcileType());
		reconcileH.setRecordTime(reconcile.getRecordTime());
		reconcileH.setRemoteUser(reconcile.getRemoteUser());
		reconcileH.setUsedLicenses(usedLicHis);
		reconcileH.setAllocationMethodology(reconcile
				.getAllocationMethodology());
		return getEntityManager().merge(reconcileH);
	}

	private void clearUsedLicenseHistories(ReconcileH reconcileH) {
		Set<UsedLicenseHistory> usedLics = reconcileH.getUsedLicenses();
		for (UsedLicenseHistory ul : usedLics) {
			removeUsedLicenseHistoryReconcileHistory(ul, reconcileH);
		}
	}

	private void removeUsedLicenseHistoryReconcileHistory(
			UsedLicenseHistory ul, ReconcileH reconcileH) {
		ul.getReconciles().remove(reconcileH);
		if (ul.getReconciles().size() == 0) {
			getEntityManager().remove(ul);
		}
	}

	private ReconcileH findReconcileHistory(AlertUnlicensedSw alert) {
		ReconcileH rh;
		if (alert.getReconcileH() == null) {
			rh = new ReconcileH();
		} else {
			rh = alert.getReconcileH();
		}
		return rh;
	}

	private AlertUnlicensedSw findAlertById(Long alertId) {
		return getEntityManager().find(AlertUnlicensedSw.class, alertId);
	}

	private Reconcile findReconcile(AlertUnlicensedSw alert) {
		Reconcile reconcile;
		if (alert.getReconcile() == null) {
			reconcile = new Reconcile();
		} else {
			reconcile = alert.getReconcile();
		}
		return reconcile;
	}

	private void breakReconcile(Reconcile reconcile, Account account,
			String remoteUser) {
		InstalledSoftware is = reconcile.getInstalledSoftware();
		clearUsedLicenses(reconcile, remoteUser);
		addToQueue(is, account, remoteUser);
		getEntityManager().remove(reconcile);
	}

	private void clearUsedLicenses(Reconcile reconcile, String remoteUser) {
		Set<UsedLicense> usedLics = reconcile.getUsedLicenses();
		for (UsedLicense ul : usedLics) {
			License license = ul.getLicense();
			addToQueue(license, remoteUser);
			removeUsedLicenseReconcile(ul, reconcile);
		}
	}

	private void clearUsedLicenses(Set<UsedLicense> usedLicenses,
			Set<UsedLicenseHistory> usedLicenseHistories, String remoteUser) {
		for (UsedLicense ul : usedLicenses) {
			getEntityManager().remove(ul);

		}
		for (UsedLicenseHistory ulh : usedLicenseHistories) {
			getEntityManager().remove(ulh);

		}
	}

	private void removeUsedLicenseReconcile(UsedLicense ul, Reconcile reconcile) {
		ul.getReconciles().remove(reconcile);
		if (ul.getReconciles().size() == 0) {
			getEntityManager().remove(ul);
		}
	}

	private void addToQueue(License license, String remoteUser) {
		ReconLicense queue = reconLicenseDAO.getExistingReconLicense(license.getId());
		if (queue == null) {
			queue = new ReconLicense();
			queue.setAccount(license.getAccount());
			queue.setAction("UPDATE");
			queue.setLicense(license);
			queue.setRecordTime(new Date());
			queue.setRemoteUser(remoteUser);
			getEntityManager().persist(queue);
		}
	}

	private void addToQueue(InstalledSoftware instSw, Account account,
			String remoteUser) {
		ReconInstalledSoftware queue = findQueueByInstalledSoftwareId(instSw
				.getId());
		if (queue == null) {
			queue = new ReconInstalledSoftware();
			queue.setAccount(account);
			queue.setAction("UPDATE");
			queue.setInstalledSoftware(instSw);
			queue.setRecordTime(new Date());
			queue.setRemoteUser(remoteUser);
			getEntityManager().persist(queue);
		}
	}

	private ReconInstalledSoftware findQueueByInstalledSoftwareId(Long id) {
	@SuppressWarnings("unchecked")
		List<ReconInstalledSoftware> results = getEntityManager()
				.createQuery(
						"from ReconInstalledSoftware a where a.installedSoftware.id = :instSwId")
				.setParameter("instSwId", id).getResultList();
		ReconInstalledSoftware result;
		if (results == null || results.isEmpty()) {
			result = null;
		} else {
			result = results.get(0);
		}
		return result;
	}

	private AlertUnlicensedSw openAlert(AlertUnlicensedSw alert) {
		alert.setRecordTime(new Date());
		alert.setCreationTime(new Date());
		alert.setOpen(true);
		alert.setComments("Manual Open");
		return getEntityManager().merge(alert);
	}

	private ReconcileH breakReconcileHistory(Reconcile reconcile,
			ReconcileH reconcileH, AlertUnlicensedSw alert, String remoteUser,
			Set<UsedLicenseHistory> usedLicenseHistorieSet) {
		reconcileH.setComments(reconcile.getComments());
		reconcileH.setInstalledSoftware(alert.getInstalledSoftware());
		reconcileH.setMachineLevel(reconcile.getMachineLevel());
		reconcileH.setManualBreak(true);
		reconcileH.setParentInstalledSoftware(reconcile
				.getParentInstalledSoftware());
		reconcileH.setReconcileType(reconcile.getReconcileType());
		reconcileH.setRecordTime(new Date());
		reconcileH.setRemoteUser(remoteUser);
		reconcileH.setAllocationMethodology(reconcile
				.getAllocationMethodology());
		reconcileH.setUsedLicenses(usedLicenseHistorieSet);
		return getEntityManager().merge(reconcileH);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public Long manualReconcileByAlert(Long alertId,
			InstalledSoftware parentInstalledSoftware, Recon pRecon,
			String remoteUser, String comments, Account account,
			Map<License, Integer> appliedLicenseQtyMap, String psMethod, int owner) {
		AlertUnlicensedSw selectedAlert = getEntityManager().find(
				AlertUnlicensedSw.class, alertId);
		List<AlertUnlicensedSw> affectedAlertList = new ArrayList<AlertUnlicensedSw>();
		Reconcile reconcile = null;
		Iterator<Entry<License, Integer>> liLicenseApplied = null;
		Entry<License, Integer> leTemp = null;

		liLicenseApplied = appliedLicenseQtyMap.entrySet().iterator();

		while (liLicenseApplied.hasNext()) {
			leTemp = liLicenseApplied.next();
			if (leTemp.getValue().intValue() == 0) {
				log.error("ERROR: Attempting to insert a 0 quantity LicenseReconMap for method "
						+ psMethod);
				log.error(selectedAlert);
				log.error(appliedLicenseQtyMap);
				return null;
			}
		}

		if (isAllocateByHardware(pRecon)) {
			affectedAlertList.addAll(findAffectedAlertList(account,
					selectedAlert.getInstalledSoftware().getSoftware()
							.getSoftwareId(), selectedAlert
							.getInstalledSoftware().getSoftwareLpar()
							.getHardwareLpar().getHardware().getId(),
					pRecon.isAutomated(), pRecon.isManual()));
		} else {
			affectedAlertList.add(selectedAlert);
		}

		liLicenseApplied = appliedLicenseQtyMap.entrySet().iterator();
		Set<UsedLicense> usedLicenseSet = new HashSet<UsedLicense>();
		Set<UsedLicenseHistory> usedLicenseHistorieSet = new HashSet<UsedLicenseHistory>();
		int totalUsedLicenses = 0;
		while (affectedAlertList.size() != 0 && liLicenseApplied.hasNext()) {
			leTemp = liLicenseApplied.next();

			UsedLicense ul = new UsedLicense();
			ul.setLicense(leTemp.getKey());
			ul.setUsedQuantity(leTemp.getValue());
			ul.setCapacityType(leTemp.getKey().getCapacityType());
			getEntityManager().persist(ul);
			usedLicenseSet.add(ul);
			totalUsedLicenses += ul.getUsedQuantity();

			UsedLicenseHistory ulh = new UsedLicenseHistory();
			ulh.setLicense(leTemp.getKey());
			ulh.setUsedQuantity(leTemp.getValue());
			ulh.setCapacityType(leTemp.getKey().getCapacityType());
			getEntityManager().persist(ulh);
			usedLicenseHistorieSet.add(ulh);
		}

		// Story 26012
		int alertWithoutScheduleFcounter = 0;
		int hasInvalidAlertcount = 0;
		for (AlertUnlicensedSw affectedAlert : affectedAlertList) {
			boolean bReconcileValidation = reconcileValidate(affectedAlert,
					pRecon, totalUsedLicenses);

			// User Story - 17236 - Manual License Allocation at HW level
			// can automatically close Alerts on another account on the same
			// Shared HW as requested by users Start
			int alertlistSwOwner = -1;// default init value
			boolean validateScheduleF4WorkingAlertAndCrossAccountAlertFlag = false;// default
																					// init
																					// value
			boolean crossAccountAlertFlag = isCrossAccountAlert(affectedAlert
					.getInstalledSoftware().getSoftwareLpar().getAccount(),
					account);
			if (crossAccountAlertFlag == false) {// same account alert

				// AB added
				alertlistSwOwner = validateScheduleFowner(affectedAlert, pRecon);
				// this only used to export the schedule F defined flag to
				// ReconWorkspaceImpl
				if (alertlistSwOwner == 2) {
					alertWithoutScheduleFcounter++;
				}

			} else {// cross account alert
				validateScheduleF4WorkingAlertAndCrossAccountAlertFlag = validateScheduleF4WorkingAlertAndCrossAccountAlert(
						selectedAlert, affectedAlert);
			}

			if ((crossAccountAlertFlag == false && alertlistSwOwner == owner && owner != 2)
					|| (crossAccountAlertFlag == true && validateScheduleF4WorkingAlertAndCrossAccountAlertFlag == true)) {

				if (!bReconcileValidation) {
					hasInvalidAlertcount++;
					continue;
				}
				if (affectedAlert.isOpen()) {
					reconcile = createReconcile(
							affectedAlert.getInstalledSoftware(),
							affectedAlert.getInstalledSoftware(), pRecon,
							remoteUser, comments, usedLicenseSet,
							usedLicenseHistorieSet);

					AlertUnlicensedSwH aush = createAlertHistory(affectedAlert);
					aush.setAlertUnlicensedSw(affectedAlert);

					// Close the alert
					affectedAlert.setOpen(false);
					affectedAlert.setComments("Manual Close");
					affectedAlert.setRecordTime(new Date());
					aush = getEntityManager().merge(aush);
				} else {
					reconcile = affectedAlert.getReconcile();
					reconcile.setParentInstalledSoftware(reconcile
							.getParentInstalledSoftware());
					reconcile.setReconcileType(pRecon.getReconcileType());
					reconcile.setRecordTime(new Date());
					reconcile.setRemoteUser(remoteUser);
					reconcile.setComments(comments);
					reconcile.setMachineLevel(new Integer(
							isAllocateByHardware(pRecon) ? 1 : 0));
					if (pRecon.getPer() != null) {
						AllocationMethodology allocationMethodology = allocationMethodologyService
								.findByCode(pRecon.getPer().toUpperCase());
						reconcile
								.setAllocationMethodology(allocationMethodology);
					}

					log.debug("Clearing licenses");
					clearUsedLicenses(reconcile, remoteUser);
					reconcile.setUsedLicenses(usedLicenseSet);
					log.debug("Saving reconcile");
					reconcile = getEntityManager().merge(reconcile);
					createReconcileHistory(reconcile, usedLicenseHistorieSet);
				}
			}
		}// end of for
		
		if (hasInvalidAlertcount == affectedAlertList.size()){
			clearUsedLicenses(usedLicenseSet, usedLicenseHistorieSet,
					remoteUser);
		}

		// Story 26012
		if (alertWithoutScheduleFcounter == affectedAlertList.size()) {
			setScheduleFDefInRecon("Schedule F not defined");
		} else if (alertWithoutScheduleFcounter > 0
				&& alertWithoutScheduleFcounter < affectedAlertList.size()) {
			setScheduleFDefInRecon("Schedule F not defined for all alerts");
		}

		return selectedAlert.getInstalledSoftware().getSoftwareLpar()
				.getHardwareLpar().getHardware().getId();

	}

	public boolean isAllocateByHardware(Recon pRecon) {
		return pRecon.getPer().equalsIgnoreCase("HWDEVICE")
				|| pRecon.getPer().equalsIgnoreCase("HWPROCESSOR")
				|| pRecon.getPer().equalsIgnoreCase("PVU")
				|| pRecon.getPer().equalsIgnoreCase("CHIP")
				|| pRecon.getPer().equalsIgnoreCase("HWGARTMIPS")
				|| pRecon.getPer().equalsIgnoreCase("HWLSPRMIPS")
				|| pRecon.getPer().equalsIgnoreCase("HWMSU");
	}

	private Reconcile createReconcile(InstalledSoftware installedSoftware,
			InstalledSoftware parentInstalledSoftware, Recon pRecon,
			String remoteUser, String comments, Set<UsedLicense> usedLicenses,
			Set<UsedLicenseHistory> usedLicenseHistories) {
		if (parentInstalledSoftware == null) {
			parentInstalledSoftware = installedSoftware;
		}

		log.debug("Creating a new reconcile object");

		Reconcile reconcile = new Reconcile();
		reconcile.setInstalledSoftware(installedSoftware);
		reconcile.setParentInstalledSoftware(parentInstalledSoftware);
		reconcile.setReconcileType(pRecon.getReconcileType());
		reconcile.setComments(comments);
		reconcile.setRecordTime(new Date());
		reconcile.setRemoteUser(remoteUser);
		reconcile.setMachineLevel(new Integer(pRecon.getPer() != null
				&& isAllocateByHardware(pRecon) ? 1 : 0));

		reconcile.setUsedLicenses(usedLicenses);
		if (pRecon.getPer() != null) {
			AllocationMethodology allocationMethodology = allocationMethodologyService
					.findByCode(pRecon.getPer().toUpperCase());
			reconcile.setAllocationMethodology(allocationMethodology);
		}
		log.debug("Calling save");
		reconcile = getEntityManager().merge(reconcile);
		createReconcileHistory(reconcile, usedLicenseHistories);

		log.debug("Reconcile created");
		return reconcile;
	}

	private void createReconcileHistory(Reconcile reconcile,
			Set<UsedLicenseHistory> usedLicenseHistories) {

		ReconcileH reconcileH = null;

		log.debug("Checking if reconcileH exists");
		@SuppressWarnings("unchecked")
		List<ReconcileH> results = getEntityManager()
				.createQuery(
						"from ReconcileH a where a.installedSoftware = :installedSoftware")
				.setParameter("installedSoftware",
						reconcile.getInstalledSoftware()).getResultList();
		if (results == null || results.isEmpty()) {
			reconcileH = new ReconcileH();
			reconcileH.setInstalledSoftware(reconcile.getInstalledSoftware());
			reconcileH.setParentInstalledSoftware(reconcile
					.getParentInstalledSoftware());
			reconcileH.setReconcileType(reconcile.getReconcileType());
			reconcileH.setRecordTime(new Date());
			reconcileH.setRemoteUser(reconcile.getRemoteUser());
			reconcileH.setMachineLevel(reconcile.getMachineLevel());
			reconcileH.setComments(reconcile.getComments());
			reconcileH.setAllocationMethodology(reconcile
					.getAllocationMethodology());
			reconcileH.setUsedLicenses(usedLicenseHistories);
		} else {
			reconcileH = results.get(0);
			reconcileH.setParentInstalledSoftware(reconcile
					.getParentInstalledSoftware());
			reconcileH.setReconcileType(reconcile.getReconcileType());
			reconcileH.setRecordTime(new Date());
			reconcileH.setManualBreak(false);
			reconcileH.setRemoteUser(reconcile.getRemoteUser());
			reconcileH.setMachineLevel(reconcile.getMachineLevel());
			reconcileH.setComments(reconcile.getComments());
			reconcileH.setAllocationMethodology(reconcile
					.getAllocationMethodology());

			log.debug("Clearing license recon maps");
			reconcileH.setUsedLicenses(usedLicenseHistories);
		}

		log.debug("Calling saveReconcileHistory");
		reconcileH = getEntityManager().merge(reconcileH);
	}

	private AlertUnlicensedSwH createAlertHistory(AlertUnlicensedSw alert) {
		AlertUnlicensedSwH aush = new AlertUnlicensedSwH();
		aush.setComments(alert.getComments());
		aush.setType(alert.getType());
		aush.setCreationTime(alert.getCreationTime());
		aush.setOpen(alert.isOpen());
		aush.setRecordTime(alert.getRecordTime());
		aush.setRemoteUser(alert.getRemoteUser());
		aush.setAlertUnlicensedSw(alert);
		getEntityManager().persist(aush);
		return aush;
	}

	// For User Story 17236, change the logic of findAffectedAlertList method to
	// get the affected alert list
	// from account level to global cross account level for the same hardware
	// box
	@SuppressWarnings("unchecked")
	private List<AlertUnlicensedSw> findAffectedAlertList(Account pAccount,
			Long productInfoId, Long hardwareId, boolean isAuto,
			boolean isManual) {
		List<AlertUnlicensedSw> llAlertUnlicensedSw = new ArrayList<AlertUnlicensedSw>();
		StringBuffer lsbQuery = null;

		// This query will get all open alerts that meet our criteria, but
		// the
		// manual and automated variables do not come into play
		lsbQuery = new StringBuffer(
				"FROM AlertUnlicensedSw AUS WHERE AUS.open = 1 AND AUS.installedSoftware.softwareLpar.hardwareLpar.hardware.id = :hardwareID AND AUS.installedSoftware.software.softwareId = :productInfoId");
		log.debug(new StringBuffer("lsbQuery = ").append(lsbQuery));

		llAlertUnlicensedSw = getEntityManager()
				.createQuery(lsbQuery.toString())
				.setParameter("hardwareID", hardwareId)
				.setParameter("productInfoId", productInfoId).getResultList();
		log.debug(new StringBuffer("llAlertUnlicensedSw size: ")
				.append(llAlertUnlicensedSw.size()));

		if (isAuto) {
			Query lQuery = null;

			// This query will get all alerts that were reconciled automatically
			lsbQuery = new StringBuffer(
					"FROM AlertUnlicensedSw AUS JOIN FETCH AUS.reconcile WHERE AUS.reconcile.reconcileType.manual = 0 AND AUS.installedSoftware.software.softwareId = :productInfoId AND AUS.installedSoftware.softwareLpar.hardwareLpar.hardware.id = :hardwareID");

			log.debug(new StringBuffer("lsbQuery = ").append(lsbQuery));

			lQuery = getEntityManager().createQuery(lsbQuery.toString())
					.setParameter("productInfoId", productInfoId)
					.setParameter("hardwareID", hardwareId);

			llAlertUnlicensedSw.addAll(lQuery.getResultList());
			log.debug(new StringBuffer("llAlertUnlicensedSw size: ")
					.append(llAlertUnlicensedSw.size()));
		}

		if (isManual) {
			Query lQuery = null;

			// This query will get all alerts that were reconciled manually
			lsbQuery = new StringBuffer(
					"FROM AlertUnlicensedSw AUS JOIN FETCH AUS.reconcile WHERE AUS.reconcile.reconcileType.manual = 1 AND AUS.installedSoftware.software.softwareId = :productInfoId AND AUS.installedSoftware.softwareLpar.hardwareLpar.hardware.id = :hardwareID");

			log.debug(new StringBuffer("lsbQuery = ").append(lsbQuery));

			lQuery = getEntityManager().createQuery(lsbQuery.toString())
					.setParameter("productInfoId", productInfoId)
					.setParameter("hardwareID", hardwareId);

			llAlertUnlicensedSw.addAll(lQuery.getResultList());
			log.debug(new StringBuffer("llAlertUnlicensedSw size: ")
					.append(llAlertUnlicensedSw.size()));
		}

		return llAlertUnlicensedSw;
	}
	// User Story - 17236 - Manual License Allocation at HW level can
	// automatically close Alerts on another account on the same Shared HW as
	// requested by users End
}
