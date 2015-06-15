package com.ibm.asset.trails.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;




import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.BaseEntityDAO;
import com.ibm.asset.trails.dao.NonInstanceDAO;
import com.ibm.asset.trails.dao.SoftwareDAO;
import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.CapacityType_;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.Manufacturer_;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.domain.NonInstanceH;
import com.ibm.asset.trails.domain.NonInstanceHDisplay;
import com.ibm.asset.trails.domain.NonInstance_;
import com.ibm.asset.trails.domain.ScheduleF;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.domain.Software_;
import com.ibm.asset.trails.domain.Status;
import com.ibm.asset.trails.domain.Status_;
import com.ibm.asset.trails.service.NonInstanceService;

@Service
public class NonInstanceServiceImpl implements NonInstanceService{

	private EntityManager em;
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public NonInstanceDisplay findNonInstanceDisplayById(Long Id) {
		// TODO Auto-generated method stub
		CriteriaBuilder cb = getEntityManager().getCriteriaBuilder();
		CriteriaQuery<NonInstanceDisplay> q = cb.createQuery(NonInstanceDisplay.class);
		Root<NonInstance> nonInstance = q.from(NonInstance.class);
		
		Join<NonInstance, Software> software = nonInstance.join(NonInstance_.software, JoinType.LEFT);
		Join<NonInstance, Manufacturer> manufacturer = nonInstance.join(NonInstance_.manufacturer, JoinType.LEFT);
		Join<NonInstance, CapacityType> capacityType = nonInstance.join(NonInstance_.capacityType, JoinType.LEFT);
		Join<NonInstance, Status> status = nonInstance.join(NonInstance_.status, JoinType.LEFT);
		
		q.where(cb.equal(nonInstance.get(NonInstance_.id), Id));
		
		q.multiselect(
				nonInstance.get(NonInstance_.id).alias("id"),
				software.get(Software_.softwareId).alias("softwareId"),
				software.get(Software_.softwareName).alias("softwareName"),
				manufacturer.get(Manufacturer_.manufacturerName).alias("manufacturerName"),
				nonInstance.get(NonInstance_.restriction).alias("restriction"),
				capacityType.get(CapacityType_.code).alias("capacityCode"),
				capacityType.get(CapacityType_.description).alias("capacityDesc"),
				nonInstance.get(NonInstance_.baseOnly).alias("baseOnly"),
				status.get(Status_.id).alias("statusId"),
				status.get(Status_.description).alias("statusDesc"),
				nonInstance.get(NonInstance_.remoteUser).alias("remoteUser"),
				nonInstance.get(NonInstance_.recordTime).alias("recordTime"));
		
		TypedQuery<NonInstanceDisplay> typedQuery = getEntityManager().createQuery(q);
		List<NonInstanceDisplay> result = typedQuery.getResultList();

		if(null != result){
			return result.get(0);
		}else{
			return null;
		}
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstanceDisplay> findNonInstanceDisplays(
			NonInstanceDisplay nonInstanceDisplay) {
		// TODO Auto-generated method stub
		String hql = "select new com.ibm.asset.trails.domain.NonInstanceDisplay(non.id, non.software.softwareId, non.software.softwareName, "
				+ "non.manufacturer.manufacturerName, non.restriction, non.capacityType.code, non.capacityType.description, "
				+ "non.baseOnly, non.status.id, non.status.description, non.remoteUser, non.recordTime) from NonInstance as non where 1=1";
		if(nonInstanceDisplay.getId() != null){
			hql += " and non.id = " + nonInstanceDisplay.getId();
		}
		
		if(nonInstanceDisplay.getSoftwareName() != null && !"".equals(nonInstanceDisplay.getSoftwareName())){
			hql += " and non.software.softwareName like '%" + nonInstanceDisplay.getSoftwareName() + "%'";
		}
		
		if(nonInstanceDisplay.getManufacturerName() != null && !"".equals(nonInstanceDisplay.getManufacturerName())){
			hql += " and non.manufacturer.manufacturerName like '%" + nonInstanceDisplay.getManufacturerName() + "%'";
		}
		
		if(nonInstanceDisplay.getRestriction() != null && !"".equals(nonInstanceDisplay.getRestriction())){
			hql += " and non.restriction like '%" + nonInstanceDisplay.getRestriction() + "%'";
		}
		
		if(nonInstanceDisplay.getCapacityDesc() != null  && !"".equals(nonInstanceDisplay.getCapacityDesc())){
			hql += " and non.capacityType.description like '%" + nonInstanceDisplay.getCapacityDesc() + "%'";
		}
		
		if(nonInstanceDisplay.getBaseOnly() != null){
			hql += " and non.baseOnly =" + nonInstanceDisplay.getBaseOnly();
		}
		
		if(nonInstanceDisplay.getStatusId() != null){
			hql += " and non.status.id =" + nonInstanceDisplay.getSoftwareId();
		}
		
		List<NonInstanceDisplay> list =  getEntityManager().createQuery(hql).getResultList();

		return list;
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstanceHDisplay> findNonInstanceHDisplays(Long nonInstanceId) {
		// TODO Auto-generated method stub
		String hql = "select new com.ibm.asset.trails.domain.NonInstanceHDisplay(non.id,non.nonInstanceId, "
				+ "non.software.softwareId, non.software.softwareName, "
				+ "non.manufacturer.manufacturerName, non.restriction, non.capacityType.code, "
				+ "non.capacityType.description, non.baseOnly, non.status.id, non.status.description,"
				+ "non.remoteUser, non.recordTime) from NonInstanceH as non where nonInstanceId = " + nonInstanceId;
		
		hql += " order by non.recordTime desc";
		List<NonInstanceHDisplay> list =  getEntityManager().createQuery(hql).getResultList();

		return list;
	}
	
	
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void updateNonInstance(NonInstance nonInstance) {
		// TODO Auto-generated method stub
		NonInstance dbNonInstance = (NonInstance)getEntityManager()
				.createNamedQuery("findNonInstancesById")
				.setParameter("id", nonInstance.getId())
				.getResultList().get(0);
		if(null != dbNonInstance){
			getEntityManager().merge(nonInstance);
			
			NonInstanceH nonInstanceH = new NonInstanceH();
			nonInstanceH.setNonInstanceId(nonInstance.getId());
			nonInstanceH.setSoftware(nonInstance.getSoftware());
			nonInstanceH.setManufacturer(nonInstance.getManufacturer());
			nonInstanceH.setRestriction(nonInstance.getRestriction());
			nonInstanceH.setCapacityType(nonInstance.getCapacityType());
			nonInstanceH.setBaseOnly(nonInstance.getBaseOnly());
			nonInstanceH.setStatus(nonInstance.getStatus());
			nonInstanceH.setRemoteUser(nonInstance.getRemoteUser());
			nonInstanceH.setRecordTime(nonInstance.getRecordTime());
			getEntityManager().persist(nonInstanceH);
		}
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void saveNonInstance(NonInstance nonInstance) {
		// TODO Auto-generated method stub

			getEntityManager().persist(nonInstance);
/*			
			NonInstanceH nonInstanceH = new NonInstanceH();
			nonInstanceH.setNonInstanceId(nonInstance.getId());
			nonInstanceH.setSoftware(nonInstance.getSoftware());
			nonInstanceH.setManufacturer(nonInstance.getManufacturer());
			nonInstanceH.setRestriction(nonInstance.getRestriction());
			nonInstanceH.setCapacityType(nonInstance.getCapacityType());
			nonInstanceH.setBaseOnly(nonInstance.getBaseOnly());
			nonInstanceH.setStatus(nonInstance.getStatus());
			nonInstanceH.setRemoteUser(nonInstance.getRemoteUser());
			nonInstanceH.setRecordTime(nonInstance.getRecordTime());
			getEntityManager().persist(nonInstanceH);*/
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<Software> findSoftwareBySoftwareName(String softwareName) {
		// TODO Auto-generated method stub
		return getEntityManager()
				.createNamedQuery("softwareBySoftwareName")
				.setParameter("name", softwareName.toUpperCase())
				.getResultList();
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<Manufacturer> findManufacturerByName(String manufacturerName) {
		// TODO Auto-generated method stub
		return getEntityManager()
				.createNamedQuery("manufacturerByName")
				.setParameter("name", manufacturerName.toUpperCase())
				.getResultList();
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<CapacityType> findCapacityTypeByDesc(String description) {
		// TODO Auto-generated method stub
		return getEntityManager()
				.createNamedQuery("capacityTypeByDesc")
				.setParameter("desc", description.toUpperCase())
				.getResultList();
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstance> findNonInstanceByswIdAndCapacityCode(
			Long softwareId, Integer capacityCode) {
		// TODO Auto-generated method stub
		return getEntityManager()
				.createNamedQuery("findNonInstancesBySwIdAndCapacityCode")
				.setParameter("softwareId", softwareId)
				.setParameter("code", capacityCode)
				.getResultList();
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstance> findNonInstanceByswIdAndCapacityCodeNotEqId(
			Long softwareId, Integer capacityCode, Long id) {
		// TODO Auto-generated method stub
		return getEntityManager()
				.createNamedQuery("findNonInstancesBySwIdAndCapacityCodeNotEqId")
				.setParameter("softwareId", softwareId)
				.setParameter("code", capacityCode)
				.setParameter("id", id)
				.getResultList();
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<Status> findStatusByDesc(String StatusDesc) {
		List<Status> results =  getEntityManager()
				.createNamedQuery("statusDetails")
				.setParameter(
						"description", StatusDesc)
						.getResultList();
		if (results == null || results.isEmpty()) {
			results = null;
		} else {
			return results;
		}
		return results;
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstance> findBySoftwareNameAndCapacityCode(String softwareName, Integer capacityCode){
		// TODO Auto-generated method stub
		List<NonInstance> results =  getEntityManager()
				.createNamedQuery("findNonInstancesBySwNameAndCapacityCode")
				.setParameter("softwareName", softwareName)
				.setParameter("code", capacityCode)
				.getResultList();
		if (results == null || results.isEmpty() ) {
			results = null;
		} else {
			return results;
		}
		return results;
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ByteArrayOutputStream parserUpload(FileInputStream fileinput,HttpServletRequest request) throws IOException{
            HSSFWorkbook wb = new HSSFWorkbook(fileinput);
      		HSSFSheet sheet = wb.getSheetAt(0);
      		Iterator liRow = null;
      		HSSFRow row = null;
      		NonInstance ni = null;
      		boolean error = false;
      		StringBuffer lsbErrorMessage = null;
      		HSSFCellStyle lcsError = wb.createCellStyle();
      		HSSFCellStyle lcsNormal = wb.createCellStyle();
      		HSSFCellStyle lcsMessage = wb.createCellStyle();
      		HSSFCell cell = null;
      		boolean lbHeaderRow = false;

      		lcsError.setFillForegroundColor(HSSFColor.RED.index);
      		lcsError.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
      		lcsNormal.setFillForegroundColor(HSSFColor.WHITE.index);
      		lcsNormal.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
      		lcsMessage.setFillForegroundColor(HSSFColor.YELLOW.index);
      		lcsMessage.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

      		for (liRow = sheet.rowIterator(); liRow.hasNext();) {
      			row = (HSSFRow) liRow.next();
      			ni = new NonInstance();
      			error = false;
      			lsbErrorMessage = new StringBuffer();
      			lbHeaderRow = false;

      			for (int i = 0; i <= 5; i++) {
      				cell = row.getCell(i);
      				if (cell == null) {
      					cell = row.createCell(i);
      						cell.setCellStyle(lcsError);
      						lsbErrorMessage.append(error ? "\n" : "").append(
      								getErrorMessage(i));
      						error = true;
      				} else {
      					cell.setCellStyle(lcsNormal);

      					try {
      						if (row.getRowNum() == 0 && cell.getColumnIndex() == 0) {
      							lbHeaderRow = true;
      							break;
      						} else {
      							parseCell(cell, ni);
      						}
      					} catch (Exception e) {
      						cell.setCellStyle(lcsError);
      						// e.printStackTrace();
      						lsbErrorMessage.append(error ? "\n" : "").append(
      								e.getMessage());
      						error = true;
      					}
      				}
      			}

      			if (!lbHeaderRow) {
      				if (error) {
      					cell = row.createCell(6);
      					cell.setCellStyle(lcsError);
      					cell.setCellValue(new HSSFRichTextString(lsbErrorMessage
      							.toString()));
      				} else if (ni.getSoftware() != null && ni.getCapacityType() != null
      						) {
      					ni.setRemoteUser(request.getRemoteUser());
      					ni.setRecordTime(new Date());
      					List<NonInstance> ilExists =  findBySoftwareNameAndCapacityCode(ni.getSoftware().getSoftwareName(),ni.getCapacityType().getCode());
      					if (ilExists != null) {
      									ni.setId(ilExists.get(0).getId());	
      					    updateNonInstance(ni);
      					} else {     	     				
          					saveNonInstance(ni);
      					}
      					cell = row.createCell(6);
      					cell.setCellStyle(lcsMessage);
      					cell.setCellValue(new StringBuffer(
      							"YOUR TEMPLATE UPLOAD SUCCESSFULLY").toString());
      				}
      			}
      		}
      		ByteArrayOutputStream bos = new ByteArrayOutputStream();
    		wb.write(bos);

		return bos;
	}
    @SuppressWarnings("null")
	private void parseCell(HSSFCell cell, NonInstance ni) throws Exception {

		switch (cell.getColumnIndex()) {
		case 0: { // Software Name
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Software Name is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("Software Name is required.");
			} else {
				List<Software> swlist = findSoftwareBySoftwareName(cell.getRichStringCellValue().getString()
						.trim());
				ni.setSoftware(swlist.get(0));
			}

			break;
		}
		case 1: { // Manufacturer
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Manufacturer is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("Manufacturer is required.");
			} else {
				List<Manufacturer> mlist = findManufacturerByName(cell.getRichStringCellValue().getString()
				.trim());
				ni.setManufacturer(mlist.get(0));
			}

			break;
		}
		case 2: { // RESTRICTION
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("RESTRICTION is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("RESTRICTION is required.");
			} else {
				ni.setRestriction(cell.getRichStringCellValue().getString()
						.trim());
			}

			break;
		}
		case 3: { // CAPACITY_TYPE
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("CAPACITY TYPE is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("CAPACITY TYPE is required.");
			} else {
				List<CapacityType> cplist = findCapacityTypeByDesc(cell.getRichStringCellValue().getString()
						.trim());
				ni.setCapacityType(cplist.get(0));
			}

			break;
		}
		case 4: { // BASE ONLY
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("BASE ONLY is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("BASE ONLY is required.");
			} else {
				String baseOnly = cell.getRichStringCellValue().getString()
						.trim();
				if (baseOnly.equalsIgnoreCase("YES")) {
					ni.setBaseOnly(1);
				} else {
					ni.setBaseOnly(0);
				}
			}


			break;
		}
		case 5: { // STATUS
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("STATUS is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("STATUS is required.");
			} else {
				List<Status> statusList = findStatusByDesc(cell.getRichStringCellValue().getString().trim());
				if (statusList == null || statusList.isEmpty()) {
					throw new Exception("Status is invalid.");
				} else  {
				    ni.setStatus(statusList.get(0));
				}
			break;
		}
		}
		}
	}

 
	private String getErrorMessage(int piCellIndex) {
		String lsErrorMessage = null;

		switch (piCellIndex) {
		case 0: { // Software Name
			lsErrorMessage = " Software Name is required.";

			break;
		}

		case 1: { // Manufacturer
			lsErrorMessage = "  Manufacturer is required.";
			
			break;
		}

		case 2: { // RESTRICTION
			lsErrorMessage = "RESTRICTION is required.";
			
			break;
		}

		case 3: { // CAPACITY_TYPE_CODE
			lsErrorMessage = " CAPACITY TYPE CODE is required.";
			
			break;
		}

		case 4: { // BASE_ONLY
			lsErrorMessage = " BASE ONLY is required.";
			
			break;
		}

		case 5: { // STATUS
			lsErrorMessage = "STATUS is required.";

			break;
		}
		}

		return lsErrorMessage;
	}

	@PersistenceContext(unitName="trailspd")
    public void setEntityManager(EntityManager em) {
        this.em = em;
    }

    private EntityManager getEntityManager() {
        return em;
    }
}
