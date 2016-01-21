package com.ibm.asset.trails.service.impl;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Example;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AccountSearch;
import com.ibm.asset.trails.service.SearchService;

@Service
public class SearchServiceImpl implements SearchService {
    private EntityManager em;

    // "Note that the @PersistenceContext(unitName="trailspd") annotation has an optional attribute
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
    // entity manager which is in inexpensive. The @PersistenceContext(unitName="trailspd") tells
    // spring to inject the entitymanager.
    @PersistenceContext(unitName="trailspd")
    public void setEntityManager(EntityManager em) {
        this.em = em;
    }

    private EntityManager getEntityManager() {
        return em;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<AccountSearch> searchAccounts(String searchString,
            boolean outOfScopeSearch, boolean nameSearch,
            boolean accountNumberSearch) throws Exception {

        Account account = new Account();

        if (nameSearch && accountNumberSearch) {
            // don't do anything
        } else if (nameSearch) {
            account.setName(searchString);
        } else if (accountNumberSearch) {
            account.setAccountStr(searchString);
        } else {
            throw new Exception("Illegal search criteria");
        }

        Example exampleAccount = Example.create(account).ignoreCase()
                .enableLike(MatchMode.ANYWHERE);

        return searchAccount(exampleAccount, outOfScopeSearch,
                accountNumberSearch, nameSearch, searchString);

    }

    @SuppressWarnings("unchecked")
    private List<AccountSearch> searchAccount(Example account,
            boolean outOfScopeSearch, boolean accountNumberSearch,
            boolean nameSearch, String searchString) {

        Session session = (Session) getEntityManager().getDelegate();

        Criteria criteria = session
                .createCriteria(Account.class)
                .createAlias("dpe", "d", CriteriaSpecification.LEFT_JOIN)
                .createAlias("industry", "i")
                .createAlias("accountType", "a")
                .createAlias("department", "dt")
                .createAlias("sector", "s", CriteriaSpecification.LEFT_JOIN)
                .setProjection(
                        Projections
                                .projectionList()
                                .add(Projections.id().as("accountId"))
                                .add(Projections.property("name").as(
                                        "accountName"))
                                .add(Projections.property("account").as(
                                        "account"))
                                .add(Projections.property("swlm").as("scope"))
                                .add(Projections.property("d.name").as("dpe"))
                                .add(Projections.property("s.name")
                                        .as("sector"))
                                .add(Projections.property("a.name").as("type"))
                                .add(Projections.property("dt.name").as("dept")))
                .add(account)
                .add(Restrictions.eq("status", "ACTIVE"))
                .setResultTransformer(
                        new AliasToBeanResultTransformer(AccountSearch.class));

        if (nameSearch && accountNumberSearch) {
            criteria.add(Restrictions.or(Restrictions.ilike("accountStr",
                    searchString, MatchMode.ANYWHERE), Restrictions.ilike(
                    "name", searchString, MatchMode.ANYWHERE)));
        }

        if (!outOfScopeSearch) {
            criteria.add(Restrictions.eq("swlm", "YES"));
        }

        return criteria.list();
    }
}