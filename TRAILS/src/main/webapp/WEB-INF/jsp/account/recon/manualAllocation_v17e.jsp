<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<s:url id="settingsLink" action="settings" namespace="/account/recon"
	includeContext="true" includeParams="none">
</s:url>
<s:url id="workspaceLink" action="workspace?gotoV17e=y" namespace="/account/recon"
	includeContext="true" includeParams="none">
</s:url>
<script type="text/javascript">
<!--
	function disableLicenses(pfoAllocation) {
		if (pfoAllocation.value == 'PVU'
				|| pfoAllocation.value == 'PVU'
				|| pfoAllocation.value == 'HWGARTMIPS'
				|| pfoAllocation.value == 'LPARGARTMIPS'
				|| pfoAllocation.value == 'HWLSPRMIPS'
				|| pfoAllocation.value == 'LPARLSPRMIPS'
				|| pfoAllocation.value == 'HWMSU'
				|| pfoAllocation.value == 'LPARMSU'
				|| pfoAllocation.value == 'HWIFL'
			) {
			document.showManualConfirmation.maxLicenses.value="";
			document.showManualConfirmation.maxLicenses.disabled = true;
		} else {
			document.showManualConfirmation.maxLicenses.disabled = false;
		}
	}
//-->
</script>
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
		<p>Choose a license to allocate in the license free pool below, then
	select which systems in which to allocate the license. Choose whether
	or not to overwrite both manual and automated reconciliations that have
	the selected software products shown in the list below and how to
	allocate the licenses and how many licenses to allocate per LPAR or
	processor. When you are finished, click on the "Next" button to be
	taken to a confirmation page. Click on cancel to return to the
	workspace.</p>
		<br />
	</div>

	<div class="ibm-rule">
		<hr />
	</div>
	<div style="float:right">
		<s:include value="/WEB-INF/jsp/include/v17eReportModule.jsp" />
	</div>
	<s:if test="hasErrors()">
		<s:actionerror />
		<s:fielderror />
	</s:if>
	<s:form id="showManualConfirmation" action="showManualConfirmation?gotoV17e=y" namespace="/account/recon" theme="simple">
		<s:hidden name="page" value="%{#attr.page}" />
		<s:hidden name="dir" value="%{#attr.dir}" />
		<s:hidden name="sort" value="%{#attr.sort}" />
		<div style="width: 70%; float:left; padding-left: 10px">
			<table width="99%" padding="3px">
				<tr>
					<td style="width: 25%"><label for="runon">Run on:</label></td>
					<td style="padding-left: 3px; padding-top: 3px;"><s:select name="runon"
							label="runon"
							list="#{'SELECTED':'Selected systems', 'IBMHW':'All IBM HW', 'CUSTHW':'All customer owned HW', 'ALL':'All systems'}" />
					</td>
				</tr>
				<tr>
					<td><label for="automated">Overwrite automated
							reconciliations:</label></td>
					<td  style="padding-top: 3px;"><s:checkbox name="automated" label="automated" />Yes</td>
				</tr>
				<tr>
					<td><label for="manual">Overwrite manual
							reconciliations:</label></td>
					<td><s:checkbox name="manual"
							label="manual" />Yes</td>
				</tr>
				<tr>
					<td><label>Number of licenses to apply:</label></td>
					<td style="padding-left: 3px;"><s:textfield name="maxLicenses" /></td>
				</tr>
				<tr>
					<td><label>Allocation methodology:</label></td>
					<td style="padding-left: 3px;padding-top: 3px;">
						<s:select name="per" list="allocationMethodologies" listKey="code" listValue="name" onchange="disableLicenses(this)" />
					</td>
				</tr>
				<tr>
					<td><label for="comments">Comments:</label></td>
					<td style="padding-left: 3px;padding-top: 3px;"><s:textarea name="comments"
							id="comments" label="comments" wrap="virtual" style="width:70%" />
					</td>
				</tr>
			</table>
		</div>
		<div style="clear:both"></div>
		<div style="text-align: right; padding-top: 10px; padding-right: 10px; padding-bottom: 5px;">
			<s:submit value="Next" cssClass="ibm-btn-cancel-pri ibm-btn-small" />
			<s:submit method="cancel" value="Cancel" cssClass="ibm-btn-cancel-pri ibm-btn-small" />
		</div>
		
		<div class="ibm-rule">
			<hr />
		</div>
		<div class="ibm-col-1-1" style="width: 99%; overflow-x: auto">
			<small>
				<display:table name="list" class="ibm-data-table ibm-sortable-table ibm-alternating tablesorter tablesorter-default" style="background: white;" id="row" summary="alert" cellspacing="1" cellpadding="0" excludedParams="*">
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
		<div class="ibm-col-1-1" style="width: 99%; overflow-x: auto">
			<h2>Selected licenses</h2>
			<s:submit method="deleteSelectedLicenses" value="Delete selected licenses" cssClass="ibm-btn-cancel-pri ibm-btn-small" /> <br/>
			<small> 
				
				<display:table name="reconLicenseList" summary="Recon License List" class="ibm-data-table ibm-sortable-table ibm-alternating tablesorter tablesorter-default" id="row"
					cellspacing="1" cellpadding="0" excludedParams="*"
					requestURI="showQuestion.htm?gotoV17e=y&flag=1&page=${page}&dir=${dir}&sort=${sort}&sortReq=true">
					<display:column>
						<s:checkbox name="selectedLicenseId" fieldValue="%{#attr.row.id}" />
					</display:column>
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
					<display:column property="account.account" title="Account number"
						sortable="true" />
					<display:column property="fullDesc" title="License Name"
						sortable="true" />
					<display:column property="software.softwareName" title="Primary Component"
		 				sortable="true" />
		 			<display:column title="License Ownership" sortable="true">
		 				<s:if test="%{#attr.row.ibmOwned}">
		 				IBM</s:if>
		 				<s:else>
		 				Customer
		 				</s:else>
		 			</display:column> 
		 			<display:column property="swproPID" title="Software product PID"
		 				sortable="true" /> 	 				
					<display:column property="capacityType.description"
						title="Capacity type" sortable="true" />
					<display:column property="availableQty" title="Avail qty"
						sortable="true" />
					<display:column property="quantity" title="Total qty" sortable="true" />
					<display:column property="expireDate" title="Exp date" class="date"
						format="{0,date,MM-dd-yyyy}" sortable="true" />
					<display:column property="cpuSerial" title="Serial" sortable="true" />
					<display:column property="environment" title="Environment" sortable="true" />
					<display:column property="extSrcId" title="SWCM ID" sortable="true" />
					<display:column property="sku" title="SKU" sortable="true"  sortProperty="license.sku"/>
				</display:table>
			</small>
		</div>
		
		<div class="ibm-col-1-1" style="padding-top: 10px; width: 99%; overflow-x: auto">
			<h2>Available licenses</h2>
			<s:submit method="addAvailableLicenses" value="Add available licenses" cssClass="ibm-btn-cancel-pri ibm-btn-small" /><br />
			<small> 
				<display:table name="data" class="ibm-data-table ibm-sortable-table ibm-alternating tablesorter tablesorter-default" id="row" summary="Available Licenses"
				decorator="com.ibm.tap.trails.framework.LicenseDisplayTagDecorator"
				cellspacing="1" cellpadding="0" excludedParams="*"
				requestURI="showQuestion.htm?gotoV17e=y&flag=1&page=${page}&dir=${dir}&sort=${sort}&sortReq=true">
					<display:column><s:checkbox name="availableLicenseId" fieldValue="%{#attr.row.licenseId}" /> </display:column>
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
					<display:column property="ownerAccountNumber"
						sortProperty="account.account" title="Account number"
						sortable="true" />
					<display:column property="fullDesc"
						sortProperty="license.fullDesc" title="License name" sortable="true" />
					<display:column property="productName"
						sortProperty="software.softwareName" title="Primary component" sortable="true" />
					<display:column property="licenseOwner" sortProperty="license.ibmOwned" title="License Ownership" sortable="true" />			
					<display:column property="swproPID"
						sortProperty="license.swproPID" title="Software product PID" sortable="false" />
					<display:column property="capTypeDesc"
						sortProperty="capacityType.description" title="Capacity type"
						sortable="true" />
					<display:column property="availableQty" title="Avail qty"
						sortable="true" />
					<display:column property="quantity" title="Total qty" sortable="true" />
					<display:column property="expireDate" title="Exp date" class="date"
						format="{0,date,MM-dd-yyyy}" sortable="true" />
					<display:column property="cpuSerial" title="Serial" sortable="true" />
					<display:column property="environment" title="Environment" sortable="true" />
					<display:column property="extSrcId" title="SWCM ID" sortable="true" />
					<display:column property="skuAsString" title="SKU" sortable="true"  sortProperty="license.sku"/>
				</display:table>
			</small>
		</div>
	</s:form>
	
	
</div>