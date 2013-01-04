package com.ibm.asset.trails.dao.jpa;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.AlertUnlicensedSoftwareDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.ReconWorkspace;

@Repository
public class AlertUnlicensedSoftwareDAOJpa extends
        AbstractGenericEntityDAOJpa<AlertUnlicensedSw, Long> implements
        AlertUnlicensedSoftwareDAO {

    @SuppressWarnings("unchecked")
    public List<Long> findAffectedAlertList(Long accountId, Long productInfoId,
            boolean overwriteAuto, boolean overwriteManual, String owner,
            boolean includeOpenAlerts) {
        ArrayList<BigInteger> lalbiAlertUnlicensedSwId = new ArrayList<BigInteger>();
        ArrayList<Long> lallAlertUnlicensedSwId = new ArrayList<Long>();
        String lsOwnerFromClause = null;
        String lsOwnerWhereClause = null;
        StringBuffer lsbQuery = new StringBuffer();

        if (!owner.equals("ALL")) {
            lsOwnerFromClause = ", EAADMIN.Hw_Sw_Composite HSC, EAADMIN.Hardware_Lpar HL, EAADMIN.Hardware H";
            lsOwnerWhereClause = "AND HSC.Software_Lpar_Id = SL.Id AND HL.Id = HSC.Hardware_Lpar_Id AND H.Id = HL.Hardware_Id AND H.Owner = :owner ";
        } else {
            lsOwnerFromClause = "";
            lsOwnerWhereClause = "";
        }

        if (includeOpenAlerts) {
            // This query will get all open alerts that meet our criteria. The
            // manual
            // and automated variables do not come into play
            lsbQuery.append(
                    "SELECT AUS.Id FROM EAADMIN.Alert_Unlicensed_Sw AUS, EAADMIN.Installed_Software IS, EAADMIN.Software_Lpar SL, EAADMIN.Software_Item SI")
                    .append(lsOwnerFromClause)
                    .append(" WHERE AUS.Open = 1 AND SL.Customer_Id = :customerId AND SI.Id = :softwareItemId AND IS.Id = AUS.Installed_Software_Id AND SL.Id = IS.Software_Lpar_Id AND SI.Id = IS.Software_Id ")
                    .append(lsOwnerWhereClause);
        }

        if (overwriteAuto) {
            lsbQuery.append(lsbQuery.length() > 0 ? "UNION " : "")
                    .append("SELECT AUS.Id FROM EAADMIN.Alert_Unlicensed_Sw AUS, EAADMIN.Installed_Software IS, EAADMIN.Software_Lpar SL, EAADMIN.Software_Item SI, EAADMIN.Reconcile R, EAADMIN.Reconcile_Type RT")
                    .append(lsOwnerFromClause)
                    .append(" WHERE SL.Customer_Id = :customerId AND SI.Id = :softwareItemId AND IS.Id = AUS.Installed_Software_Id AND SL.Id = IS.Software_Lpar_Id AND SI.Id = IS.Software_Id AND R.Installed_Software_Id = IS.Id AND RT.Id = R.Reconcile_Type_Id AND RT.Is_Manual = 0 ")
                    .append(lsOwnerWhereClause);
        }

        if (overwriteManual) {
            lsbQuery.append(lsbQuery.length() > 0 ? "UNION " : "")
                    .append("SELECT AUS.Id FROM EAADMIN.Alert_Unlicensed_Sw AUS, EAADMIN.Installed_Software IS, EAADMIN.Software_Lpar SL, EAADMIN.Software_Item SI, EAADMIN.Reconcile R, EAADMIN.Reconcile_Type RT")
                    .append(lsOwnerFromClause)
                    .append(" WHERE SL.Customer_Id = :customerId AND SI.Id = :softwareItemId AND IS.Id = AUS.Installed_Software_Id AND SL.Id = IS.Software_Lpar_Id AND SI.Id = IS.Software_Id AND R.Installed_Software_Id = IS.Id AND RT.Id = R.Reconcile_Type_Id AND RT.Is_Manual = 1 ")
                    .append(lsOwnerWhereClause);
        }

        if (lsbQuery.length() > 0) {
            if (!owner.equals("ALL")) {
                lalbiAlertUnlicensedSwId.addAll(((Session) entityManager
                        .getDelegate()).createSQLQuery(lsbQuery.toString())
                        .setParameter("customerId", accountId)
                        .setParameter("softwareItemId", productInfoId)
                        .setParameter("owner", owner).list());
            } else {
                lalbiAlertUnlicensedSwId.addAll(((Session) entityManager
                        .getDelegate()).createSQLQuery(lsbQuery.toString())
                        .setParameter("customerId", accountId)
                        .setParameter("softwareItemId", productInfoId).list());
            }

            for (BigInteger lbiAlertUnlicensedSwId : lalbiAlertUnlicensedSwId) {
                lallAlertUnlicensedSwId.add(Long.valueOf(lbiAlertUnlicensedSwId
                        .longValue()));
            }

        }

        return lallAlertUnlicensedSwId;
    }

    public List<Long> findAffectedAlertList(
            List<ReconWorkspace> reconWorkspaces, boolean overwriteAuto,
            boolean overwriteManual) {
        ArrayList<AlertUnlicensedSw> lalAlertUnlicensedSw = new ArrayList<AlertUnlicensedSw>();

        for (ReconWorkspace lrwTemp : reconWorkspaces) {
            AlertUnlicensedSw lausTemp = entityManager.find(
                    AlertUnlicensedSw.class, lrwTemp.getAlertId());

            if (lausTemp.getReconcile() != null) {
                // Add if the overwrite automated reconciles option was checked
                // and if
                // the reconcile was automated
                if (overwriteAuto
                        & !lausTemp.getReconcile().getReconcileType()
                                .isManual()) {
                    sortedListAdd(lalAlertUnlicensedSw, lausTemp);
                }

                // Add if overwrite manual reconciles option was checked and if
                // the
                // reconcile was manual
                if (overwriteManual
                        & lausTemp.getReconcile().getReconcileType().isManual()) {
                    sortedListAdd(lalAlertUnlicensedSw, lausTemp);
                }
            } else {
                sortedListAdd(lalAlertUnlicensedSw, lausTemp);
            }
        }
        List<Long> results = new ArrayList<Long>();
        for (AlertUnlicensedSw aus : lalAlertUnlicensedSw) {
            results.add(aus.getId());
        }

        return results;
    }

    private void sortedListAdd(List<AlertUnlicensedSw> plAlertUnlicensedSw,
            AlertUnlicensedSw pausAdd) {
        if (plAlertUnlicensedSw.size() == 0) {
            plAlertUnlicensedSw.add(pausAdd);
        } else {
            boolean lbAdd = false;
            int liIndex = 0;
            for (AlertUnlicensedSw lausTemp : plAlertUnlicensedSw) {
                if (pausAdd.getCreationTime()
                        .before(lausTemp.getCreationTime())) {
                    lbAdd = true;
                    plAlertUnlicensedSw.add(liIndex, pausAdd);
                    break;
                }
                liIndex++;
            }

            if (!lbAdd) {
                plAlertUnlicensedSw.add(pausAdd);
            }
        }
    }

    @SuppressWarnings("unchecked")
    public List<Long> findAffectedLicenseAlertList(Long accountId, Long alertId) {
        return entityManager
                .createQuery(
                        "select aus.id from AlertUnlicensedSw aus join aus.installedSoftware instSw join instSw.softwareLpar sl join aus.reconcile r join r.reconcileType rt join r.usedLicenses lrm join lrm.license l where sl.account.id = :accountId and rt.manual = 1 and l.id in(select l.id from AlertUnlicensedSw alert join alert.reconcile reconcile join reconcile.reconcileType reconcileType join reconcile.usedLicenses ul join ul.license license where aus.id = :alertId)")
                .setParameter("accountId", accountId)
                .setParameter("alertId", alertId).getResultList();
    }

    @SuppressWarnings("unchecked")
    public List<Long> findAffectedAlertList(List<Long> alertIds) {
        return entityManager.createNamedQuery("alertUnlicensedSwListSelected")
                .setParameter("alertUnlicensedSwIdList", alertIds)
                .getResultList();
    }

    @SuppressWarnings("unchecked")
    public List<Long> findAffectedAlertList(Account pAccount,
            List<Long> llProductInfoId) {
        return entityManager.createNamedQuery("alertUnlicensedSwListAll")
                .setParameter("account", pAccount)
                .setParameter("productInfoIdList", llProductInfoId)
                .getResultList();
    }

    @SuppressWarnings("unchecked")
    public List<Long> findAffectedAlertList(Account pAccount,
            List<Long> llProductInfoId, String psRunOn) {
        return entityManager
                .createNamedQuery("alertUnlicensedSwListByOwner")
                .setParameter("account", pAccount)
                .setParameter("productInfoIdList", llProductInfoId)
                .setParameter("owner",
                        psRunOn.equalsIgnoreCase("IBMHW") ? "IBM" : "CUSTO")
                .getResultList();
    }

    @SuppressWarnings("unchecked")
    public List<Long> findMachineLevelAffected(Long productId, Long hardwareId) {
        String query = "select alert.id from AlertUnlicensedSw alert join alert.installedSoftware instSw join alert.reconcile reconcile join instSw.softwareLpar swLpar join swLpar.hardwareLpar hwLpar join hwLpar.hardware hardware join instSw.productInfo product where reconcile.machineLevel = 1 and product.id = :productId and hardware.id = :hardwareId";
        return entityManager.createQuery(query)
                .setParameter("productId", productId)
                .setParameter("hardwareId", hardwareId).getResultList();
    }

}
