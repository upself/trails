package com.ibm.asset.trails.service.impl;

import java.util.ArrayList;
import java.util.List;

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
        
        
        lQuery.setParameter("accountId", pAccount.getId());
        lQuery.setParameter("type", "SWISCOPE");
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
        lQuery.setParameter("type", "UNDEFINED_SCOPE");
        lQuery.setFirstResult(piStartIndex);
        lQuery.setMaxResults(piObjectsPerPage);
        return (ArrayList) lQuery.getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public Long total(Account account) {
        Query lQuery = super.getEntityManager().createNamedQuery(
                "alertUnlicensedSwTotalByAccountAndType");

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