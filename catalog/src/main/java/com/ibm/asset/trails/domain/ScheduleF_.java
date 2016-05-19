package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(ScheduleF.class)
public class ScheduleF_ {
	public static volatile SetAttribute<ScheduleF, CVersionId> cVersionId;
	public static volatile SingularAttribute<ScheduleF, Long> id;
	public static volatile SingularAttribute<ScheduleF, Long> softwareId;
	public static volatile SingularAttribute<ScheduleF, String> softwareTitle;
	public static volatile SingularAttribute<ScheduleF, String> softwareName;
	public static volatile SingularAttribute<ScheduleF, String> manufacturer;
}
