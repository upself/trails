package com.ibm.tap.sigbank.softwarecategory.test;

import static org.junit.Assert.*;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.junit.Test;

import com.ibm.tap.sigbank.softwarecategory.SoftwareCategory;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategoryDelegate;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategoryH;

public class SoftwareCategoryDelegateTest {

	private final static String SOFTWARE_CATEGORY_ID = "1052";// Microsoft BizTalk Fin Svc

	@Test
	@SuppressWarnings("rawtypes")
	public void testGetSoftwareCategorys() {
		List softwareCategories = null;

		try {
			softwareCategories = SoftwareCategoryDelegate.getSoftwareCategories();
		} catch (HibernateException e) {
			System.out.println("HibernateException happened with message: " + e.getMessage());
		} catch (NamingException e) {
			System.out.println("NamingException happened with message: " + e.getMessage());
		}

		assertNotNull(softwareCategories);
		System.out.println("Software Category Count : " + softwareCategories.size());
	}

	@Test
	public void testGetSoftwareCategoryString() {
		SoftwareCategory softwareCategory = null;
		try {
			softwareCategory = SoftwareCategoryDelegate.getSoftwareCategory(SOFTWARE_CATEGORY_ID);
		} catch (HibernateException e) {
			System.out.println("HibernateException happened with message: " + e.getMessage());
		} catch (NamingException e) {
			System.out.println("NamingException happened with message: " + e.getMessage());
		}

		assertNotNull(softwareCategory);
		assertNotNull(softwareCategory.getSoftwareCategoryId());
		System.out.println("Software Category Id : " + softwareCategory.getSoftwareCategoryId().intValue());
		assertNotNull(softwareCategory.getSoftwareCategoryName());
		System.out.println("Software Category Name : " + softwareCategory.getSoftwareCategoryName());
		assertNotNull(softwareCategory.getStatus());
		System.out.println("Software Category Status : " + softwareCategory.getStatus());
	}

	@Test
	@SuppressWarnings("rawtypes")
	public void testSoftwareCategoryHistory() {
		List softwareCategoryHistoryList = null;

		try {
			softwareCategoryHistoryList = SoftwareCategoryDelegate.getSoftwareCategoryHistory(SOFTWARE_CATEGORY_ID);
		} catch (HibernateException e) {
			System.out.println("HibernateException happened with message: " + e.getMessage());
		} catch (NamingException e) {
			System.out.println("NamingException happened with message: " + e.getMessage());
		}

		assertNotNull(softwareCategoryHistoryList);
		assertTrue(softwareCategoryHistoryList.size() > 0);
		SoftwareCategoryH softwareCategoryH = (SoftwareCategoryH)softwareCategoryHistoryList.get(0);
		assertNotNull(softwareCategoryH.getSoftwareCategoryHId());
		System.out.println("Software Category History Id : " + softwareCategoryH.getSoftwareCategoryHId().intValue());
		assertNotNull(softwareCategoryH.getSoftwareCategory());
		System.out.println("Software Category Id : " + softwareCategoryH.getSoftwareCategory().getSoftwareCategoryId().intValue());
		assertNotNull(softwareCategoryH.getSoftwareCategoryName());
		System.out.println("Software Category History Software Category Name : " + softwareCategoryH.getSoftwareCategoryName());
		assertNotNull(softwareCategoryH.getRemoteUser());
		System.out.println("Software Category History Remote User : " + softwareCategoryH.getRemoteUser());
		assertNotNull(softwareCategoryH.getStatus());
		System.out.println("Software Category History Status : " + softwareCategoryH.getStatus());
	}

}
