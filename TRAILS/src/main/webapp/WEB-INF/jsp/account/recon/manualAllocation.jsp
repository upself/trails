<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<script type="text/javascript">
<!--
function disableLicenses(pfoAllocation) {
	if (pfoAllocation.value == "PVU") {
		document.showManualConfirmation.maxLicenses.disabled = true;
	} else {
		document.showManualConfirmation.maxLicenses.disabled = false;
	}
}
//-->
</script>

<h1>Reconcile workspace: <s:property value="account.name" />(<s:property
	value="account.account" />)</h1>
<p class="confidential">IBM Confidential</p>

<h2>Action: Manual license allocation</h2>
<br />
<p>Choose a license to allocate in the license free pool below, then
select which systems in which to allocate the license. Choose whether or
not to overwrite both manual and automated reconciliations that have the
selected software products shown in the list below and how to allocate
the licenses and how many licenses to allocate per LPAR or processor.
When you are finished, click on the "Next" button to be taken to a
confirmation page. Click on cancel to return to the workspace.</p>
<br />
<div class="hrule-dots"></div>
<br />
<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<s:form action="showManualConfirmation" namespace="/account/recon"
	theme="simple">
	<s:hidden name="page" value="%{#attr.page}" />
	<s:hidden name="dir" value="%{#attr.dir}" />
	<s:hidden name="sort" value="%{#attr.sort}" />
	<div class="float-left" style="width: 25%;"><label for="runon">Run
	on:</label></div>
	<div class="float-left" style="width: 75%;"><s:select
		name="runon" label="Run on"
		list="#{'SELECTED':'Selected systems', 'IBMHW':'All IBM HW', 'CUSTHW':'All customer owned HW', 'ALL':'All systems'}" /></div>

	<div class="float-left" style="width: 25%;"><label
		for="automated">Overwrite automated reconciliations:</label></div>
	<div class="float-left" style="width: 75%;"><s:checkbox
		name="automated" label="automated" />Yes</div>

	<div class="float-left" style="width: 25%;"><label
		for="automated">Overwrite manual reconciliations:</label></div>
	<div class="float-left" style="width: 75%;"><s:checkbox
		name="manual" label="manual" />Yes</div>

	<div class="float-left" style="width: 25%;"><label
		for="automated">Number of licenses to apply:</label></div>
	<div class="float-left" style="width: 75%;"><s:textfield
		name="maxLicenses" disabled="disabled" /></div>

	<div class="float-left" style="width: 25%;"><label
		for="automated">Allocation methodology:</label></div>
	<div class="float-left" style="width: 75%;"><s:select name="per"
		list="#{'LPAR':'Per LPAR', 'PROCESSOR':'Per processor', 'HWDEVICE':'Per hardware device', 'HWPROCESSOR':'Per hardware processor', 'CHIP':'Per hardware chip', 'PVU':'Per PVU'}"
		onchange="disableLicenses(this)" /></div>
	<div class="clear"></div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"> <s:submit
		value="Next" /> <s:submit method="cancel" value="Cancel" /> </span></div>
	</div>

	<div class="clear"></div>
	<div class="hrule-dots"></div>
	<div class="clear"></div>
	<small> <display:table name="list" class="basic-table" id="row"
	    summary="alert"
		cellspacing="1" cellpadding="0" excludedParams="*">
		<display:column property="alertStatus" title="" />
		<display:column property="alertAgeI" title="Age" />
		<display:column property="hostname" title="Hostname" />
		<display:column property="serial" title="Serial" />
		<display:column property="country" title="Country" />
		<display:column property="owner" title="HW Owner" />
		<display:column property="assetType" title="Asset type" />
		<display:column property="productInfoName" title="SW Name" />
		<display:column property="processorManufacturer" title="Proc mfg" />
		<display:column property="mastProcessorType" title="Proc type" />
		<display:column property="mastProcessorModel" title="Proc model" />
		<display:column property="nbrCoresPerChip" title="cores per chip" />
		<display:column property="chips" title=" HW chip" />
		<display:column property="hardwareProcessorCount"
			title="HW proc" />
		<display:column property="nbrOfChipsMax" title=" # chips max" />
		<display:column property="cpuLsprMips" title="CPU IBM LSPR MIPS" />
		<display:column property="partLsprMips" title="PART IBM LSPR MIPS" />
		<display:column property="cpuGartnerMips" title="CPU Gartner MIPS" />
		<display:column property="partGartnerMips" title="Part Gartner MIPS" />
		<display:column property="cpuMsu" title="CPU MSU" />
		<display:column property="partMsu" title="Part MSU" />
		<display:column property="shared" title="Shared" />
		<display:column property="processorCount" title="LPAR proc" />
		<display:column property="sysplex" title="Sysplex" />
		<display:column property="spla" title="SPLA" />
		<display:column property="internetIccFlag" title="Internet Acc" />
		<display:column property="reconcileTypeName" title="Recon type" />
		<display:column property="assignee" title="Assignee" />
	</display:table> </small>
	<br />

	<h2 class="green-med-dark">Selected licenses</h2>
	<span class="button-blue"><s:submit
		method="deleteSelectedLicenses" value="Delete selected licenses" /></span>
	<br />
	<small> <display:table name="reconLicenseList"
	    summary="Recon License List"
		class="basic-table" id="row" cellspacing="1" cellpadding="0"
		excludedParams="*"
		requestURI="showQuestion.htm?flag=1&page=${page}&dir=${dir}&sort=${sort}">
		<display:column>
			<s:checkbox name="selectedLicenseId" fieldValue="%{#attr.row.id}" />
		</display:column>
        <display:column sortProperty="catalogMatch" title=""
            class="catalogMatch" value="" />
        <display:column property="account.account" title="Account number"
            sortable="true" />
        <display:column property="productInfo.name" title="Product name"
            sortable="true" />
        <display:column property="capacityType.description"
            title="Capacity type" sortable="true" />
        <display:column property="availableQty" title="Avail qty"
            sortable="true" />
        <display:column property="quantity" title="Total qty" sortable="true" />
        <display:column property="expireDate" title="Exp date" class="date"
            format="{0,date,MM-dd-yyyy}" sortable="true" />
        <display:column property="cpuSerial" title="Serial" sortable="true" />
        <display:column property="extSrcId" title="SWCM ID" sortable="true" />
	</display:table> </small>

	<h2 class="green-med-dark">Available licenses</h2>
	<span class="button-blue"><s:submit
		method="addAvailableLicenses" value="Add available licenses" /></span>
	<br />
	<small> <display:table name="data" class="basic-table" id="row"
	    summary="Available Licenses"
		decorator="com.ibm.tap.trails.framework.LicenseDisplayTagDecorator"
		cellspacing="1" cellpadding="0" excludedParams="*"
		requestURI="showQuestion.htm?flag=1&page=${page}&dir=${dir}&sort=${sort}">
		<display:column>
			<s:checkbox name="availableLicenseId"
				fieldValue="%{#attr.row.licenseId}" />
		</display:column>
		<display:column title="" class="catalogMatch" value="" />
		<display:column property="ownerAccountNumber"
			sortProperty="account.account" title="Account number" sortable="true" />
		<display:column property="productName" sortProperty="productInfo.name" title="Product name"
			sortable="true" />
		<display:column property="capTypeDesc" sortProperty="capacityType.description" title="Capacity type"
			sortable="true" />
		<display:column property="availableQty" title="Avail qty"
			sortable="true" />
		<display:column property="quantity" title="Total qty" sortable="true" />
		<display:column property="expireDate" title="Exp date" class="date"
			format="{0,date,MM-dd-yyyy}" sortable="true" />
		<display:column property="cpuSerial" title="Serial" sortable="true" />
		<display:column property="extSrcId" title="SWCM ID" sortable="true" />
	</display:table> </small>
</s:form>
