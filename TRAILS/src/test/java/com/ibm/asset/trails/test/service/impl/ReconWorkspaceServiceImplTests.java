package com.ibm.asset.trails.test.service.impl;

import static org.junit.Assert.*;

import java.util.List;
import java.util.Map;

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
import com.ibm.asset.trails.service.ReconWorkspaceService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/applicationContext-test.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class ReconWorkspaceServiceImplTests {

	@Autowired
	private ReconWorkspaceService reconWorkspaceService;

	/*
	 * Author: liuhaidl@cn.ibm.com
	 * Test Remove logic for manual CO/CM reconcile type for Story_23223
	 * */
	@Test
	public void testReconcileTypeActions(){
	  List<Map<String, Object>> reconcileTypeList = reconWorkspaceService.reconcileTypeActions();
	  boolean existedManualCOCMReconcileType = false;
	  for(Map<String, Object> reconcileTypeMap: reconcileTypeList){
		  if(reconcileTypeMap.get("id")!=null && ((Long)reconcileTypeMap.get("id")).intValue()==2){//judge if reconcile type is manual CO/CM
		    existedManualCOCMReconcileType = true;
		  }	  
	  }
	  
	  System.out.println("existedManualCOCMReconcileType: "+existedManualCOCMReconcileType);
	  assertTrue(!existedManualCOCMReconcileType);
	}
	
	@Test
	public void testReconcileTypes(){
		List<ReconcileType> reconcileTypeList = reconWorkspaceService.reconcileTypes(true);
		  boolean existedManualCOCMReconcileType = false;
		  for(ReconcileType reconcileType: reconcileTypeList){
			  if(reconcileType.getId()!=null && reconcileType.getId().intValue()==2){//judge if reconcile type is manual CO/CM
				  existedManualCOCMReconcileType = true;
			  } 
		  }
		  
		  System.out.println("existedManualCOCMReconcileType: "+existedManualCOCMReconcileType);
		  assertTrue(!existedManualCOCMReconcileType);
	}
}
