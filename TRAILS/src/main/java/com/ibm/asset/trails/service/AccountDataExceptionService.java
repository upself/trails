// $Id$
// File name: $HeadURL$
// Revision: $Revison$
// Last modified: $Date$
// Last modified by: $Author$


package com.ibm.asset.trails.service;

import java.util.List;
import java.util.Map;

public interface AccountDataExceptionService {

	List<Map<String, String>> getAlertTypeSummary(Long accountId, String type);

}
