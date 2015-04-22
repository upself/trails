package com.ibm.ea.bravo.hardware.test;


import static org.junit.Assert.*;
import org.junit.Test;
import com.ibm.ea.bravo.hardware.HardwareLparEff;


public class HardwareLparEffTest {
	
	@Test
	public void hardwareLparEffTest() throws Exception {
		HardwareLparEff hardwareLparEff = new HardwareLparEff();
		hardwareLparEff.setProcessorCount(4);
		hardwareLparEff.setStatus("ACTIVE");
		
		assertEquals("status is ACTIVE and processorCount is 4 => 4", 4, hardwareLparEff.getProcessorCount().intValue() );

		hardwareLparEff.setStatus("INACTIVE");
		assertEquals("status is INACTIVE and processorCount is 4 => 0", 0, hardwareLparEff.getProcessorCount().intValue());

		
	}

}
