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
			Account account, String remoteUser) {
		AlertUnlicensedSw alert = findAlertById(alertId);
		Reconcile reconcile = findReconcile(alert);
		clearUsedLicenses(reconcile, remoteUser);
		ReconcileH reconcileH = findReconcileHistory(alert);
		breakReconcileHistory(reconcile, reconcileH, alert, remoteUser);
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

	public int validateScheduleFowner(AlertUnlicensedSw alert) {
		ScheduleF scheduleF = getScheduleFItem(alert.getInstalledSoftware()
				.getSoftwareLpar().getAccount(), alert.getInstalledSoftware()
				.getSoftware().getSoftwareName(), alert.getInstalledSoftware()
				.getSoftwareLpar().getName(), alert.getInstalledSoftware()
				.getSoftwareLpar().getHardwareLpar().getHardware().getOwner(),
				alert.getInstalledSoftware().getSoftwareLpar()
						.getHardwareLpar().getHardware().getMachineType()
						.getName(), alert.getInstalledSoftware()
						.getSoftwareLpar().getHardwareLpar().getHardware()
						.getSerial());
		int owner = 2;
		if (scheduleF != null) {
			String[] scDesParts = scheduleF.getScope().getDescription()
					.split(",");

			if (scDesParts[0].contains("IBM owned")) {
				owner = 1;
			} else if (scDesParts[0].contains("Customer owned")) {
				owner = 0;
			}
		}
		return owner;
	}

	private ScheduleF getScheduleFItem(Account account, String swname,
			String hostName, String hwOwner, String machineType, String serial) {
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createQuery(
						" from ScheduleF a where a.status.description='ACTIVE' and a.account =:account and a.softwareName =:swname")
				.setParameter("account", account)
				.setParameter("swname", swname).getResultList();

		ScheduleF result = null;
		if (results == null || results.isEmpty()) {
			return result;
		}

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
			} else {
				proudctLevel.add(sf);
			}
		}

		for (ScheduleF sf : hostNameLevel) {
			if (sf.getHostname().equals(hostName)) {
				return sf;
			}
		}

		for (ScheduleF sf : hwboxLevel) {
			if (sf.getSerial().equals(serial)
					&& sf.getMachineType().equals(machineType)) {
				return sf;
			}
		}

		for (ScheduleF sf : hwOwnerLevel) {
			if (sf.getHwOwner().equals(hwOwner)) {
				return sf;
			}
		}

		for (ScheduleF sf : proudctLevel) {
			if (sf.getSoftwareName().equals(swname)) {
				return sf;
			}
		}

		return result;
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
		ReconLicense queue = findQueueByLicenseId(license.getId());
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

	private ReconLicense findQueueByLicenseId(Long id) {
		@SuppressWarnings("unchecked")
		List<ReconLicense> results = getEntityManager()
				.createQuery(
						"from ReconLicense a where a.license.id = :licenseId")
				.setParameter("licenseId", id).getResultList();
		ReconLicense result;
		if (results == null || results.isEmpty()) {
			result = null;
		} else {
			result = results.get(0);
		}
		return result;
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
			ReconcileH reconcileH, AlertUnlicensedSw alert, String remoteUser) {
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
		return getEntityManager().merge(reconcileH);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public Long manualReconcileByAlert(Long alertId,
			InstalledSoftware parentInstalledSoftware, Recon pRecon,
			String remoteUser, String comments, Account account,
			Map<License, Integer> pmLicenseApplied, String psMethod, int owner) {
		AlertUnlicensedSw aus = getEntityManager().find(
				AlertUnlicensedSw.class, alertId);
		List<AlertUnlicensedSw> llAlertUnlicensedSw = new ArrayList<AlertUnlicensedSw>();
		Reconcile reconcile = null;
		Iterator<Entry<License, Integer>> liLicenseApplied = null;
		Entry<License, Integer> leTemp = null;
		boolean lbFoundZero = false;

		liLicenseApplied = pmLicenseApplied.entrySet().iterator();
		while (liLicenseApplied.hasNext()) {
			leTemp = liLicenseApplied.next();
			if (leTemp.getValue().intValue() == 0) {
				log.error("ERROR: Attempting to insert a 0 quantity LicenseReconMap for method "
						+ psMethod);
				log.error(aus);
				log.error(pmLicenseApplied);
				lbFoundZero = true;
				break;
			}
		}

		if (!lbFoundZero) {
			if (pRecon.getPer().equalsIgnoreCase("HWDEVICE")
					|| pRecon.getPer().equalsIgnoreCase("HWPROCESSOR")
					|| pRecon.getPer().equalsIgnoreCase("PVU")
					|| pRecon.getPer().equalsIgnoreCase("HWGARTMIPS")
					|| pRecon.getPer().equalsIgnoreCase("HWLSPRMIPS")
					|| pRecon.getPer().equalsIgnoreCase("HWMSU")) {
				llAlertUnlicensedSw.addAll(findAffectedAlertList(account, aus
						.getInstalledSoftware().getSoftware().getSoftwareId(), aus
						.getInstalledSoftware().getSoftwareLpar()
						.getHardwareLpar().getHardware().getId(),
						pRecon.isAutomated(), pRecon.isManual()));
			} else {
				llAlertUnlicensedSw.add(aus);
			}

			liLicenseApplied = pmLicenseApplied.entrySet().iterator();
			Set<UsedLicense> usedLicenses = new HashSet<UsedLicense>();
			Set<UsedLicenseHistory> usedLicenseHistories = new HashSet<UsedLicenseHistory>();
			int totalUsedLicenses = 0;
			while (liLicenseApplied.hasNext()) {
				leTemp = liLicenseApplied.next();

				UsedLicense ul = new UsedLicense();
				ul.setLicense(leTemp.getKey());
				ul.setUsedQuantity(leTemp.getValue());
				ul.setCapacityType(leTemp.getKey().getCapacityType());
				getEntityManager().persist(ul);
				usedLicenses.add(ul);
				totalUsedLicenses += ul.getUsedQuantity();

				UsedLicenseHistory ulh = new UsedLicenseHistory();
				ulh.setLicense(leTemp.getKey());
				ulh.setUsedQuantity(leTemp.getValue());
				ulh.setCapacityType(leTemp.getKey().getCapacityType());
				getEntityManager().persist(ulh);
				usedLicenseHistories.add(ulh);
			}

			for (AlertUnlicensedSw lausTemp : llAlertUnlicensedSw) {
				boolean bReconcileValidation = reconcileValidate(lausTemp,
						pRecon, totalUsedLicenses);
				int alertlistSwOwner = validateScheduleFowner(lausTemp);
				if (alertlistSwOwner == owner && owner != 2) {
					if (bReconcileValidation) {
						if (lausTemp.isOpen()) {
							reconcile = createReconcile(
									lausTemp.getInstalledSoftware(),
									lausTemp.getInstalledSoftware(), pRecon,
									remoteUser, comments, usedLicenses,
									usedLicenseHistories);

							AlertUnlicensedSwH aush = createAlertHistory(lausTemp);
							aush.setAlertUnlicensedSw(lausTemp);

							// Close the alert
							lausTemp.setOpen(false);
							lausTemp.setComments("Manual Close");
							lausTemp.setRecordTime(new Date());
							aush = getEntityManager().merge(aush);
						} else {
							reconcile = lausTemp.getReconcile();
							reconcile.setParentInstalledSoftware(reconcile
									.getParentInstalledSoftware());
							reconcile.setReconcileType(pRecon
									.getReconcileType());
							reconcile.setRecordTime(new Date());
							reconcile.setRemoteUser(remoteUser);
							reconcile.setComments(comments);
							reconcile
									.setMachineLevel(new Integer(
											pRecon.getPer().equalsIgnoreCase(
													"HWDEVICE")
													|| pRecon
															.getPer()
															.equalsIgnoreCase(
																	"HWPROCESSOR")
													|| pRecon.getPer()
															.equalsIgnoreCase(
																	"PVU")
													|| pRecon
															.getPer()
															.equalsIgnoreCase(
																	"HWGARTMIPS")
													|| pRecon
															.getPer()
															.equalsIgnoreCase(
																	"HWLSPRMIPS")
													|| pRecon.getPer()
															.equalsIgnoreCase(
																	"HWMSU") ? 1
													: 0));
							if (pRecon.getPer() != null) {
								AllocationMethodology allocationMethodology = allocationMethodologyService
										.findByCode(pRecon.getPer()
												.toUpperCase());
								reconcile
										.setAllocationMethodology(allocationMethodology);
							}

							log.debug("Clearing licenses");
							clearUsedLicenses(reconcile, remoteUser);
							reconcile.setUsedLicenses(usedLicenses);
							log.debug("Saving reconcile");
							reconcile = getEntityManager().merge(reconcile);
							createReconcileHistory(reconcile,
									usedLicenseHistories);
						}
					} else {
						clearUsedLicenses(usedLicenses, usedLicenseHistories,
								remoteUser);
					}
				}
			}

			return aus.getInstalledSoftware().getSoftwareLpar()
					.getHardwareLpar().getHardware().getId();
		} else {
			return null;
		}
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
		reconcile.setMachineLevel(new Integer(
				pRecon.getPer() != null
						&& (pRecon.getPer().equalsIgnoreCase("HWDEVICE")
								|| pRecon.getPer().equalsIgnoreCase(
										"HWPROCESSOR")
								|| pRecon.getPer().equalsIgnoreCase("PVU")
								|| pRecon.getPer().equalsIgnoreCase(
										"HWGARTMIPS")
								|| pRecon.getPer().equalsIgnoreCase(
										"HWLSPRMIPS") || pRecon.getPer()
								.equalsIgnoreCase("HWMSU")) ? 1 : 0));

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
		aush.setCreationTime(alert.getCreationTime());
		aush.setOpen(alert.isOpen());
		aush.setRecordTime(alert.getRecordTime());
		aush.setRemoteUser(alert.getRemoteUser());
		aush.setAlertUnlicensedSw(alert);
		getEntityManager().persist(aush);
		return aush;
	}

	@SuppressWarnings("unchecked")
	private List<AlertUnlicensedSw> findAffectedAlertList(Account pAccount,
			Long plProductInfoId, Long plHardwareID, boolean pbAutomated,
			boolean pbManual) {
		List<AlertUnlicensedSw> llAlertUnlicensedSw = new ArrayList<AlertUnlicensedSw>();
		StringBuffer lsbQuery = null;

		if (pAccount != null) {
			// This query will get all open alerts that meet our criteria, but
			// the
			// manual and automated variables do not come into play
			lsbQuery = new StringBuffer(
					"FROM AlertUnlicensedSw AUS WHERE AUS.open = 1 AND AUS.installedSoftware.softwareLpar.hardwareLpar.account = :account AND AUS.installedSoftware.softwareLpar.hardwareLpar.hardware.id = :hardwareID AND AUS.installedSoftware.software.softwareId = :productInfoId");
			log.debug(new StringBuffer("lsbQuery = ").append(lsbQuery));

			llAlertUnlicensedSw = getEntityManager()
					.createQuery(lsbQuery.toString())
					.setParameter("account", pAccount)
					.setParameter("hardwareID", plHardwareID)
					.setParameter("productInfoId", plProductInfoId)
					.getResultList();
			log.debug(new StringBuffer("llAlertUnlicensedSw size: ")
					.append(llAlertUnlicensedSw.size()));
		}

		if (pbAutomated) {
			Query lQuery = null;

			// This query will get all alerts that were reconciled automatically
			lsbQuery = new StringBuffer(
					"FROM AlertUnlicensedSw AUS JOIN FETCH AUS.reconcile WHERE AUS.reconcile.reconcileType.manual = 0 AND AUS.installedSoftware.software.softwareId = :productInfoId AND AUS.installedSoftware.softwareLpar.hardwareLpar.hardware.id = :hardwareID")
					.append(pAccount != null ? " AND AUS.installedSoftware.softwareLpar.hardwareLpar.account = :account"
							: "");
			log.debug(new StringBuffer("lsbQuery = ").append(lsbQuery));

			lQuery = getEntityManager().createQuery(lsbQuery.toString())
					.setParameter("productInfoId", plProductInfoId)
					.setParameter("hardwareID", plHardwareID);
			if (pAccount != null) {
				lQuery.setParameter("account", pAccount);
			}

			llAlertUnlicensedSw.addAll(lQuery.getResultList());
			log.debug(new StringBuffer("llAlertUnlicensedSw size: ")
					.append(llAlertUnlicensedSw.size()));
		}

		if (pbManual) {
			Query lQuery = null;

			// This query will get all alerts that were reconciled manually
			lsbQuery = new StringBuffer(
					"FROM AlertUnlicensedSw AUS JOIN FETCH AUS.reconcile WHERE AUS.reconcile.reconcileType.manual = 1 AND AUS.installedSoftware.software.softwareId = :productInfoId AND AUS.installedSoftware.softwareLpar.hardwareLpar.hardware.id = :hardwareID")
					.append(pAccount != null ? " AND AUS.installedSoftware.softwareLpar.hardwareLpar.account = :account"
							: "");
			log.debug(new StringBuffer("lsbQuery = ").append(lsbQuery));

			lQuery = getEntityManager().createQuery(lsbQuery.toString())
					.setParameter("productInfoId", plProductInfoId)
					.setParameter("hardwareID", plHardwareID);
			if (pAccount != null) {
				lQuery.setParameter("account", pAccount);
			}

			llAlertUnlicensedSw.addAll(lQuery.getResultList());
			log.debug(new StringBuffer("llAlertUnlicensedSw size: ")
					.append(llAlertUnlicensedSw.size()));
		}

		return llAlertUnlicensedSw;
	}
}
