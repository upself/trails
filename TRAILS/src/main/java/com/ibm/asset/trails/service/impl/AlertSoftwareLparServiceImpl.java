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
import com.ibm.asset.trails.domain.AlertSoftwareLpar;
import com.ibm.asset.trails.domain.AlertSoftwareLparH;
import com.ibm.asset.trails.form.AlertHistoryReport;
import com.ibm.asset.trails.form.AlertListForm;
import com.ibm.asset.trails.service.AlertService;

@Service
public class AlertSoftwareLparServiceImpl extends BaseAlertServiceImpl
        implements AlertService {

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList paginatedList(Account account, int startIndex,
            int objectsPerPage, String sort, String dir) {
        StringBuffer query = new StringBuffer(
                "from AlertViewSoftwareLpar a join fetch a.softwareLpar where a.account = :account and a.open = 1 order by a.")
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
                "from AlertViewSoftwareLpar a join fetch a.softwareLpar where a.remoteUser = :remoteUser and a.open = 1 ");

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
                "alertSoftwareLparTotalByAccount");
        q.setParameter("account", account);

        return ((Long) q.getSingleResult());
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public Long total(String remoteUser) {
        Query q = super.getEntityManager().createNamedQuery(
                "alertSoftwareLparTotalByRemoteUser");
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

            AlertSoftwareLpar asl = super.getEntityManager().find(
                    AlertSoftwareLpar.class, alf.getId());
            createHistory(asl);

            if (alf.isUnassign()) {
                asl.setRemoteUser("STAGING");
            } else if (alf.isAssign()) {
                asl.setRemoteUser(remoteUser);
            }
            asl.setComments(comments);
            asl.setRecordTime(new Date());

            super.getEntityManager().merge(asl);
            super.getEntityManager().flush();
        }
    }

    private void createHistory(AlertSoftwareLpar asl) {

        // TODO May be good just to create a constructor
        AlertSoftwareLparH aslh = new AlertSoftwareLparH();
        aslh.setAlertSoftwareLpar(asl);
        aslh.setComments(asl.getComments());
        aslh.setCreationTime(asl.getCreationTime());
        aslh.setOpen(asl.isOpen());
        aslh.setRecordTime(asl.getRecordTime());
        aslh.setRemoteUser(asl.getRemoteUser());

        super.getEntityManager().persist(aslh);
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAlertHistory(Long id) {

        ArrayList<AlertHistoryReport> list = new ArrayList<AlertHistoryReport>();

        list.addAll(super.getEntityManager()
                .createNamedQuery("alertSoftwareLparHistory")
                .setParameter("id", id).getResultList());

        AlertSoftwareLpar asl = super.getEntityManager().find(
                AlertSoftwareLpar.class, id);
        AlertHistoryReport ahr = new AlertHistoryReport(asl.getComments(),
                asl.getRemoteUser(), asl.getCreationTime(),
                asl.getRecordTime(), asl.isOpen());
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
                                "FROM AlertSoftwareLpar ASL JOIN FETCH ASL.softwareLpar SL WHERE ASL.open = 1 AND SL.account = :account")
                                .append(piMode == MODE_UNASSIGN ? " AND ASL.remoteUser = :remoteUser"
                                        : "").toString());
        List<AlertSoftwareLpar> llAlertSoftwareLpar = null;

        lqUpdateAll.setParameter("account", pAccount);
        if (piMode == MODE_UNASSIGN) {
            lqUpdateAll.setParameter("remoteUser", psRemoteUser);
        }
        llAlertSoftwareLpar = lqUpdateAll.getResultList();

        for (AlertSoftwareLpar laslTemp : llAlertSoftwareLpar) {
            createHistory(laslTemp);

            if (piMode == MODE_UNASSIGN) {
                laslTemp.setRemoteUser("STAGING");
            } else if (piMode == MODE_ASSIGN) {
                laslTemp.setRemoteUser(psRemoteUser);
            }
            laslTemp.setComments(psComments);
            laslTemp.setRecordTime(new Date());

            super.getEntityManager().merge(laslTemp);
            super.getEntityManager().flush();
        }
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void unassign(List<Long> findAffectedAlertUnlicensedSwList,
            String remoteUser, String comments) {
        // TODO Auto-generated method stub

    }
}
