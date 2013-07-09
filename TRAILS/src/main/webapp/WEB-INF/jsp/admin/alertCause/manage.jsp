<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<h1 class="oneline">Add</h1><div style="font-size:22px; display:inline">&nbsp;cause code</div>
<p class="confidential">IBM Confidential</p>
<br />
<p>Add/Edit the cause code's name. Press the Save button to save your changes.
Fields marked with an asterisk (*) are required.</p>
<br />
<div class="hrule-dots"></div>
<br />
<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<h2 class="bar-blue-med-light">Cause code details</h2>
<br />
<s:form action="save" method="post" namespace="/admin/alertCause"
	theme="simple">
	<s:hidden name="alertCauseId" />
	<div class="float-left" style="width: 1%;">*</div>
	<div class="float-left" style="width: 29%;"><label for="alertCauseName">Name:</label></div>
	<div class="float-left" style="width: 70%;">
		<s:textfield name="alertCauseForm.alertCauseName" required="true" size="50" id="alertCauseName"
			maxlength="64" />
	</div>
	<br />
	<br />
	<div class="button-bar"><div class="buttons"><span class="button-blue">
		<s:submit value="Save" alt="Save"/>
		<s:submit value="Cancel" method="cancel" alt="Cancel"/>
	</span></div></div>
</s:form>
