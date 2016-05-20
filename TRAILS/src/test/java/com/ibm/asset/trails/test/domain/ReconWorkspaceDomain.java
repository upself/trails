package com.ibm.asset.trails.test.domain;

import static org.junit.Assert.assertEquals;

import java.math.BigDecimal;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import com.ibm.asset.trails.domain.ReconWorkspace;

public class ReconWorkspaceDomain {
	ReconWorkspace reconWorkspace;
	
	@Before
	public void setUp() {
		reconWorkspace = Mockito.mock(ReconWorkspace.class);
	}
	
	@Test
	public void reconWorkspaceTest() throws Exception {
		Mockito.when(reconWorkspace.getVcpu()).thenReturn(BigDecimal.valueOf(10.0)).thenReturn(BigDecimal.valueOf(20.0));
		BigDecimal result = reconWorkspace.getVcpu().add(reconWorkspace.getVcpu()) ;
		
		Mockito.verify(reconWorkspace, Mockito.times(2)).getVcpu();
		//System.out.print(result.toString());
	    assertEquals(BigDecimal.valueOf(30.0), result);

	}
}
