<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data" class="basic-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="AlertRedAging summary by accountDetail"
	cellspacing="1" cellpadding="0" defaultsort="2" export="true"
	requestURI="/reports/alertRedAging/accountDetail.htm">
	<!-- <display:setProperty name="export.excel.filename" value="alertRedAgingAccount.xls"/> -->
	<display:caption media="excel">${account.account} - ${account.name} - ${account.accountType.name} - IBM confidential</display:caption>
	<display:column property="displayName" title="Alert type" />
	<display:column property="alertAge" title="Alert age" />
	<display:column property="machineType" title="Machine type" />
	<display:column property="serial" title="Serial" />
	<display:column property="hardwareLparName" title="Hardware lpar name" />
	<display:column property="softwareLparName" title="Software lpar name" />
	<display:column property="softwareName" title="Software name" />
</display:table>
