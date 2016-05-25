<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list" class="ibm-data-table ibm-sortable-table" 
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="Alert summary by account"
	cellspacing="1" cellpadding="0" defaultsort="2">
	<display:column property="accountNumber" title="Account #"
		href="/TRAILS/account/home.htm" paramId="accountId" paramProperty="id"
		group="1" />
	<display:column property="name" title="Account" group="1" />
	<display:column property="alertNameWithCount" title="Software Operational Metrics(Alert #)" />
	<display:column property="assignedCount" title="Assigned #"
		total="true" format="{0,number,0}" />
	<display:column property="greenSum" title="Green(0-45)" total="true"
		format="{0,number,0}" />
	<display:column property="yellowSum" title="Yellow(46-90)" total="true"
		format="{0,number,0}" />
	<display:column property="redSum" title="Red(91+)" total="true"
		format="{0,number,0}" />

</display:table>
