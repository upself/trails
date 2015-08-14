<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list" class="basic-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="AlertRedAging summary by geography"
	cellspacing="1" cellpadding="0" defaultsort="1" export="true"
	requestURI="/reports/alertRedAging/geography.htm">
	<display:setProperty name="export.excel.filename" value="alertRedAgingGeography.xls"/>
	<display:column property="name" title="Geography" group="1"
		href="region.htm" paramId="geographyId" paramProperty="id"
		media="html" />
	<display:column property="name" title="Geography" media="excel" />
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


