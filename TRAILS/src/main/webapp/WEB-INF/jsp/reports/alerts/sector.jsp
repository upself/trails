<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list" class="ibm-data-table ibm-sortable-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="Alert summary by sector"
	cellspacing="1" cellpadding="0" defaultsort="1">
	<display:column property="name" title="Sector" group="1"
		href="account.htm?geographyId=${geography.id}&regionId=${region.id}&countryCodeId=${countryCode.id}"
		paramId="sectorId" paramProperty="id" />
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
