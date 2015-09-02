<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<s:if test="geographyId != null">
<span class="download-link">
	<s:url id="accountRegionLink" value="accountRegion.htm"
		includeContext="false" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
		<s:param name="d-49653-e" value="2" />
		<s:param name="6578706f7274" value="1" />
	</s:url>
	<s:a href="%{accountRegionLink}">Account report</s:a>
</span>
</s:if>

<display:table name="data.list" class="basic-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="AlertRedAging summary by region"
	cellspacing="1" cellpadding="0" defaultsort="1" export="true"
	requestURI="/reports/alertRedAging/region.htm">
	<display:setProperty name="export.excel.filename" value="alertRedAgingRegion.xls"/>
	<display:column property="name" title="Region" group="1"
		href="countryCode.htm?geographyId=${geography.id}" paramId="regionId"
		paramProperty="id" media="html" />
	<display:column property="name" title="Region" media="excel" />
	<display:column property="alertName" title="Software Operational Metrics" />
	<display:column property="red91Sum" title="Red(91-120)" total="true"
		format="{0,number,0}" />
	<display:column property="red121Sum" title="Red(121-150)" total="true"
		format="{0,number,0}" />
	<display:column property="red151Sum" title="Red(151-180)" total="true"
		format="{0,number,0}" />
	<display:column property="red181Sum" title="Red(181-365)" total="true"
		format="{0,number,0}" />
	<display:column property="red366Sum" title="Red(366+)" total="true"
		format="{0,number,0}" />
	<display:column property="totalRed" title="Red Total" total="true"
		format="{0,number,0}" />
</display:table>
