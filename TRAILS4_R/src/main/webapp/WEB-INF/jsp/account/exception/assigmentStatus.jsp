<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<s:iterator value="#request.list" id="alertListForm" status="st">
	<s:if test="%{#alertListForm!=null}">
		<s:property value="#alertListForm.id" />
{sep}
   <s:div id="id_assignment_action_%{#alertListForm.id}">
			<s:if test="%{#alertListForm.assignee==userSession.remoteUser}">
				<s:hidden name="list[%{#st.index}].id" value="%{#alertListForm.id}"
					id="swlpar_list_id_%{#attr.row.id}" />
				<s:hidden name="list[%{#st.index}].beenAssigned" value="true"
					id="swlpar_list_beenAssigned_%{#attr.row.id}" />
				<s:url id="unassign_url"
					value="javascript:showDl('exceptionSoftwareLparUnassign.htm',%{#alertListForm.id},%{#st.index})"
					includeContext="false" includeParams="none" />
				<s:a href="%{unassign_url}">unassign</s:a>
			</s:if>
			<s:else>
				<s:hidden name="list[%{#st.index}].id" value="%{#alertListForm.id}"
					id="swlpar_list_id_%{#attr.row.id}" />
				<s:hidden name="list[%{#st.index}].beenAssigned" value="false"
					id="swlpar_list_beenAssigned_%{#attr.row.id}" />
				<s:url id="assign_url"
					value="javascript:showDl('exceptionSoftwareLparAssign.htm',%{#alertListForm.id},%{#st.index})"
					includeContext="false" includeParams="none" />
				<s:a href="%{assign_url}">assign</s:a>
			</s:else>
		</s:div>
{sep}
      <s:div id="div#id_assignment_assignee_%{#alertListForm.id}">
			<s:property value="%{#alertListForm.assignee}" />
		</s:div>

	</s:if>


{row}
</s:iterator>
