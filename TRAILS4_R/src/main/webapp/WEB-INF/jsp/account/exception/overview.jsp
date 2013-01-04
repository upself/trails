<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Data exception overview: <s:property value="account.name" />(<s:property
	value="account.account" />)</h1>
<p class="confidential">IBM Confidential</p>
<br />
<p>This page displays the total number of data exceptions assigned
per data exception type.</p>
<s:if test="%{data.list.size>0}">
	<p>Clicking on the data exception type will take you to the
	corresponding data exception detail page.</p>
	<br />
	<display:table id="row" name="data.list" class="basic-table"
	 summary="Exception OverView"
		decorator="org.displaytag.decorator.TotalTableDecorator"
		cellspacing="1" cellpadding="0">
		<display:column title="Data exception">
			<s:url id="alertUrl" namespace="/account/exceptions"
				action="swlpar%{#attr.row.alertType.code}" includeParams="none" />
			<s:a href="%{alertUrl}">
				<s:property value="%{#attr.row.name}" />
			</s:a>
		</display:column>
		<display:column property="assigned" title="Assigned #" total="true"
			format="{0,number,0}" />
		<display:column property="total" title="Total #" total="true"
			format="{0,number,0}" />
	</display:table>
</s:if>
<s:else>
	<p>No records found. <a
		href="${pageContext.request.contextPath}/account/exceptions/home.htm">back</a>
	</p>
</s:else>