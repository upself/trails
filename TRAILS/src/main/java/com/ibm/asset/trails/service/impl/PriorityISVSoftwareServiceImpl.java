package com.ibm.asset.trails.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.PriorityISVSoftwareDAO;
import com.ibm.asset.trails.dao.PriorityISVSoftwareHDAO;
import com.ibm.asset.trails.domain.PriorityISVSoftware;
import com.ibm.asset.trails.domain.PriorityISVSoftwareDisplay;
import com.ibm.asset.trails.domain.PriorityISVSoftwareH;
import com.ibm.asset.trails.domain.PriorityISVSoftwareHDisplay;
import com.ibm.asset.trails.service.PriorityISVSoftwareService;

@Service
public class PriorityISVSoftwareServiceImpl implements PriorityISVSoftwareService{

	@Autowired
	private PriorityISVSoftwareDAO priorityISVSoftwareDAO;
	
	@Autowired
	private PriorityISVSoftwareHDAO priorityISVSoftwareHDAO;
	
	public PriorityISVSoftwareDAO getPriorityISVSoftwareDAO() {
		return priorityISVSoftwareDAO;
	}

	public void setPriorityISVSoftwareDAO(
			PriorityISVSoftwareDAO priorityISVSoftwareDAO) {
		this.priorityISVSoftwareDAO = priorityISVSoftwareDAO;
	}
	
	public PriorityISVSoftwareHDAO getPriorityISVSoftwareHDAO() {
		return priorityISVSoftwareHDAO;
	}

	public void setPriorityISVSoftwareHDAO(
			PriorityISVSoftwareHDAO priorityISVSoftwareHDAO) {
		this.priorityISVSoftwareHDAO = priorityISVSoftwareHDAO;
	}
	
	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public PriorityISVSoftwareDisplay findPriorityISVSoftwareDisplayById(Long Id) {
	  return priorityISVSoftwareDAO.findPriorityISVSoftwareDisplayById(Id);
	}
	
	@Override
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updatePriorityISVSoftware(PriorityISVSoftware updatePISVSW) {
		PriorityISVSoftware dbPISVSW = priorityISVSoftwareDAO.findById(updatePISVSW.getId());
		
		if(null != dbPISVSW){
			PriorityISVSoftwareH pISVSWH = new PriorityISVSoftwareH();
			pISVSWH.setPriorityISVSoftwareId(dbPISVSW.getId());
			pISVSWH.setLevel(dbPISVSW.getLevel());
			pISVSWH.setAccount(dbPISVSW.getAccount());
			pISVSWH.setManufacturer(dbPISVSW.getManufacturer());
			pISVSWH.setEvidenceLocation(dbPISVSW.getEvidenceLocation());
			pISVSWH.setStatus(dbPISVSW.getStatus());
			pISVSWH.setBusinessJustification(dbPISVSW.getBusinessJustification());
			pISVSWH.setRemoteUser(dbPISVSW.getRemoteUser());
			pISVSWH.setRecordTime(dbPISVSW.getRecordTime());
			this.priorityISVSoftwareHDAO.persist(pISVSWH);//persist PriorityISVSoftwareH object to PRIORITY_ISV_SW_H db table
		    
			dbPISVSW.setLevel(updatePISVSW.getLevel());
			dbPISVSW.setAccount(updatePISVSW.getAccount());
			dbPISVSW.setManufacturer(updatePISVSW.getManufacturer());
			dbPISVSW.setEvidenceLocation(updatePISVSW.getEvidenceLocation());
			dbPISVSW.setStatus(updatePISVSW.getStatus());
			dbPISVSW.setBusinessJustification(updatePISVSW.getBusinessJustification());
			dbPISVSW.setRemoteUser(updatePISVSW.getRemoteUser());
			dbPISVSW.setRecordTime(updatePISVSW.getRecordTime());
			this.priorityISVSoftwareDAO.merge(dbPISVSW);//update PriorityISVSoftware object to PRIORITY_ISV_SW db table
		}
	}

	@Override
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void addPriorityISVSoftware(PriorityISVSoftware addPISVSW) {
	   this.priorityISVSoftwareDAO.persist(addPISVSW);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public PriorityISVSoftware findPriorityISVSoftwareByUniqueKeys(
			String level, Long manufacturerId, Long customerId) {
		return this.priorityISVSoftwareDAO.findPriorityISVSoftwareByUniqueKeys(level, manufacturerId, customerId);
	}

	@Override
	public List<PriorityISVSoftwareDisplay> getAllPriorityISVSoftwareDisplays() {
	  return this.priorityISVSoftwareDAO.getAllPriorityISVSoftwareDisplays();
	}

	@Override
	public List<PriorityISVSoftwareHDisplay> findPriorityISVSoftwareHDisplaysByISVSoftwareId(
			Long priorityISVSoftwareId) {
	   return this.priorityISVSoftwareHDAO.findPriorityISVSoftwareHDisplaysByISVSoftwareId(priorityISVSoftwareId);
	}
}
