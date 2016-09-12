<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui/jquery-ui.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-paginationTable-1.0.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/js/jquery-ui/themes/smoothness/jquery-ui.css">
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<h1>License baseline: <s:property value="account.name" />(<s:property
	value="account.account" />)</h1>
<p class="ibm-confidential">IBM Confidential</p>
<br />
<br />
<div style="float: right"><s:a
	href="/TRAILS/report/download/freeLicensePool%{#attr.account.account}.tsv?name=freeLicensePool"
	cssClass="download-link">Download free license pool report</s:a> <s:include
	value="/WEB-INF/jsp/include/reportModule.jsp" /></div>
<br />
<br />
<s:hidden name="page" value="%{#attr.page}" />
<s:hidden name="dir" value="%{#attr.dir}" />
<s:hidden name="sort" value="%{#attr.sort}" />
<s:if test="requestURI == 'license.htm'">
	<display:table name="data" class="ibm-data-table ibm-alternating" id="row" summary="License List" cellspacing="1" cellpadding="0" requestURI="license.htm">
		<display:column title="" class="catalogMatch" property="catalogMatch"
			decorator="com.ibm.tap.trails.framework.LicenseCatalogColumnDecorator" />
		<display:column property="fullDesc" title="License name"
			sortable="true" />
		<display:column property="productName" title="Primary Component"
			sortable="true" href="/TRAILS/account/license/licenseDetails.htm"
			paramId="licenseId" paramProperty="licenseId" />
		<display:column property="swproPID" title="Software product PID"
			sortable="true" />
		<display:column property="capTypeCode" title="Capacity type"
			sortable="true" />
		<display:column property="availableQty" title="Avail qty"
			sortable="true" />
		<display:column property="quantity" title="Total qty" sortable="true" />
		<display:column property="expireDate" title="Exp date" class="date"
			format="{0,date,MM-dd-yyyy}" sortable="true"
			decorator="com.ibm.tap.trails.framework.NullableColumnDecorator" />
		<display:column property="cpuSerial" title="Serial" sortable="true"
			decorator="com.ibm.tap.trails.framework.NullableColumnDecorator" />
		<display:column property="extSrcId" title="SWCM ID" sortable="true" />
	</display:table>
</s:if>
<s:else>
	<display:table name="data" class="ibm-data-table ibm-alternating" id="row" summary="License List" decorator="com.ibm.tap.trails.framework.LicenseDisplayTagDecorator" cellspacing="1" cellpadding="0" requestURI="licenseFreePool.htm">
		<display:column title="" class="catalogMatch" value="" />
		<display:column property="fullDesc" title="License name"
			sortable="true" />
		<display:column property="productName" title="Primary Component"
			sortable="true" href="/TRAILS/account/license/licenseDetails.htm"
			paramId="licenseId" paramProperty="licenseId" />
		<display:column property="swproPID" title="Software product PID"
			sortable="true" />
		<display:column property="capTypeCode" title="Capacity type"
			sortable="true" />
		<display:column property="availableQty" title="Avail quantity"
			sortable="true" />
		<display:column property="quantity" title="Total quantity" sortable="true" />
		<display:column property="expireDate" title="Exp date" class="date"
			format="{0,date,MM-dd-yyyy}" sortable="true" />
		<display:column property="cpuSerial" title="Serial" sortable="true" />
		<display:column property="extSrcId" title="SWCM ID" sortable="true" />
	</display:table>
</s:else>
