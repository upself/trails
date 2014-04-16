package com.ibm.asset.trails.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.AlertUnlicensedSoftwareDAO;
import com.ibm.asset.trails.dao.InstalledSoftwareDAO;
import com.ibm.asset.trails.dao.PVUInfoDAO;
import com.ibm.asset.trails.dao.PVUMapDAO;
import com.ibm.asset.trails.dao.ReconcileDAO;
import com.ibm.asset.trails.dao.ReconcileTypeDAO;
import com.ibm.asset.trails.dao.VSoftwareLparDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.InstalledSoftware;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.domain.PvuInfo;
import com.ibm.asset.trails.domain.PvuMap;
import com.ibm.asset.trails.domain.Recon;
import com.ibm.asset.trails.domain.ReconSetting;
import com.ibm.asset.trails.domain.ReconWorkspace;
import com.ibm.asset.trails.domain.Reconcile;
import com.ibm.asset.trails.domain.ReconcileType;
import com.ibm.asset.trails.domain.VSoftwareLpar;
import com.ibm.asset.trails.service.ReconService;
import com.ibm.asset.trails.service.ReconWorkspaceService;
import com.ibm.tap.trails.framework.DisplayTagList;

@Service
public class ReconWorkspaceServiceImpl implements ReconWorkspaceService {
	// TODO need to make sure I update alert history
	private static final Log log = LogFactory
			.getLog(ReconWorkspaceServiceImpl.class);

	private final int DEFAULT_PVU_VALUE = 100;

	@Autowired
	private ReconService reconService;

	@Autowired
	private ReconcileTypeDAO reconTypeDAO;

	@Autowired
	private InstalledSoftwareDAO instSwDAO;

	@Autowired
	private AlertUnlicensedSoftwareDAO alertDAO;

	@Autowired
	private ReconcileDAO reconDAO;

	@Autowired
	private PVUMapDAO pvuMapDAO;

	@Autowired
	private PVUInfoDAO pvuInfoDAO;

	@Autowired
	private VSoftwareLparDAO vSwLparDAO;

	private int alertsProcessed;

	private int alertsTotal;

	public int getAlertsProcessed() {
		return alertsProcessed;
	}

	public void setAlertsProcessed(int alertsProcessed) {
		this.alertsProcessed = alertsProcessed;
	}

	public int getAlertsTotal() {
		return alertsTotal;
	}

	public void setAlertsTotal(int alertsTotal) {
		this.alertsTotal = alertsTotal;
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public List<Map<String, Object>> reconcileTypeActions() {
		return reconTypeDAO.reconcileTypeActions();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public List<ReconcileType> reconcileTypes(boolean isManual) {
		return reconTypeDAO.reconcileTypes(isManual);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public ReconcileType findReconcileType(Long id) {
		return reconTypeDAO.findById(id);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public List<InstalledSoftware> installedSoftwareList(
			Long installedSoftwareId) {
		InstalledSoftware is = instSwDAO.findById(installedSoftwareId);
		return instSwDAO.installedSoftwareList(is.getSoftwareLpar().getId(), is
				.getProductInfo().getId());
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public InstalledSoftware getInstalledSoftware(Long installedSoftwareId) {
		return instSwDAO.getInstalledSoftware(installedSoftwareId);
	}

	private List<Long> findAffectedAlertList(
			List<ReconWorkspace> reconWorkspaces, boolean overwriteAuto,
			boolean overwriteManual) {
		return alertDAO.findAffectedAlertList(reconWorkspaces, overwriteAuto,
				overwriteManual);
	}

	// Begin customer owned manual recon
	@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
	public void reconCustomerOwned(Account account, String remoteUser,
			List<ReconWorkspace> selectedList, Recon pRecon, String runon,
			boolean automated, boolean manual, String comments) {
		log.debug(account.toString()
				+ " "
				+ remoteUser
				+ " "
				+ pRecon.getReconcileType().toString()
				+ " "
				+ runon
				+ " "
				+ automated
				+ " "
				+ manual);

		String owner = null;

		// I can probably just get rid of this based on selection
		if (runon.equals("IBMHW")) {
			owner = "IBM";
			reconCustomerOwnedGroup(account, remoteUser, selectedList, pRecon,
					automated, manual, owner, comments);
		} else if (runon.equals("CUSTHW")) {
			owner = "CUSTO";
			reconCustomerOwnedGroup(account, remoteUser, selectedList, pRecon,
					automated, manual, owner, comments);
		} else if (runon.equals("ALL")) {
			owner = runon;
			reconCustomerOwnedGroup(account, remoteUser, selectedList, pRecon,
					automated, manual, owner, comments);
		} else if (runon.equals("SELECTED")) {
			owner = runon;
			reconCustomerOwnedSelected(account, remoteUser, selectedList,
					pRecon, automated, manual, owner, comments);
		} else {
			return;
		}
	}

	private void reconCustomerOwnedSelected(Account account, String remoteUser,
			List<ReconWorkspace> selectedList, Recon pRecon, boolean automated,
			boolean manual, String owner, String comments) {

		List<Long> alertList = findAffectedAlertList(selectedList, automated,
				manual);

		setAlertsProcessed(0);
		setAlertsTotal(alertList.size());
		for (Long alertId : alertList) {
			reconService.reconcileByAlert(alertId, null, pRecon, remoteUser,
					comments, account);
			setAlertsProcessed(getAlertsProcessed() + 1);
		}
	}

	private void reconCustomerOwnedGroup(Account account, String remoteUser,
			List<ReconWorkspace> selectedList, Recon pRecon, boolean automated,
			boolean manual, String owner, String comments) {

		// Get distinct product info ids
		HashSet<Long> distinctSoftwareItemSet = new HashSet<Long>();
		for (ReconWorkspace rw : selectedList) {
			distinctSoftwareItemSet.add(rw.getProductInfoId());
		}

		for (Long softwareItemId : distinctSoftwareItemSet) {

			log.debug("Processing softwareItemId: " + softwareItemId);

			List<Long> alertList = alertDAO.findAffectedAlertList(
					account.getId(), softwareItemId, automated, manual, owner,
					true);

			setAlertsProcessed(0);
			setAlertsTotal(alertList.size());
			log.debug("alertList: " + alertList.size());

			for (Long alertId : alertList) {
				reconService.reconcileByAlert(alertId, null, pRecon,
						remoteUser, comments, account);
				setAlertsProcessed(getAlertsProcessed() + 1);
			}
		}
	}

	// End customer owned manual recon

	// Begin manual license allocation
	@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
	public void manualRecon(Account account, String remoteUser, Recon recon) {

		String owner = null;
		// I can probably just get rid of this based on selection
		if (recon.getRunon().equals("IBMHW")) {
			owner = "IBM";
			manualReconGroup(account, remoteUser, recon, owner);
		} else if (recon.getRunon().equals("CUSTHW")) {
			owner = "CUSTO";
			manualReconGroup(account, remoteUser, recon, owner);
		} else if (recon.getRunon().equals("ALL")) {
			owner = recon.getRunon();
			manualReconGroup(account, remoteUser, recon, owner);
		} else if (recon.getRunon().equals("SELECTED")) {
			owner = recon.getRunon();
			manualReconSelected(account, remoteUser, recon, owner);
		} else {
			return;
		}
	}

	private void manualReconSelected(Account pAccount, String psRemoteUser,
			Recon pRecon, String psOwner) {
		List<Long> lalAlertUnlicensedSw = findAffectedAlertList(
				pRecon.getList(), pRecon.isAutomated(), pRecon.isManual());
		Long alertId = lalAlertUnlicensedSw.get(0);
		AlertUnlicensedSw lausTemp = alertDAO.findById(alertId);
		int liLicensesNeeded = determineLicensesNeeded(pRecon, lausTemp);
		Map<Long, Integer> lmLicenseAvailableQty = new HashMap<Long, Integer>();
		int liLicensesApplied = 0;
		Map<License, Integer> lmLicenseApplied = new HashMap<License, Integer>();

		setAlertsProcessed(0);
		setAlertsTotal(lalAlertUnlicensedSw.size());
		if (!lalAlertUnlicensedSw.isEmpty() && liLicensesNeeded > 0) {
			for (License llTemp : pRecon.getLicenseList()) {
				if (!lmLicenseAvailableQty.containsKey(llTemp.getId())) {
					lmLicenseAvailableQty.put(llTemp.getId(),
							llTemp.getAvailableQty());
				}

				if (lmLicenseAvailableQty.get(llTemp.getId()).intValue() < 1) {
					continue;
				}

				// If there are enough licenses available to cover this alert,
				// then
				// use all that are necessary
				if (lmLicenseAvailableQty.get(llTemp.getId()).intValue() >= liLicensesNeeded) {
					liLicensesApplied = liLicensesNeeded;
					lmLicenseAvailableQty.put(llTemp.getId(), new Integer(
							lmLicenseAvailableQty.get(llTemp.getId())
									.intValue() - liLicensesNeeded));
				} else {
					liLicensesApplied = lmLicenseAvailableQty.get(
							llTemp.getId()).intValue();
					lmLicenseAvailableQty.put(llTemp.getId(), new Integer(0));
				}
				liLicensesNeeded -= liLicensesApplied;
				lmLicenseApplied.put(llTemp, liLicensesApplied);

				// If the number of needed licenses applied is now zero, then
				// break out
				// of the license loop to process the next alert
				if (liLicensesNeeded == 0) {
					break;
				}
			}

			if (liLicensesNeeded == 0) {
				reconService.manualReconcileByAlert(alertId, null, pRecon,
						psRemoteUser, null, pAccount, lmLicenseApplied,
						"selected");
			}
		}
		setAlertsProcessed(getAlertsProcessed() + 1);
	}

	private void manualReconGroup(Account pAccount, String psRemoteUser,
			Recon pRecon, String psOwner) {
		List<Long> lalAlertUnlicensedSw = alertDAO.findAffectedAlertList(
				pAccount.getId(), (pRecon.getList().get(0)).getProductInfoId(),
				pRecon.isAutomated(), pRecon.isManual(), psOwner, true);
		int liLicensesNeeded = 0;
		Map<Long, Integer> lmTempLicenseAvailableQty = null;
		Map<Long, Integer> lmLicenseAvailableQty = new HashMap<Long, Integer>();
		int liLicensesApplied = 0;
		Map<License, Integer> lmLicenseApplied = null;
		Long llHardwareId = null;
		Map<Long, Long> lmHardwareId = new HashMap<Long, Long>();
		boolean lbProcessAlert = false;

		setAlertsProcessed(0);
		setAlertsTotal(lalAlertUnlicensedSw.size());
		log.debug("lalAlertUnlicensedSw: " + lalAlertUnlicensedSw.size());
		for (Long alertId : lalAlertUnlicensedSw) {
			AlertUnlicensedSw lausTemp = alertDAO.findById(alertId);
			liLicensesNeeded = determineLicensesNeeded(pRecon, lausTemp);
			lbProcessAlert = processAlert(pRecon, lmHardwareId, lausTemp);

			if (liLicensesNeeded > 0 && lbProcessAlert) {
				lmTempLicenseAvailableQty = new HashMap<Long, Integer>();
				copyMap(lmLicenseAvailableQty, lmTempLicenseAvailableQty);
				lmLicenseApplied = new HashMap<License, Integer>();

				for (License llTemp : pRecon.getLicenseList()) {
					if (!lmTempLicenseAvailableQty.containsKey(llTemp.getId())) {
						lmTempLicenseAvailableQty.put(llTemp.getId(),
								llTemp.getAvailableQty());
					}

					if (lmTempLicenseAvailableQty.get(llTemp.getId())
							.intValue() < 1) {
						continue;
					}

					// If there are enough licenses available to cover this
					// alert,
					// then use all that are necessary
					if (lmTempLicenseAvailableQty.get(llTemp.getId())
							.intValue() >= liLicensesNeeded) {
						liLicensesApplied = liLicensesNeeded;
						lmTempLicenseAvailableQty.put(
								llTemp.getId(),
								new Integer(lmTempLicenseAvailableQty.get(
										llTemp.getId()).intValue()
										- liLicensesNeeded));
					} else {
						liLicensesApplied = lmTempLicenseAvailableQty.get(
								llTemp.getId()).intValue();
						lmTempLicenseAvailableQty.put(llTemp.getId(),
								new Integer(0));
					}
					liLicensesNeeded -= liLicensesApplied;
					lmLicenseApplied.put(llTemp, liLicensesApplied);

					// If the number of needed licenses applied is now zero,
					// then break out
					// of the license loop to process the next alert
					if (liLicensesNeeded == 0) {
						break;
					}
				}

				if (liLicensesNeeded == 0) {
					llHardwareId = reconService.manualReconcileByAlert(alertId,
							null, pRecon, psRemoteUser, null, pAccount,
							lmLicenseApplied, "group");
					if (llHardwareId != null) {
						lmHardwareId.put(llHardwareId, llHardwareId);
					}
					copyMap(lmTempLicenseAvailableQty, lmLicenseAvailableQty);
				}
			}

			setAlertsProcessed(getAlertsProcessed() + 1);
		}
	}

	// End manual license allocation

	// Begin included with other product manual recon
	@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
	public void reconIncluded(Account account, String remoteUser,
			List<ReconWorkspace> selectedList, Recon pRecon,
			InstalledSoftware parentInstalledSoftware) {

		if (selectedList.size() > 1) {
			return;
		}

		ReconWorkspace rw = selectedList.get(0);

		setAlertsProcessed(0);
		setAlertsTotal(1);
		reconService.reconcileByAlert(rw.getAlertId(), parentInstalledSoftware,
				pRecon, remoteUser, null, account);
		setAlertsProcessed(getAlertsProcessed() + 1);
	}

	// End included with other product manual recon

	// Begin break manual recon
	@Transactional(readOnly = true, propagation = Propagation.REQUIRES_NEW)
	public void breakManualRecon(Account account, String remoteUser,
			List<ReconWorkspace> selectedList, ReconcileType reconcileType,
			String runon) {
		String owner = null;
		// I can probably just get rid of this based on selection
		if (runon.equals("IBMHW")) {
			owner = "IBM";
			breakManualReconGroup(account, remoteUser, selectedList,
					reconcileType, owner);
		} else if (runon.equals("CUSTHW")) {
			owner = "CUSTO";
			breakManualReconGroup(account, remoteUser, selectedList,
					reconcileType, owner);
		} else if (runon.equals("ALL")) {
			owner = runon;
			breakManualReconGroup(account, remoteUser, selectedList,
					reconcileType, owner);
		} else if (runon.equals("SELECTED")) {
			owner = runon;
			breakManualReconSelected(account, remoteUser, selectedList,
					reconcileType, owner);
		} else {
			return;
		}
	}

	private void breakManualReconSelected(Account account, String remoteUser,
			List<ReconWorkspace> selectedList, ReconcileType reconcileType,
			String owner) {
		List<Long> alertList = findAffectedAlertList(selectedList, false, true);

		setAlertsProcessed(0);
		setAlertsTotal(alertList.size());
		for (Long alertId : alertList) {
			AlertUnlicensedSw alert = alertDAO.findById(alertId);
			List<Long> alertIds = new ArrayList<Long>();
			if (alert.getReconcile().getMachineLevel() == 1) {
				alertIds.addAll(alertDAO.findMachineLevelAffected(alert
						.getInstalledSoftware().getProductInfo().getId(), alert
						.getInstalledSoftware().getSoftwareLpar()
						.getHardwareLpar().getHardware().getId()));
			} else {
				alertIds.add(alertId);
			}
			for (Long id : alertIds) {
				reconService.breakReconcileByAlert(id, account, remoteUser);
			}
		}
		setAlertsProcessed(getAlertsProcessed() + 1);
	}

	private void breakManualReconGroup(Account account, String remoteUser,
			List<ReconWorkspace> selectedList, ReconcileType reconcileType,
			String owner) {
		HashSet<Long> lhsSoftwareItemId = new HashSet<Long>();

		// Get distinct software ids
		for (ReconWorkspace rw : selectedList) {
			lhsSoftwareItemId.add(rw.getProductInfoId());
		}

		for (Long llSoftwareItemId : lhsSoftwareItemId) {

			log.debug("Processing softwareItemId: " + llSoftwareItemId);

			List<Long> alertList = alertDAO.findAffectedAlertList(
					account.getId(), llSoftwareItemId, false, true, owner,
					false);

			setAlertsProcessed(0);
			setAlertsTotal(alertList.size());
			log.debug("alertList: " + alertList.size());
			for (Long alertId : alertList) {
				AlertUnlicensedSw alert = alertDAO.findById(alertId);
				// bug fix for #166. alert may null under multi-threads.
				if (alert == null || alert.getReconcile() == null) {
					continue;
				}
				List<Long> alertIds = new ArrayList<Long>();
				if (alert.getReconcile().getMachineLevel() == 1) {
					alertIds.addAll(alertDAO.findMachineLevelAffected(alert
							.getInstalledSoftware().getProductInfo().getId(),
							alert.getInstalledSoftware().getSoftwareLpar()
									.getHardwareLpar().getHardware().getId()));
				} else {
					alertIds.add(alertId);
				}
				for (Long id : alertIds) {
					reconService.breakReconcileByAlert(id, account, remoteUser);
				}
			}
			setAlertsProcessed(getAlertsProcessed() + 1);
		}
	}

	@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
	public void breakLicenseRecon(Account account, String remoteUser,
			List<ReconWorkspace> reconWorkspaces, ReconcileType reconcileType) {
		for (ReconWorkspace reconWorkspace : reconWorkspaces) {
			List<Long> alertIds = alertDAO.findAffectedLicenseAlertList(
					account.getId(), reconWorkspace.getAlertId());
			setAlertsProcessed(0);
			setAlertsTotal(alertIds.size());
			for (Long alertId : alertIds) {
				reconService
						.breakReconcileByAlert(alertId, account, remoteUser);
				setAlertsProcessed(getAlertsProcessed() + 1);
			}
		}
	}

	// End break reconcile manual action
	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void paginatedList(DisplayTagList data, Account account,
			ReconSetting reconSetting, int startIndex, int objectsPerPage,
			String sort, String dir) {
		vSwLparDAO.paginatedList(data, account, reconSetting, startIndex,
				objectsPerPage, sort, dir);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public Reconcile reconcileDetail(Long id) {
		return reconDAO.reconcileDetail(id);
	}

	private int determineLicensesNeeded(Recon pRecon,
			AlertUnlicensedSw pAlertUnlicensedSw) {
		int liLicensesNeeded = 0;
		String lsPer = pRecon.getPer();
		int liMaxLicenses = lsPer.equalsIgnoreCase("PVU") ? 0 : pRecon
				.getMaxLicenses().intValue();

		if (lsPer.equalsIgnoreCase("LPAR")
				|| lsPer.equalsIgnoreCase("HWDEVICE")) {
			liLicensesNeeded = liMaxLicenses;
		} else if (lsPer.equalsIgnoreCase("CHIP")) {
			liLicensesNeeded = pAlertUnlicensedSw.getInstalledSoftware()
					.getSoftwareLpar().getHardwareLpar().getHardware()
					.getChips().intValue()
					* liMaxLicenses;
		} else if (lsPer.equalsIgnoreCase("PVU")) {
			int liChips = pAlertUnlicensedSw.getInstalledSoftware()
					.getSoftwareLpar().getHardwareLpar().getHardware()
					.getChips();
			int liProcessorCount = pAlertUnlicensedSw.getInstalledSoftware()
					.getSoftwareLpar().getHardwareLpar().getHardware()
					.getProcessorCount();

			if (liProcessorCount < 1) {
				liProcessorCount = pAlertUnlicensedSw.getInstalledSoftware()
						.getSoftwareLpar().getProcessorCount();
			}

			if (liProcessorCount > 0) {
				if (liChips == 0) {
					liLicensesNeeded = DEFAULT_PVU_VALUE * liProcessorCount;
				} else {
					String lsProcessorBrand = pAlertUnlicensedSw
							.getInstalledSoftware().getSoftwareLpar()
							.getHardwareLpar().getHardware()
							.getProcessorBrand();
					String lsProcessorModel = pAlertUnlicensedSw
							.getInstalledSoftware().getSoftwareLpar()
							.getHardwareLpar().getHardware()
							.getProcessorModel();
					MachineType lmtAlert = pAlertUnlicensedSw
							.getInstalledSoftware().getSoftwareLpar()
							.getHardwareLpar().getHardware().getMachineType();
					PvuMap lpvumAlert = null;
					int liNumberOfCores = 0;

					lpvumAlert = pvuMapDAO
							.getPvuMapByBrandAndModelAndMachineTypeId(
									lsProcessorBrand, lsProcessorModel,
									lmtAlert);

					if (lpvumAlert == null) {
						liLicensesNeeded = DEFAULT_PVU_VALUE * liProcessorCount;
					} else {
						liNumberOfCores = liProcessorCount / liChips;

						if (liNumberOfCores == 0) {
							liLicensesNeeded = DEFAULT_PVU_VALUE
									* liProcessorCount;
						} else {
							List<PvuInfo> llPvuInfo = null;
							PvuInfo lpvuiAlert = null;
							if (liNumberOfCores == 1
									|| liNumberOfCores == 2
									|| liNumberOfCores == 4) {
								llPvuInfo = pvuInfoDAO.find(lpvumAlert
										.getProcessorValueUnit().getId(),
										liNumberOfCores);
								if (llPvuInfo != null && llPvuInfo.size() > 0) {
									lpvuiAlert = llPvuInfo.get(0);
								}
							}

							if (lpvuiAlert != null
									&& lpvuiAlert.getValueUnitsPerCore()
											.intValue() > 0) {
								liLicensesNeeded = lpvuiAlert
										.getValueUnitsPerCore().intValue()
										* liProcessorCount;
							} else {
								llPvuInfo = pvuInfoDAO.find(lpvumAlert
										.getProcessorValueUnit().getId());
								if (llPvuInfo != null && llPvuInfo.size() > 0) {
									lpvuiAlert = llPvuInfo.get(0);
								}

								if (lpvuiAlert == null
										|| lpvuiAlert.getValueUnitsPerCore()
												.intValue() == 0) {
									liLicensesNeeded = DEFAULT_PVU_VALUE
											* liProcessorCount;
								} else {
									liLicensesNeeded = lpvuiAlert
											.getValueUnitsPerCore().intValue()
											* liProcessorCount;
								}
							}
						}
					}
				}
			} else {
				liLicensesNeeded = 0;
			}
		} else { // lsPer.equalsIgnoreCase("PROCESSOR") || //
			// lsPer.equalsIgnoreCase("HWPROCESSOR")
			VSoftwareLpar lVSoftwareLpar = vSwLparDAO
					.findById(pAlertUnlicensedSw.getInstalledSoftware()
							.getSoftwareLpar().getId());

			liLicensesNeeded = (lsPer.equalsIgnoreCase("PROCESSOR") ? lVSoftwareLpar
					.getProcessorCount().intValue()
					: (lVSoftwareLpar.getHardwareLpar().getHardware()
							.getProcessorCount() == null ? 0 : lVSoftwareLpar
							.getHardwareLpar().getHardware()
							.getProcessorCount().intValue()))
					* liMaxLicenses;
		}

		return liLicensesNeeded;
	}

	private void copyMap(Map<Long, Integer> pmSource,
			Map<Long, Integer> pmTarget) {
		Set<Entry<Long, Integer>> lsSource = pmSource.entrySet();
		Iterator<Entry<Long, Integer>> liSource = lsSource.iterator();
		Entry<Long, Integer> leSource = null;

		while (liSource.hasNext()) {
			leSource = liSource.next();

			pmTarget.put(leSource.getKey(), leSource.getValue());
		}
	}

	private boolean processAlert(Recon pRecon, Map<Long, Long> pmHardwareId,
			AlertUnlicensedSw pAlertUnlicensedSw) {
		if (pRecon.getPer().equalsIgnoreCase("HWDEVICE")
				|| pRecon.getPer().equalsIgnoreCase("HWPROCESSOR")
				|| pRecon.getPer().equalsIgnoreCase("PVU")) {
			return !pmHardwareId.containsKey(pAlertUnlicensedSw
					.getInstalledSoftware().getSoftwareLpar().getHardwareLpar()
					.getHardware().getId());
		} else {
			return true;
		}
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public List<Long> findAffectedAlertUnlicensedSwList(Account pAccount,
			List<ReconWorkspace> plReconWorkspace, String psRunOn) {
		ListIterator<ReconWorkspace> lliReconWorkspace = plReconWorkspace
				.listIterator();
		ReconWorkspace lrwTemp = null;
		List<Long> results;

		if (psRunOn.equalsIgnoreCase("SELECTED")) {
			List<Long> llAlertUnlicensedSwId = new ArrayList<Long>();

			while (lliReconWorkspace.hasNext()) {
				lrwTemp = lliReconWorkspace.next();
				llAlertUnlicensedSwId.add(lrwTemp.getAlertId());
			}
			results = alertDAO.findAffectedAlertList(llAlertUnlicensedSwId);
		} else {
			List<Long> llProductInfoId = new ArrayList<Long>();
			Map<Long, Long> lmProductInfoId = new HashMap<Long, Long>();

			while (lliReconWorkspace.hasNext()) {
				lrwTemp = lliReconWorkspace.next();

				if (!lmProductInfoId.containsKey(lrwTemp.getProductInfoId())) {
					llProductInfoId.add(lrwTemp.getProductInfoId());
				}
			}

			if (psRunOn.equalsIgnoreCase("ALL")) {
				results = alertDAO.findAffectedAlertList(pAccount,
						llProductInfoId);
			} else {
				results = alertDAO.findAffectedAlertList(pAccount,
						llProductInfoId, psRunOn);
			}
		}

		return results;
	}
}
