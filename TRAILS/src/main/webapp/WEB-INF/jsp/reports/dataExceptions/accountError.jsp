<%@ taglib prefix="s" uri="/struts-tags"%>

This page will only display accounts at the country code level or lower.
Please narrow the result set by selecting one of the alert report
navigation links on the left or choose a link below:

<s:url id="geographyLink" action="geography"
	namespace="/reports/dataExceptions" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="regionLink" action="region"
	namespace="/reports/dataExceptions" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="countryCodeLink" action="countryCode"
	namespace="/reports/dataExceptions" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="departmentLink" action="department"
	namespace="/reports/dataExceptions" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="sectorLink" action="sector"
	namespace="/reports/dataExceptions" includeContext="true"
	includeParams="none">
</s:url>

<ul class="ibm-bullet-list">
	<li><s:a href="%{geographyLink}">Geography</s:a></li>
	<li><s:a href="%{regionLink}">Region</s:a></li>
	<li><s:a href="%{countryCodeLink}">Country code</s:a></li>
	<li><s:a href="%{sectorLink}">Sector</s:a></li>
	<li><s:a href="%{departmentLink}">Department</s:a></li>
	<li>
		<a href="https://www-950.ibm.com/ram/assetDetail/generalDetails.faces?guid=0DFB1651-7375-F052-0886-9CBEBA19BB53" target="_blank">See GLOBAL SW EDUCATION: Managing TRAILS Data Exceptions for more details.</a>
	</li>
</ul>
