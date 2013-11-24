<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<h1>Cause code</h1>
<p class="confidential">IBM Confidential</p>
<br />
<p>Below is a list of the cause codes in the application. Press one
	of the links to edit the cause code details. You can also add a new
	cause code to the application by pressing the Add a cause code link.</p>
<br />
<div class="hrule-dots"></div>
<br />
<s:if test="hasActionMessages()">
	<s:actionmessage />
	<br />
</s:if>
<br />
<br />
<display:table name="alertTypeCausesList" class="basic-table" id="row"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	cellspacing="1" cellpadding="0" requestURI="listAlertCause.htm">
	<display:column property="pk.alertType.name" title="Alert" />
	<display:column title="Cause code name" property="pk"
		decorator="com.ibm.tap.trails.framework.AlertTypeCauseColumnDecorator" />
	<display:column property="pk.alertCause.alertCauseResponsibility.name"
		title="Responsibility" />
	<display:column property="status" title="Status" />
</display:table>
