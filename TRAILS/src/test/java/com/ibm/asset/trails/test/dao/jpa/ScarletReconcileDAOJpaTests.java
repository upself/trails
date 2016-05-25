package com.ibm.asset.trails.test.dao.jpa;

import static org.junit.Assert.assertNotNull;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import com.ibm.asset.trails.dao.ScarletReconcileDAO;
import com.ibm.asset.trails.domain.ScarletReconcile;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/h2/applicationContext-test-h2.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional(propagation = Propagation.REQUIRED)
public class ScarletReconcileDAOJpaTests {

    @Autowired
    private ScarletReconcileDAO scarletReconcileDAO;
    
    @Test
	public void testScheduleFfindSoftwareByName(){
		ScarletReconcile scarletReconcile = scarletReconcileDAO.findById(1L);
		assertNotNull(scarletReconcile);
	}

}
