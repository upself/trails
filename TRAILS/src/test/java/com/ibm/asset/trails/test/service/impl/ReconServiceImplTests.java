package com.ibm.asset.trails.test.service.impl;

import static org.junit.Assert.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.AlertUnlicensedSoftwareDAO;
import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.InstalledSoftware;
import com.ibm.asset.trails.domain.Recon;
import com.ibm.asset.trails.domain.Reconcile;
import com.ibm.asset.trails.domain.ReconcileType;
import com.ibm.asset.trails.service.ReconService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/applicationContext-test.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class ReconServiceImplTests {
	@Autowired
	private ReconService reconService;
	@Autowired
	private AlertUnlicensedSoftwareDAO alertDao;

	/*
	 * Author: vndwbwan@cn.ibm.com
	 * Test ReconcileByAlert test (update reconcile comments),Story_25388 in jazzHub 
	 * */
	@Test
	public void reconcileByAlertTest() throws Exception {
		
		Recon recon = new Recon();
		
		ReconcileType reconcileType = new ReconcileType();
		reconcileType.setId(4L);
		reconcileType.setName("Include with other product");
		
		InstalledSoftware is =  new InstalledSoftware();
		is.setId(137310153L);
		
		String comments = "Test comments";
		
		
		recon.setReconcileType(reconcileType);
		recon.setInstalledSoftware(is);
		recon.setComments(comments);
		Long alertId = 16319604L;
		
		
		reconService.reconcileByAlert(alertId, null, recon, "tomcatTest", null, null);
		
		AlertUnlicensedSw alert = alertDao.findById(alertId);
		assertNotNull(alert);
		
		Reconcile reconcile = alert.getReconcile();
		assertNotNull(reconcile);
		
		assertEquals("Comments must be equals with DB",comments,reconcile.getComments());

	}
}
