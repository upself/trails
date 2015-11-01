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

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

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
import com.ibm.asset.trails.domain.ScheduleF;
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
	
	//Story 26012
	private List<String> ScheduleFValResult;
	
	//defect 27747
	private String procWarnMsg;
	
	public String getProcWarnMsg() {
		return procWarnMsg;
	}

	public void setProcWarnMsg(String procWarnMsg) {
		this.procWarnMsg = procWarnMsg;
	}

	public void setScheduleFValResult(String result) {
		if(result!=null){
			if(ScheduleFValResult==null||ScheduleFValResult.isEmpty()){
				ScheduleFValResult=new ArrayList<String>();
				ScheduleFValResult.add(result);
			}else{
				if(!ScheduleFValResult.contains(result)){
					ScheduleFValResult.add(result);
				}
			}
		}else{
			ScheduleFValResult=null;
		}
	}

	public List<String> getScheduleFValResult() {
		return ScheduleFValResult;
	}


	//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users Start
	private EntityManager em;

	@PersistenceContext(unitName = "trailspd")
	public void setEntityManager(EntityManager em) {
		this.em = em;
	}

	private EntityManager getEntityManager() {
		return em;
	}
	//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users End
	
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
		//User Story 23223 - remove "CO/CM" from reconcile type list Start
		List<Map<String, Object>> reconcileTypeList = reconTypeDAO.reconcileTypeActions();
		List<Map<String, Object>> reconcileTypeRemoveList = new ArrayList<Map<String, Object>>();
		
		for(Map<String, Object> reconcileTypeMap:reconcileTypeList){
		 if(reconcileTypeMap.get("id")!=null && ((Long)reconcileTypeMap.get("id")).intValue()==2){//judge if reconcile type is manual CO/CM
			reconcileTypeRemoveList.add(reconcileTypeMap);//add manual CO/CM reconcile type into reconcile type remove list 
		 }	
		}
		
		reconcileTypeList.removeAll(reconcileTypeRemoveList);//remove manual CO/CM reconcile type from reconcile type list
		return reconcileTypeList;
		//User Story 23223 - remove "CO/CM" from reconcile type list End
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public List<ReconcileType> reconcileTypes(boolean isManual) {
		//User Story 23223 - remove "CO/CM" from reconcile type list Start
		List<ReconcileType> reconcileTypeList = reconTypeDAO.reconcileTypes(isManual);
		
		if(isManual){
		   List<ReconcileType> reconcileTypeRemoveList = new ArrayList<ReconcileType>();
			
	  	   for(ReconcileType reconcileType: reconcileTypeList){
	  		   //task 36542 add MLA back to Trails on UAT and DEV
		     if(reconcileType.getId()!=null && reconcileType.getId().intValue()==2){//judge if reconcile type is manual CO/CM
		       reconcileTypeRemoveList.add(reconcileType);//add manual CO/CM reconcile type into reconcile type remove list
		     }
		   }
	  	   
	  	   reconcileTypeList.removeAll(reconcileTypeRemoveList);//remove manual CO/CM reconcile type from reconcile type list
		}
	
		return reconcileTypeList;
		//User Story 23223 - remove "CO/CM" from reconcile type list End
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
		//AB added,each time access to the interface, first clear the flag to avoid of confusing by last time
		//Story 26012
		setScheduleFValResult(null);
		
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
			//AB added
			AlertUnlicensedSw aul = alertDAO.findById(alertId);
			int SchedulefFlag = reconService.validateScheduleFowner(aul, pRecon);
			//Story 26012
			if(SchedulefFlag==2){
				setScheduleFValResult("Schedule F not defined");
			}
			//AB added end
			//AB added, add IF condition for no Schedule F defined, then no close Alert
			if(SchedulefFlag!=2){
				reconService.reconcileByAlert(alertId, null, pRecon, remoteUser,
						comments, account);
				setAlertsProcessed(getAlertsProcessed() + 1);
			}
			
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
			//Story 26012
			int alertWithoutScheduleFcounter=0;
			for (Long alertId : alertList) {
				//AB added
				AlertUnlicensedSw aul = alertDAO.findById(alertId);
				int SchedulefFlag = reconService.validateScheduleFowner(aul, pRecon);
				//story 26012
				if(SchedulefFlag==2){
					alertWithoutScheduleFcounter++;
				}
				//AB added end
				//AB added, add IF condition for no Schedule F defined, then not close the alert
				if(SchedulefFlag!=2){
					reconService.reconcileByAlert(alertId, null, pRecon,
							remoteUser, comments, account);
					setAlertsProcessed(getAlertsProcessed() + 1);
				}
				
			}
			
			//Story 26012
			if (alertWithoutScheduleFcounter == alertList.size()) {
				setScheduleFValResult("Schedule F not defined");
			} else if (alertWithoutScheduleFcounter > 0
					&& alertWithoutScheduleFcounter < alertList.size()) {
				setScheduleFValResult("Schedule F not defined for all alerts");
			}
		}
	}

	// End customer owned manual recon

	// Begin manual license allocation
	@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
	public void manualRecon(Account account, String remoteUser, Recon recon) {

		String owner = null;
		
		//AB added,each time access to the interface, first clear the flag first to avoid of confusing by last time
		setScheduleFValResult(null);
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
		int owner = reconService.validateScheduleFowner(lausTemp, pRecon);
		
		//AB added, if no scheduleF defined for the alert, set the flag as N
		if(owner==2){
			setScheduleFValResult("Schedule F not defined");
		}
		
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
				//AB added, when reconService process manualReconcileByAlert, it also validate ScheduleF again, so need to judge its validation result after the process
				//Story 26012
				List<String> scheduleFflagInRecon= reconService.getScheduleFDefInRecon();
				if(scheduleFflagInRecon!=null && !scheduleFflagInRecon.isEmpty()){
					for(String result:scheduleFflagInRecon){
						setScheduleFValResult(result);
					}
				}
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
		
		//Story 26012
		int alertWithoutScheduleFcounter=0;
		
		for (Long alertId : lalAlertUnlicensedSw) {
			AlertUnlicensedSw lausTemp = alertDAO.findById(alertId);
			int scheduleFOwner = reconService.validateScheduleFowner(lausTemp, pRecon);
			
			//Story 26012
			if(scheduleFOwner==2){
				alertWithoutScheduleFcounter++;
			}
			//AB added, if no scheduleF defined for the alert, set the flag as N
//			if(scheduleFOwner==2 && (reconService.getScheduleFDefinRecon()==null || !reconService.getScheduleFDefinRecon().equalsIgnoreCase("N"))){
//				setScheduleFExisting("N");
//			}
			
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
					
					//AB added, when reconService process manualReconcileByAlert, it also needs to validate ScheduleF again, so need to set its validation result after the process
					//Story 26012
					List<String> scheduleFflagInRecon= reconService.getScheduleFDefInRecon();
					if(scheduleFflagInRecon!=null && !scheduleFflagInRecon.isEmpty()){
						for(String result:scheduleFflagInRecon){
							setScheduleFValResult(result);
						}
					}
						
					if (llHardwareId != null) {
						processedHwIds.add(llHardwareId);
					}
					copyMap(lmTempLicenseAvailableQty, lmLicenseAvailableQty);
				}
			}

			setAlertsProcessed(getAlertsProcessed() + 1);
		}
		//Story 26012, above manualReconcileByAlert process, if already set validation result of schedule F, then will ignore here, to avoid of make conflict error msg
		if(getScheduleFValResult()==null || getScheduleFValResult().isEmpty()){
			if(alertWithoutScheduleFcounter==lalAlertUnlicensedSw.size()){
				setScheduleFValResult("Schedule F not defined");
			}else if(alertWithoutScheduleFcounter>0 && alertWithoutScheduleFcounter<lalAlertUnlicensedSw.size()){
				setScheduleFValResult("Schedule F not defined for all alerts");
			}			
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

		// AB added, each time access to the interface, first clear the flag first to avoid of confusing by last time
		//Story 26012
		setScheduleFValResult(null);
		AlertUnlicensedSw aul = alertDAO.findById(rw.getAlertId());
		int SchedulefFlag = reconService.validateScheduleFowner(aul, pRecon);
		// AB added end
		
		setAlertsProcessed(0);
		setAlertsTotal(1);
		
		//AB added, add IF condition for no Schedule F defined, then don't manual recon closed alert
		if(SchedulefFlag!=2){
			reconService.reconcileByAlert(rw.getAlertId(), parentInstalledSoftware,
					pRecon, remoteUser, null, account);
		setAlertsProcessed(getAlertsProcessed() + 1);
		//Story 26012
		}else{
			setScheduleFValResult("Schedule F not defined");
		}
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
				//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users Start
				/*alertIds.addAll(alertDAO.findMachineLevelAffected(alert
						.getInstalledSoftware().getSoftware().getSoftwareId(),
						alert.getInstalledSoftware().getSoftwareLpar()
								.getHardwareLpar().getHardware().getId()));*/
				alertIds.addAll(filterTargetAffectedBreakAlertList4MachineLevel(alert,alertDAO.findMachineLevelAffected(alert
						.getInstalledSoftware().getSoftware()
						.getSoftwareId(), alert.getInstalledSoftware()
						.getSoftwareLpar().getHardwareLpar().getHardware()
						.getId())));
				//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users End
			} else {
				alertIds.add(alertId);
			}
			for (Long id : alertIds) {
				//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users Start
				//reconService.breakReconcileByAlert(id, account, remoteUser);
				AlertUnlicensedSw alertObj = alertDAO.findById(id);
				reconService.breakReconcileByAlert(id, alertObj.getInstalledSoftware().getSoftwareLpar().getAccount(), remoteUser);
				//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users End
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
					//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users Start
					/*alertIds.addAll(alertDAO.findMachineLevelAffected(alert
							.getInstalledSoftware().getSoftware()
							.getSoftwareId(), alert.getInstalledSoftware()
							.getSoftwareLpar().getHardwareLpar().getHardware()
							.getId()));*/
					alertIds.addAll(filterTargetAffectedBreakAlertList4MachineLevel(alert,alertDAO.findMachineLevelAffected(alert
							.getInstalledSoftware().getSoftware()
							.getSoftwareId(), alert.getInstalledSoftware()
							.getSoftwareLpar().getHardwareLpar().getHardware()
							.getId())));
					//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users End
				} else {
					alertIds.add(alertId);
				}
				for (Long id : alertIds) {
					
					//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users Start
					//reconService.breakReconcileByAlert(id, account, remoteUser);
					AlertUnlicensedSw alertObj = alertDAO.findById(id);
					reconService.breakReconcileByAlert(id, alertObj.getInstalledSoftware().getSoftwareLpar().getAccount(), remoteUser);
					//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users End
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
				//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users Start
				/*alertIds.addAll(alertDAO.findMachineLevelAffected(alert
						.getInstalledSoftware().getSoftware()
						.getSoftwareId(), alert.getInstalledSoftware()
						.getSoftwareLpar().getHardwareLpar().getHardware()
						.getId()));*/
				alertIds.addAll(filterTargetAffectedBreakAlertList4MachineLevel(alert,alertDAO.findMachineLevelAffected(alert
						.getInstalledSoftware().getSoftware()
						.getSoftwareId(), alert.getInstalledSoftware()
						.getSoftwareLpar().getHardwareLpar().getHardware()
						.getId())));
				//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users End	
			} else {
				alertIds.add(alert.getId());
			}		
			setAlertsProcessed(0);
			setAlertsTotal(alertIds.size());
			for (Long alertId : alertIds) {
				//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users Start
				//reconService.breakReconcileByAlert(alertId, account, remoteUser);
				AlertUnlicensedSw alertObj = alertDAO.findById(alertId);
				reconService.breakReconcileByAlert(alertId,alertObj.getInstalledSoftware().getSoftwareLpar().getAccount(), remoteUser);
				//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users End
				
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

				//fix defect 27747
				if(lsPer.equalsIgnoreCase("PROCESSOR")){
					if(lVSoftwareLpar.getHardwareLpar()!=null 
							&& lVSoftwareLpar.getHardwareLpar().getHardwareLparEff()!=null
							&& lVSoftwareLpar.getHardwareLpar().getHardwareLparEff().getProcessorCount()!=null 
							&& lVSoftwareLpar.getHardwareLpar().getHardwareLparEff().getProcessorCount().intValue()>0
							&& lVSoftwareLpar.getHardwareLpar().getHardwareLparEff().getStatus().equalsIgnoreCase("ACTIVE")){
						liLicensesNeeded = lVSoftwareLpar.getHardwareLpar()
								.getHardwareLparEff()
								.getProcessorCount()
								.intValue() * liMaxLicenses;
					}else{
						setProcWarnMsg("LPAR proc must be active and greater than zero when closing Alerts Per Processor.");
					}
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
	
	//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users Start
	private List<Long> filterTargetAffectedBreakAlertList4MachineLevel(AlertUnlicensedSw workingAlert, List<Long> affectedAlertList4MachineLevel){
		List<Long> targetAffectedBreakAlertList4MachineLevel = new ArrayList<Long>();
	    if(workingAlert!=null && affectedAlertList4MachineLevel!=null){
	      int workingAlertAccountId = workingAlert.getInstalledSoftware().getSoftwareLpar().getAccount().getId().intValue();
	      for(Long affectedAlertId: affectedAlertList4MachineLevel){
	        AlertUnlicensedSw affectedAlertObj = alertDAO.findById(affectedAlertId);
	        int affectedAlertAccountId = affectedAlertObj.getInstalledSoftware().getSoftwareLpar().getAccount().getId().intValue();
	        if(workingAlertAccountId == affectedAlertAccountId){//Same Acccount
	          targetAffectedBreakAlertList4MachineLevel.add(affectedAlertId);
	        }
	        else{//Cross Account
	        	ScheduleF scheduleF4WorkingAlert = getScheduleFItem(workingAlert.getInstalledSoftware().getSoftwareLpar().getAccount(),
	    				workingAlert.getInstalledSoftware().getSoftware().getSoftwareName(),
	    				workingAlert.getInstalledSoftware().getSoftwareLpar().getName(),
	    				workingAlert.getInstalledSoftware().getSoftwareLpar().getHardwareLpar().getHardware().getOwner(),
	    				workingAlert.getInstalledSoftware().getSoftwareLpar().getHardwareLpar().getHardware().getMachineType().getName(),
	    				workingAlert.getInstalledSoftware().getSoftwareLpar().getHardwareLpar().getHardware().getSerial());
	    		
	    		ScheduleF scheduleF4AffectedAlert = getScheduleFItem(affectedAlertObj.getInstalledSoftware().getSoftwareLpar().getAccount(),
	    				affectedAlertObj.getInstalledSoftware().getSoftware().getSoftwareName(),
	    				affectedAlertObj.getInstalledSoftware().getSoftwareLpar().getName(),
	    				affectedAlertObj.getInstalledSoftware().getSoftwareLpar().getHardwareLpar().getHardware().getOwner(),
	    				affectedAlertObj.getInstalledSoftware().getSoftwareLpar().getHardwareLpar().getHardware().getMachineType().getName(),
	    				affectedAlertObj.getInstalledSoftware().getSoftwareLpar().getHardwareLpar().getHardware().getSerial());
	    		
	    		if (scheduleF4WorkingAlert!=null && scheduleF4AffectedAlert != null) {
	    			Long scopeId4WorkingAlert = scheduleF4WorkingAlert.getScope().getId();
	    			Long scopeId4AffecteddAlert = scheduleF4AffectedAlert.getScope().getId();
	    		
	    			if(scopeId4WorkingAlert.intValue()==3//Working Alert Scope must be IBM owned, IBM managed
	    			  && scheduleF4WorkingAlert.getLevel()!=null
	    			  && !scheduleF4WorkingAlert.getLevel().trim().equals("HOSTNAME")//Working Alert Level must be great than "HOSTNAME"(The value can be 'HWBOX','HWOWNER','PRODUCT') 
	    			  && scopeId4AffecteddAlert.intValue() == 3//Cross Account Alert Scope must be IBM owned, IBM managed
	    			  && scheduleF4AffectedAlert.getLevel()!=null
	    			  && !scheduleF4AffectedAlert.getLevel().trim().equals("HOSTNAME")//Cross Account Alert Level must be great than "HOSTNAME"(The value can be 'HWBOX','HWOWNER','PRODUCT') 
	    			  ){
	    			  targetAffectedBreakAlertList4MachineLevel.add(affectedAlertId);  
	    			}
	    		}
	        }
	      }
	    }
		
		return targetAffectedBreakAlertList4MachineLevel;
	}
	
	private ScheduleF getScheduleFItem(Account account, String swname,
			String hostName, String hwOwner, String machineType, String serial) {
	
		@SuppressWarnings("unchecked")
		List<ScheduleF> results = getEntityManager()
				.createQuery(
						" from ScheduleF a where a.status.description='ACTIVE' and a.account =:account and a.softwareName =:swname")
				.setParameter("account", account)
				.setParameter("swname", swname).getResultList();


		if (results == null || results.isEmpty()) {
			return null;
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

		return null;
	}
	//User Story - 17236 - Manual License Allocation at HW level can automatically close Alerts on another account on the same Shared HW as requested by users End
}
