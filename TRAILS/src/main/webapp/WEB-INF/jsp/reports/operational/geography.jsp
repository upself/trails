<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list" class="basic-table"
	decorator="com.ibm.tap.trails.framework.OperationalReportTotalTableDecorator"
	summary="Operational Metric summary by geography"
	cellspacing="1" cellpadding="0" defaultsort="1" export="true"
	requestURI="/reports/operational/geography.htm">
	   <display:caption media="excel">
          IBM Confidential
    </display:caption>
	<display:setProperty name="export.excel.filename"
		value="operationalByGeography.xls" />
	<display:column property="name" title="Geography" group="1"
		href="region.htm" paramId="geographyId" paramProperty="id"
		media="html" />
	<display:column property="name" title="Geography" media="excel" />
	<display:column property="alertNameWithCount" title="Software Operational Metrics(Alert #)" />
	<display:column property="greenSum" title="Green(0-45)" total="true"
		format="{0,number,0}" />
	<display:column property="yellowSum" title="Yellow(46-90)" total="true"
		format="{0,number,0}" />
	<display:column property="redSum" title="Red(91+)" total="true"
		format="{0,number,0}" />
	<display:column property="assetSum" title="Universe" total="true"
		format="{0,number,0}" />
	<display:column property="operationalMetric" title="Operational metric"
		format="{0,number,0.00}%" total="true" />
</display:table>


