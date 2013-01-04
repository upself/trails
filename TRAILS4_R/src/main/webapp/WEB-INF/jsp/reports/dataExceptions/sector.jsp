<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list" class="basic-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="DataExceptions summary by sector"
	cellspacing="1" cellpadding="0" defaultsort="1" export="true"
	requestURI="/reports/dataExceptions/sector.htm">
	<display:setProperty name="export.excel.filename"
		value="dataExceptionsSector.xls"/>
	<display:column property="name" title="Sector" group="1"
		href="account.htm?geographyId=${geography.id}&regionId=${region.id}&countryCodeId=${countryCode.id}"
		paramId="sectorId" paramProperty="id" media="html" />
	<display:column property="name" title="Sector" media="excel" />
	<display:column property="alertType.name" title="Data exception type" />
	<display:column property="assigned" title="Assigned #" total="true"
		format="{0,number,0}" />
	<display:column property="total" title="Total #" total="true"
		format="{0,number,0}" />
</display:table>
