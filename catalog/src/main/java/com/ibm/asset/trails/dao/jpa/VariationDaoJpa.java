package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.VariationDao;
import com.ibm.asset.trails.domain.Variation;

@Repository
public class VariationDaoJpa extends KbDefinitionDaoJpa<Variation, Long>
		implements VariationDao {

}
