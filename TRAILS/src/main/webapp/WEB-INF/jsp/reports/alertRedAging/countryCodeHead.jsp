<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="trails" action="home" namespace="/" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="reports" action="home" namespace="/reports"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="alerts" action="home" namespace="/reports/alertRedAging"
	includeContext="true" includeParams="none">
</s:url>

<ul id="ibm-navigation-trail">
	<li><s:a href="%{trails}">TRAILS</s:a></li>
	<li><s:a href="%{reports}">Reports</s:a></li>
	<li><s:a href="%{alerts}">Aging red alerts</s:a></li>
	<s:if test="geography != null && region != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/alertRedAging" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>

		<s:url id="regionLink" action="region"
			namespace="/reports/alertRedAging" includeContext="true"
			includeParams="none">
			<s:param name="geographyId" value="geography.id" />
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>
	</s:if>
	<s:elseif test="geography != null">
		<s:url id="geographyLink" action="geography"
			namespace="/reports/alertRedAging" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{geographyLink}">Geography</s:a></li>
	</s:elseif>
	<s:elseif test="region != null">
		<s:url id="regionLink" action="region"
			namespace="/reports/alertRedAging" includeContext="true"
			includeParams="none">
		</s:url>
		<li><s:a href="%{regionLink}">Region</s:a></li>
	</s:elseif>
</ul>

<h1>Country code</h1>
<h4>Aging red alerts reports</h4>
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
	<s:if test="geography != null && region != null">
		<s:url id="countryCodeLink" value="countryCode.htm"
			includeContext="false" includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>

		<s:url id="departmentLink" value="department.htm"
			includeContext="false" includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>

		<s:url id="sectorLink" value="sector.htm" includeContext="false"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="geographyId" value="geography.id" />
		</s:url>

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{countryCodeLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Country code aging red alerts</s:a></li>
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link">Sector aging red alerts</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department aging red alerts</s:a></li>
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
	</s:if>
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
			<li><s:a href="%{regionLink}" cssClass="ibm-forward-link">Region aging red alerts</s:a></li>
			<li><s:a href="%{countryCodeLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Country code aging red alerts</s:a></li>
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link">Sector aging red alerts</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department aging red alerts</s:a></li>
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

		<s:url id="departmentLink" value="department.htm"
			includeContext="false" includeParams="none">
			<s:param name="regionId" value="region.id" />
		</s:url>

		<s:url id="sectorLink" value="sector.htm" includeContext="false"
			includeParams="none">
			<s:param name="regionId" value="region.id" />
		</s:url>

		<ul class="ibm-link-list horizontal-list">
			<li><s:a href="%{countryCodeLink}" cssClass="ibm-forward-link"
					cssStyle="font-weight: bold;text-decoration: underline;">Country code aging red alerts</s:a></li>
			<li><s:a href="%{sectorLink}" cssClass="ibm-forward-link">Sector aging red alerts</s:a></li>
			<li><s:a href="%{departmentLink}" cssClass="ibm-forward-link">Department aging red alerts</s:a></li>
		</ul>

		<br>
		<h2 class="green-dark">
			Region:
			<s:property value="region.name" />
		</h2>
	</s:elseif>
	<s:else>
	</s:else>
</div>
