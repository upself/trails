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
import com.ibm.ea.sigbank.ProductInfo;

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
	
	
	@SuppressWarnings("unchecked")
	@Test
	public void testInsertReadsDeletesfromDB() {

		DiscrepancyType discrepancyType = DiscrepancyTypeTestHelper.getAnyRecord();
		
		System.out.println("discrepancyType: " + discrepancyType.getName());
		
//		InstalledScript testInstalledScript = setupDataForInstalledSoftware();
		
//		List<BankAccount> bankAccountsList = new ArrayList<BankAccount>(); 
		
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

	}
	
//	@Test(expected = NullPointerException.class)
	public void testNoLparIdPassedIn() {

		DelegateSoftware.getSoftwareBankAccounts(null);
	}
	
	public InstalledScript setupDataForInstalledSoftware() {
		ProductInfo productInfo = ProductInfoTestHelper.createRecord();
		SoftwareLpar softwareLpar = SoftwareLparTestHelper.createActiveRecord();
		DiscrepancyType discrepancyType = DiscrepancyTypeTestHelper.getAnyRecord();
		InstalledSoftware installedSoftware = InstalledSoftwareTestHelper.createActiveRecord(productInfo, softwareLpar, discrepancyType);
		InstalledScript installedScript = InstalledScriptTesthelper.createRecord(installedSoftware.getId());
		return installedScript;
	}
	
	public void cleanupDataForInstalledSoftware(InstalledScript installedScriptData){
		Long installedScriptId = installedScriptData.getId();
		Long softwareLparId = installedScriptData.getInstalledSoftware().getSoftwareLpar().getId();
		Long installedSoftwareId = installedScriptData.getInstalledSoftware().getId();
		Long discrepancyTypeId = installedScriptData.getInstalledSoftware().getDiscrepancyType().getId();
//		Long productInfoId = installedScriptData.getInstalledSoftware().get
		//???
		
//		ProductInfoTestHelper.deleteRecord(productInfoId);
		SoftwareLparTestHelper.deleteRecord(softwareLparId);
		DiscrepancyTypeTestHelper.deleteRecord(discrepancyTypeId);
		InstalledSoftwareTestHelper.deleteRecord(installedSoftwareId);
		InstalledScriptTesthelper.deleteRecord(installedScriptId);
	}

}
