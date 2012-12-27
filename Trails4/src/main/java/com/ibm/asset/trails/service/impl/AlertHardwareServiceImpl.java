package com.ibm.asset.trails.service.impl;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertHardware;
import com.ibm.asset.trails.domain.AlertHardwareH;
import com.ibm.asset.trails.form.AlertHistoryReport;
import com.ibm.asset.trails.form.AlertListForm;
import com.ibm.asset.trails.service.AlertService;

@Service
public class AlertHardwareServiceImpl extends BaseAlertServiceImpl implements
        AlertService {

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList paginatedList(Account account, int startIndex,
            int objectsPerPage, String sort, String dir) {
        StringBuffer query = new StringBuffer(
                "from AlertViewHardware a join fetch a.hardware where a.account = :account and a.open = 1 order by a.")
                .append(sort).append(" ").append(dir);

        Query q = super.getEntityManager().createQuery(query.toString());
        q.setParameter("account", account);
        q.setFirstResult(startIndex);
        q.setMaxResults(objectsPerPage);
        return (ArrayList) q.getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList paginatedList(String remoteUser, int startIndex,
            int objectsPerPage, String sort, String dir) {

        StringBuffer query = new StringBuffer(
                "from AlertViewHardware a join fetch a.hardware where a.remoteUser = :remoteUser and a.open = 1 ");

        query.append("order by a." + sort + " " + dir);

        Query q = super.getEntityManager().createQuery(query.toString());
        q.setParameter("remoteUser", remoteUser);
        q.setFirstResult(startIndex);
        q.setMaxResults(objectsPerPage);
        return (ArrayList) q.getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public Long total(Account account) {
        Query q = super.getEntityManager().createNamedQuery(
                "alertHardwareTotalByAccount");
        q.setParameter("account", account);

        return ((Long) q.getSingleResult());
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public Long total(String remoteUser) {
        Query q = super.getEntityManager().createNamedQuery(
                "alertHardwareByRemoteUser");
        q.setParameter("remoteUser", remoteUser);

        return ((Long) q.getSingleResult());
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void assign(List list, String remoteUser, String comments) {

        Iterator i = list.iterator();
        while (i.hasNext()) {
            AlertListForm alf = (AlertListForm) i.next();

            if (!alf.isAssign()) {
                if (!alf.isUnassign()) {
                    continue;
                }
            }

            AlertHardware ah = super.getEntityManager().find(
                    AlertHardware.class, alf.getId());
            createHistory(ah);

            if (alf.isUnassign()) {
                ah.setRemoteUser("STAGING");
            } else if (alf.isAssign()) {
                ah.setRemoteUser(remoteUser);
            }

            ah.setComments(comments);
            ah.setRecordTime(new Date());

            super.getEntityManager().merge(ah);
            super.getEntityManager().flush();
        }
    }

    private void createHistory(AlertHardware ah) {

        // TODO May be good just to create a constructor
        AlertHardwareH ahh = new AlertHardwareH();
        ahh.setAlertHardware(ah);
        ahh.setComments(ah.getComments());
        ahh.setCreationTime(ah.getCreationTime());
        ahh.setOpen(ah.isOpen());
        ahh.setRecordTime(ah.getRecordTime());
        ahh.setRemoteUser(ah.getRemoteUser());

        super.getEntityManager().persist(ahh);
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAlertHistory(Long id) {

        ArrayList<AlertHistoryReport> list = new ArrayList<AlertHistoryReport>();

        list.addAll(super.getEntityManager()
                .createNamedQuery("alertHardwareHistory")
                .setParameter("id", id).getResultList());

        AlertHardware ah = super.getEntityManager().find(AlertHardware.class,
                id);
        AlertHistoryReport ahr = new AlertHistoryReport(ah.getComments(),
                ah.getRemoteUser(), ah.getCreationTime(), ah.getRecordTime(),
                ah.isOpen());
        list.add(ahr);

        return list;
    }

    @SuppressWarnings("unchecked")
    @Override
    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void updateAll(Account pAccount, String psRemoteUser,
            String psComments, int piMode) {
        Query lqSelectAlertHardwareIdList = super
                .getEntityManager()
                .createNativeQuery(
                        new StringBuffer(
                                "SELECT AH.Id FROM eaadmin.Alert_Hardware AH, eaadmin.Hardware H, eaadmin.Customer_Number CN WHERE AH.Open = 1 AND AH.Hardware_Id = H.Id AND H.Customer_Number = CN.Customer_Number AND CN.Customer_Id = :customerId")
                                .append(piMode == MODE_UNASSIGN ? " AND AH.Remote_User = :remoteUser"
                                        : "")
                                .append(" UNION ALL SELECT AH.Id FROM eaadmin.Alert_Hardware AH, eaadmin.Hardware H, eaadmin.Customer C WHERE AH.Open = 1 AND AH.Hardware_Id = H.Id AND H.Account_Number = CAST(C.Account_Number AS CHAR(8)) AND C.Customer_Id = :customerId")
                                .append(piMode == MODE_UNASSIGN ? " AND AH.Remote_User = :remoteUser"
                                        : "").toString());
        List<BigInteger> llAlertHardwareIdList = null;
//       Query lqUpdateAll = super.getEntityManager().createQuery(
//                "FROM AlertHardware WHERE id IN (:alertHardwareIdList)");
        lqSelectAlertHardwareIdList
                .setParameter("customerId", pAccount.getId());
        if (piMode == MODE_UNASSIGN) {
            lqSelectAlertHardwareIdList
                    .setParameter("remoteUser", psRemoteUser);
        }
        llAlertHardwareIdList = lqSelectAlertHardwareIdList.getResultList();
        for (BigInteger llAlertHardwareId : llAlertHardwareIdList) {
        //	lqUpdateAll.setParameter("alertHardwareIdList", Long.valueOf(llAlertHardwareId.longValue()));
      //  	System.out.print("testing out result is "+ Long.valueOf(llAlertHardwareId.toString()));
        	AlertHardware lahTemp = super.getEntityManager().find(AlertHardware.class, llAlertHardwareId.longValue());
            createHistory(lahTemp);

            if (piMode == MODE_UNASSIGN) {
                lahTemp.setRemoteUser("STAGING");
            } else if (piMode == MODE_ASSIGN) {
                lahTemp.setRemoteUser(psRemoteUser);
            }
            lahTemp.setComments(psComments);
            lahTemp.setRecordTime(new Date());

           super.getEntityManager().merge(lahTemp);
           super.getEntityManager().flush();
        }
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void unassign(List<Long> findAffectedAlertUnlicensedSwList,
            String remoteUser, String comments) {
        // TODO Auto-generated method stub

    }
}
