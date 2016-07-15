<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list"
	class="ibm-data-table ibm-sortable-table" id="row"
	decorator="com.ibm.tap.trails.framework.OperationalReportTotalTableDecorator"
	summary="Software Tracking Only Metric summary by department" cellspacing="1"
	cellpadding="0" defaultsort="1" export="true"
	requestURI="/reports/softwareTracking/department.htm">
	<display:setProperty name="export.excel.filename"
		value="alertSwTrackingOnlyByDepartment.xls" />
	<display:column title="Department" group="1"
		href="accountByName.htm?geographyId=${geography.id}&regionId=${region.id}&countryCodeId=${countryCode.id}"
		paramId="departmentId" paramProperty="id" media="html">
		<s:if test="%{#attr.row.name==''}">
            NO NAME
        </s:if>
		<s:else>
			<s:property value="%{#attr.row.name}" />
		</s:else>
	</display:column>
	<display:column property="name" title="Department" media="excel" />
	<display:column property="alertNameWithCount"
		title="Software Tracking Only Metrics(Alert #)" />
	<display:column property="greenSum" title="Green(0-45)" total="true"
		format="{0,number,0}" />
	<display:column property="yellowSum" title="Yellow(46-90)" total="true"
		format="{0,number,0}" />
	<display:column property="redSum" title="Red(91+)" total="true"
		format="{0,number,0}" />
	<display:column property="assetSum" title="Universe" total="true"
		format="{0,number,0}" />
	<display:column property="operationalMetric" title="Software Tracking Only metric"
		format="{0,number,0.00}%" total="true" />
</display:table>
