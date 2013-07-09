<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data" class="basic-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="Operational Metric summary by accountCountryCode"
	cellspacing="1" cellpadding="0" defaultsort="2" export="true"
	requestURI="/reports/operational/accountCountryCode.htm">
	<display:setProperty name="export.excel.filename"
		value="operationalAccountCountryCode.xls"/>
	<!--<display:caption media="excel">
		<s:if test="geography != null && region != null">${geography.name} - ${region.name} - IBM confidential</s:if>
		<s:elseif test="geography != null">${geography.name} - IBM confidential</s:elseif>
		<s:else>${region.name} - IBM confidential</s:else>
	</display:caption> -->
	<display:column property="accountNumber" title="Account #" />
	<display:column property="name" title="Account" />
	<s:if test="geography == null">
		<display:column property="geographyName" title="Geography" />
	</s:if>
	<s:if test="region == null">
		<display:column property="regionName" title="Region" />
	</s:if>
	<display:column property="countryCodeName" title="Country code" />
	<display:column property="sectorName" title="Sector" />
	<display:column property="accountTypeName" title="Account type" />
	<display:column property="alertNameWithCount" title="Alert(#)" />
	<display:column property="greenSum" title="Green(0-45)" total="true"
		format="{0,number,0}" />
	<display:column property="yellowSum" title="Yellow(46-90)" total="true"
		format="{0,number,0}" />
	<display:column property="redSum" title="Red(91+)" total="true"
		format="{0,number,0}" />
	<display:column property="assetSum" title="Universe" total="true"
		format="{0,number,0}" />
	<display:column property="operationalMetric" title="Operational metric"
		format="{0,number,0.00}%" total="true" />
</display:table>
