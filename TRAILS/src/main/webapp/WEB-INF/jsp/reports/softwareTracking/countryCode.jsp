<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<s:if test="geographyId != null || region != null">
	<s:if test="geographyId != null && region != null">
		<s:url id="accountCountryCodeLink" value="accountCountryCode.htm"
			includeContext="false" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
			<s:param name="regionId" value="region.id" />
			<s:param name="d-49653-e" value="2" />
			<s:param name="6578706f7274" value="1" />
		</s:url>
	</s:if>
	<s:elseif test="geographyId != null">
		<s:url id="accountCountryCodeLink" value="accountCountryCode.htm"
			includeContext="false" includeParams="none">
			<s:param name="geographyId" value="geography.id" />
			<s:param name="d-49653-e" value="2" />
			<s:param name="6578706f7274" value="1" />
		</s:url>
	</s:elseif>
	<s:else>
		<s:url id="accountCountryCodeLink" value="accountCountryCode.htm"
			includeContext="false" includeParams="none">
			<s:param name="regionId" value="region.id" />
			<s:param name="d-49653-e" value="2" />
			<s:param name="6578706f7274" value="1" />
		</s:url>
	</s:else>
	<ul class="ibm-link-list">
		<li><s:a href="%{accountCountryCodeLink}"
				cssClass="ibm-download-link">Account report</s:a></li>
	</ul>
</s:if>

<display:table name="data.list"
	class="ibm-data-table ibm-sortable-table"
	decorator="com.ibm.tap.trails.framework.OperationalReportTotalTableDecorator"
	summary="Operational Metric summary by countryCode" cellspacing="1"
	cellpadding="0" defaultsort="1" export="true"
	requestURI="/reports/operational/countryCode.htm">
	<display:setProperty name="export.excel.filename"
		value="operationalByCountryCode.xls" />
	<display:column property="name" title="Country code"
		href="sector.htm?geographyId=${geography.id}&regionId=${region.id}"
		paramId="countryCodeId" paramProperty="id" group="1" media="html" />
	<display:column property="name" title="Country code" media="excel" />
	<display:column property="alertNameWithCount"
		title="Software Operational Metrics(Alert #)" />
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
