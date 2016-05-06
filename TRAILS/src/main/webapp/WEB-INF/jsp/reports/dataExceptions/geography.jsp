<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list"
	class="ibm-data-table ibm-sortable-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="DataExceptions summary by geography" cellspacing="1"
	cellpadding="0" defaultsort="1" export="true"
	requestURI="/reports/dataExceptions/geography.htm">
	<display:setProperty name="export.excel.filename"
		value="dataExceptionsGeography.xls" />
	<display:column property="name" title="Geography" group="1"
		href="region.htm" paramId="geographyId" paramProperty="id"
		media="html" />
	<display:column property="name" title="Geography" media="excel" />
	<display:column property="alertType.name" title="Data exception type" />
	<display:column property="assigned" title="Assigned #" total="true"
		format="{0,number,0}" />
	<display:column property="total" title="Total #" total="true"
		format="{0,number,0}" />
</display:table>
