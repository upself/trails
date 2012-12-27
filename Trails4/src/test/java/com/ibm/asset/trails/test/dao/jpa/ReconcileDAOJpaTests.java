package com.ibm.asset.trails.test.dao.jpa;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.ReconcileDAO;
import com.ibm.asset.trails.domain.Reconcile;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/applicationContext-test.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class ReconcileDAOJpaTests {

    @Autowired
    private ReconcileDAO dao;
    private final Long reconcileId = 21083987L;

    @Test
    public void testReconcileDetail() {
        Reconcile reconcile = dao.reconcileDetail(reconcileId);
        assertNotNull(reconcile);
    }
}
