<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<s:url id="settingsLink" action="settings" namespace="/account/recon"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="workspaceLink" action="workspace?gotoV17e=y" namespace="/account/recon"
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
		<p class="ibm-confidential">IBM Confidential</p>
		<h2>Action: Break license allocation</h2>
		<br />
		<p>This will break the instance selected as well any software instances tied to
the same exact license record. This will only break manually allocated
licenses. When you are finished, click on the "Next" button to be taken to a
confirmation page. Click on cancel to return to the workspace.</p>
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
		<s:form action="showBreakLicenseConfirmation?gotoV17e=y" namespace="/account/recon" theme="simple">
			<table width="99%" padding="3px">
				<tr>
					<td style="text-align: right; padding-top: 10px; padding-bottom: 5px;">
						<s:submit value="Next" cssClass="ibm-btn-cancel-pri ibm-btn-small" />
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
			<display:table name="list" class="ibm-data-table ibm-sortable-table ibm-alternating tablesorter tablesorter-default" summary="break license Recon" id="row" cellspacing="1" cellpadding="0">
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