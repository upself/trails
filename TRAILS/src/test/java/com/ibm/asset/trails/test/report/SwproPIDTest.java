package com.ibm.asset.trails.test.report;

import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import com.ibm.asset.trails.domain.License;

public class SwproPIDTest {
	License license;
	
	@Before
	public void setUp() {
		license = Mockito.mock(License.class);
	}
	
	/*
	 * Author: vndwbwan@cn.ibm.com
	 * Test swproPID in license 
	 * */
	@Test
	public void swproPIDTest() throws Exception {
		
		
		Mockito.when(license.getSwproPID()).thenReturn("Test by").thenReturn(" mockito");
		String result = license.getSwproPID() + license.getSwproPID();
		
		Mockito.verify(license, Mockito.times(2)).getSwproPID();
		
		assertEquals("Test by mockito", result);

	}
}
