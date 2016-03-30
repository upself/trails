<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tmp"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<h1>Manage By Software: <span class="orange-dark"><bean:write
	name="user.container" property="product.name" /></span></h1>

<div id="fourth-level">
<ul class="text-tabs">
	<li><html:link page="/SoftwareFilter.do" styleClass="active">Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareFilterSearchSetup.do">Search Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareFilterMove.do">Manage Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareSignature.do">Sigs</html:link>
	|</li>
	<li><html:link page="/SoftwareSignatureSearchSetup.do">Search Sigs</html:link>
	|</li>
	<li><html:link page="/SoftwareSignatureMove.do">Manage Sigs</html:link>
	|</li>
	<li><html:link page="/AddSoftwareSignature.do">Add Signature</html:link>
	</li>
</ul>
</div>
<h2>Software Filter Update Form</h2>
<br>
<p>Use this form to update a software filter. When you are finished,
click the submit button. Press the Cancel button to discard your
changes.</p>
<p>Required fields are marked with an asterisk(*) and must be filled
in to complete the form.
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/UpdateSoftwareFilterSave">
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<html:hidden property="softwareFilterId" />
		<tr>
			<td class="t1"><label for="softwareName"> Filter name: </label></td>
			<td><div class="input-note">&nbsp;</div><bean:write name="softwareFilterForm" property="softwareName" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="softwareVersion"> Filter
			Version: </label></td>
			<td><div class="input-note">&nbsp;</div><bean:write name="softwareFilterForm" property="softwareVersion" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="mapSoftwareVersion">*Map Software
			version: </label></td>
			<td>
			<div class="input-note">maximum 64 characters</div>
			<html:text property="mapSoftwareVersion" styleClass="input" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="endOfSupport"> End of
			support: </label></td>
			<td><div class="input-note">&nbsp;</div><bean:write name="softwareFilterForm" property="endOfSupport" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="catalogType"> Catalog type: </label></td>
			<td>
			<div class="input-note">maximum 32 characters</div>
			<html:text property="catalogType" styleClass="input" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="osType"> Operating System: </label></td>
			<td><div class="input-note">&nbsp;</div><bean:write name="softwareFilterForm" property="osType" /></td>
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
			<td class="t1"><label for="changeJustification">*Change
			justification: </label></td>
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
<br>
<display:table id="row" name="softwareFilterHistory" class="bravo"
	defaultsort="15" defaultorder="descending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:caption>Software Filter history</display:caption>
	<display:column title="Software" property="product.name"
		headerClass="blue-med" />
	<display:column title="Filter name" property="softwareName" headerClass="blue-med" />
	<display:column title="Filter version" property="softwareVersion"
		headerClass="blue-med" />
	<display:column title="Map version" property="mapSoftwareVersion"
		headerClass="blue-med" />
	<display:column title="End of support" property="endOfSupport"
		headerClass="blue-med" />
	<display:column title="Catalog type" property="catalogType"
		headerClass="blue-med" />
	<display:column title="Operating System" property="osType"
		headerClass="blue-med" />
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
