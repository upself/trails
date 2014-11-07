package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.SoftwareDAO;
import com.ibm.asset.trails.domain.Software;

@Repository
public class SoftwareDAOJpa extends AbstractGenericEntityDAOJpa<Software, Long>
implements SoftwareDAO {

}
