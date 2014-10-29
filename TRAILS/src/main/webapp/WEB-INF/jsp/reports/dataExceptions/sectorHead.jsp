<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="trails" action="home" namespace="/" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="reports" action="home" namespace="/reports"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="dataExceptions" action="home"
	namespace="/reports/dataExceptions" includeContext="true"
	includeParams="none">
</s:url>

<p id="breadcrumbs"><s:a href="%{trails}">TRAILS</s:a> &gt; <s:a
	href="%{reports}">Reports</s:a> &gt; <s:a href="%{dataExceptions}">Data exceptions</s:a>
&gt; <s:if
	test="geography != null && region != null && countryCode != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/dataExceptions" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="regionLink" action="region"
		namespace="/reports/dataExceptions" includeContext="true"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/dataExceptions" includeContext="true"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
</s:if> <s:elseif test="geography != null && region != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/dataExceptions" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="regionLink" action="region"
		namespace="/reports/dataExceptions" includeContext="true"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
</s:elseif> <s:elseif test="geography != null && countryCode != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/dataExceptions" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/dataExceptions" includeContext="true"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
</s:elseif> <s:elseif test="region != null && countryCode != null">
	<s:url id="regionLink" action="region"
		namespace="/reports/dataExceptions" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
	
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/dataExceptions" includeContext="true"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
	</s:url>
	<s:a href="%{countryCodeLink}">Country code</s:a> &gt;
</s:elseif> <s:elseif test="geography != null">
	<s:url id="geographyLink" action="geography"
		namespace="/reports/dataExceptions" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{geographyLink}">Geography</s:a> &gt;
</s:elseif> <s:elseif test="region != null">
	<s:url id="regionLink" action="region"
		namespace="/reports/dataExceptions" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{regionLink}">Region</s:a> &gt;
</s:elseif> <s:elseif test="countryCode != null">
	<s:url id="countryCodeLink" action="countryCode"
		namespace="/reports/dataExceptions" includeContext="true"
		includeParams="none">
	</s:url>
	<s:a href="%{countryCodeLink}">Country Code</s:a> &gt;
</s:elseif></p>

<br>
<h1>Sector</h1>
<h4>Data exceptions reports</h4>
<p class="confidential">IBM Confidential</p>
<br />

Data last refreshed:
<s:date name="reportTimestamp" format="MM-dd-yyyy HH:mm:ss 'EST'" />
<br />
Data age (in minutes):
<s:property value="reportMinutesOld" />
<br />

<div id="fourth-level"><s:if
	test="geography != null && region != null && countryCode != null">
	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
		<s:param name="regionId" value="region.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<s:url id="sectorLink" value="sector.htm" includeContext="false"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
		<s:param name="regionId" value="region.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<s:url id="accountLink" value="account.htm" includeContext="false"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
		<s:param name="regionId" value="region.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{sectorLink}" cssClass="active">Sector data exceptions</s:a>|</li>
		<li><s:a href="%{departmentLink}">Department data exceptions</s:a>|</li>
		<li><s:a href="%{accountLink}">Account data exceptions</s:a></li>
	</ul>

	<br>
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
	<h2 class="green-dark">Region:<s:property value="region.name" /></h2>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
</s:if> <s:elseif test="geography != null && region != null">
	<s:url id="countryCodeLink" value="countryCode.htm"
		includeContext="false" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<s:url id="sectorLink" value="sector.htm" includeContext="false"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{countryCodeLink}">Country code data exceptions</s:a>|</li>
		<li><s:a href="%{sectorLink}" cssClass="active">Sector data exceptions</s:a>|</li>
		<li><s:a href="%{departmentLink}">Department data exceptions</s:a></li>
	</ul>

	<br>
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
</s:elseif> <s:elseif test="geography != null && countryCode != null">
	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<s:url id="sectorLink" value="sector.htm" includeContext="false"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<s:url id="accountLink" value="account.htm" includeContext="false"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{sectorLink}" cssClass="active">Sector data exceptions</s:a>|</li>
		<li><s:a href="%{departmentLink}">Department data exceptions</s:a>|</li>
		<li><s:a href="%{accountLink}">Account data exceptions</s:a></li>
	</ul>

	<br>
	<h2 class="green-dark">Geography: <s:property
		value="countryCode.name" /></h2>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
</s:elseif> <s:elseif test="region != null && countryCode != null">
	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<s:url id="sectorLink" value="sector.htm" includeContext="false"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<s:url id="accountLink" value="account.htm" includeContext="false"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{sectorLink}" cssClass="active">Sector data exceptions</s:a>|</li>
		<li><s:a href="%{departmentLink}">Department data exceptions</s:a>|</li>
		<li><s:a href="%{accountLink}">Account data exceptions</s:a></li>
	</ul>

	<br>
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
</s:elseif> <s:elseif test="geography != null">
	<s:url id="regionLink" value="region.htm" includeContext="false"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<s:url id="countryCodeLink" value="countryCode.htm"
		includeContext="false" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<s:url id="sectorLink" value="sector.htm" includeContext="false"
		includeParams="none">
		<s:param name="geographyId" value="geography.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{regionLink}">Region data exceptions</s:a>|</li>
		<li><s:a href="%{countryCodeLink}">Country code data exceptions</s:a>|</li>
		<li><s:a href="%{sectorLink}" cssClass="active">Sector data exceptions</s:a>|</li>
		<li><s:a href="%{departmentLink}">Department data exceptions</s:a></li>
	</ul>

	<br>
	<h2 class="green-dark">Geography: <s:property
		value="geography.name" /></h2>
</s:elseif> <s:elseif test="region != null">

	<s:url id="countryCodeLink" value="countryCode.htm"
		includeContext="false" includeParams="none">
		<s:param name="regionId" value="region.id" />
	</s:url>

	<s:url id="sectorLink" value="sector.htm" includeContext="false"
		includeParams="none">
		<s:param name="regionId" value="region.id" />
	</s:url>

	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="regionId" value="region.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{countryCodeLink}">Country code data exceptions</s:a>|</li>
		<li><s:a href="%{sectorLink}" cssClass="active">Sector data exceptions</s:a>|</li>
		<li><s:a href="%{departmentLink}">Department data exceptions</s:a></li>
	</ul>

	<br>
	<h2 class="green-dark">Region: <s:property value="region.name" /></h2>
</s:elseif> <s:elseif test="countryCode != null">
	<s:url id="sectorLink" value="sector.htm" includeContext="false"
		includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<s:url id="departmentLink" value="department.htm"
		includeContext="false" includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<s:url id="accountLink" value="account.htm" includeContext="false"
		includeParams="none">
		<s:param name="countryCodeId" value="countryCode.id" />
	</s:url>

	<ul class="text-tabs">
		<li><s:a href="%{sectorLink}" cssClass="active">Sector data exceptions</s:a>|</li>
		<li><s:a href="%{departmentLink}">Department data exceptions</s:a>|</li>
		<li><s:a href="%{accountLink}">Account data exceptions</s:a></li>
	</ul>

	<br>
	<h2 class="green-dark">Country code: <s:property
		value="countryCode.name" /></h2>
</s:elseif> <s:else>
</s:else></div>
