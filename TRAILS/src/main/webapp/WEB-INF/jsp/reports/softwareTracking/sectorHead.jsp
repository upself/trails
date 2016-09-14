<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="trails" action="home" namespace="/" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="reports" action="home" namespace="/reports"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="alerts" action="home" namespace="/reports/softwareTracking"
	includeContext="true" includeParams="none">
</s:url>

<ul id="ibm-navigation-trail">
	<li><s:a href="%{trails}">TRAILS</s:a></li>
	<li><s:a href="%{reports}">Reports</s:a></li>
	<li><s:a href="%{alerts}">Software Tracking Only metrics</s:a></li>

	<s:if test="geography != null && region != null && countryCode != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/softwareTracking" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="regionLink" action="region"
			namespace="/reports/softwareTracking" includeContext="true"
			includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>

		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/softwareTracking" includeContext="true"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>

		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>
	</s:if>
	<s:elseif test="geography != null && region != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/softwareTracking" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="regionLink" action="region"
			namespace="/reports/softwareTracking" includeContext="true"
			includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>
	</s:elseif>
	<s:elseif test="geography != null && countryCode != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/softwareTracking" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/softwareTracking" includeContext="true"
			includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>
	</s:elseif>
	<s:elseif test="region != null && countryCode != null">
		<s:url id="regionLink" action="region"
			namespace="/reports/softwareTracking" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>

		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/softwareTracking" includeContext="true"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country code</s:a></li>
	</s:elseif>
	<s:elseif test="geography != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/softwareTracking" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>
	</s:elseif>
	<s:elseif test="region != null">
		<s:url id="regionLink" action="region"
			namespace="/reports/softwareTracking" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>
	</s:elseif>
	<s:elseif test="countryCode != null">
		<s:url id="countryCodeLink" action="countryCode"
			namespace="/reports/softwareTracking" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{countryCodeLink}">Country Code</s:a></li>
	</s:elseif>
</ul>

<h1>Sector</h1>
<h4>Software Tracking Only metrics reports</h4>
<p class="ibm-confidential">IBM Confidential</p>
<p>The following reports reflect metric purification where customer
	financial responsible software has been counted towards closed alerts
	where IBM has documented report delivery dates in Schedule F Report
	Date Tracking.</p>
<br />

Data last refreshed:
<span class="ibm-item-note"> <s:date name="reportTimestamp"
		format="MM-dd-yyyy HH:mm:ss 'EST'" /></span>
<br />
Data age (in minutes):
<span class="ibm-item-note"> <s:property value="reportMinutesOld" /></span>
<br />

<div id="fourth-level">
	<s:if test="geography != null && region != null && countryCode != null">
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

		<s:url id="accountByNameLink" value="accountByName.htm"
			includeContext="false" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
			<s:param name="regionId" value="region.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<s:url id="accountByNumberLink" value="accountByNumber.htm"
			includeContext="false" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
			<s:param name="regionId" value="region.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Sector Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{accountByNameLink}" cssClass="ibm-forward-link">Account by name Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{accountByNumberLink}"
					cssClass="ibm-forward-link">Account by number Software Tracking Only metrics</s:a></li>
		</ul>

		<br>
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
	</s:if>
	<s:elseif test="geography != null && region != null">
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

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{countryCodeLink}" cssClass="ibm-forward-link">Country code Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Sector Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department Software Tracking Only metrics</s:a></li>
		</ul>

		<br>
		<h2 class="green-dark">
			Geography:
			<s:property value="geography.name" />
		</h2>
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
	</s:elseif>
	<s:elseif test="geography != null && countryCode != null">
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

		<s:url id="accountByNameLink" value="accountByName.htm"
			includeContext="false" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<s:url id="accountByNumberLink" value="accountByNumber.htm"
			includeContext="false" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Sector Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{accountByNameLink}" cssClass="ibm-forward-link">Account by name Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{accountByNumberLink}"
					cssClass="ibm-forward-link">Account by number Software Tracking Only metrics</s:a></li>
		</ul>

		<br>
		<h2 class="green-dark">
			Geography:
			<s:property value="countryCode.name" />
		</h2>
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
	</s:elseif>
	<s:elseif test="region != null && countryCode != null">
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

		<s:url id="accountByNameLink" value="accountByName.htm"
			includeContext="false" includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<s:url id="accountByNumberLink" value="accountByNumber.htm"
			includeContext="false" includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Sector Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{accountByNameLink}" cssClass="ibm-forward-link">Account by name Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{accountByNumberLink}"
					cssClass="ibm-forward-link">Account by number Software Tracking Only metrics</s:a></li>
		</ul>

		<br>
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
	</s:elseif>
	<s:elseif test="geography != null">
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

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{regionLink}" cssClass="ibm-forward-link">Region Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{countryCodeLink}" cssClass="ibm-forward-link">Country code Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Sector Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department Software Tracking Only metrics</s:a></li>
		</ul>

		<br>
		<h2 class="green-dark">
			Geography:
			<s:property value="geography.name" />
		</h2>
	</s:elseif>
	<s:elseif test="region != null">

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

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{countryCodeLink}" cssClass="ibm-forward-link">Country code Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Sector Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department Software Tracking Only metrics</s:a></li>
		</ul>

		<br>
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
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

		<s:url id="accountByNameLink" value="accountByName.htm"
			includeContext="false" includeParams="none">
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<s:url id="accountByNumberLink" value="accountByNumber.htm"
			includeContext="false" includeParams="none">
			<s:param name="countryCodeId" value="countryCode.id" />
		</s:url>

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Sector Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{accountByNameLink}" cssClass="ibm-forward-link">Account by name Software Tracking Only metrics</s:a></li>
			<li><s:a href="%{accountByNumberLink}"
					cssClass="ibm-forward-link">Account by number Software Tracking Only metrics</s:a></li>
		</ul>

		<br>
		<h2 class="green-dark">
			Country code:
			<s:property value="countryCode.name" />
		</h2>
	</s:elseif>
	<s:else>
	</s:else>
</div>
