<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list"
	class="ibm-data-table ibm-alternating"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="DataExceptions summary by countryCode" cellspacing="1"
	cellpadding="0" defaultsort="1" export="true"
	requestURI="/reports/dataExceptions/countryCode.htm">
	<display:setProperty name="export.excel.filename"
		value="dataExceptionsCountryCode.xls" />
	<display:column property="name" title="Country code" group="1"
		href="sector.htm?geographyId=${geography.id}&regionId=${region.id}"
		paramId="countryCodeId" paramProperty="id" media="html" />
	<display:column property="name" title="Country code" media="excel" />
	<display:column property="alertType.name" title="Data exception type" />
	<display:column property="assigned" title="Assigned #" total="true"
		format="{0,number,0}" />
	<display:column property="total" title="Total #" total="true"
		format="{0,number,0}" />
</display:table>
