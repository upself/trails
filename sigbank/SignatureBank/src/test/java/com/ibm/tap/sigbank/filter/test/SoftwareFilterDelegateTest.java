package com.ibm.tap.sigbank.filter.test;

import static org.junit.Assert.*;

import org.hibernate.HibernateException;
import org.junit.Test;

import com.ibm.tap.sigbank.filter.SoftwareFilterDelegate;

public class SoftwareFilterDelegateTest {

	@Test
	public void testGetNewSoftwareFilterCount() {
		Long newSoftwareFilterCnt = null;
		try {
			newSoftwareFilterCnt = SoftwareFilterDelegate.getNewSoftwareFilterCount();
		} catch (HibernateException e) {
			System.out.println("HibernateException happened with message: " + e.getMessage());
		} catch (Exception e) {
			System.out.println("Exception happened with message: " + e.getMessage());
		}

		assertNotNull(newSoftwareFilterCnt);
		System.out.println("New Software Filter Count: " + newSoftwareFilterCnt.intValue());
	}

}
