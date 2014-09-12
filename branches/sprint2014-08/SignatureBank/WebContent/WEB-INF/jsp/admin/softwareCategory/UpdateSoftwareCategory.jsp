<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tmp"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Update Software Category Request Form</h1>
<br>
<p>Use this form to update a software category. When you are
finished, click the submit button. Press the Cancel button to discard
your changes.</p>
<p>Required fields are marked with an asterisk(*) and must be filled
in to complete the form.
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/UpdateSoftwareCategorySave">
	<html:hidden property="softwareCategoryId" />
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td class="t1"><label for="softwareCategoryName">*Software
			Category Name:</label></td>
			<td>
			<div class="input-note">maximum 64 characters</div>
			<html:text property="softwareCategoryName" styleClass="input"
				size="64" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="status">*Status: </label></td>
			<td>
			<div class="input-note">choose one</div>
			<html:select property="status" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="ACTIVE">ACTIVE</html:option>
				<html:option value="INACTIVE">INACTIVE</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="changeJustification"> *Change
			Justification:</label></td>
			<td>
			<div class="input-note">maximum 128 characters</div>
			<html:textarea rows="4" cols="64" property="changeJustification" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="comments">Additional
			Comments:</label></td>
			<td>
			<div class="input-note">maximum 255 characters</div>
			<html:textarea rows="4" cols="64" property="comments" /></td>
		</tr>
	</table>
	<p>&nbsp;</p>
	<div class="hrule-dots">&nbsp;</div>

	<div class="clear">&nbsp;</div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
	<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
	</div>

</html:form>

<div class="clear">&nbsp;</div>

<display:table name="softwareCategoryHistory" class="bravo"
	defaultsort="10" defaultorder="descending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:caption>Software Category History</display:caption>

	<display:column title="Software Category"
		property="softwareCategoryName" headerClass="blue-med" />
	<display:column title="Change Justification"
		property="changeJustification" headerClass="blue-med" />
	<display:column title="Comments" property="comments"
		headerClass="blue-med" />
	<display:column title="Editor" property="remoteUser"
		headerClass="blue-med" />
	<display:column title="Record Time" property="recordTime"
		headerClass="blue-med" />
	<display:column title="Status" property="status" headerClass="blue-med" />
</display:table>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
