<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="trails" action="home" namespace="/" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="reports" action="home" namespace="/reports"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="alerts" action="home" namespace="/reports/alerts"
	includeContext="true" includeParams="none">
</s:url>

<ul id="ibm-navigation-trail">
	<li><s:a href="%{trails}">TRAILS</s:a></li>
	<li><s:a href="%{reports}">Reports</s:a></li>
	<li><s:a href="%{alerts}">Alerts</s:a></li>
	<s:if
		test="geography != null && region != null && countryCode != null && department != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="regionLink" action="region" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>

		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>;
	
	<s:url id="departmentLink" action="department"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>
		<li><s:a href="%{departmentLink}">Department</s:a></li>
	</s:if>
	<s:elseif
		test="geography != null && region != null && countryCode != null && sector != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="regionLink" action="region" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>

		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>

		<s:url id="sectorLink" action="sector" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>
		<li><s:a href="%{sectorLink}">Sector</s:a></li>;
</s:elseif>
	<s:elseif
		test="geography != null && region != null && countryCode != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="regionLink" action="region" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>

		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>;
</s:elseif>
	<s:elseif
		test="geography != null && region != null && department != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="regionLink" action="region" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>

		<s:url id="departmentLink" action="department"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{departmentLink}">Department</s:a></li>
	</s:elseif>
	<s:elseif test="geography != null && region != null && sector != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="regionLink" action="region" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>

		<s:url id="sectorLink" action="sector" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{sectorLink}">Sector</s:a></li>
	</s:elseif>
	<s:elseif
		test="geography != null && countryCode != null && department != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>;
	
	<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>

		<s:url id="departmentLink" action="department"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="countryCodeId" value="countryCode.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{departmentLink}">Department</s:a></li>
	</s:elseif>
	<s:elseif
		test="geography != null && countryCode != null && sector != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>;
	
	<s:url id="sectorLink" action="sector" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
			<s:param name="countryCodeId" value="countryCode.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{sectorLink}">Sector</s:a></li>
	</s:elseif>
	<s:elseif
		test="region != null && countryCode != null && department != null">
		<s:url id="regionLink" action="region" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>;
	
	<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>

		<s:url id="departmentLink" action="department"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{departmentLink}">Department</s:a></li>
	</s:elseif>
	<s:elseif
		test="region != null && countryCode != null && sector != null">
		<s:url id="regionLink" action="region" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>

		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>

		<s:url id="sectorLink" action="sector" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{sectorLink}">Sector</s:a></li>
	</s:elseif>
	<s:elseif test="geography != null && countryCode != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>
	</s:elseif>
	<s:elseif test="region != null && countryCode != null">
		<s:url id="regionLink" action="region" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>

		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>
	</s:elseif>
	<s:elseif test="countryCode != null && department != null">
		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>

		<s:url id="departmentLink" action="department"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>
		<li><s:a href="%{departmentLink}">Department</s:a></li>
	</s:elseif>
	<s:elseif test="countryCode != null && sector != null">
		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>;
	
	<s:url id="sectorLink" action="sector" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>
		<li><s:a href="%{sectorLink}">Sector</s:a></li>
	</s:elseif>
	<s:elseif test="region != null && department != null">
		<s:url id="regionLink" action="region" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>;
	
	<s:url id="departmentLink" action="department"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
		</s:url>
		<li><s:a href="%{departmentLink}">Department</s:a></li>
	</s:elseif>
	<s:elseif test="region != null && sector != null">
		<s:url id="regionLink" action="region" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>

		<s:url id="sectorLink" action="sector" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
			<s:param name="regionId" value="region.id" />
		</s:url>
		<li><s:a href="%{sectorLink}">Sector</s:a></li>
	</s:elseif>
	<s:elseif test="geography != null && department != null">
		<s:url id="geographyLink" action="region" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="departmentLink" action="department"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{departmentLink}">Department</s:a></li>
	</s:elseif>
	<s:elseif test="geography != null && sector != null">
		<s:url id="geographyLink" action="region" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="sectorLink" action="sector" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{sectorLink}">Sector</s:a></li>
	</s:elseif>
	<s:elseif test="countryCode != null">
		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>;
</s:elseif>
	<s:elseif test="sector != null">
		<s:url id="sectorLink" action="sector" namespace="/reports/alerts"
			includeContext="true" includeParams="none">
		</s:url>
		<li><s:a href="%{sectorLink}">Sector</s:a></li>;
   </s:elseif>
	<s:else>
		<s:url id="departmentLink" action="department"
			namespace="/reports/alerts" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{departmentLink}">Department</s:a></li>;
   </s:else>
</ul>

<br />
<h1 class="oneline">Account alerts</h1>

<s:if
	test="geography != null || region != null || countryCode != null || department != null || sector != null">
	<p class="ibm-important">IBM Confidential</p>
	<p>The following reports reflect metric purification where customer
		financial responsible software has been counted towards closed alerts
		where IBM has documented report delivery dates in Schedule F Report
		Date Tracking.</p>
</s:if>
<br />
Data last refreshed:
<span class="ibm-item-note"> <s:date name="reportTimestamp"
		format="MM-dd-yyyy HH:mm:ss 'EST'" /></span>
<br />
Data age (in minutes):
<span class="ibm-item-note"> <s:property value="reportMinutesOld" /></span>
<br />

<div id="fourth-level">
	<s:if
		test="geography != null && region != null && countryCode != null && department != null">

		<br />
		<h2 class="green-dark">
			Geography:
			<s:property value="geography.name" />
		</h2>
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
		<h2 class="green-dark">
			Department:
			<s:property value="department.name" />
		</h2>
	</s:if>
	<s:elseif
		test="geography != null && region != null && countryCode != null && sector != null">

		<br />
		<h2 class="green-dark">
			Geography:
			<s:property value="geography.name" />
		</h2>
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
		<h2 class="green-dark">
			Sector:
			<s:property value="sector.name" />
		</h2>
	</s:elseif>
	<s:elseif
		test="geography != null && region != null && countryCode != null">
		<s:url id="sectorLink" value="sector.htm" includeContext="false"
			includeParams="none">
			<s:param name="countryCodeId" value="countryCode.id" />
			<s:param name="geographyId" value="geography.id" />
			<s:param name="regionId" value="region.id" />
		</s:url>

		<s:url id="departmentLink" value="department.htm"
			includeContext="false" includeParams="none">
			<s:param name="countryCodeId" value="countryCode.id" />
			<s:param name="geographyId" value="geography.id" />
			<s:param name="regionId" value="region.id" />
		</s:url>

		<s:url id="accountLink" value="account.htm" includeContext="false"
			includeParams="none">
			<s:param name="countryCodeId" value="countryCode.id" />
			<s:param name="geographyId" value="geography.id" />
			<s:param name="regionId" value="region.id" />
		</s:url>

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link">Sector alerts</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department alerts</s:a></li>
			<li><s:a href="%{accountLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Account alerts</s:a></li>
		</ul>

		<br />
		<h2 class="green-dark">
			Geography:
			<s:property value="geography.name" />
		</h2>
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
	</s:elseif>
	<s:elseif
		test="geography != null && region != null && department != null">

		<br />
		<h2 class="green-dark">
			Geography:
			<s:property value="geography.name" />
		</h2>
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
		<h2 class="green-dark">
			Department:
			<s:property value="department.name" />
		</h2>
	</s:elseif>
	<s:elseif test="geography != null && region != null && sector != null">

		<br />
		<h2 class="green-dark">
			Geography:
			<s:property value="geography.name" />
		</h2>
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
		<h2 class="green-dark">
			Sector:
			<s:property value="sector.name" />
		</h2>
	</s:elseif>
	<s:elseif
		test="geography != null && countryCode != null && department != null">

		<br />
		<h2 class="green-dark">
			Geography:
			<s:property value="geography.name" />
		</h2>
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
		<h2 class="green-dark">
			Department:
			<s:property value="department.name" />
		</h2>
	</s:elseif>
	<s:elseif
		test="geography != null && countryCode != null && sector != null">

		<br />
		<h2 class="green-dark">
			Geography:
			<s:property value="geography.name" />
		</h2>
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
		<h2 class="green-dark">
			Sector:
			<s:property value="sector.name" />
		</h2>
	</s:elseif>
	<s:elseif
		test="region != null && countryCode != null && department != null">

		<br />
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
		<h2 class="green-dark">
			Department:
			<s:property value="department.name" />
		</h2>
	</s:elseif>
	<s:elseif
		test="region != null && countryCode != null && sector != null">

		<br />
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
		<h2 class="green-dark">
			Sector:
			<s:property value="sector.name" />
		</h2>
	</s:elseif>
	<s:elseif test="geography != null && countryCode != null">
		<s:url id="sectorLink" value="sector.htm" includeContext="false"
			includeParams="none">
			<s:param name="geographyId" value="geography.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<s:url id="departmentLink" value="department.htm"
			includeContext="false" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<s:url id="accountLink" value="account.htm" includeContext="false"
			includeParams="none">
			<s:param name="geographyId" value="geography.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link">Sector alerts</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department alerts</s:a></li>
			<li><s:a href="%{accountLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Account alerts</s:a></li>
		</ul>

		<br />
		<h2 class="green-dark">
			Geography:
			<s:property value="geography.name" />
		</h2>
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
	</s:elseif>
	<s:elseif test="region != null && countryCode != null">
		<s:url id="sectorLink" value="sector.htm" includeContext="false"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>
		<s:url id="departmentLink" value="department.htm"
			includeContext="false" includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<s:url id="accountLink" value="account.htm" includeContext="false"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link">Sector alerts</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department alerts</s:a></li>
			<li><s:a href="%{accountLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Account alerts</s:a></li>
		</ul>

		<br />
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
	</s:elseif>
	<s:elseif test="countryCode != null && department != null">

		<br />
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
		<h2 class="green-dark">
			Department:
			<s:property value="department.name" />
		</h2>
	</s:elseif>
	<s:elseif test="countryCode != null && sector != null">

		<br />
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
		<h2 class="green-dark">
			Sector:
			<s:property value="sector.name" />
		</h2>
	</s:elseif>
	<s:elseif test="region != null && department != null">

		<br />
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
		<h2 class="green-dark">
			Department:
			<s:property value="department.name" />
		</h2>
	</s:elseif>
	<s:elseif test="region != null && sector != null">

		<br />
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
		<h2 class="green-dark">
			Sector:
			<s:property value="sector.name" />
		</h2>
	</s:elseif>
	<s:elseif test="geography != null && department != null">

		<br />
		<h2 class="green-dark">
			Geography:
			<s:property value="geography.name" />
		</h2>
		<h2 class="green-dark">
			Department:
			<s:property value="department.name" />
		</h2>
	</s:elseif>
	<s:elseif test="geography != null && sector != null">

		<br />
		<h2 class="green-dark">
			Geography:
			<s:property value="geography.name" />
		</h2>
		<h2 class="green-dark">
			Sector:
			<s:property value="sector.name" />
		</h2>
	</s:elseif>
	<s:elseif test="countryCode != null">
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

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link">Sector alerts</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department alerts</s:a></li>
			<li><s:a href="%{accountLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Account alerts</s:a></li>
		</ul>

		<br />
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
	</s:elseif>
	<s:elseif test="sector != null">

		<br />
		<h2 class="green-dark">
			Sector:
			<s:property value="sector.name" />
		</h2>
	</s:elseif>
	<s:else>

		<br />
		<h2 class="green-dark">
			Department:
			<s:property value="department.name" />
		</h2>
	</s:else>
</div>