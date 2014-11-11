package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ReconcileDAO;
import com.ibm.asset.trails.domain.Reconcile;

@Repository
public class ReconcileDAOJpa extends
        AbstractGenericEntityDAOJpa<Reconcile, Long> implements ReconcileDAO {

    public Reconcile reconcileDetail(Long id) {
        return (Reconcile) entityManager
                .createQuery(
                        "from Reconcile a join fetch a.reconcileType join fetch a.installedSoftware join fetch a.installedSoftware.softwareLpar join fetch a.installedSoftware.softwareLpar.hardwareLpar join fetch a.installedSoftware.softwareLpar.hardwareLpar.hardware join fetch a.installedSoftware.softwareLpar.hardwareLpar.hardware.machineType join fetch a.installedSoftware.software join fetch a.parentInstalledSoftware join fetch a.parentInstalledSoftware.software left join fetch a.usedLicenses b left join fetch b.license left join fetch b.license.productInfo where a.id = :id")
                .setParameter("id", id).getSingleResult();
    }

}
