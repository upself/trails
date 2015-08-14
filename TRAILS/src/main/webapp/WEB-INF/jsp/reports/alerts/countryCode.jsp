<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list" class="basic-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="Alert summary by countryCode"
	cellspacing="1" cellpadding="0" defaultsort="1">
	<display:column property="name" title="Country code" group="1"
		href="sector.htm?geographyId=${geography.id}&regionId=${region.id}"
		paramId="countryCodeId" paramProperty="id" />
	<display:column property="alertNameWithCount" title="Software Operational Metrics (Alert #)" />
	<display:column property="assignedCount" title="Assigned #"
		total="true" format="{0,number,0}" />
	<display:column property="greenSum" title="Green(0-45)" total="true"
		format="{0,number,0}" />
	<display:column property="yellowSum" title="Yellow(46-90)" total="true"
		format="{0,number,0}" />
	<display:column property="redSum" title="Red(91+)" total="true"
		format="{0,number,0}" />

</display:table>
