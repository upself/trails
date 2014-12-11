<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tmp"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Update Software Request Form</h1>
<br>
<p>Use this form to update software in the software catalog. When
you are finished, click the submit button. Press the Cancel button to
discard your changes.</p>
<p>Required fields are marked with an asterisk(*) and must be filled
in to complete the form.
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/UpdateSoftwareSave">
	<html:hidden property="softwareId" />
	<html:hidden property="priority" />
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td class="t1"><label for="softwareName">*Software Name:</label></td>
			<td>
			<div class="input-note">maximum 128 characters</div>
			<html:text property="softwareName" styleClass="input" size="128" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="manufacturer">*Software
			Manufacturer: </label></td>
			<td>
			<div class="input-note">choose one</div>
			<html:select property="manufacturer" styleClass="input">
				<html:option value="">-NONE-</html:option>
				<html:options collection="manufacturers" property="manufacturerId"
					labelProperty="manufacturerName" />
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="softwareCategory">*Software
			Category: </label></td>
			<td>
			<div class="input-note">choose one</div>
			<html:select property="softwareCategory" styleClass="input">
				<html:option value="">-NONE-</html:option>
				<html:options collection="softwareCategories"
					property="softwareCategoryId" labelProperty="softwareCategoryName" />
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="type">*Software License Type:
			</label></td>
			<td>
			<div class="input-note">choose one</div>
			<html:select property="type" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="O">OPERATING SYSTEM</html:option>
				<html:option value="A">APPLICATION</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="level">*Software License
			Level: </label></td>
			<td>
			<div class="input-note">choose one</div>
			<html:select property="level" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="LICENSABLE">LICENSABLE</html:option>
				<html:option value="UN-LICENSABLE">UN-LICENSABLE</html:option>
				<html:option value="COMPONENT">COMPONENT</html:option>
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="level">*Vendor Managed: </label></td>
			<td>
			<div class="input-note">choose one</div>
			<html:select property="vendorManaged" styleClass="input">
				<html:option value="">-SELECT-</html:option>
				<html:option value="true">TRUE</html:option>
				<html:option value="false">FALSE</html:option>
			</html:select></td>
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

<display:table name="softwareHistory" class="bravo" defaultsort="10"
	defaultorder="descending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:caption>Software History</display:caption>

	<display:column property="softwareName" headerClass="blue-med" />
	<display:column property="manufacturer" headerClass="blue-med" />
	<display:column property="softwareCategory" headerClass="blue-med" />
	<display:column property="priority" headerClass="blue-med" />
	<display:column property="level" headerClass="blue-med" />
	<display:column property="changeJustification" headerClass="blue-med" />
	<display:column property="type" headerClass="blue-med" />
	<display:column property="vendorManaged" headerClass="blue-med" />
	<display:column property="comments" headerClass="blue-med" />
	<display:column property="remoteUser" headerClass="blue-med" />
	<display:column property="recordTime" headerClass="blue-med" />
	<display:column property="status" headerClass="blue-med" />
</display:table>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
