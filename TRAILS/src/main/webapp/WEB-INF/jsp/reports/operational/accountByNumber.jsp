<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<display:table name="data.list" class="basic-table"
	decorator="com.ibm.tap.trails.framework.OperationalReportTotalTableDecorator"
	summary="Operational Metric summary by accountByNumber"
	cellspacing="1" cellpadding="0" defaultsort="1" export="true"
	requestURI="/reports/operational/accountByNumber.htm">
	<display:setProperty name="export.excel.filename"
		value="operationalByAccountNumber.xls" />
	<display:column property="accountNumber" title="Account #"
		href="/TRAILS/account/home.htm" paramId="accountId" paramProperty="id"
		group="1" media="html" />
	<display:column property="accountNumber" title="Account #" media="excel" />
	<display:column property="name" title="Account" group="1" media="html" />
	<display:column property="name" title="Account" media="excel" />
	<display:column property="geographyName" title="Geography" media="excel" />
	<display:column property="regionName" title="Region" media="excel" />
	<display:column property="countryCodeName" title="Country" media="excel" />
	<display:column property="sectorName" title="Sector" media="excel" />
	<display:column property="accountTypeName" title="Account type" media="excel" />
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
