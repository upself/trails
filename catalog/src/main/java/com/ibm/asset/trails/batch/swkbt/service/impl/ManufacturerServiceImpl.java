package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.ManufacturerType;
import com.ibm.asset.trails.batch.swkbt.service.AliasService;
import com.ibm.asset.trails.batch.swkbt.service.ManufacturerService;
import com.ibm.asset.trails.dao.KbDefinitionDao;
import com.ibm.asset.trails.dao.ManufacturerDao;
import com.ibm.asset.trails.domain.Alias;
import com.ibm.asset.trails.domain.Manufacturer;

@Service
public class ManufacturerServiceImpl extends
		KbDefinitionServiceImpl<Manufacturer, ManufacturerType, Long> implements
		ManufacturerService {

	private static final Log LOG = LogFactory.getLog(ManufacturerServiceImpl.class);

	protected static final String[] IBM_MANUFACTURER = { "IBM", "IBM FileNet",
			"IBM Tivoli", "Informix", "Rational Software Corporation",
			"Ascential Software", "IBM WebSphere", "Digital CandleWebSphere",
			"IBM Rational", "Lotus", "Candle", "Tivoli", "COGNOS" };
	@Autowired
	private ManufacturerDao dao;
	@Autowired
	private AliasService aliasService;

	public void save(ManufacturerType xmlEntity) {
		Manufacturer existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new Manufacturer();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public Manufacturer update(Manufacturer existing, ManufacturerType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setName(xmlEntity.getName());
		existing.setWebsite(xmlEntity.getWebsite());
		System.out.print("**********" + xmlEntity.getDefinitionSource() +"***********");
		existing.setDefinitionSource(xmlEntity.getDefinitionSource());
		Set<Alias> aliases = aliasService.findFromXmlObjectSet(xmlEntity
				.getAliasAndAdditional());
		existing.getAlias().retainAll(aliases);
		existing.getAlias().addAll(aliases);
		return existing;
	}

	public boolean isIBMManufacturer(Long id) {
		
		Manufacturer manufacturer = findById(id);
		if ( manufacturer == null ) {
			LOG.error("Manufacturer not in database");
			return false;
		}
		return isIBMManufacturer(manufacturer.getGuid());
	}

	public boolean isIBMManufacturer(String guid) {
		Manufacturer manufacturer = findByNaturalKey(guid);
		if ( manufacturer == null ) {
			LOG.error("Manufacturer not in database");
			return false;
		}
		for (String s : IBM_MANUFACTURER) {
			if (manufacturer.getName().equals(s)) {
				return true;
			}
		}
		return false;
	}

	@Override
	public KbDefinitionDao<Manufacturer, Long> getDao() {
		return dao;
	}

}
