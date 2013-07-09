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
import com.ibm.asset.trails.domain.AlertHardwareLpar;
import com.ibm.asset.trails.domain.AlertHardwareLparH;
import com.ibm.asset.trails.form.AlertHistoryReport;
import com.ibm.asset.trails.form.AlertListForm;
import com.ibm.asset.trails.service.AlertService;

@Service
public class AlertHardwareLparServiceImpl extends BaseAlertServiceImpl
        implements AlertService {

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList paginatedList(Account account, int startIndex,
            int objectsPerPage, String sort, String dir) {
        StringBuffer query = new StringBuffer(
                "from AlertViewHardwareLpar a join fetch a.hardwareLpar hl where a.account = :account and a.open = 1 order by a.")
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
                "from AlertViewHardwareLpar a join fetch a.hardwareLpar where a.remoteUser = :remoteUser and a.open = 1 ");

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
                "alertHardwareLparTotalByAccount");
        q.setParameter("account", account);

        return ((Long) q.getSingleResult());
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public Long total(String remoteUser) {
        Query q = super.getEntityManager().createNamedQuery(
                "alertHardwareLparTotalByRemoteUser");
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

            AlertHardwareLpar ahl = super.getEntityManager().find(
                    AlertHardwareLpar.class, alf.getId());
            createHistory(ahl);

            if (alf.isUnassign()) {
                ahl.setRemoteUser("STAGING");
            } else if (alf.isAssign()) {
                ahl.setRemoteUser(remoteUser);
            }

            ahl.setComments(comments);
            ahl.setRecordTime(new Date());

            super.getEntityManager().merge(ahl);
            super.getEntityManager().flush();
        }
    }

    private void createHistory(AlertHardwareLpar ahl) {

        // TODO May be good just to create a constructor
        AlertHardwareLparH ahlh = new AlertHardwareLparH();
        ahlh.setAlertHardwareLpar(ahl);
        ahlh.setComments(ahl.getComments());
        ahlh.setCreationTime(ahl.getCreationTime());
        ahlh.setOpen(ahl.isOpen());
        ahlh.setRecordTime(ahl.getRecordTime());
        ahlh.setRemoteUser(ahl.getRemoteUser());

        super.getEntityManager().persist(ahlh);
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAlertHistory(Long id) {

        ArrayList<AlertHistoryReport> list = new ArrayList<AlertHistoryReport>();

        list.addAll(super.getEntityManager()
                .createNamedQuery("alertHardwareLparHistory")
                .setParameter("id", id).getResultList());

        AlertHardwareLpar ahl = super.getEntityManager().find(
                AlertHardwareLpar.class, id);
        AlertHistoryReport ahr = new AlertHistoryReport(ahl.getComments(),
                ahl.getRemoteUser(), ahl.getCreationTime(),
                ahl.getRecordTime(), ahl.isOpen());
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
                                "FROM AlertHardwareLpar AHL JOIN FETCH AHL.hardwareLpar HL WHERE AHL.open = 1 AND HL.account = :account")
                                .append(piMode == MODE_UNASSIGN ? " AND AHL.remoteUser = :remoteUser"
                                        : "").toString());
        List<AlertHardwareLpar> llAlertHardwareLpar = null;

        lqUpdateAll.setParameter("account", pAccount);
        if (piMode == MODE_UNASSIGN) {
            lqUpdateAll.setParameter("remoteUser", psRemoteUser);
        }
        llAlertHardwareLpar = lqUpdateAll.getResultList();

        for (AlertHardwareLpar lahlTemp : llAlertHardwareLpar) {
            createHistory(lahlTemp);

            if (piMode == MODE_UNASSIGN) {
                lahlTemp.setRemoteUser("STAGING");
            } else if (piMode == MODE_ASSIGN) {
                lahlTemp.setRemoteUser(psRemoteUser);
            }
            lahlTemp.setComments(psComments);
            lahlTemp.setRecordTime(new Date());

            super.getEntityManager().merge(lahlTemp);
            super.getEntityManager().flush();
        }
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void unassign(List<Long> findAffectedAlertUnlicensedSwList,
            String remoteUser, String comments) {
        // TODO Auto-generated method stub

    }
}
