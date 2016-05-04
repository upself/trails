<%@ taglib prefix="s" uri="/struts-tags"%>

<ul class="ibm-link-list">
	<li><s:a
			href="http://%{#attr.trailsFileServerName}/reports/temp/trails/pendingCustomerDecisionByGeoRegionCountry.tsv"
			cssClass="ibm-download-link">By geography, region and country</s:a></li>
	<li><s:a
			href="http://%{#attr.trailsFileServerName}/reports/temp/trails/pendingCustomerDecisionByGeoRegionCountryAccount.tsv"
			cssClass="ibm-download-link">By geography, region, country and account</s:a>
	</li>
</ul>
