<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data" class="basic-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="Operational Metric summary by accountRegion"
	cellspacing="1" cellpadding="0" defaultsort="2" export="true"
	requestURI="/reports/operational/accountRegion.htm">
	<display:setProperty name="export.excel.filename" value="operationalAccountRegion.xls"/>
	<display:caption media="excel">${geography.name} - IBM confidential</display:caption>
	<display:column property="accountNumber" title="Account #" />
	<display:column property="name" title="Account" />
	<display:column property="regionName" title="Region" />
	<display:column property="countryCodeName" title="Country code" />
	<display:column property="sectorName" title="Sector" />
	<display:column property="accountTypeName" title="Account type" />
	<display:column property="alertNameWithCount" title="Software Operational Metrics(Alert #)" />
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
