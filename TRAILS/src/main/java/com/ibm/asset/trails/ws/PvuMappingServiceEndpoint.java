package com.ibm.asset.trails.ws;

import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.domain.ProcessorValueUnit;
import com.ibm.asset.trails.domain.ProcessorValueUnitDisplay;
import com.ibm.asset.trails.domain.ProcessorValueUnitInfo;
import com.ibm.asset.trails.service.PvuService;
import com.ibm.asset.trails.ws.common.Pagination;
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

	@POST
	@Path("/getAll")
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	public WSMsg getAllPvu(@FormParam("currentPage") Integer currentPage,
			@FormParam("pageSize") Integer pageSize,
			@FormParam("sort") String sort,
			@FormParam("dir") String dir){
		
		int startIndex = (currentPage-1) * pageSize;
		
		List<ProcessorValueUnit> pvuList = getPvuService().getPvuList(startIndex,pageSize, sort, dir);
		
		List<ProcessorValueUnitDisplay> pvuArrayList=new ArrayList<ProcessorValueUnitDisplay>();
		for (ProcessorValueUnit pvu:pvuList){
			if(pvu!=null){
				ProcessorValueUnitDisplay temp = new ProcessorValueUnitDisplay(pvu.getId(),pvu.getProcessorBrand(),pvu.getProcessorModel());
				pvuArrayList.add(temp);
			}
		}
		
		Long total = 0L;
		List<ProcessorValueUnit> totalList = getPvuService().getPvuList();
		if(null != totalList){
			total = (long) totalList.size();
		}

		Pagination page = new Pagination();
		page.setPageSize(pageSize.longValue());
		page.setTotal(total);
		page.setCurrentPage(currentPage.longValue());
		page.setList(pvuArrayList);
		return WSMsg.successMessage("SUCCESS", page);
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
}
