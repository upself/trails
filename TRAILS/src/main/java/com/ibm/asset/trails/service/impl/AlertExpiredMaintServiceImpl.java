package com.ibm.asset.trails.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertExpiredMaint;
import com.ibm.asset.trails.domain.AlertExpiredMaintH;
import com.ibm.asset.trails.domain.AlertViewExpiredMaint;
import com.ibm.asset.trails.form.AlertHistoryReport;
import com.ibm.asset.trails.form.AlertListForm;
import com.ibm.asset.trails.service.AlertService;

@Service
public class AlertExpiredMaintServiceImpl extends BaseAlertServiceImpl
        implements AlertService {

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertViewExpiredMaint> paginatedList(Account pAccount,
            int piStartIndex, int piObjectsPerPage, String psSort, String psDir) {
        String lsQuery = new StringBuffer(
                "FROM AlertViewExpiredMaint AVEM JOIN FETCH AVEM.license L LEFT JOIN FETCH L.software S WHERE AVEM.account = :account AND AVEM.open = 1 ORDER BY ")
                .append(translateSort(psSort)).append(" ").append(psDir)
                .toString();
        Query lQuery = super.getEntityManager().createQuery(lsQuery);

        lQuery.setParameter("account", pAccount);
        lQuery.setFirstResult(piStartIndex);
        lQuery.setMaxResults(piObjectsPerPage);
        return (ArrayList<AlertViewExpiredMaint>) lQuery.getResultList();
    }

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList<AlertViewExpiredMaint> paginatedList(String psRemoteUser,
            int piStartIndex, int piObjectsPerPage, String psSort, String psDir) {
        String lsQuery = new StringBuffer(
                "FROM AlertViewExpiredMaint AVEM JOIN FETCH AVEM.license L LEFT JOIN FETCH L.software S WHERE AVEM.remoteUser = :remoteUser AND AVEM.open = 1 ORDER BY ")
                .append(translateSort(psSort)).append(" ").append(psDir)
                .toString();
        Query lQuery = super.getEntityManager().createQuery(lsQuery);

        lQuery.setParameter("remoteUser", psRemoteUser);
        lQuery.setFirstResult(piStartIndex);
        lQuery.setMaxResults(piObjectsPerPage);
        return (ArrayList) lQuery.getResultList();
    }

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public Long total(Account pAccount) {
        Query lQuery = super.getEntityManager().createNamedQuery(
                "alertExpiredMaintTotalByAccount");
        lQuery.setParameter("account", pAccount);

        return ((Long) lQuery.getSingleResult());
    }

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public Long total(String psRemoteUser) {
        Query lQuery = super.getEntityManager().createNamedQuery(
                "alertExpiredMaintTotalByRemoteUser");
        lQuery.setParameter("remoteUser", psRemoteUser);

        return ((Long) lQuery.getSingleResult());
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void assign(List pList, String psRemoteUser, String psComments) {
        Iterator liList = pList.iterator();
        AlertListForm lalfTemp = null;
        AlertExpiredMaint laemTemp = null;

        while (liList.hasNext()) {
            lalfTemp = (AlertListForm) liList.next();

            if (!lalfTemp.isAssign()) {
                if (!lalfTemp.isUnassign()) {
                    continue;
                }
            }

            laemTemp = super.getEntityManager().find(AlertExpiredMaint.class,
                    lalfTemp.getId());
            createHistory(laemTemp);

            if (lalfTemp.isUnassign()) {
                laemTemp.setRemoteUser("STAGING");
            } else if (lalfTemp.isAssign()) {
                laemTemp.setRemoteUser(psRemoteUser);
            }

            laemTemp.setComments(psComments);
            laemTemp.setRecordTime(new Date());

            super.getEntityManager().merge(laemTemp);
            super.getEntityManager().flush();
        }
    }

    private void createHistory(AlertExpiredMaint pAlertExpiredMaint) {
        // TODO May be good just to create a constructor
        AlertExpiredMaintH lAlertExpiredMaintH = new AlertExpiredMaintH();
        lAlertExpiredMaintH.setAlertExpiredMaint(pAlertExpiredMaint);
        lAlertExpiredMaintH.setComments(pAlertExpiredMaint.getComments());
        lAlertExpiredMaintH.setCreationTime(pAlertExpiredMaint
                .getCreationTime());
        lAlertExpiredMaintH.setOpen(pAlertExpiredMaint.isOpen());
        lAlertExpiredMaintH.setRecordTime(pAlertExpiredMaint.getRecordTime());
        lAlertExpiredMaintH.setRemoteUser(pAlertExpiredMaint.getRemoteUser());

        super.getEntityManager().persist(lAlertExpiredMaintH);
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAlertHistory(Long plId) {
        ArrayList<AlertHistoryReport> lalAlertHistoryReport = new ArrayList<AlertHistoryReport>();
        AlertExpiredMaint lAlertExpiredMaint = null;
        AlertHistoryReport lAlertHistoryReport = null;

        lalAlertHistoryReport.addAll(super.getEntityManager()
                .createNamedQuery("alertExpiredMaintHistory")
                .setParameter("id", plId).getResultList());
        lAlertExpiredMaint = super.getEntityManager().find(
                AlertExpiredMaint.class, plId);
        lAlertHistoryReport = new AlertHistoryReport(
                lAlertExpiredMaint.getComments(),
                lAlertExpiredMaint.getRemoteUser(),
                lAlertExpiredMaint.getCreationTime(),
                lAlertExpiredMaint.getRecordTime(), lAlertExpiredMaint.isOpen());
        lalAlertHistoryReport.add(lAlertHistoryReport);

        return lalAlertHistoryReport;
    }

    @SuppressWarnings("unchecked")
    @Override
    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void updateAll(Account pAccount, String psRemoteUser,
            String psComments, int piMode) {
        Query lqUpdateAll = super
                .getEntityManager()
                .createQuery(
                        new StringBuffer(
                                "FROM AlertExpiredMaint AEM JOIN FETCH AEM.license L WHERE AEM.open = 1 AND L.account = :account")
                                .append(piMode == MODE_UNASSIGN ? " AND AEM.remoteUser = :remoteUser"
                                        : "").toString());
        List<AlertExpiredMaint> llAlertExpiredMaint = null;

        lqUpdateAll.setParameter("account", pAccount);
        if (piMode == MODE_UNASSIGN) {
            lqUpdateAll.setParameter("remoteUser", psRemoteUser);
        }
        llAlertExpiredMaint = lqUpdateAll.getResultList();

        for (AlertExpiredMaint laemTemp : llAlertExpiredMaint) {
            createHistory(laemTemp);

            if (piMode == MODE_UNASSIGN) {
                laemTemp.setRemoteUser("STAGING");
            } else if (piMode == MODE_ASSIGN) {
                laemTemp.setRemoteUser(psRemoteUser);
            }
            laemTemp.setComments(psComments);
            laemTemp.setRecordTime(new Date());

            super.getEntityManager().merge(laemTemp);
            super.getEntityManager().flush();
        }
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void accept(List<AlertListForm> pList, String psRemoteUser,
            String psComments) {
        AlertExpiredMaint laemTemp = null;

        for (AlertListForm lalfTemp : pList) {
            laemTemp = super.getEntityManager().find(AlertExpiredMaint.class,
                    lalfTemp.getId());
            laemTemp.setOpen(false);
            laemTemp.setComments(psComments);
            laemTemp.setRecordTime(new Date());

            createHistory(laemTemp);
            super.getEntityManager().merge(laemTemp);
            super.getEntityManager().flush();
        }
    }

    private String translateSort(String psSort) {
        if (psSort.startsWith("COALESCE")) {
            return psSort;
        } else {
            return new StringBuffer("AVEM.").append(psSort).toString();
        }
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void unassign(List<Long> findAffectedAlertUnlicensedSwList,
            String remoteUser, String comments) {
        // TODO Auto-generated method stub

    }

}
