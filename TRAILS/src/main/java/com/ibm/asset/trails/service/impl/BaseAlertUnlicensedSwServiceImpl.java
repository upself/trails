package com.ibm.asset.trails.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.AlertUnlicensedSwH;
import com.ibm.asset.trails.form.AlertHistoryReport;

public abstract class BaseAlertUnlicensedSwServiceImpl extends
        BaseAlertServiceImpl {

    public final String SQL_SELECT_UNLICENSED_SW_BY_ACCOUNT_ID_AND_TYPE = "SELECT Alert_Age, Software_Item_Name, Alert_Count, Creation_Time FROM (SELECT MAX(DAYS(CURRENT TIMESTAMP) - DAYS(VA.Creation_Time)) AS Alert_Age, SW.Software_Name AS Software_Item_Name, COUNT(*) AS Alert_Count, MIN(VA.Creation_Time) AS Creation_Time FROM EAADMIN.V_Alerts VA, EAADMIN.Alert_Unlicensed_Sw AUS, EAADMIN.Installed_Software IS, EAADMIN.Software SW WHERE VA.Customer_Id = :accountId AND VA.Type = :type AND VA.Open = 1 AND AUS.Id = VA.Id AND IS.Id = AUS.Installed_Software_Id AND IS.Software_id=SW.Software_id GROUP BY SW.Software_Name) AS TEMP";

    public final String SQL_SELECT_UNLICENSED_SW_BY_REMOTE_USER_AND_TYPE = "SELECT Alert_Age, Software_Item_Name, Alert_Count, Creation_Time FROM (SELECT MAX(DAYS(CURRENT TIMESTAMP) - DAYS(VA.Creation_Time)) AS Alert_Age, SW.Software_Name AS Software_Item_Name, COUNT(*) AS Alert_Count, MIN(VA.Creation_Time) AS Creation_Time FROM EAADMIN.V_Alerts VA, EAADMIN.Alert_Unlicensed_Sw AUS, EAADMIN.Installed_Software IS, EAADMIN.Software SW WHERE VA.Remote_User = :remoteUser AND VA.Type = :type AND VA.Open = 1 AND AUS.Id = VA.Id AND IS.Id = AUS.Installed_Software_Id AND IS.Software_id=SW.Software_id GROUP BY SW.Software_Name) AS TEMP";

    private int alertsProcessed;

    private int alertsTotal;

    @Override
    public int getAlertsProcessed() {
        return alertsProcessed;
    }

    @Override
    public void setAlertsProcessed(int alertsProcessed) {
        this.alertsProcessed = alertsProcessed;
    }

    @Override
    public int getAlertsTotal() {
        return alertsTotal;
    }

    @Override
    public void setAlertsTotal(int alertsTotal) {
        this.alertsTotal = alertsTotal;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ArrayList getAlertHistory(Long plId) {
        ArrayList<AlertHistoryReport> lalAlertHistoryReport = new ArrayList<AlertHistoryReport>();
        AlertUnlicensedSw lAlertUnlicensedSw = null;
        AlertHistoryReport lAlertHistoryReport = null;

        lalAlertHistoryReport.addAll(getEntityManager()
                .createNamedQuery("alertUnlicensedSwHistory")
                .setParameter("id", plId).getResultList());
        lAlertUnlicensedSw = getEntityManager().find(AlertUnlicensedSw.class,
                plId);
        lAlertHistoryReport = new AlertHistoryReport(
                lAlertUnlicensedSw.getComments(),
                lAlertUnlicensedSw.getType(),
                lAlertUnlicensedSw.getRemoteUser(),
                lAlertUnlicensedSw.getCreationTime(),
                lAlertUnlicensedSw.getRecordTime(), lAlertUnlicensedSw.isOpen());
        lalAlertHistoryReport.add(lAlertHistoryReport);

        return lalAlertHistoryReport;
    }

    public String translateSort(String psSort, String psDir) {
        StringBuffer lsbSort = new StringBuffer(" ORDER BY ");

        if (psSort.equalsIgnoreCase("alertAge")) {
            lsbSort.append("Alert_Age ");
        } else if (psSort.equalsIgnoreCase("softwareItemName")) {
            lsbSort.append("Software_Item_Name ");
        } else if (psSort.equalsIgnoreCase("alertCount")) {
            lsbSort.append("Alert_Count ");
        }
        lsbSort.append(psDir);

        return lsbSort.toString();
    }

    public void assignAll(String psRemoteUser, String psComments) {
        // TODO Auto-generated method stub
    }

    public void unassignAll(String psRemoteUser, String psComments) {
        // TODO Auto-generated method stub
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void assign(List<Long> alertIds, String psRemoteUser,
            String psComments) {
        setAlertsProcessed(0);
        setAlertsTotal(alertIds.size());
        for (Long alertId : alertIds) {
            AlertUnlicensedSw lausTemp = getEntityManager().find(
                    AlertUnlicensedSw.class, alertId);

            if (lausTemp.isOpen()) {
                createHistory(lausTemp);

                lausTemp.setRemoteUser(psRemoteUser);
                lausTemp.setComments(psComments);
                lausTemp.setRecordTime(new Date());

                super.getEntityManager().merge(lausTemp);
                super.getEntityManager().flush();
            }

            setAlertsProcessed(getAlertsProcessed() + 1);
        }
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void unassign(List<Long> alertIds, String psRemoteUser,
            String psComments) {

        setAlertsProcessed(0);
        setAlertsTotal(alertIds.size());
        for (Long alertId : alertIds) {
            AlertUnlicensedSw lausTemp = getEntityManager().find(
                    AlertUnlicensedSw.class, alertId);

            if (lausTemp.isOpen()) {
                createHistory(lausTemp);

                if (!lausTemp.getRemoteUser().equals(psRemoteUser)) {
                    setAlertsProcessed(getAlertsProcessed() + 1);
                    continue;
                }

                lausTemp.setRemoteUser("STAGING");
                lausTemp.setComments(psComments);
                lausTemp.setRecordTime(new Date());

                super.getEntityManager().merge(lausTemp);
                super.getEntityManager().flush();
            }

            setAlertsProcessed(getAlertsProcessed() + 1);
        }
    }

    private void createHistory(AlertUnlicensedSw aus) {

        // TODO May be good just to create a constructor
        AlertUnlicensedSwH aush = new AlertUnlicensedSwH();
        aush.setAlertUnlicensedSw(aus);
        aush.setComments(aus.getComments());
        aush.setType(aus.getType());
        aush.setCreationTime(aus.getCreationTime());
        aush.setOpen(aus.isOpen());
        aush.setRecordTime(aus.getRecordTime());
        aush.setRemoteUser(aus.getRemoteUser());

        getEntityManager().persist(aush);
    }
}
