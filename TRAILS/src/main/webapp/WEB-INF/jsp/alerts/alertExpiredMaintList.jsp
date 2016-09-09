<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
function displayPopUp(page) {
	window.open(page, 'PopUpWindow', 'left=200,top=180,resizable=yes,scrollbars=yes,width=700,height=500');
}

function selectAll(psType) {
	var laElement = document.alertExpiredMaint.elements;
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

<h1>Expired maintenance alerts: <s:property value="account.name" />(<s:property
	value="account.account" />)</h1>
<p class="ibm-confidential">IBM Confidential</p>
<br />
<p>This page displays expired maintenance alerts. Use the checkboxes to assign,
update or unassign alerts. You must enter a comment to successfully update the
alert.</p>
<br />
<div class="download-link" style="float:right">
	<s:a href="/TRAILS/report/download/alertExpiredMaint${account.account}.tsv?name=alertExpiredMaint">Download expired maintenance alert report</s:a>
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
<s:form action="alertExpiredMaint" method="post" namespace="/account/alerts"
	theme="simple">
	<s:hidden name="page" value='${page}' />
	<s:hidden name="dir" value='${dir}' />
	<s:hidden name="sort" value='${sort}' />

	<div class="float-left" style="width:25%;">
		<label for="automated">Comments:</label>
	</div>
	<div class="float-left" style="width:75%;">
		<s:textarea rows="2" cols="32" name="comments" id="comments" wrap="virtual" />
	</div>

	<div class="clear"></div>
	<div class="button-bar">
		<div class="buttons"><span class="button-blue">
			<s:submit value="Assign/Update" method="update" />
			<s:submit value="Unassign" method="update" />
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
	    summary="Expired MainList"
		decorator="org.displaytag.decorator.TotalTableDecorator" cellspacing="1"
		cellpadding="0" excludedParams="*">
		<display:column title="A/U">
			<s:checkbox name="list[%{#attr.row_rowNum-1}].assign" />
			<s:hidden name="list[%{#attr.row_rowNum-1}].id" value="${row.tableId}" />
		</display:column>
		<display:column property="alertStatus" sortProperty="alertAge"
			title="Status" sortable="true" />
		<display:column property="alertAge" title="Age(days)"
			sortable="true" />
		<display:column property="license.productName"
			sortProperty="COALESCE(SI.name, L.fullDesc)" title="Product name"
			sortable="true" href="/TRAILS/account/license/licenseDetails.htm"
			paramId="licenseId" paramProperty="license.id" />
		<display:column property="license.quantity" title="Total qty"
			sortable="true" />
		<display:column property="license.expireDate" title="Exp date" class="date"
			format="{0,date,MM-dd-yyyy}" sortable="true" />
		<display:column property="license.extSrcId" title="SWCM ID" sortable="true" />
		<display:column property="remoteUser" title="Assignee" sortable="true" />
		<display:column title="Comments">
			<a id="view_${row.tableId}"
				href="javascript:displayPopUp('alertExpiredMaintHistory.htm?id=${row.tableId}')">View</a>
		</display:column>
		<display:column title="Unassign">
			<s:if test="#session.userSession.remoteUser==#attr.row.remoteUser">
				<s:checkbox name="list[%{#attr.row_rowNum-1}].unassign" />
			</s:if>
		</display:column>
	</display:table>
</s:form>
