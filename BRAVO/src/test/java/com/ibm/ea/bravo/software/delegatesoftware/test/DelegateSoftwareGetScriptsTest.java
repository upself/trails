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

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.runners.MockitoJUnitRunner;

import com.ibm.ea.bravo.software.DelegateSoftware;
import com.ibm.ea.bravo.software.InstalledScript;
import com.ibm.ea.bravo.software.InstalledSoftware;

@RunWith(MockitoJUnitRunner.class)

public class DelegateSoftwareGetScriptsTest {

	@Before
	public void setup() {
		MockitoAnnotations.initMocks(this);
	}

//	@Test
	public void testReadsSpecificSoftwareIdfromDB() {
		final String softwareId = "243702656";

		List<InstalledScript> scriptList = DelegateSoftware.getScripts(softwareId);
		
		assertNotNull(scriptList);
		assertTrue(scriptList.size() > 0);

	}
	
	@Test
	public void testReadsfromDB() {
		
		InstalledSoftware installedSoftware = InstalledSoftwareTestHelper.getAnyRecord();
		Long installedSoftwareId = installedSoftware.getId();
		System.out.println("installedSoftwareId: " + installedSoftwareId);
		System.out.println("installedSoftwareId.toString(): " + installedSoftwareId.toString());

		List<InstalledScript> scriptList = DelegateSoftware.getScripts(installedSoftwareId.toString());
		
		System.out.println("scriptList.get(0).getSoftwareScript().getSoftware().getSoftwareName(): "
				+ scriptList.get(0).getSoftwareScript().getSoftware().getSoftwareName());
		
		assertNotNull(scriptList);
		assertTrue(scriptList.size() > 0);

	}
	
	
	@Test(expected = NullPointerException.class)
	public void testNoSoftwareIdPassedIn() {

		DelegateSoftware.getScripts(null);

	}

}
