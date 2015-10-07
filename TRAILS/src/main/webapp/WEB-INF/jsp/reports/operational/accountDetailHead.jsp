<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="trails" action="home" namespace="/" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="reports" action="home" namespace="/reports"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="alerts" action="home" namespace="/reports/operational"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="accountByNameLink" action="accountByName.htm"
	namespace="/reports/operational" includeContext="true"
	includeParams="none">
	<s:param name="geographyId" value="geography.id" />
	<s:param name="regionId" value="region.id" />
	<s:param name="countryCodeId" value="countryCode.id" />
	<s:param name="sectorId" value="sector.id" />
	<s:param name="departmentId" value="department.id" />
</s:url>

<p id="breadcrumbs"><s:a href="%{trails}">TRAILS</s:a> &gt; <s:a
	href="%{reports}">Reports</s:a> &gt; <s:a href="%{alerts}">Operational metrics</s:a>
&gt; <s:if
	test="geography != null && region != null && countryCode != null && department != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="regionLink" action="region" namespace="/reports/operational"
		includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:if> <s:elseif
	test="geography != null && region != null && countryCode != null && sector != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="regionLink" action="region" namespace="/reports/operational"
		includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
	
	<s:url id="sectorLink" action="sector" namespace="/reports/operational"
		includeContext="true" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>
	<s:a href="%{sectorLink}">Sector</s:a> &gt;
</s:elseif> <s:elseif
	test="geography != null && region != null && countryCode != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="regionLink" action="region" namespace="/reports/operational"
		includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
</s:elseif> <s:elseif
	test="geography != null && region != null && department != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="regionLink" action="region" namespace="/reports/operational"
		includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:elseif> <s:elseif test="geography != null && region != null && sector != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="regionLink" action="region" namespace="/reports/operational"
		includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="sectorLink" action="sector" namespace="/reports/operational"
		includeContext="true" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{sectorLink}">Sector</s:a> &gt;
</s:elseif> <s:elseif
	test="geography != null && countryCode != null && department != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:elseif> <s:elseif
	test="geography != null && countryCode != null && sector != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
	
	<s:url id="sectorLink" action="sector" namespace="/reports/operational"
		includeContext="true" includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{sectorLink}">Sector</s:a> &gt;
</s:elseif> <s:elseif
	test="region != null && countryCode != null && department != null">
	<s:url id="regionLink" action="region" namespace="/reports/operational"
		includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:elseif> <s:elseif
	test="region != null && countryCode != null && sector != null">
	<s:url id="regionLink" action="region" namespace="/reports/operational"
		includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
	
	<s:url id="sectorLink" action="sector" namespace="/reports/operational"
		includeContext="true" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{sectorLink}">Sector</s:a> &gt;
</s:elseif> <s:elseif test="geography != null && countryCode != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
</s:elseif> <s:elseif test="region != null && countryCode != null">
	<s:url id="regionLink" action="region" namespace="/reports/operational"
		includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
</s:elseif> <s:elseif test="countryCode != null && department != null">
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:elseif> <s:elseif test="countryCode != null && sector != null">
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
	
	<s:url id="sectorLink" action="sector" namespace="/reports/operational"
		includeContext="true" includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>
	<s:a href="%{sectorLink}">Sector</s:a> &gt;
</s:elseif> <s:elseif test="region != null && department != null">
	<s:url id="regionLink" action="region" namespace="/reports/operational"
		includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:elseif> <s:elseif test="region != null && sector != null">
	<s:url id="regionLink" action="region" namespace="/reports/operational"
		includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="sectorLink" action="sector" namespace="/reports/operational"
		includeContext="true" includeParams="none">
		<s:param name="regionId" value="region.id" />
	</s:url>
	<s:a href="%{sectorLink}">Sector</s:a> &gt;
</s:elseif> <s:elseif test="geography != null && department != null">
	<s:url id="geographyLink" action="region"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="departmentLink" action="department"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:elseif> <s:elseif test="geography != null && sector != null">
	<s:url id="geographyLink" action="region"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="sectorLink" action="sector" namespace="/reports/operational"
		includeContext="true" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{sectorLink}">Sector</s:a> &gt;
</s:elseif> <s:elseif test="countryCode != null">
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
</s:elseif> <s:elseif test="sector != null">
	<s:url id="sectorLink" action="sector" namespace="/reports/operational"
		includeContext="true" includeParams="none">
	</s:url>
	<s:a href="%{sectorLink}">Sector</s:a> &gt;
</s:elseif> <s:else>
	<s:url id="departmentLink" action="department"
		namespace="/reports/operational" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{departmentLink}">Department</s:a> &gt;
</s:else>
<s:a href="%{accountByNameLink}">Account by name</s:a> &gt;
</p>

<br />
<h1>Account</h1>
<h4>Operational metrics reports</h4>
<p class="confidential">IBM Confidential</p>
<p>The following reports reflect metric purification where customer financial responsible software has been counted towards closed alerts where IBM has documented report delivery dates in Schedule F Report Date Tracking.</p>
<br />

Data last refreshed:
<s:date name="reportTimestamp" format="MM-dd-yyyy HH:mm:ss 'EST'" />
<br />
Data age (in minutes):
<s:property value="reportMinutesOld" />
<br />

<div id="fourth-level"><s:if
	test="geography != null && region != null && countryCode != null && department != null">

	<br />
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
	<h2 class="green-dark">Department: <s:property
		value="department.name" /></h2>
</s:if> <s:elseif
	test="geography != null && region != null && countryCode != null && sector != null">

	<br />
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
	<h2 class="green-dark">Sector: <s:property value="sector.name" /></h2>
</s:elseif> <s:elseif
	test="geography != null && region != null && countryCode != null">

	<br />
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
</s:elseif> <s:elseif
	test="geography != null && region != null && department != null">

	<br />
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Department: <s:property
		value="department.name" /></h2>
</s:elseif> <s:elseif test="geography != null && region != null && sector != null">

	<br />
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Sector: <s:property value="sector.name" /></h2>
</s:elseif> <s:elseif
	test="geography != null && countryCode != null && department != null">

	<br />
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
	<h2 class="green-dark">Department: <s:property
		value="department.name" /></h2>
</s:elseif> <s:elseif
	test="geography != null && countryCode != null && sector != null">

	<br />
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
	<h2 class="green-dark">Sector: <s:property value="sector.name" /></h2>
</s:elseif> <s:elseif
	test="region != null && countryCode != null && department != null">

	<br />
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
	<h2 class="green-dark">Department: <s:property
		value="department.name" /></h2>
</s:elseif> <s:elseif
	test="region != null && countryCode != null && sector != null">

	<br />
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
	<h2 class="green-dark">Sector: <s:property value="sector.name" /></h2>
</s:elseif> <s:elseif test="geography != null && countryCode != null">

	<br />
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
</s:elseif> <s:elseif test="region != null && countryCode != null">

	<br />
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
</s:elseif> <s:elseif test="countryCode != null && department != null">

	<br />
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
	<h2 class="green-dark">Department: <s:property
		value="department.name" /></h2>
</s:elseif> <s:elseif test="countryCode != null && sector != null">

	<br />
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
	<h2 class="green-dark">Sector: <s:property value="sector.name" /></h2>
</s:elseif> <s:elseif test="region != null && department != null">

	<br />
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Department: <s:property
		value="department.name" /></h2>
</s:elseif> <s:elseif test="region != null && sector != null">

	<br />
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Sector: <s:property value="sector.name" /></h2>
</s:elseif> <s:elseif test="geography != null && department != null">

	<br />
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
	<h2 class="green-dark">Department: <s:property
		value="department.name" /></h2>
</s:elseif> <s:elseif test="geography != null && sector != null">

	<br />
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
	<h2 class="green-dark">Sector: <s:property value="sector.name" /></h2>
</s:elseif> <s:elseif test="countryCode != null">

	<br />
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
</s:elseif> <s:elseif test="sector != null">

	<br />
	<h2 class="green-dark">Sector: <s:property value="sector.name" /></h2>
</s:elseif> <s:else>

	<br />
	<h2 class="green-dark">Department: <s:property
		value="department.name" /></h2>
</s:else></div>
