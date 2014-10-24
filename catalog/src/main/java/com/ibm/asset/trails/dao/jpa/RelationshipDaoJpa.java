package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.RelationshipDao;
import com.ibm.asset.trails.domain.Relationship;

@Repository
public class RelationshipDaoJpa extends KbDefinitionDaoJpa<Relationship, Long>
		implements RelationshipDao {

}
