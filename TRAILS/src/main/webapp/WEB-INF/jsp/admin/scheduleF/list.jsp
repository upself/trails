<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<h1 class="oneline">Schedule F</h1>
<div style="font-size: 22px; display: inline">
	&nbsp;:
	<s:property value="account.name" />
	(
	<s:property value="account.account" />
	)
</div>
<p class="confidential">IBM Confidential</p>
<br />
<p>To edit a schedule F record, press one of the links below. If you
	want to add a new record, press the Add link.</p>
<br />
<div class="hrule-dots"></div>
<br />

<div style="float: right">
	<s:a href="/TRAILS/admin/scheduleF/manage.htm">Add</s:a>
</div>
<br />
<br />

<s:hidden name="page" value="%{#attr.page}" />
<s:hidden name="dir" value="%{#attr.dir}" />
<s:hidden name="sort" value="%{#attr.sort}" />

<display:table name="data" class="basic-table" id="row"
	summary="scheduleF View"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	cellspacing="1" cellpadding="0" requestURI="list.htm" defaultsort="1"
	export="true">
	<display:setProperty name="export.excel.filename"
		value="SheduleF_View.xls" />
	<display:column property="softwareName" sortProperty="SF.softwareName"
		title="Software name" sortable="true"
		href="/TRAILS/admin/scheduleF/manage.htm" paramProperty="id"
		paramId="scheduleFId" media="html" />
	<display:column property="level" sortProperty="SF.level" title="Level"
		sortable="true" />
	<display:column property="hwOwner" sortProperty="SF.hwOwner"
		title="Hw Owner" sortable="true" />
	<display:column property="hostname" sortProperty="SF.hostname"
		title="Hostname" sortable="true" />
	<display:column property="serial" sortProperty="SF.serial"
		title="Serial" sortable="true" />
	<display:column property="machineType" sortProperty="SF.machineType"
		title="Machine Type" sortable="true" />
	<display:column property="account.account" title="Account Number"
		media="excel" />
	<display:column property="softwareTitle" title="Software title"
		media="excel" />
	<display:column property="softwareName" title="Software name"
		media="excel" />
	<display:column property="softwareTitle"
		sortProperty="SF.softwareTitle" title="Software title" sortable="true"
		media="html" />
	<display:column property="manufacturer" sortProperty="SF.manufacturer"
		title="Manufacturer" sortable="true" />
	<display:column property="scope.description"
		sortProperty="SF.scope.description" title="Scope" sortable="true" />
	<!-- AB added -->	
	<display:column property="SWFinanceResp"
		sortProperty="SF.SWFinanceResp" title="SW Financial Resp" sortable="true" />
	<display:column property="source.description"
		sortProperty="SF.source.description" title="Source" sortable="true" />
	
	<display:column property="sourceLocation"
		sortProperty="SF.sourceLocation" title="Source location"
		sortable="true" />
	<display:column property="status.description"
		sortProperty="SF.status.description" title="Status" sortable="true" />
	<display:column property="businessJustification"
		title="Business Justification" media="excel" />
	<s:if test="account.softwareComplianceManagement == 'YES'">
		<display:column value="YES" title="Compliance" sortable="false" />
	</s:if>
	<s:else>
		<display:column value="NO" title="Compliance" sortable="false" />
	</s:else>
</display:table>
