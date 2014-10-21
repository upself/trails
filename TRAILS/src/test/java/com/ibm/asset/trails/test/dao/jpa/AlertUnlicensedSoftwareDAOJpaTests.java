package com.ibm.asset.trails.test.dao.jpa;

import static org.junit.Assert.assertEquals;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.AlertUnlicensedSoftwareDAO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/applicationContext-test.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class AlertUnlicensedSoftwareDAOJpaTests {

    @Autowired
    private AlertUnlicensedSoftwareDAO alertUnlicensedSoftwareDAO;

    @Test
    public void testFindAffectedAlertList() {
        Long alertId = 11300170L;
        Long accountId = 9286L;
        List<Long> alertIds = alertUnlicensedSoftwareDAO.findAffectedLicenseAlertList(accountId,
                alertId);
        for (Long alert : alertIds) {
            System.out.println(alert);
        }
        assertEquals(alertIds.size(), 5);
    }
}
