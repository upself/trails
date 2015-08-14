<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<s:if test="geographyId != null">
<span class="download-link">
	<s:url id="accountRegionLink" value="accountRegion.htm"
		includeContext="false" includeParams="none">
		<s:param name="geographyId" value="geography.id" />
		<s:param name="d-49653-e" value="2" />
		<s:param name="6578706f7274" value="1" />
	</s:url>
	<s:a href="%{accountRegionLink}">Account report</s:a>
</span>
</s:if>

<display:table name="data.list" class="basic-table"
	decorator="com.ibm.tap.trails.framework.OperationalReportTotalTableDecorator"
	summary="Operational Metric summary by region"
	cellspacing="1" cellpadding="0" defaultsort="1" export="true"
	requestURI="/reports/operational/region.htm">
	<display:setProperty name="export.excel.filename"
		value="operationalByRegion.xls" />
	<display:column property="name" title="Region" group="1"
		href="countryCode.htm?geographyId=${geography.id}" paramId="regionId"
		paramProperty="id" media="html" />
	<display:column property="name" title="Region" media="excel" />
	<display:column property="alertNameWithCount" title="Software Operational Metrics (Alert #)" />
	<display:column property="greenSum" title="Green(0-45)" total="true"
		format="{0,number,0}" />
	<display:column property="yellowSum" title="Yellow(46-90)" total="true"
		format="{0,number,0}" />
	<display:column property="redSum" title="Red(91+)" total="true"
		format="{0,number,0}" />
	<display:column property="assetSum" title="Universe" total="true"
		format="{0,number,0}" />
	<display:column property="operationalMetric" title="Operational metric"
		format="{0,number,0.00}%" total="true"/>
</display:table>
