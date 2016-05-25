<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list"
	class="ibm-data-table ibm-sortable-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="DataExceptions summary by account" cellspacing="1"
	cellpadding="0" defaultsort="2" export="true"
	requestURI="/reports/dataExceptions/account.htm">
	<display:setProperty name="export.excel.filename"
		value="dataExceptionsAccount.xls" />
	<display:column property="account.account" title="Account #"
		href="/TRAILS/account/home.htm" paramId="accountId"
		paramProperty="account.id" group="1" media="html" />
	<display:column property="account.account" title="Account #"
		media="excel" />
	<display:column property="account.name" title="Account" group="1"
		media="html" />
	<display:column property="account.name" title="Account" media="excel" />
	<display:column property="alertType.name" title="Data exception type" />
	<display:column property="assigned" title="Assigned #" total="true"
		format="{0,number,0}" />
	<display:column property="total" title="Total #" total="true"
		format="{0,number,0}" />
</display:table>
