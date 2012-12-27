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
import com.ibm.asset.trails.domain.AlertExpiredScan;
import com.ibm.asset.trails.domain.AlertExpiredScanH;
import com.ibm.asset.trails.form.AlertHistoryReport;
import com.ibm.asset.trails.form.AlertListForm;
import com.ibm.asset.trails.service.AlertService;

@Service
public class AlertExpiredScanServiceImpl extends BaseAlertServiceImpl implements
        AlertService {

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList paginatedList(Account account, int startIndex,
            int objectsPerPage, String sort, String dir) {
        StringBuffer query = new StringBuffer(
                "from AlertViewExpiredScan a join fetch a.softwareLpar where a.account = :account and a.open = 1 order by a.")
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
                "from AlertViewExpiredScan a join fetch a.softwareLpar where a.remoteUser = :remoteUser and a.open = 1 ");

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
                "alertExpiredScanTotalByAccount");
        q.setParameter("account", account);

        return ((Long) q.getSingleResult());
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public Long total(String remoteUser) {
        Query q = super.getEntityManager().createNamedQuery(
                "alertExpiredScanTotalByRemoteUser");
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

            AlertExpiredScan aes = super.getEntityManager().find(
                    AlertExpiredScan.class, alf.getId());
            createHistory(aes);

            if (alf.isUnassign()) {
                aes.setRemoteUser("STAGING");
            } else if (alf.isAssign()) {
                aes.setRemoteUser(remoteUser);
            }

            aes.setComments(comments);
            aes.setRecordTime(new Date());

            super.getEntityManager().merge(aes);
            super.getEntityManager().flush();
        }
    }

    private void createHistory(AlertExpiredScan aes) {

        // TODO May be good just to create a constructor
        AlertExpiredScanH aesh = new AlertExpiredScanH();
        aesh.setAlertExpiredScan(aes);
        aesh.setComments(aes.getComments());
        aesh.setCreationTime(aes.getCreationTime());
        aesh.setOpen(aes.isOpen());
        aesh.setRecordTime(aes.getRecordTime());
        aesh.setRemoteUser(aes.getRemoteUser());

        super.getEntityManager().persist(aesh);
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAlertHistory(Long id) {

        ArrayList<AlertHistoryReport> list = new ArrayList<AlertHistoryReport>();

        list.addAll(super.getEntityManager()
                .createNamedQuery("alertExpiredScanHistory")
                .setParameter("id", id).getResultList());

        AlertExpiredScan aes = super.getEntityManager().find(
                AlertExpiredScan.class, id);
        AlertHistoryReport ahr = new AlertHistoryReport(aes.getComments(),
                aes.getRemoteUser(), aes.getCreationTime(),
                aes.getRecordTime(), aes.isOpen());
        list.add(ahr);

        return list;
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
                                "FROM AlertExpiredScan AES JOIN FETCH AES.softwareLpar SL WHERE AES.open = 1 AND SL.account = :account")
                                .append(piMode == MODE_UNASSIGN ? " AND AES.remoteUser = :remoteUser"
                                        : "").toString());
        List<AlertExpiredScan> llAlertExpiredScan = null;

        lqUpdateAll.setParameter("account", pAccount);
        if (piMode == MODE_UNASSIGN) {
            lqUpdateAll.setParameter("remoteUser", psRemoteUser);
        }
        llAlertExpiredScan = lqUpdateAll.getResultList();

        for (AlertExpiredScan laesTemp : llAlertExpiredScan) {
            createHistory(laesTemp);

            if (piMode == MODE_UNASSIGN) {
                laesTemp.setRemoteUser("STAGING");
            } else if (piMode == MODE_ASSIGN) {
                laesTemp.setRemoteUser(psRemoteUser);
            }
            laesTemp.setComments(psComments);
            laesTemp.setRecordTime(new Date());

            super.getEntityManager().merge(laesTemp);
            super.getEntityManager().flush();
        }
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void unassign(List<Long> findAffectedAlertUnlicensedSwList,
            String remoteUser, String comments) {
        // TODO Auto-generated method stub

    }
}
