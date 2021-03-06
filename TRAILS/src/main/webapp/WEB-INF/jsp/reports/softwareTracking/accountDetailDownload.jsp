<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data" class="basic-table"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	summary="Software Tracking Only Metrc summary by accountDetailDownload"
	cellspacing="1" cellpadding="0" defaultsort="2" export="true"
	requestURI="/reports/softwareTracking/accountDetailDownload.htm">
	<display:setProperty name="export.excel.filename"
		value="alertSwTrackingOnlyAccount.xls"/>
	<!--<display:caption media="excel">${account.account} - ${account.name} - ${account.accountType.name} - IBM confidential</display:caption> -->
	<display:column property="alertNameWithCount" title="Sw Tracking Only Report Metrics(Alert #)" />
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
