<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
function popupBravoHl( accountId, lparName, hwId) {
newWin=window.open('//${bravoServerName}/BRAVO/lpar/view.do?accountId=' + accountId + '&lparName=' + lparName + '&hwId=' + hwId,'popupWindow','height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes'); 
newWin.focus(); 
void(0);
}
function displayPopUp(page) {
	
	window.open(page, 'PopUpWindow', 'left=200,top=180,resizable=yes,scrollbars=yes,width=700,height=500');
}

function selectAll(psType) {
	var laElement = document.alertHardwareLpar.elements;
	var lfoTemp = null;
	var lsName = null;

	for (var i = 0; i < laElement.length; i++) {
		lfoTemp = laElement[i];
		lsName = lfoTemp.name;

		if ((psType == 'assign'
					&& lsName.length >= 14
					&& lsName.substring(0, 5) == "list["
					&& lsName.substring(lsName.length - 7, lsName.length) == ".assign")
				|| (psType == 'unassign'
					&& lsName.length >= 16
					&& lsName.substring(0, 5) == "list["
					&& lsName.substring(lsName.length - 9, lsName.length) == ".unassign")) {
			lfoTemp.checked = true;
		}
	}

	return false;
}
</script>

<h1>HW LPAR w/o SW LPAR alerts: <s:property value="account.name" />(<s:property
	value="account.account" />)</h1>
<p class="confidential">IBM Confidential</p>
<br />
<p>This page displays hardware lpars without an associated software lpar.
Use the checkboxes to assign, update or unassign alerts. You must enter
a comment to successfully update the alert.</p>
<br />
<div class="download-link" style="float:right">
	<s:url id="reportUrl"
		value="/TRAILS/report/download/alertHardwareLpar%{#attr.account.account}.tsv?name=alertHardwareLpar"
		includeContext="false" includeParams="none" />
	<s:a href="%{reportUrl}">Download HW LPAR w/o SW LPAR alert report</s:a>
</div>
<br />
<br />
<div class="hrule-dots"></div>
<br />
<div class="float-left" style="width:100%;">
<s:if test="hasErrors()">
	<s:actionerror theme="simple" />
	<s:fielderror theme="simple"/>
</s:if>
</div>
<s:form action="alertHardwareLpar" method="post"
	namespace="/account/alerts" theme="simple">
	<s:hidden name="page" value="%{#attr.page}" />
	<s:hidden name="dir" value="%{#attr.dir}" />
	<s:hidden name="sort" value="%{#attr.sort}" />

	<div class="float-left" style="width:25%;"><label for="comments">Comments:</label></div>
	<div class="float-left" style="width:75%;"><s:textarea rows="2"
		cols="32" name="comments" id="comments" wrap="virtual" /></div>

	<div class="clear"></div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"> <s:submit id="alertHardwareLpar_update_1"
		value="Assign/Update" method="update" /><s:submit id="alertHardwareLpar_update_2" value="Unassign"
		method="update" />
			<s:submit value="Assign all" method="assignAll" />
			<s:submit value="Unassign all" method="unassignAll" />
	</span></div>
	</div>
	<div class="clear"></div>
	<div class="hrule-dots"></div>
	<div class="clear"></div>

	<div class="button-bar">
		<div class="buttons"><span class="button-blue">
			<s:submit value="Select all assign" onclick="return selectAll('assign')" />
			<s:submit value="Select all unassign"
				onclick="return selectAll('unassign')" />
		</span></div>
	</div>
	<display:table name="data" class="basic-table" id="row"
	 summary="HardwareLpar Without SoftwareLpar Alerts "
		decorator="org.displaytag.decorator.TotalTableDecorator"
		cellspacing="1" cellpadding="0" requestURI="alertHardwareLpar.htm">
		<display:column title="A/U">
		<div class="date"><label for="checkbox_%{#attr.row.tableId}"></label></div>
			<s:checkbox id="checkbox_%{#attr.row.tableId}" name="list[%{#attr.row_rowNum-1}].assign" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].id" value="%{#attr.row.tableId}" />
		</display:column>
		<display:column property="alertStatus" sortProperty="alertAge"
			title="Status" sortable="true" />
		<display:column sortProperty="hardwareLpar.name" title="Name"
			sortable="true">
			<s:url id="bravoUrl"
				value="javascript:popupBravoHl(%{#attr.row.account.account},'%{#attr.row.hardwareLpar.name}',%{#attr.row.hardwareLpar.id})"
				includeContext="false" includeParams="none" />
			<s:a id="hardwarelpar_name_%{#attr.row.hardwareLpar.id}" href="%{bravoUrl}">${row.hardwareLpar.name}</s:a>
		</display:column>
		<display:column property="creationTime" title="Create date"
			sortable="true" class="date" format="{0,date,MM-dd-yyyy}" />
		<display:column property="alertAge" title="Age(days)" sortable="true" />
		<display:column property="remoteUser" title="Assignee" sortable="true" />
		<display:column title="Comments">
			<s:url id="commentsUrl"
				value="javascript:displayPopUp('alertHardwareLparHistory.htm?id=%{#attr.row.tableId}')"
				includeContext="false" includeParams="none" />
			<s:a id="view_%{#attr.row.tableId}" href="%{commentsUrl}">View</s:a>
		</display:column>
		<display:column title="Unassign">
			<s:if test="#session.userSession.remoteUser==#attr.row.remoteUser">
				<s:checkbox name="list[%{#attr.row_rowNum-1}].unassign" />
			</s:if>
		</display:column>
	</display:table>
</s:form>
