<%@ taglib prefix="s" uri="/struts-tags"%>

<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<h1>Pending customer decision</h1>
<h4>Alerts reports</h4>
<p class="confidential">IBM Confidential</p>
<br />
<br />

<h2 class="bar-blue-med-light">Pending customer decision reports</h2><br />
<span class="download-link">
	<s:a href="http://%{#attr.trailsFileServerName}/reports/temp/trails/pendingCustomerDecisionByGeoRegionCountry.tsv">By geography, region and country</s:a>
</span>
<span class="download-link">
	<s:a href="http://%{#attr.trailsFileServerName}/reports/temp/trails/pendingCustomerDecisionByGeoRegionCountryAccount.tsv">By geography, region, country and account</s:a>
</span>
