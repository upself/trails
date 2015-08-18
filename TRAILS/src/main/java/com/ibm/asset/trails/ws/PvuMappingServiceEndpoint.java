package com.ibm.asset.trails.ws;

import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.ProcessorValueUnit;
import com.ibm.asset.trails.domain.ProcessorValueUnitDisplay;
import com.ibm.asset.trails.domain.ProcessorValueUnitInfo;
import com.ibm.asset.trails.service.PvuService;
import com.ibm.asset.trails.ws.common.WSMsg;

@Path("/pvu")
public class PvuMappingServiceEndpoint {
	
	@Autowired
	private PvuService pvuService;
	
	private ProcessorValueUnit pvu;
	
	public PvuService getPvuService() {
		return pvuService;
	}

	public void setPvuService(PvuService pvuService) {
		this.pvuService = pvuService;
	}

	@GET
	@Path("/getAll")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllPvu(){
		List<ProcessorValueUnit> pvuList = getPvuService().getPvuList();
		List<ProcessorValueUnitDisplay> pvuArrayList=new ArrayList<ProcessorValueUnitDisplay>();
		for (ProcessorValueUnit pvu:pvuList){
			if(pvu!=null){
				ProcessorValueUnitDisplay temp = new ProcessorValueUnitDisplay(pvu.getId(),pvu.getProcessorBrand(),pvu.getProcessorModel());
				pvuArrayList.add(temp);
			}
		}
		if(pvuArrayList.isEmpty()){
			return WSMsg.failMessage("No PVU record is returned!");
		}else{
			return WSMsg.successMessage("All PVU records are returned!", pvuArrayList);
		}
	}
	
	@GET
	@Path("/getPvuById/{pvuId}")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getPvuById(@PathParam("pvuId")long id){
		pvu=getPvuService().findWithInfo(id);
		List<ProcessorValueUnitInfo> pvulist=pvu.getProcessorValueUnitInfo();
		if(pvulist==null || pvulist.isEmpty()){
			return  WSMsg.failMessage("No PVU record is returned with specified pvuId!");
		}else{
			return WSMsg.successMessage("PVU record is found", pvu);
		}
	}
	
	@PUT
	@Path("/update/{id}")
	@Consumes(MediaType.APPLICATION_JSON) 
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg updatePvu(){
		return null;
	}
	
	public WSMsg getProcessorTypes(){
		return null;
	}
	
	public WSMsg getMachineTypeByPro(){
		return null;
	}
	
	public WSMsg getAvailableProcessorModelsByMachineType(){
		return null;
	}
}
