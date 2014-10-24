<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Manage Manufacturer: <span class="orange-dark"><bean:write
	name="user.container" property="manufacturer.manufacturerName" /></span></h1>
<br>
<p>Utilize this form to add software to a manufacturer. First search
for your software to add and then use the form below to add the software
to the manufacturer.</p>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/ManufacturerSoftwareSearch">
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td class="t1">*<label for="softwareName">Software Name</label>:</td>
			<td>
			<div class="input-note">maximum 128 characters</div>
			<html:text styleId="softwareName" property="softwareName" styleClass="input" size="128" /></td>
		</tr>
	</table>
	<p>&nbsp;</p>

	<div class="clear">&nbsp;</div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Search</html:submit></span>
	</div>
	<div class="clear">&nbsp;</div>
	<div class="hrule-dots">&nbsp;</div>
</html:form>


<html:form action="/AddSoftwareManufacturerSave">
	<html:hidden property="manufacturer" />
	<html:hidden property="softwareName" />
	<display:table id="row" name="report" class="bravo" defaultsort="2"
		defaultorder="ascending">
		<display:setProperty name="basic.empty.showtable" value="true" />
		<display:caption><label for="id_selectedItems">Results</label></display:caption>
		<display:column
			title="<input id="id_selectedItems" type='checkbox' name='selectedItems' onclick='this.value=check(this.form.selectedItems);' />"
			headerClass="blue-med">
			<html:multibox property="selectedItems" value="${row.softwareId}" />
		</display:column>
		<display:column title="Status" property="statusImage"
			headerClass="blue-med" />
		<display:column title="Software Name" property="softwareName"
			headerClass="blue-med" />
		<display:column title="Manufacturer"
			property="manufacturer.manufacturerName" headerClass="blue-med" />
	</display:table>
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td class="t1">*<label for="changeJustification">Change
			Justification</label>:</td>
			<td>
			<div class="input-note">maximum 128 characters</div>
			<html:textarea styleId="changeJustification" rows="4" cols="64" property="changeJustification" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="comments">Additional
			Comments</label>:</td>
			<td>
			<div class="input-note">maximum 255 characters</div>
			<html:textarea styleId="comments" rows="4" cols="64" property="comments" /></td>
		</tr>
	</table>
	<p>&nbsp;</p>

	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Add</html:submit></span>
	</div>
	</div>
	<div class="clear">&nbsp;</div>
	<div class="hrule-dots">&nbsp;</div>
</html:form>

</div>
<!-- stop main content -->

</div>
<!-- stop content -->
