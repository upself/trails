<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list"
	class="ibm-data-table ibm-sortable-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="AlertRedAging summary by account" cellspacing="1"
	cellpadding="0" defaultsort="2" export="true"
	requestURI="/reports/alertRedAging/account.htm">
	<display:setProperty name="export.excel.filename"
		value="alertRedAgingAccount.xls" />
	<display:column property="accountNumber" title="Account #"
		href="/TRAILS/reports/alertRedAging/accountDetail.htm?d-49653-e=2&6578706f7274=1"
		paramId="accountId" paramProperty="id" group="1" media="html" />
	<display:column property="accountNumber" title="Account #"
		media="excel" />
	<display:column property="name" title="Account" group="1" media="html" />
	<display:column property="name" title="Account" media="excel" />
	<display:column property="alertName"
		title="Software Operational Metrics" />
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
