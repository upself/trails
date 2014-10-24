package com.ibm.asset.trails.batch.swkbt.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.FilterSignatureType;
import com.ibm.asset.trails.batch.swkbt.service.FilterSignatureService;
import com.ibm.asset.trails.dao.FilterSignatureDao;
import com.ibm.asset.trails.dao.SignatureDao;
import com.ibm.asset.trails.domain.FilterSignature;

@Service
public class FilterSignatureServiceImpl extends
		SignatureServiceImpl<FilterSignature, FilterSignatureType, Long>
		implements FilterSignatureService {

	@Autowired
	private FilterSignatureDao dao;

	public void save(FilterSignatureType xmlEntity) {
		FilterSignature existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new FilterSignature();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public FilterSignature update(FilterSignature existing,
			FilterSignatureType xmlEntity) {
		super.update(existing, xmlEntity);
		existing.setPackageName(xmlEntity.getPackageName());
		existing.setPackageVendor(xmlEntity.getPackageVendor());
		existing.setPackageVersion(xmlEntity.getPackageVersion());
		return existing;
	}

	@Override
	public SignatureDao<FilterSignature, Long> getDao() {
		return dao;
	}

}
