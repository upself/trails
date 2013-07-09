package com.ibm.asset.trails.service.impl;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.CountryCode;
import com.ibm.asset.trails.domain.Department;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.domain.Region;
import com.ibm.asset.trails.domain.Sector;
import com.ibm.asset.trails.service.AccountService;

@Service
public class AccountServiceImpl implements AccountService {
    private EntityManager em;

    // "Note that the @PersistenceContext annotation has an optional attribute
    // type, which defaults to PersistenceContextType.TRANSACTION. This default
    // is what you need to receive a "shared EntityManager" proxy. The
    // alternative, PersistenceContextType.EXTENDED, is a completely different
    // affair: This results in a so-called "extended EntityManager", which is
    // not thread-safe and hence must not be used in a concurrently accessed
    // component such as a Spring-managed singleton bean. Extended
    // EntityManagers are only supposed to be used in stateful components that,
    // for example, reside in a session, with the lifecycle of the EntityManager
    // not tied to a current transaction but rather being completely up to the
    // application."
    // AGM: We create the entitymanager factory in the applicationcontext.xml.
    // This is expensive to create so instead of getting a new one, we get an
    // entity manager which is in inexpensive. The @PersistenceContext tells
    // spring to inject the entitymanager.
    @PersistenceContext
    public void setEntityManager(EntityManager em) {
        this.em = em;
    }

    private EntityManager getEntityManager() {
        return em;
    }

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public Account getAccount(Long id) {
        return (Account) getEntityManager().createNamedQuery("accountDetails")
                .setParameter("customerId", id).getSingleResult();
    }

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public CountryCode getCountryCode(Long id) {
        return getEntityManager().find(CountryCode.class, id);
    }

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public Geography getGeography(Long id) {
        return getEntityManager().find(Geography.class, id);
    }

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public Region getRegion(Long id) {
        return getEntityManager().find(Region.class, id);
    }

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public Department getDepartment(Long id) {
        return getEntityManager().find(Department.class, id);
    }

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public Sector getSector(Long id) {
        return getEntityManager().find(Sector.class, id);
    }

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public Account getAccountByAccountNumber(Long accountNumber) {
        @SuppressWarnings("unchecked")
        List<Account> results = getEntityManager()
                .createNamedQuery("accountByAccountNumber")
                .setParameter("accountNumber", accountNumber).getResultList();
        Account result;
        if (results == null || results.isEmpty()) {
            result = null;
        } else {
            result = results.get(0);
        }
        return result;
    }
}