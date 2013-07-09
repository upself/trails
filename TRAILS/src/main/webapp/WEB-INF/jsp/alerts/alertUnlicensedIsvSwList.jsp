<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<h1>Unlicensed ISV SW alerts: <s:property value="account.name" />(<s:property
	value="account.account" />)</h1>
<p class="confidential">IBM Confidential</p>
<br />
<p>
	This page displays unlicensed installed vendor software. Assigment of these
	alerts can be performed in the reconciliation workspace.
</p>
<br />
<div class="download-link" style="float:right">
	<s:url id="reportUrl"
		value="/TRAILS/report/download/alertUnlicensedIsvSw%{#attr.account.account}.tsv?name=alertUnlicensedIsvSw"
		includeContext="false" includeParams="none" />
	<s:a href="%{reportUrl}">Download unlicensed ISV SW alert report</s:a>
</div>
<br />
<br />
<div class="hrule-dots"></div>
<br />
<display:table name="data" class="basic-table" id="row"
 summary="Unlicensed ISV Software Alerts "
	decorator="org.displaytag.decorator.TotalTableDecorator"
	cellspacing="1" cellpadding="0" requestURI="alertUnlicensedIsvSw.htm">
	<display:column property="alertStatus" sortProperty="alertAge"
		title="Status" sortable="true" />
	<display:column property="softwareItemName" title="Installed product"
		sortable="true" href="/TRAILS/account/recon/settingsSoftware.htm"
		paramId="productInfoName" paramProperty="softwareItemName" />
	<display:column property="alertCount" title="Number of instances"
		sortable="true" />
	<display:column property="creationTime" sortProperty="alertAge"
		title="Date loaded" sortable="true" class="date"
		format="{0,date,MM-dd-yyyy}" />
	<display:column property="alertAge" title="Days old" sortable="true" />
</display:table>
