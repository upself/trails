package com.ibm.asset.trails.service.impl;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.Recon;
import com.ibm.asset.trails.domain.ReconWorkspace;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.LicenseService;
import com.ibm.asset.trails.service.ReconWorkspaceService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/applicationContext-test.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
public class ReconWorkspaceServiceImplTest {

	@Autowired
	private ReconWorkspaceService reconWorkspaceService;

	@Autowired
	private AccountService accountService;

	@Autowired
	private LicenseService licenseService;


	@SuppressWarnings("rawtypes")
	@Transactional
	@Test
	public void testManualReconGroupForStory16837() {
		
		
		//Preparing testing data. 
		Account testAccount = accountService.getAccount(Long.valueOf(2541));       
        
		Recon testRecon = new Recon();                                           
		List<ReconWorkspace> list = new ArrayList<ReconWorkspace>();       
		ReconWorkspace workspace = new ReconWorkspace();                   
		workspace.setProductInfoId(Long.valueOf(133253));                  
		list.add(workspace);                                               
                                                                           
		License license = licenseService.findById(Long.valueOf(337239));  
		//force to get the cap type, since it's lazy loading. avoid hibernate session issue. 
		System.out.println(license.getCapacityType().getDescription());
		
		List<License> licenseList = new ArrayList<License>();              
		licenseList.add(license);   
		
		testRecon.setLicenseList(licenseList);                             
		testRecon.setList(list);                                           
		testRecon.setAutomated(false);                                     
		testRecon.setManual(false);                                        
		testRecon.setPer("LPAR");                                          
		testRecon.setMaxLicenses(1);      
		testRecon.setReconcileType(reconWorkspaceService.findReconcileType(Long.valueOf(1)));
		
		
		//Perform the unit execution. 
		try {

			Class<? extends ReconWorkspaceServiceImpl> clazz = ReconWorkspaceServiceImpl.class;
			Class[] args = new Class[] { Account.class, String.class,
					Recon.class, String.class };
			Method method = clazz.getDeclaredMethod("manualReconGroup", args);
			method.setAccessible(true);


			InvocationHandler handler = Proxy.getInvocationHandler(reconWorkspaceService);
			handler.invoke(reconWorkspaceService, method, new Object[] {
					testAccount, "JUnit@cn.ibm.com", testRecon, "ALL" });

		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		//Checking result. 
		
		
		//Clean the testing data. 

	}
}
