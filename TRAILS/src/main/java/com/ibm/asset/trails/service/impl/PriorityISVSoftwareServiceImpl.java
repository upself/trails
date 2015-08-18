package com.ibm.asset.trails.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.PriorityISVSoftwareDAO;
import com.ibm.asset.trails.dao.PriorityISVSoftwareHDAO;
import com.ibm.asset.trails.dao.ReconPriorityISVSoftwareDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.PriorityISVSoftware;
import com.ibm.asset.trails.domain.PriorityISVSoftwareDisplay;
import com.ibm.asset.trails.domain.PriorityISVSoftwareH;
import com.ibm.asset.trails.domain.PriorityISVSoftwareHDisplay;
import com.ibm.asset.trails.domain.ReconPriorityISVSoftware;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.service.PriorityISVSoftwareService;

@Service
public class PriorityISVSoftwareServiceImpl implements PriorityISVSoftwareService{

	private final static String OPERATION_ADD     = "ADD";
	private final static String OPERATION_UPDATE  = "UPDATE";
	private final static String LEVEL_ACCOUNT     = "ACCOUNT";
	private final static String LEVEL_GLOBAL      = "GLOBAL";
	
	@Autowired
	private PriorityISVSoftwareDAO priorityISVSoftwareDAO;
	
	@Autowired
	private PriorityISVSoftwareHDAO priorityISVSoftwareHDAO;
	
	@Autowired
	private ReconPriorityISVSoftwareDAO reconPriorityISVSoftwareDAO;
	
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
	
	public ReconPriorityISVSoftwareDAO getReconPriorityISVSoftwareDAO() {
		return reconPriorityISVSoftwareDAO;
	}

	public void setReconPriorityISVSoftwareDAO(
			ReconPriorityISVSoftwareDAO reconPriorityISVSoftwareDAO) {
		this.reconPriorityISVSoftwareDAO = reconPriorityISVSoftwareDAO;
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
		    
			PriorityISVSoftware dbOldPISVSW = new PriorityISVSoftware();
			dbOldPISVSW.setId(dbPISVSW.getId());
			dbOldPISVSW.setLevel(dbPISVSW.getLevel());
			dbOldPISVSW.setAccount(dbPISVSW.getAccount());
			dbOldPISVSW.setManufacturer(dbPISVSW.getManufacturer());
			dbOldPISVSW.setEvidenceLocation(dbPISVSW.getEvidenceLocation());
			dbOldPISVSW.setStatus(dbPISVSW.getStatus());
			dbOldPISVSW.setBusinessJustification(dbPISVSW.getBusinessJustification());
			dbOldPISVSW.setRemoteUser(dbPISVSW.getRemoteUser());
			dbOldPISVSW.setRecordTime(dbPISVSW.getRecordTime());
			
			dbPISVSW.setLevel(updatePISVSW.getLevel());
			dbPISVSW.setAccount(updatePISVSW.getAccount());
			dbPISVSW.setManufacturer(updatePISVSW.getManufacturer());
			dbPISVSW.setEvidenceLocation(updatePISVSW.getEvidenceLocation());
			dbPISVSW.setStatus(updatePISVSW.getStatus());
			dbPISVSW.setBusinessJustification(updatePISVSW.getBusinessJustification());
			dbPISVSW.setRemoteUser(updatePISVSW.getRemoteUser());
			dbPISVSW.setRecordTime(updatePISVSW.getRecordTime());
			this.priorityISVSoftwareDAO.merge(dbPISVSW);//update PriorityISVSoftware object to PRIORITY_ISV_SW db table
			
			if(insertReconFlag(OPERATION_UPDATE,dbOldPISVSW,updatePISVSW)){
			  insertRelatedReconPriorityISVSWs(OPERATION_UPDATE,dbOldPISVSW,updatePISVSW);
			}
		}
	}

	@Override
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void addPriorityISVSoftware(PriorityISVSoftware addPISVSW) {
	   this.priorityISVSoftwareDAO.persist(addPISVSW);
	   if(insertReconFlag(OPERATION_ADD,null,addPISVSW)){
	     insertRelatedReconPriorityISVSWs(OPERATION_ADD,null,addPISVSW);
	   }
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public PriorityISVSoftware findPriorityISVSoftwareByUniqueKeys(
			String level, Long manufacturerId, Long customerId) {
		return this.priorityISVSoftwareDAO.findPriorityISVSoftwareByUniqueKeys(level, manufacturerId, customerId);
	}


	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public Long total() {
		// TODO Auto-generated method stub
		 return this.priorityISVSoftwareDAO.total();
	}

	@Override
	public List<PriorityISVSoftwareDisplay> getAllPriorityISVSoftwareDisplays(Integer pageIndex, Integer pageSize) {
	  return this.priorityISVSoftwareDAO.getAllPriorityISVSoftwareDisplays(pageIndex,pageSize);
	}

	@Override
	public List<PriorityISVSoftwareHDisplay> findPriorityISVSoftwareHDisplaysByISVSoftwareId(
			Long priorityISVSoftwareId) {
	   return this.priorityISVSoftwareHDAO.findPriorityISVSoftwareHDisplaysByISVSoftwareId(priorityISVSoftwareId);
	}
	
	private void insertRelatedReconPriorityISVSWs(String operation, PriorityISVSoftware oldPISVSW,PriorityISVSoftware newPISVSW){
	 	
  	  if(OPERATION_ADD.equals(operation)){//ADD
  	    insertReconPriorityISVSW(newPISVSW, newPISVSW.getRemoteUser());
      }	
	  else{//UPDATE
		String oldLevel = oldPISVSW.getLevel().toUpperCase().trim();
		String newLevel = newPISVSW.getLevel().toUpperCase().trim();
		long oldManufacturerId = oldPISVSW.getManufacturer().getId().longValue();
		long newManufacturerId = newPISVSW.getManufacturer().getId().longValue();
		if(oldManufacturerId!=newManufacturerId){
		  //If the Manufacturer has been changed, then add the old and new Manufacturer into the Recon Priority ISV Queue	
		  insertReconPriorityISVSW(oldPISVSW, newPISVSW.getRemoteUser());
		  insertReconPriorityISVSW(newPISVSW, newPISVSW.getRemoteUser());
		}
		else if(oldLevel.equals(LEVEL_GLOBAL) && newLevel.equals(LEVEL_ACCOUNT)){
          //If only the level for certain Manufacturer has been changed from 'GLOBAL' to 'ACCOUNT'
		  //, then only add the Global level into the Recon Priority ISV Queue
		  insertReconPriorityISVSW(oldPISVSW, newPISVSW.getRemoteUser());
		}
		else if(oldLevel.equals(LEVEL_ACCOUNT) && newLevel.equals(LEVEL_GLOBAL)){
	       //If only the level for certain Manufacturer has been changed from 'ACCOUNT' to 'GLOBAL'
		   //, then only add the Global level into the Recon Priority ISV Queue
		   insertReconPriorityISVSW(newPISVSW, newPISVSW.getRemoteUser());
		}
		else if(oldLevel.equals(LEVEL_ACCOUNT)
		     && newLevel.equals(LEVEL_ACCOUNT) 
		     && oldPISVSW.getAccount()!=null
		     && newPISVSW.getAccount()!=null
		     && oldPISVSW.getAccount().getId().longValue()!=newPISVSW.getAccount().getId().longValue()){
			 //support account value changed case
			 insertReconPriorityISVSW(oldPISVSW, newPISVSW.getRemoteUser());
			 insertReconPriorityISVSW(newPISVSW, newPISVSW.getRemoteUser());
		}
		else{
		  //If only the status has been changed, then only add the old scope into Recon Priority ISV Queue
		  insertReconPriorityISVSW(oldPISVSW, newPISVSW.getRemoteUser());	
		}
	  }
	}
	
	private boolean insertReconFlag(String operation, PriorityISVSoftware oldPISVSW,PriorityISVSoftware newPISVSW){
		if(null!=operation && OPERATION_ADD.equalsIgnoreCase(operation.trim())){
			return true;
		}
		else if(null!=operation && OPERATION_UPDATE.equalsIgnoreCase(operation.trim())){
			if(null!=oldPISVSW && null!=newPISVSW){
			    String oldLevel = oldPISVSW.getLevel();
			    Account oldAccount = oldPISVSW.getAccount();
			    Manufacturer oldManufacturer = oldPISVSW.getManufacturer();
			    Status oldStatus = oldPISVSW.getStatus();
			    String newLevel = newPISVSW.getLevel();
			    Account newAccount = newPISVSW.getAccount();
			    Manufacturer newManufacturer = newPISVSW.getManufacturer();
			    Status newStatus = newPISVSW.getStatus();
			    
			    //If the status of priority ISV SW is 'INACTIVE', then we don't need to add the recon priority ISV SW record
			    if(null!=oldStatus
				  &&null!=newStatus
				  &&null!=oldStatus.getId()
				  &&null!=newStatus.getId()
				  &&oldStatus.getId().longValue()==newStatus.getId().longValue()
				  &&oldStatus.getId().longValue()==1){//1 = INACTIVE
					  return false;
				}
			    
			    if(null!=oldLevel
			     &&null!=newLevel
			     &&!oldLevel.trim().equalsIgnoreCase(newLevel.trim())){
			      return true;
			    }
			    
			    if((null==oldAccount&&null!=newAccount)
			     ||(null==newAccount&&null!=oldAccount)
			     ||(null!=oldAccount
			      &&null!=newAccount
			      &&null!=oldAccount.getId()
			      &&null!=newAccount.getId()
			      &&oldAccount.getId().longValue()!=newAccount.getId().longValue())){
			      return true; 
			    }
			    
			    if(null!=oldManufacturer
			     &&null!=newManufacturer
			     &&null!=oldManufacturer.getId()
			     &&null!=newManufacturer.getId()
			     &&oldManufacturer.getId().longValue()!=newManufacturer.getId().longValue()){
				  return true;
				}
			    
			    if(null!=oldStatus
			     &&null!=newStatus
			     &&null!=oldStatus.getId()
			     &&null!=newStatus.getId()
			     &&oldStatus.getId().longValue()!=newStatus.getId().longValue()){
				  return true;
				}
			    
			    return false;
			}
			else{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	
	private void insertReconPriorityISVSW(PriorityISVSoftware pISVSW, String psRemoteUser) {
		String pISVSWLevel= pISVSW.getLevel().toUpperCase().trim();
		ReconPriorityISVSoftware rcPISVSWDB;
		if(pISVSWLevel.equals(LEVEL_GLOBAL)){//Global Level
		  rcPISVSWDB = this.reconPriorityISVSoftwareDAO.findReconPriorityISVSoftwareByUniqueKeys(pISVSW.getManufacturer().getId(), null);
		}
		else{//Account Level
		  //Search the Global Level first
		  rcPISVSWDB = this.reconPriorityISVSoftwareDAO.findReconPriorityISVSoftwareByUniqueKeys(pISVSW.getManufacturer().getId(), null);
		  if(rcPISVSWDB == null){//If Global level is null, then search the account level
		    rcPISVSWDB = this.reconPriorityISVSoftwareDAO.findReconPriorityISVSoftwareByUniqueKeys(pISVSW.getManufacturer().getId(), pISVSW.getAccount().getId());
		  }  
		}
		
		if(rcPISVSWDB == null){
			ReconPriorityISVSoftware rcPISVSWSave = new ReconPriorityISVSoftware();
			rcPISVSWSave.setAccount(pISVSW.getAccount());
			rcPISVSWSave.setManufacturer(pISVSW.getManufacturer());
			rcPISVSWSave.setAction("UPDATE");
			rcPISVSWSave.setRecordTime(new Date());
			rcPISVSWSave.setRemoteUser(psRemoteUser);
			this.reconPriorityISVSoftwareDAO.persist(rcPISVSWSave);
		}
	}
}
