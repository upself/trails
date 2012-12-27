<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Active SW LPAR with NULL or 1970 Scan Date:<s:property
	value="account.name" />(<s:property value="account.account" />)</h1>
<p class="confidential">IBM Confidential</p>
<p>This page displays data exceptions for software lpars with NULL
or 1970 Scan Date.</p>
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

	<s:form action="swlparNULLTIME" method="post" theme="simple">
		<s:hidden name="page" value="%{#attr.page}" />
		<s:hidden name="dir" value="%{#attr.dir}" />
		<s:hidden name="sort" value="%{#attr.sort}" />


		<div class="clear"></div>
		<div class="button-bar">
		<div class="buttons"><span class="button-blue"> <input
			type="button" value="Assign all"
			onclick="javascript:showDx('exceptionSoftwareLparAssignAll.htm')" />

		<input type="button" value="Unassign all"
			onclick="javascript:showDx('exceptionSoftwareLparUnAssignAll.htm')" />
		</span></div>
		<br />
		</div>

		<display:table name="data" class="basic-table" id="row"
			decorator="org.displaytag.decorator.TotalTableDecorator"
			summary="SoftwareLpar Invalid Scan Time"
			cellspacing="2" cellpadding="0" requestURI="swlparNULLTIME.htm">
			<display:column title="Action<br>to be taken:">
				<s:div id="id_assignment_action_%{#attr.row.id}">
					<s:if test="%{#attr.row.assignee==userSession.remoteUser}">
						<s:hidden name="list[%{#attr.row_rowNum-1}].id"
							value="%{#attr.row.Id}" id="swlpar_list_id_%{#attr.row.id}" />
						<s:hidden name="list[%{#attr.row_rowNum-1}].beenAssigned"
							value="true" id="swlpar_list_beenAssigned_%{#attr.row.id}" />
						<s:url id="unassign"
							value="javascript:showDl('exceptionSoftwareLparUnassign.htm',%{#attr.row.id},%{#attr.row_rowNum-1})"
							includeContext="false" includeParams="none" />
						<s:a id="unassign_%{#attr.row.id}" href="%{unassign}">unassign</s:a>
					</s:if>
					<s:else>
						<s:hidden name="list[%{#attr.row_rowNum-1}].id"
							value="%{#attr.row.Id}" id="swlpar_list_id_%{#attr.row.id}" />
						<s:hidden name="list[%{#attr.row_rowNum-1}].beenAssigned"
							value="false" id="swlpar_list_beenAssigned_%{#attr.row.id}" />
						<s:url id="assign"
							value="javascript:showDl('exceptionSoftwareLparAssign.htm',%{#attr.row.id},%{#attr.row_rowNum-1})"
							includeContext="false" includeParams="none" />
						<s:a id="assign_%{#attr.row.id}" href="%{assign}">assign</s:a>
					</s:else>
				</s:div>
			</display:column>
			<display:column sortProperty="softwareLpar.name" title="Name"
				sortable="true">
				<s:url id="bravoUrl"
					value="javascript:popupBravoSl(%{#attr.row.softwareLpar.account.account},'%{#attr.row.softwareLpar.name}',%{#attr.row.softwareLpar.id})"
					includeContext="false" includeParams="none" />
				<s:a id="softwarelpar_%{#attr.row.softwareLpar.id}" href="%{bravoUrl}">${row.softwareLpar.name}</s:a>
			</display:column>
			<display:column property="softwareLpar.scanTime" title="Scantime"
				sortable="true" class="date" format="{0,date,MM-dd-yyyy}" />
			<display:column property="creationTime" title="Create date"
				sortable="true" class="date" format="{0,date,MM-dd-yyyy}" />

			<display:column property="softwareLpar.serial" title="Serial"
				sortable="true" />
			<display:column property="softwareLpar.osName" title="OS Name"
				sortable="true" />
			<display:column title="Assignee" sortable="true"
				sortProperty="assignee">
				<s:div id="id_assignment_assignee_%{#attr.row.id}">
					<s:property value="%{#attr.row.assignee}" />
				</s:div>
			</display:column>
			<display:column title="Comments">
				<s:url id="commentsUrl"
					value="javascript:displayPopUp('exceptionSoftwareLparHistory.htm?alertId=%{#attr.row.id}')"
					includeContext="false" includeParams="none" />
				<s:a id="view_%{#attr.row.id}" href="%{commentsUrl}">View</s:a>
			</display:column>

		</display:table>

	</s:form>

	<div id="popupDl" class="hideDlg" style=""><s:form theme="simple">
		<table width="100%" style="height: 100%; width: 100%;" id="table1">
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
		</table>
	</s:form></div>
</s:if>
<s:else>
	<p>No records found. <a
		href="${pageContext.request.contextPath}/account/exceptions/home.htm">back</a>
	</p>
</s:else>