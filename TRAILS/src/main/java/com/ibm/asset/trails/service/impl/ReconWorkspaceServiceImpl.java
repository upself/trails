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
import com.ibm.asset.trails.dao.ReconcileDAO;
import com.ibm.asset.trails.dao.ReconcileTypeDAO;
import com.ibm.asset.trails.dao.VSoftwareLparDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.InstalledSoftware;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.Recon;
import com.ibm.asset.trails.domain.ReconSetting;
import com.ibm.asset.trails.domain.ReconWorkspace;
import com.ibm.asset.trails.domain.Reconcile;
import com.ibm.asset.trails.domain.ReconcileType;
import com.ibm.asset.trails.domain.VSoftwareLpar;
import com.ibm.asset.trails.service.ReconService;
import com.ibm.asset.trails.service.ReconWorkspaceService;
import com.ibm.ea.common.reconcile.IReconcileRule;
import com.ibm.tap.trails.framework.DisplayTagList;

@Service
public class ReconWorkspaceServiceImpl implements ReconWorkspaceService {

	// TODO need to make sure I update alert history
	private static final Log log = LogFactory
			.getLog(ReconWorkspaceServiceImpl.class);

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
	private VSoftwareLparDAO vSwLparDAO;

	private List<IReconcileRule> reconRules;

	private int alertsProcessed;

	private int alertsTotal;

	public int getAlertsProcessed() {
		return alertsProcessed;
	}

	public void setAlertsProcessed(int alertsProcessed) {
		this.alertsProcessed = alertsProcessed;
	}

	public void setReconRules(List<IReconcileRule> reconRules) {
		this.reconRules = reconRules;
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
				.getSoftware().getSoftwareId());
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
		log.debug(account.toString() + " " + remoteUser + " "
				+ pRecon.getReconcileType().toString() + " " + runon + " "
				+ automated + " " + manual);

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
		int owner = reconService.validateScheduleFowner(lausTemp);
		if (!lalAlertUnlicensedSw.isEmpty() && liLicensesNeeded > 0
				&& owner != 2) {

			for (License llTemp : pRecon.getLicenseList()) {

				if (llTemp.getIbmOwned() != (owner == 1 ? true : false)) {
					continue;
				}

				// start of reconcile rules check.
				boolean skip = false;
				for (IReconcileRule rule : reconRules) {
					if (!rule.inMyScope(pRecon.getPer()))
						continue;

					if (!rule.allocate(pRecon, llTemp, lausTemp)) {
						skip = true;
						break;
					}
				}

				if (skip)
					continue;
				// end of reconcile rules check

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
						"selected", owner);
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
		Set<Long> processedHwIds = new HashSet<Long>();
		boolean lbProcessAlert = false;

		setAlertsProcessed(0);
		setAlertsTotal(lalAlertUnlicensedSw.size());
		log.debug("lalAlertUnlicensedSw: " + lalAlertUnlicensedSw.size());
		for (Long alertId : lalAlertUnlicensedSw) {
			AlertUnlicensedSw lausTemp = alertDAO.findById(alertId);
			int scheduleFOwner = reconService.validateScheduleFowner(lausTemp);
			liLicensesNeeded = determineLicensesNeeded(pRecon, lausTemp);
			lbProcessAlert = processAlert(pRecon, processedHwIds, lausTemp);

			if (liLicensesNeeded > 0 && lbProcessAlert && scheduleFOwner != 2) {
				lmTempLicenseAvailableQty = new HashMap<Long, Integer>();
				copyMap(lmLicenseAvailableQty, lmTempLicenseAvailableQty);
				lmLicenseApplied = new HashMap<License, Integer>();

				for (License llTemp : pRecon.getLicenseList()) {

					// scheduleFOwner: the owner defined in schedule f.
					// 0 - Customer owned, 1 - IBM owned, 2 - none correspond
					// schedule f item defined.
					boolean isScheduleFIBMOwner = scheduleFOwner == 1 ? true
							: false;

					// check if license and schedule f item owner same, skip
					// when not same.
					if (llTemp.getIbmOwned() != isScheduleFIBMOwner) {
						continue;
					}

					// start of reconcile rules check.
					boolean skip = false;
					for (IReconcileRule rule : reconRules) {
						if (!rule.inMyScope(pRecon.getPer()))
							continue;

						if (!rule.allocate(pRecon, llTemp, lausTemp)) {
							skip = true;
							break;
						}
					}

					if (skip)
						continue;
					// end of reconcile rules check

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
					Long llHardwareId = reconService
							.manualReconcileByAlert(alertId, null, pRecon,
									psRemoteUser, null, pAccount,
									lmLicenseApplied, "group", scheduleFOwner);
					if (llHardwareId != null) {
						processedHwIds.add(llHardwareId);
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
						.getInstalledSoftware().getSoftware().getSoftwareId(),
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
				alertDAO.refresh(alert);
				// bug fix for #166. alert may null under multi-threads.
				if (alert == null || alert.getReconcile() == null) {
					continue;
				}
				List<Long> alertIds = new ArrayList<Long>();
				if (alert.getReconcile().getMachineLevel() == 1) {
					alertIds.addAll(alertDAO.findMachineLevelAffected(alert
							.getInstalledSoftware().getSoftware()
							.getSoftwareId(), alert.getInstalledSoftware()
							.getSoftwareLpar().getHardwareLpar().getHardware()
							.getId()));
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
			AlertUnlicensedSw alert = alertDAO.findById(reconWorkspace.getAlertId());
			alertDAO.refresh(alert);

			List<Long> alertIds = new ArrayList<Long>();
			if (alert.getReconcile().getMachineLevel() == 1) {
				alertIds.addAll(alertDAO.findMachineLevelAffected(alert
						.getInstalledSoftware().getSoftware()
						.getSoftwareId(), alert.getInstalledSoftware()
						.getSoftwareLpar().getHardwareLpar().getHardware()
						.getId()));
			} else {
				alertIds.add(alert.getId());
			}		
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
		int liMaxLicenses = (lsPer.equalsIgnoreCase("PVU")
				|| lsPer.equalsIgnoreCase("HWGARTMIPS")
				|| lsPer.equalsIgnoreCase("LPARGARTMIPS")
				|| lsPer.equalsIgnoreCase("HWLSPRMIPS")
				|| lsPer.equalsIgnoreCase("LPARLSPRMIPS")
				|| lsPer.equalsIgnoreCase("HWMSU")
				|| lsPer.equalsIgnoreCase("LPARMSU") || lsPer
				.equalsIgnoreCase("HWIFL")) ? 0 : pRecon.getMaxLicenses()
				.intValue();
		boolean cacualted = false;
		if (lsPer.equalsIgnoreCase("LPAR")
				|| lsPer.equalsIgnoreCase("HWDEVICE")) {
			liLicensesNeeded = liMaxLicenses;
			cacualted = true;
		} else if (lsPer.equalsIgnoreCase("CHIP")) {
			liLicensesNeeded = pAlertUnlicensedSw.getInstalledSoftware()
					.getSoftwareLpar().getHardwareLpar().getHardware()
					.getChips().intValue()
					* liMaxLicenses;
			cacualted = true;
		}

		// If $licenseQty can't be assigned during the scope of the rules chain
		// then perform the default quantity calculation.
		int licenseQty = 0;
		boolean coveredByRules = false;
		for (IReconcileRule rule : reconRules) {
			if (!rule.inMyScope(pRecon.getPer()))
				continue;

			coveredByRules = true;
			licenseQty = rule.requiredLicenseQty(pRecon, pAlertUnlicensedSw);
			if (licenseQty != 0) {
				liLicensesNeeded = licenseQty;
				break;
			}
		}

		// current allocation methodology have not rules, apply default qty.
		if (!coveredByRules && !cacualted) {
			VSoftwareLpar lVSoftwareLpar = vSwLparDAO.findById(pAlertUnlicensedSw.getInstalledSoftware().getSoftwareLpar().getId());

			if(lsPer.equalsIgnoreCase("PROCESSOR")){
				liLicensesNeeded = lVSoftwareLpar.getHardwareLpar().getHardwareLparEff().getProcessorCount().intValue() * liMaxLicenses;
			} else {
				if(lVSoftwareLpar.getHardwareLpar().getHardware().getProcessorCount() == null){
					liLicensesNeeded = 0 * liMaxLicenses;
				}else{
					liLicensesNeeded = lVSoftwareLpar.getHardwareLpar().getHardware().getProcessorCount().intValue() * liMaxLicenses;
				}
			}
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

	private boolean processAlert(Recon pRecon, Set<Long> pmHardwareId,
			AlertUnlicensedSw pAlertUnlicensedSw) {
		if (pRecon.getPer().equalsIgnoreCase("HWDEVICE")
				|| pRecon.getPer().equalsIgnoreCase("HWPROCESSOR")
				|| pRecon.getPer().equalsIgnoreCase("PVU")
				|| pRecon.getPer().equalsIgnoreCase("CHIP")) {

			return !pmHardwareId.contains(pAlertUnlicensedSw
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
