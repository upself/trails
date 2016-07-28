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

import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.software.DelegateSoftware;
import com.ibm.ea.bravo.software.FormSoftware;
import com.ibm.ea.bravo.software.InstalledScript;
import com.ibm.ea.bravo.software.SoftwareLpar;
import com.ibm.ea.sigbank.BankAccount;
import com.ibm.ea.utils.EaUtils;

@RunWith(MockitoJUnitRunner.class)



public class DelegateSoftwareGetSoftwareBankAccountsTest {
	
	@Mock
	private HttpServletRequest request;
	
	@Before
	public void setup() {
		MockitoAnnotations.initMocks(this);
	}

	@Test
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
	public void testReadsfromDB() {
//		final String lparId = "2223341";
		
		//create() - what ?BankAccount? SwLpar?pff
		
		//so far, the accountId = 2541L; ie. Softreq
		final String accountId = "2541";
		
		Account account = null;
		try {
			account = DelegateAccount.getAccount(accountId, request);
		} catch (ExceptionAccountAccess e) {
			e.printStackTrace();
		}
		
		System.out.println("account : " + account);
		
//		FormSoftware software = new FormSoftware(lparId);
//		software.setLparId(lparId);
//		
//		try {
//			software.init();
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		
//		List<BankAccount> bankAccounts = DelegateSoftware
//				.getSoftwareBankAccounts(software.getSoftwareLpar());
//		
//		assertNotNull(bankAccounts);
//		assertTrue(bankAccounts.size() > 0);

	}
	
	@Test(expected = NullPointerException.class)
	public void testNoLparIdPassedIn() {

		DelegateSoftware.getSoftwareBankAccounts(null);
	}

}
