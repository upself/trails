<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<script type="text/javascript">
	function popupBravoSl(id) {
		newWin = window
				.open(
						'//${bravoServerName}/BRAVO/software/view.do?id=' + id,
						'popupWindow',
						'height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes');
		newWin.focus();
		void (0);
	}

	function popupFreePool(url) {
		newWin = window
				.open(
						url,
						'popupWindow',
						'height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes');
		newWin.focus();
		void (0);
	}

	function displayPopUp(page) {

		window
				.open(page, 'PopUpWindow',
						'left=200,top=180,resizable=yes,scrollbars=yes,width=700,height=500');
	}
</script>

<s:url id="freepool" action="licenseFreePool"
	namespace="/account/license" includeContext="true" includeParams="none">
</s:url>

<h1>Reconcile workspace: <s:property value="account.name" />(<s:property
	value="account.account" />)</h1>
<p class="confidential">IBM Confidential</p>
<br />
<p>The results from your reconciliation workspace settings are
displayed below. Select an action to take by using the dropdown box
below and then select the assets in which you would like to use for the
basis of your action. The actions, manual license allocation and
included with other product, will only accept a single line item
selection. Once your selection is complete, depress the "GO" button to
be taken to the next screen.</p>
<br />
<div style="float: right"><s:include
	value="/WEB-INF/jsp/include/reportModule.jsp" /></div>
<br />
<br />
<div class="hrule-dots"></div>
<br />
<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<s:form action="showQuestion" namespace="/account/recon" theme="simple">
	<s:hidden name="page" value="%{#attr.page}" />
	<s:hidden name="dir" value="%{#attr.dir}" />
	<s:hidden name="sort" value="%{#attr.sort}" />
	<div class="float-left" style="width: 75%;"><label for="action_1">Action:</label>
	<s:select name="reconcileTypeId" label="Action" list="reconcileTypes"
		listKey="id" listValue="name" headerKey="" headerValue="Select one"
		id="action_1" /> <span class="button-blue"> <s:submit value="GO"
		id="go-btn" alt="Submit" /> </span></div>
	<div class="clear"></div>
	<br />

	<div class="clear"></div>
	<div class="hrule-dots"></div>
	<div class="clear"></div>
	<div class="float-left" style="width: 25%;"><a
		href="javascript:popupFreePool('${freepool}')">License free pool</a></div>
	<div class="clear"></div>
	<br />

	<display:table name="data" class="basic-table" id="row"
	    summary="Reconciliation Query Results"
		decorator="org.displaytag.decorator.TotalTableDecorator"
		cellspacing="1" cellpadding="0" style="font-size:.8em"
		requestURI="workspace.htm">
		<display:caption media="html">Reconciliation results</display:caption>
		<display:column title="">
			<s:checkbox name="list[%{#attr.row_rowNum-1}].selected"
				theme="simple" id="action" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].installedSoftwareId"
				value="%{#attr.row.installedSoftwareId}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].alertAgeI"
				value="%{#attr.row.alertAgeI}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].hostname"
				value="%{#attr.row.hostname}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].serial"
				value="%{#attr.row.serial}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].country"
				value="%{#attr.row.country}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].owner"
				value="%{#attr.row.owner}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].assetType"
				value="%{#attr.row.assetType}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].processorCount"
				value="%{#attr.row.processorCount}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].hardwareProcessorCount"
				value="%{#attr.row.hardwareProcessorCount}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].productInfoName"
				value="%{#attr.row.productInfoName}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].reconcileTypeName"
				value="%{#attr.row.reconcileTypeName}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].reconcileTypeId"
				value="%{#attr.row.reconcileTypeId}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].assignee"
				value="%{#attr.row.assignee}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].alertId"
				value="%{#attr.row.alertId}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].reconcileId"
				value="%{#attr.row.reconcileId}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].productInfoId"
				value="%{#attr.row.productInfoId}" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].chips"
				value="%{#attr.row.chips}" />
		</display:column>
		<display:column property="alertStatus" title="" />
		<display:column property="alertAgeI" title="Age" sortable="true"
			sortProperty="aus.alertAge" />
		<display:column property="hostname" title="Hostname"
			sortProperty="hl.name" sortable="true" />
		<display:column property="serial" title="Serial"
			sortProperty="h.serial" sortable="true" />
		<display:column property="country" title="Ctry"
			sortProperty="h.country" sortable="true" />
		<display:column property="owner" title="Owner" sortProperty="h.owner"
			sortable="true" />
		<display:column property="assetType" title="Asset type"
			sortProperty="mt.type" sortable="true" />
		<display:column property="processorCount" title="# Proc."
			sortProperty="sl.processorCount" sortable="true" />
		<display:column property="chips" title="# Chips"
			sortProperty="h.chips" sortable="true" />
		<display:column sortProperty="pi.name" title="Software"
			sortable="true">
			<a
				href="javascript:popupBravoSl(<s:property value="%{#attr.row.installedSoftwareId}"/>)">${row.productInfoName}</a>
		</display:column>
		<display:column title="Action" sortProperty="rt.name" sortable="true">
			<s:if test="#attr.row.reconcileId!=null">
				<a
					href="javascript:displayPopUp('reconcileDetails.htm?id=<s:property value="%{#attr.row.reconcileId}" />')">${row.reconcileTypeName}</a>
			</s:if>
		</display:column>
		<display:column title="Assignee" sortable="true"
			sortProperty="remoteUser">
			<a
				href="javascript:displayPopUp('/TRAILS/account/alerts/alertUnlicensedIbmSwHistory.htm?id=<s:property value="%{#attr.row.alertId}" />')">${row.assignee}</a>
		</display:column>
	</display:table>
</s:form>
