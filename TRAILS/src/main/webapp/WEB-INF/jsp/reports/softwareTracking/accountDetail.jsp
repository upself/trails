<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list"
	class="ibm-data-table ibm-sortable-table"
	decorator="com.ibm.tap.trails.framework.OperationalReportTotalTableDecorator"
	summary="Software Tracking Only Metric summary by accountDetail" cellspacing="1"
	cellpadding="0" defaultsort="1" export="true"
	requestURI="/reports/softwareTracking/accountByName.htm">
	<display:setProperty name="export.excel.filename"
		value="alertSwTrackingOnlyByAccount.xls" />
	<display:column property="accountNumber" title="Account #"
		href="/TRAILS/reports/softwareTracking/accountDetailDownload.htm?d-49653-e=2&6578706f7274=1"
		paramId="accountId" paramProperty="id" group="1" media="html" />
	<display:column property="accountNumber" title="Account #"
		media="excel" />
	<display:column property="name" title="Account" group="1" media="html" />
	<display:column property="name" title="Account" media="excel" />
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
