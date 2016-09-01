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
		<p class="ibm-important">IBM Confidential</p>
		<h2>Action: Manual license allocation</h2>
		<br />
		<p>Please confirm your action below and hit the confirm button to
	execute your request against the database. If you selected to run on
	something other than "SELECTED", your action will run on all of those
	assets with installed software matching those listed. Due to the
	potential volume of updates in the request, it may take more than a few
	minutes. Please do not close your browser or navigate to another url
	while the process is completing. You will be presented with your
	initial workspace once the request has completed.</p>
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
		<s:form action="applyManualRecon?gotoV17e=y" namespace="/account/recon" theme="simple">
			<table width="99%" padding="3px">
				<tr>
					<td style="width: 25%"><label for="runon">Run on:</label></td>
					<td>
						<s:property value="runon" />
					</td>
				</tr>
				<tr>
					<td><label for="automated">Overwrite automated reconciliations:</label></td>
					<td>
						<s:property value="automated" />
					</td>
				</tr>
				<tr>
					<td><label for="automated">Overwrite manual reconciliations:</label></td>
					<td>
						<s:property value="manual" />
					</td>
				</tr>
				<tr>
					<td><label for="automated">Number of licenses to apply:</label></td>
					<td>
						<s:property value="maxLicenses" default="N/A" />
					</td>
				</tr>
				<tr>
					<td><label for="automated">Allocation methodology:</label></td>
					<td>
						<s:property value="per" />
					</td>
				</tr>
				<tr>
					<td><label for="comments">Comments:</label></td>
					<td>
						<s:property value="comments" />
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
			<display:table name="data.list" class="ibm-data-table ibm-sortable-table ibm-alternating tablesorter tablesorter-default"
			summary="alert list" id="row" cellspacing="1" cellpadding="0" style="background: white">
				<display:column property="alertStatus" title="" />
				<display:column property="alertAgeI" title="Age" />
				<display:column property="hostname" title="Hostname" />
				<display:column property="serial" title="Serial" />
				<display:column property="country" title="Country" />
				<display:column property="owner" title="HW Owner" />
				<display:column property="assetType" title="Asset type" />
				<display:column property="pid" title="PID" />
				<display:column property="lparServerType" title="Server type" />
				<display:column property="productInfoName" title="SW Name" />
				<display:column property="processorManufacturer" title="Proc mfg" />
				<display:column property="mastProcessorType" title="Proc type" />
				<display:column property="mastProcessorModel" title="Proc model" />
				<display:column property="nbrCoresPerChip" title="cores per chip" />
				<display:column property="chips" title=" HW chip" />
				<display:column property="hardwareProcessorCount" title="HW proc" />
				<display:column property="vcpu" title="vCPU" />
				<display:column property="nbrOfChipsMax" title=" # chips max" />
				<display:column property="cpuIFL" title="HW IFL" />
				<display:column property="effectiveThreads" title="Eff Thr" />
				<display:column property="cpuLsprMips" title="CPU IBM LSPR MIPS" />
				<display:column property="partLsprMips" title="PART IBM LSPR MIPS" />
				<display:column property="cpuGartnerMips" title="CPU Gartner MIPS" />
				<display:column property="partGartnerMips" title="Part Gartner MIPS" />
				<display:column property="cpuMsu" title="CPU MSU" />
				<display:column property="partMsu" title="Part MSU" />
				<display:column property="shared" title="Shared" />
				<display:column property="multi_tenant" title="Multi Tenant" />
				<display:column property="hwLparEffProcessorCount" title="LPAR proc" />
				<display:column property="osType" title="OS Type" />
				<display:column property="sysplex" title="Sysplex" />
				<display:column property="spla" title="SPLA" />
				<display:column property="internetIccFlag" title="Internet Acc" />
				<display:column property="reconcileTypeName" title="Recon type" />
				<display:column property="assignee" title="Assignee" />
			</display:table>
		</small>
	</div>
	
	<div class="ibm-rule">
		<hr />
	</div>
	<div class="ibm-col-1-1" style="width:99%; overflow-x: auto">
		<small>
			<display:table name="licenseList" class="ibm-data-table ibm-sortable-table ibm-alternating tablesorter tablesorter-default" id="row" summary="license list" 
				decorator="com.ibm.tap.trails.framework.LicenseDisplayTagDecorator" cellspacing="1" cellpadding="0">
				<display:column>
					<s:if test="%{#attr.row.catalogMatch eq 'Yes'}">
						<ul class="ibm-link-list" style="margin-top: -22px;">
							<li><a class="ibm-confirm-link"></a></li>
						</ul>
					</s:if>
					<s:if test="%{#attr.row.catalogMatch eq 'No'}">
						<ul class="ibm-link-list ibm-alternate" style="margin-top: -22px;">
							<li><a class="ibm-cancel-link"></a></li>
						</ul>
					</s:if>
				</display:column>
				
				<display:column property="fullDesc" title="License Name"/>
				<display:column property="productName" title="Primary Component"
					href="/TRAILS/account/license/licenseDetails.htm"
					paramId="licenseId" paramProperty="id" />
				 <display:column title="License Ownership">
	 				<s:if test="%{#attr.row.ibmOwned}">
	 				IBM</s:if>
	 				<s:else>
	 				Customer
	 				</s:else>
	 			</display:column> 	
				<display:column property="swproPID" title="Software product PID"/>
				<display:column property="capacityType.code" title="Capacity type" />
				<display:column property="availableQty" title="Avail qty" />
				<display:column property="quantity" title="Total qty" />
				<display:column property="expireDate" title="Exp date" class="date"
					format="{0,date,MM-dd-yyyy}" />
				<display:column property="cpuSerial" title="Serial" />
				<display:column property="environment" title="Environment" />
				<display:column property="extSrcId" title="SWCM ID" />
				<display:column property="sku" title="SKU"/>
			</display:table>
		</small>
	</div>
</div>