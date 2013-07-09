<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data" class="basic-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="AlertRedAging summary by accountRegion"
	cellspacing="1" cellpadding="0" defaultsort="2" export="true"
	requestURI="/reports/alertRedAging/accountRegion.htm">
	<display:setProperty name="export.excel.filename"
		value="alertRedAgingAccountRegion.xls"/>
    <display:caption media="excel">${geography.name} - IBM confidential</display:caption>
	<display:column property="accountNumber" title="Account #" />
	<display:column property="name" title="Account" />
	<display:column property="regionName" title="Region" />
	<display:column property="countryCodeName" title="Country code" />
	<display:column property="sectorName" title="Sector" />
	<display:column property="accountTypeName" title="Account type" />
	<display:column property="alertName" title="Alert" />
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
