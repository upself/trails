package com.ibm.ea.bravo.software.delegatesoftware.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.anyList;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.runners.MockitoJUnitRunner;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.discrepancy.DiscrepancyType;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.software.DelegateSoftware;
import com.ibm.ea.bravo.software.FormSoftware;
import com.ibm.ea.bravo.software.InstalledScript;
import com.ibm.ea.bravo.software.InstalledSoftware;
import com.ibm.ea.bravo.software.SoftwareLpar;
import com.ibm.ea.sigbank.BankAccount;

import com.ibm.ea.sigbank.KbDefinition;
import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.ProductInfo;

import com.ibm.ea.sigbank.Software;

import com.ibm.ea.sigbank.SoftwareCategory;
import com.ibm.ea.sigbank.SoftwareItem;
import com.ibm.ea.utils.EaUtils;

@RunWith(MockitoJUnitRunner.class)



public class DelegateSoftwareGetSoftwareBankAccountsTest {

//	@Test
	public void testReadsSpecificLparIdfromDB() {
		
		final String lparId = "2223341";
		
		FormSoftware software = new FormSoftware(lparId);
		software.setLparId(lparId);
		
		try {
			software.init();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		List<BankAccount> bankAccounts = DelegateSoftware
				.getSoftwareBankAccounts(software.getSoftwareLpar());
		
		assertNotNull(bankAccounts);
		assertTrue(bankAccounts.size() > 0);

	}
	
	
	@Test
	public void testInsertReadsDeletesfromDB() {
		
		//////////////
		InstalledScript installedScript = setupDataForInstalledSoftware();
		// print out IDs
		cleanupDataForInstalledSoftware(installedScript);
		// exists(ID) - expect false
		//////////////
		
//		List<BankAccount> bankAccountsList = new ArrayList<BankAccount>(); 
		
//		Transaction tx = null;
//		Session session = null;
//		try {
//			session = HibernateDelegate.getSession();
//		    tx = session.beginTransaction();
//		     
//		    //do stuff
//		    
//		    tx.commit();
//		 }
//		 catch (Exception e) {
//			 System.out.println("whooops");
//		     if (tx!=null) tx.rollback();
//		     e.printStackTrace();
//		 }
//		 finally {
//			 session.close();
//		 }
		
		
//		try {
//			Session session = getSession();
//
////			bankAccountsList = session.
////					.setEntity("softwareLpar", testInstalledScript.getInstalledSoftware().getSoftwareLpar()).list();
//
//			closeSession(session);
//
//		} catch (Exception e) {
//		}
//		
//		
//		assertNotNull(bankAccountsList);
//		assertTrue(bankAccountsList.size() > 0);
//		assertTrue();

	}
	
//	@Test(expected = NullPointerException.class)
	public void testNoLparIdPassedIn() {

		DelegateSoftware.getSoftwareBankAccounts(null);
	}
	
	public InstalledScript setupDataForInstalledSoftware() {

		ProductInfo productInfo = ProductInfoTestHelper.create();
		System.out.println("productInfo.getRemoteUser(): " + productInfo.getRemoteUser());
		System.out.println("productInfo.getProductId(): " + productInfo.getProductId());
		
		SoftwareLpar softwareLpar = SoftwareLparTestHelper.getAnyRecord();
		System.out.println("softwareLpar.getName(): " + softwareLpar.getName());
		System.out.println("softwareLpar.getId(): " + softwareLpar.getId());
		
		DiscrepancyType discrepancyType = DiscrepancyTypeTestHelper.getAnyRecord();
		System.out.println("discrepancyType.getId(): " + discrepancyType.getId());
		
		InstalledSoftware installedSoftware = InstalledSoftwareTestHelper.createActiveRecord(productInfo, softwareLpar, discrepancyType);
//		InstalledSoftware installedSoftware = InstalledSoftwareTestHelper.getAnyRecord();
		System.out.println("installedSoftware.getId(): " + installedSoftware.getId());
		System.out.println("installedSoftware.getSoftwareLpar().getName(): " + installedSoftware.getSoftwareLpar().getName());
		
		InstalledScript installedScript = InstalledScriptTesthelper.createRecord(installedSoftware);
		System.out.println("installedScript.getId(): " + installedScript.getId());
		
		return installedScript;
	}
	
	public void cleanupDataForInstalledSoftware(InstalledScript installedScript){
		//ProductInfo comes from a catalog. By the business logic it can be accessed as follows:
		ProductInfo productInfo = installedScript.getInstalledSoftware().getProductInfo();
		SoftwareLpar softwareLpar = installedScript.getInstalledSoftware().getSoftwareLpar();
		InstalledSoftware installedSoftware = installedScript.getInstalledSoftware();
	
		ProductInfoTestHelper.delete(productInfo);
		SoftwareLparTestHelper.delete(softwareLpar);
		InstalledSoftwareTestHelper.delete(installedSoftware);
		InstalledScriptTesthelper.delete(installedScript);

	}

}
