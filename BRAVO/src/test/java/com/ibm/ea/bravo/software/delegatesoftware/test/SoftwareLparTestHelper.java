package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.util.Date;

import com.ibm.ea.bravo.software.SoftwareLpar;
import com.ibm.ea.cndb.Customer;


public class SoftwareLparTestHelper {
	
	public static SoftwareLpar createActiveRecord() {
		SoftwareLpar softwareLpar = new SoftwareLpar();
		softwareLpar.setComputerId("computerId");
		softwareLpar.setStatus("ACTIVE");
		softwareLpar.setRecordTime(new Date());
		softwareLpar.setRemoteUser("STAGING");
		softwareLpar.setProcessorCount(1);
		softwareLpar.setName("softwareLparName");
		softwareLpar.setCustomer(createTestCustomer());
		return softwareLpar;
	}

	private static Customer createTestCustomer() {
		Customer customer = new Customer();
		customer.setCustomerId(2L);
		return customer;
	}

	public static void deleteRecord(Long softwareLparId) {
		// TODO Auto-generated method stub
		
	}
}
