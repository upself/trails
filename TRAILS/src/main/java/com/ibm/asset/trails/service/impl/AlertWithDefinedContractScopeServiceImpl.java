package com.ibm.asset.trails.service.impl;

import java.util.ArrayList;

import javax.persistence.Query;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.DisplayAlertUnlicensedSw;
import com.ibm.asset.trails.service.AlertService;

@Service
public class AlertWithDefinedContractScopeServiceImpl extends
        BaseAlertUnlicensedSwServiceImpl implements AlertService {

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList paginatedList(Account pAccount, int piStartIndex,
            int piObjectsPerPage, String psSort, String psDir) {
        Query lQuery = super.getEntityManager().createNativeQuery(
                new StringBuffer(
                        SQL_SELECT_UNLICENSED_SW_BY_ACCOUNT_ID_AND_TYPE)
                        .append(super.translateSort(psSort, psDir)).toString(),
                DisplayAlertUnlicensedSw.class);

        System.out.println("lQuery : " + lQuery);
        
        lQuery.setParameter("accountId", pAccount.getId());
        lQuery.setParameter("type", "UNDEFINED_SCOPE");
        lQuery.setFirstResult(piStartIndex);
        lQuery.setMaxResults(piObjectsPerPage);
        return (ArrayList) lQuery.getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList paginatedList(String psRemoteUser, int piStartIndex,
            int piObjectsPerPage, String psSort, String psDir) {
        Query lQuery = super.getEntityManager().createNativeQuery(
                new StringBuffer(
                        SQL_SELECT_UNLICENSED_SW_BY_REMOTE_USER_AND_TYPE)
                        .append(super.translateSort(psSort, psDir)).toString(),
                DisplayAlertUnlicensedSw.class);

        lQuery.setParameter("remoteUser", psRemoteUser);
        lQuery.setParameter("type", "SCOPE");
        lQuery.setFirstResult(piStartIndex);
        lQuery.setMaxResults(piObjectsPerPage);
        return (ArrayList) lQuery.getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public Long total(Account account) {
        Query lQuery = super.getEntityManager().createNamedQuery(
                "alertUnlicensedSwTotalByAccountAndTypeScoped");

        lQuery.setParameter("account", account);
        lQuery.setParameter("type", "SCOPE");

        return ((Long) lQuery.getSingleResult());
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public Long total(String remoteUser) {
        Query lQuery = super.getEntityManager().createNamedQuery(
                "alertUnlicensedSwTotalByRemoteUser");

        lQuery.setParameter("remoteUser", remoteUser);
        lQuery.setParameter("type", "SCOPE");

        return ((Long) lQuery.getSingleResult());
    }

    @Override
    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void updateAll(Account pAccount, String psRemoteUser,
            String psComments, int piMode) {
        // TODO Auto-generated method stub

    }
}




//package com.ibm.asset.trails.service.impl;
//
//import java.math.BigInteger;
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.List;
//
//import javax.persistence.NoResultException;
//import javax.persistence.Query;
//
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Propagation;
//import org.springframework.transaction.annotation.Transactional;
//
//import com.ibm.asset.trails.domain.Account;
//import com.ibm.asset.trails.domain.AlertHardware;
//import com.ibm.asset.trails.domain.AlertHardwareCfgData;
//import com.ibm.asset.trails.domain.AlertHardwareCfgDataH;
//import com.ibm.asset.trails.domain.AlertHardwareH;
//import com.ibm.asset.trails.domain.AlertWithDefinedContractScope;
//import com.ibm.asset.trails.form.AlertHistoryReport;
//import com.ibm.asset.trails.service.AlertService;
//
//@Service
//public class AlertWithDefinedContractScopeServiceImpl extends BaseAlertServiceImpl implements AlertService{
//
//	public final String SQL_SELECT_UNLICENSED_SW_BY_ACCOUNT_ID_AND_TYPE = "SELECT Alert_Age, Software_Item_Name, Alert_Count, Creation_Time FROM (SELECT MAX(DAYS(CURRENT TIMESTAMP) - DAYS(VA.Creation_Time)) AS Alert_Age, SW.Software_Name AS Software_Item_Name, COUNT(*) AS Alert_Count, MIN(VA.Creation_Time) AS Creation_Time FROM EAADMIN.V_Alerts VA, EAADMIN.Alert_Unlicensed_Sw AUS, EAADMIN.Installed_Software IS, EAADMIN.Software SW WHERE VA.Customer_Id = :accountId AND VA.Type = :type AND VA.Open = 1 AND AUS.Id = VA.Id AND IS.Id = AUS.Installed_Software_Id AND IS.Software_id=SW.Software_id GROUP BY SW.Software_Name) AS TEMP";
//	
//	@Override
//	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
//	public ArrayList paginatedList(Account account, int startIndex,
//			int objectsPerPage, String sort, String dir) {
//		// TODO Auto-generated method stub
//		
//		//needs to be changed for SOM3 logic, 
//		
//		StringBuffer query = new StringBuffer(SQL_SELECT_UNLICENSED_SW_BY_ACCOUNT_ID_AND_TYPE)
//				.append(sort).append(" ").append(dir);
//		
//
//		Query q = super.getEntityManager().createQuery(query.toString());
//		q.setParameter("account", account);
//		q.setParameter("type", "SCOPE");
//		q.setFirstResult(startIndex);
//		q.setMaxResults(objectsPerPage);
//		return (ArrayList) q.getResultList();
//	}
//
//	@Override
//	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
//	public Long total(Account account) {
//		// TODO Auto-generated method stub
//		Query q = super.getEntityManager().createNamedQuery(
//				"alertHardwareCfgDataTotalByAccount");
//		q.setParameter("account", account);
//
//		return ((Long) q.getSingleResult());
//	}
//
//	@Override
//	public ArrayList paginatedList(String remoteUser, int startIndex,
//			int objectsPerPage, String sort, String dir) {
//		// TODO Auto-generated method stub
//		return null;
//	}
//
//	@Override
//	public Long total(String remoteUser) {
//		// TODO Auto-generated method stub
//		return 0L;
//	}
//
//	@Override
//	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
//	public void assign(List<Long> list, String remoteUser, String comments) {
//		// TODO Auto-generated method stub
//		for(Long id: list){
//			AlertWithDefinedContractScope alertWithDefinedContractScope = super.getEntityManager().find(AlertWithDefinedContractScope.class, id);
//			
////			createHistory(alertWithDefinedContractScope);
//			alertWithDefinedContractScope.setRemoteUser(remoteUser);
//			alertWithDefinedContractScope.setComments(comments);
//			alertWithDefinedContractScope.setRecordTime(new Date());
//
//			super.getEntityManager().merge(alertWithDefinedContractScope);
//			super.getEntityManager().flush();
//		}
//	}
//
//	@Override
//	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
//	public void unassign(List<Long> alertIds, String remoteUser, String comments) {
//		// TODO Auto-generated method stub
//		for(Long id: alertIds){
//			AlertWithDefinedContractScope alertWithDefinedContractScope = super.getEntityManager().find(AlertWithDefinedContractScope.class, id);
//			
////			createHistory(alertHardwareCfgData);
//			alertWithDefinedContractScope.setRemoteUser("STAGING");
//			alertWithDefinedContractScope.setComments(comments);
//			alertWithDefinedContractScope.setRecordTime(new Date());
//
//			super.getEntityManager().merge(alertWithDefinedContractScope);
//			super.getEntityManager().flush();
//		}
//	}
//
//	@Override
//	public void updateAll(Account pAccount, String psRemoteUser,
//			String psComments, int piMode) {
//		// TODO Auto-generated method stub
//		
//		
//		
//		StringBuffer sb =new StringBuffer();
//		sb.append("SELECT ahc.Id FROM eaadmin.Alert_Hardware_CfgData ahc, eaadmin.Hardware hw, eaadmin.Customer_Number cn WHERE ahc.Open = 1 AND ahc.Hardware_Id = hw.Id AND hw.Customer_Number = cn.Customer_Number AND cn.Customer_Id = :customerId")
//		.append(piMode == MODE_UNASSIGN ? " AND ahc.Remote_User = :remoteUser" : "")
//		.append(" UNION ALL SELECT ahc.Id FROM eaadmin.Alert_Hardware_CfgData ahc, eaadmin.Hardware hw, eaadmin.Customer c WHERE ahc.Open = 1 AND ahc.Hardware_Id = hw.Id AND hw.Account_Number = CAST(c.Account_Number AS CHAR(8)) AND c.Customer_Id = :customerId")
//		.append(piMode == MODE_UNASSIGN ? " AND ahc.Remote_User = :remoteUser" : "");
//	
//		Query query = super.getEntityManager().createNativeQuery(sb.toString());	
//		query.setParameter("customerId", pAccount.getId());
//		if (piMode == MODE_UNASSIGN) {
//			query.setParameter("remoteUser", psRemoteUser);
//		}
//		
//		List<BigInteger> alertHardwareCfgDataIdList = null;
//		alertHardwareCfgDataIdList = query.getResultList();
//		
//		for (BigInteger alertHardwareCfgDataId : alertHardwareCfgDataIdList) {
//			
//			AlertHardwareCfgData alertHardwareCfgData = super.getEntityManager().find(AlertHardwareCfgData.class, alertHardwareCfgDataId.longValue());
////			createHistory(alertHardwareCfgData);
//			if (piMode == MODE_UNASSIGN) {
//				alertHardwareCfgData.setRemoteUser("STAGING");
//			} else if (piMode == MODE_ASSIGN) {
//				alertHardwareCfgData.setRemoteUser(psRemoteUser);
//			}
//			alertHardwareCfgData.setComments(psComments);
//			alertHardwareCfgData.setRecordTime(new Date());
//
//			super.getEntityManager().merge(alertHardwareCfgData);
//			super.getEntityManager().flush();
//		}
//	}
//	
//	
//	
//	@Override
//	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
//	public ArrayList getAlertHistory(Long id) {
//		// TODO Auto-generated method stub
//		ArrayList<AlertHistoryReport> list = new ArrayList<AlertHistoryReport>();
//
//		list.addAll(super.getEntityManager()
//				.createNamedQuery("alertHardwareCfgDataHistory")
//				.setParameter("id", id).getResultList());
//
//		AlertHardwareCfgData alertHardwareCfgData = super.getEntityManager().find(AlertHardwareCfgData.class,id);
//		AlertHistoryReport alertHistoryReport = new AlertHistoryReport(alertHardwareCfgData.getComments(),
//				alertHardwareCfgData.getRemoteUser(), alertHardwareCfgData.getCreationTime(), alertHardwareCfgData.getRecordTime(),
//				alertHardwareCfgData.isOpen());
//		list.add(alertHistoryReport);
//
//		return list;
//	}
//	
////	private void createHistory(AlertWithDefinedContractScope alertWithDefinedContractScope) {
////
////		// TODO May be good just to create a constructor
////		AlertHardwareCfgDataH alertHardwareCfgDataH = new AlertHardwareCfgDataH();
////		alertHardwareCfgDataH.setAlertHardwareCfgData(alertHardwareCfgData);
////		alertHardwareCfgDataH.setComments(alertHardwareCfgData.getComments());
////		alertHardwareCfgDataH.setCreationTime(alertHardwareCfgData.getCreationTime());
////		alertHardwareCfgDataH.setOpen(alertHardwareCfgData.isOpen());
////		alertHardwareCfgDataH.setRecordTime(alertHardwareCfgData.getRecordTime());
////		alertHardwareCfgDataH.setRemoteUser(alertHardwareCfgData.getRemoteUser());
////
////		super.getEntityManager().persist(alertHardwareCfgDataH);
////	}
//
//}
