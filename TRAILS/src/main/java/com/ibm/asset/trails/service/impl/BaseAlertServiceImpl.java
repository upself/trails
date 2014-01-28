package com.ibm.asset.trails.service.impl;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;


import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;

public abstract class BaseAlertServiceImpl {
    public final int MODE_ASSIGN = 1;

    public final int MODE_UNASSIGN = 2;
   
    private EntityManager em;
    @Transactional
    public void assignAll(Account pAccount, String psRemoteUser,
            String psComments) {
        updateAll(pAccount, psRemoteUser, psComments, MODE_ASSIGN);
    }
    @Transactional
    public void unassignAll(Account pAccount, String psRemoteUser,
            String psComments) {
        updateAll(pAccount, psRemoteUser, psComments, MODE_UNASSIGN);
    }
    @Transactional
    public abstract void updateAll(Account pAccount, String psRemoteUser,
            String psComments, int piMode);

    @PersistenceContext(unitName="trailspd")
    public void setEntityManager(EntityManager em) {
        this.em = em;
    }
  
    public EntityManager getEntityManager() {
        return em;
    }

    public int getAlertsProcessed() {
        return 0;
    }

    public void setAlertsProcessed(int piAlertsProcessed) {
    }

    public int getAlertsTotal() {
        return 0;
    }

    public void setAlertsTotal(int piAlertsTotal) {
    }
}
