package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.io.UnsupportedEncodingException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.AliasType;
import com.ibm.asset.trails.batch.swkbt.service.AliasService;
import com.ibm.asset.trails.dao.AliasDao;
import com.ibm.asset.trails.dao.BaseDao;
import com.ibm.asset.trails.domain.Alias;

@Service
public class AliasServiceImpl extends GenericService<Alias, AliasType, Long>
		implements AliasService {

	@Autowired
	private AliasDao dao;

	public void save(AliasType xmlEntity) {
		// Donnie -- check to make sure the name is not too long to store
		//System.out.println("Attempting to save alias type");
		try {
			byte[] c_byte_array = xmlEntity.getName().getBytes("UTF-8");
			if ( c_byte_array.length > 254 ) {
				System.out.println("Alias name too long " + xmlEntity.getName() );
				return;
			}
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Alias existing = findByNaturalKey(xmlEntity.getName());
		if (existing == null) {
			existing = new Alias();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public Alias update(Alias existing, AliasType xmlEntity) {
		existing.setName(xmlEntity.getName());
		existing.setPreferred(xmlEntity.isPreferred());
		return existing;
	}

	public Set<Alias> findFromXmlSet(List<AliasType> aliasTypes) {
		Set<Alias> aliases = new HashSet<Alias>();
		for (AliasType aliasType : aliasTypes) {
			String key = aliasType.getName();
			Alias alias = findByNaturalKey(key);
			aliases.add(alias);
		}
		return aliases;
	}

	public Set<Alias> findFromXmlObjectSet(List<Object> aliasAndAdditional) {
		Set<Alias> aliases = new HashSet<Alias>();
		for (Object aliasType : aliasAndAdditional) {
			String key = ((AliasType) aliasType).getName();
			Alias alias = findByNaturalKey(key);
			aliases.add(alias);
		}
		return aliases;
	}

	@Override
	public BaseDao<Alias, Long> getDao() {
		return dao;
	}
}
