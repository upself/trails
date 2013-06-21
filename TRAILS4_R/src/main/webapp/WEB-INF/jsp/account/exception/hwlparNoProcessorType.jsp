<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>HW LPAR NO PROCESSOR TYPE:<s:property
	value="account.name" />(<s:property value="account.account" />)</h1>
<p class="confidential">IBM Confidential</p>
<p>This page displays data exceptions for hardware  Lpar without Processor Type.</p>
<br />
<s:if test="%{data.list.size>0}">
	<p>To assign/unassign a data exception simply click on the link in
	the Action column, add your required comment in the box that displays
	and click OK. The action link will switch between "assign" and
	"unassign".</p>
	<p>To assign/unassign all data exceptions displayed , click the
	appropriate button, add your required comment in the box that displays
	and click OK. All data exceptions will be switched based on the button
	you select.</p>
	<br />

	<div class="hrule-dots"></div>
	<br />
	<div class="float-left" style="width: 100%;"><s:if
		test="hasErrors()">
		<s:actionerror theme="simple" />
		<s:fielderror theme="simple" />
	</s:if></div>

	<s:form action="lparNPRCTYP" method="post" theme="simple">
		<s:hidden name="page" value="%{#attr.page}" />
		<s:hidden name="dir" value="%{#attr.dir}" />
		<s:hidden name="sort" value="%{#attr.sort}" />


		<div class="clear"></div>
		<div class="button-bar">
		<div class="buttons"><span class="button-blue"> <input
			type="button" value="Assign all"
			onclick="javascript:showDx('exceptionHwlparAssignAll.htm')" />

		<input type="button" value="Unassign all"
			onclick="javascript:showDx('exceptionHwlparUnassignAll.htm')" />
		</span></div>
		<br />
		</div>

		<display:table name="data" class="basic-table" id="row"
			summary="Hardware Lpar  No Processor Type"
			decorator="org.displaytag.decorator.TotalTableDecorator"
			cellspacing="2" cellpadding="0" requestURI="lparNPRCTYP.htm">
			<display:column title="Action<br>to be taken:">
				<s:div id="id_assignment_action_%{#attr.row.id}">
					<s:if test="%{#attr.row.assignee==userSession.remoteUser}">
						<s:hidden name="list[%{#attr.row_rowNum-1}].id"
							value="%{#attr.row.Id}" id="lpar_list_id_%{#attr.row.id}" />
						<s:hidden name="list[%{#attr.row_rowNum-1}].beenAssigned"
							value="true" id="lpar_list_beenAssigned_%{#attr.row.id}" />
						<s:url id="unassign"
							value="javascript:showDl('exceptionHwlparUnassign.htm',%{#attr.row.id},%{#attr.row_rowNum-1})"
							includeContext="false" includeParams="none" />
						<s:a id="unassign_%{#attr.row.id}" href="%{unassign}">unassign</s:a>
					</s:if>
					<s:else>
						<s:hidden name="list[%{#attr.row_rowNum-1}].id"
							value="%{#attr.row.Id}" id="lpar_list_id_%{#attr.row.id}" />
						<s:hidden name="list[%{#attr.row_rowNum-1}].beenAssigned"
							value="false" id="lpar_list_beenAssigned_%{#attr.row.id}" />
						<s:url id="assign"
							value="javascript:showDl('exceptionHwlparAssign.htm',%{#attr.row.id},%{#attr.row_rowNum-1})"
							includeContext="false" includeParams="none" />
						<s:a id="assign_%{#attr.row.id}" href="%{assign}">assign</s:a>
					</s:else>
				</s:div>
			</display:column>
			<display:column sortProperty="hardwareLpar.name" title="Name"
				sortable="true">
				<s:url id="bravoUrl"
					value="javascript:popupBravoHl(%{#attr.row.hardwareLpar.account.account},'%{#attr.row.hardwareLpar.name}',%{#attr.row.hardwareLpar.id})"
					includeContext="false" includeParams="none" />
				<s:a id="hardwareLpar_%{#attr.row.hardwareLpar.id}" href="%{bravoUrl}">${row.hardwareLpar.name}</s:a>
			</display:column>
			<display:column property="hardwareLpar.hardware.serial" title="Serial"
				sortable="true" class="date" format="{0,date,MM-dd-yyyy}" />
			<display:column property="creationTime" title="Creation Time"
				sortable="true" class="date" format="{0,date,MM-dd-yyyy}" />
            <display:column property="hardwareLpar.hardware.processorCount" title="HW Processors"
				sortable="true" />
			<display:column property="hardwareLpar.hardware.chips" title="HW Chips"
				sortable="true" />
			<display:column property="hardwareLpar.extId" title="HW EXT ID"
				sortable="true" />
			<display:column title="Assignee" sortable="true"
				sortProperty="assignee">
				<s:div id="id_assignment_assignee_%{#attr.row.id}">
					<s:property value="%{#attr.row.assignee}" />
				</s:div>
			</display:column>
			<display:column title="Comments">
				<s:url id="commentsUrl"
					value="javascript:displayPopUp('exceptionHwlparHistory.htm?alertId=%{#attr.row.id}')"
					includeContext="false" includeParams="none" />
				<s:a id="view_%{#attr.row.id}" href="%{commentsUrl}">View</s:a>
			</display:column>

		</display:table>

	</s:form>

	<div id="popupDl" class="hideDlg" style="">
	<table width="100%" style="height: 100%; width: 100%;" id="table1">
		<s:form theme="simple">
			<tr>
				<td height="10"></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td><label for="comments">Comments:</label></td>
				<td><textarea name="comments" cols="32" rows="4"
					id="id_comments"></textarea></td>
				<td></td>
			</tr>
			<tr>
				<td><input type="hidden" name="url" value="" id="id_url" /> <input
					type="hidden" name="alertId" value="" id="id_alert_id" /><input
					type="hidden" name="rowNumber" value="" id=id_row_number /></td>
				<td><input type="button" value="  OK   " id="submit_button"
					size="10" /> <input type="button" value="Cancel"
					id="cancel_button" size="10" onclick="hideDl();" /></td>
				<td></td>
			</tr>
		</s:form>
	</table>
	</div>
</s:if>
<s:else>
	<p>No records found. <a
		href="${pageContext.request.contextPath}/account/exceptions/home.htm">back</a>
	</p>
</s:else>