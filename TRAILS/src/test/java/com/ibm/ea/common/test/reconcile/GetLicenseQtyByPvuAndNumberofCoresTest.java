package com.ibm.ea.common.test.reconcile;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import static org.mockito.Matchers.anyLong;
import static org.mockito.Matchers.eq;

import com.ibm.asset.trails.dao.PVUInfoDAO;
import com.ibm.asset.trails.domain.ProcessorValueUnit;
import com.ibm.asset.trails.domain.PvuInfo;
import com.ibm.asset.trails.domain.PvuMap;
import com.ibm.ea.common.reconcile.PvuReconRule;


public class GetLicenseQtyByPvuAndNumberofCoresTest {

	PVUInfoDAO pvuInfoDAO;
	PvuMap pvuMap;
	
	@Before
	public void setUp() {
		pvuInfoDAO = Mockito.mock(PVUInfoDAO.class);
		pvuMap = new PvuMap();
		
	}
	
	
	@Test
	public void getLicenseQtyByPvuAndNumberofCores_offline_1_Test() throws Exception {
		
		List<PvuInfo> llPvuInfo = new ArrayList<PvuInfo>();
		PvuInfo item = new PvuInfo();
		
		item.setValueUnitsPerCore(70);
		llPvuInfo.add(item);
		
		Mockito.when(pvuInfoDAO.find(anyLong(),eq(2))).thenReturn(llPvuInfo);
//		Mockito.when(pvuInfoDAO.find(anyLong())).thenReturn(llPvuInfo);
		
		PvuReconRule pvuReconRule = new PvuReconRule();
		
		ProcessorValueUnit processorValueUnit = new ProcessorValueUnit();
		
		processorValueUnit.setId( (long) 1);
		
		
		pvuMap.setProcessorValueUnit(processorValueUnit);
		assertEquals("70 x 2 = 140", 140, pvuReconRule.getLicenseQtyByPvuAndNumberOfCores(2,pvuMap, 2,pvuInfoDAO));

	}

}
