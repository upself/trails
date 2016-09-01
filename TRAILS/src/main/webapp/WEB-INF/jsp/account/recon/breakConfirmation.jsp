<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<s:url id="settingsLink" action="settings" namespace="/account/recon"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="workspaceLink" action="workspace" namespace="/account/recon"
	includeContext="true" includeParams="none">
</s:url>
<div class="ibm-columns" style="width: 95%;">
	<div class="ibm-col-1-1" >
		<p id="breadcrumbs">
			<a href="${settingsLink}"> Workspace settings </a> &gt; <a href="${workspaceLink}"> Workspace</a> &gt;
		</p>
		<h1>
			Reconcile workspace: <s:property value="account.name" />(<s:property value="account.account" />)
		</h1>
		<p class="ibm-important">IBM Confidential</p>
		<h2>Action: Break manual reconciliation</h2>
		<br />
		<p>Please confirm your action below and hit the confirm button to
execute your request against the database. If you selected to run on
something other than "SELECTED", your action will run on all of those
assets with installed software matching those listed. Due to the
potential volume of updates in the request, it may take more than a few
minutes. Please do not close your browser or navigate to another url
while the process is completing. You will be presented with your initial
workspace once the request has completed.</p>
		<br />
	</div>

	<div class="ibm-rule">
		<hr />
	</div>
	<div class="ibm-col-1-1">
		<s:if test="hasErrors()">
			<s:actionerror />
			<s:fielderror />
		</s:if>
		<s:form action="applyManualRecon" namespace="/account/recon" theme="simple">
			<table width="99%" padding="3px">
				<tr>
					<td style="width: 25%"><label for="runon">Run on:</label></td>
					<td>
						<s:property value="runon" />
					</td>
				</tr>
				<tr>
					<td colspan="2" style="text-align: right; padding-top: 10px; padding-bottom: 5px;">
						<s:submit value="Confirm" cssClass="ibm-btn-cancel-pri ibm-btn-small" />
						<s:submit method="cancel" value="Cancel" cssClass="ibm-btn-cancel-pri ibm-btn-small" />
					</td>
				</tr>
			</table>
		</s:form>
	</div>
	<div class="ibm-rule">
		<hr />
	</div>
	<div class="ibm-col-1-1" style="width:99%; overflow-x: auto">
		<small>
			<display:table name="data.list" class="ibm-data-table ibm-sortable-table ibm-alternating tablesorter tablesorter-default" summary="Break Confirmation" id="row" cellspacing="1" cellpadding="0">
				<display:column property="alertStatus" title="" />
				<display:column property="alertAgeI" title="Age" />
				<display:column property="hostname" title="Hostname" />
				<display:column property="serial" title="Serial" />
				<display:column property="country" title="Country" />
				<display:column property="owner" title="Owner" />
				<display:column property="assetType" title="Asset type" />
				<display:column property="processorCount" title="Processor count" />
				<display:column property="hardwareStatus" title="Hardware Status" />
				<display:column property="lparStatus" title="Lpar Status" />
				<display:column property="productInfoName" title="Software name" />
				<display:column property="reconcileTypeName" title="Reconcile type" />
				<display:column property="assignee" title="Assignee" />
			</display:table>
		</small>
	</div>
</div>