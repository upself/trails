<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Manage Manufacturer: <span class="orange-dark"><bean:write
	name="user.container" property="manufacturer.manufacturerName" /></span></h1>
<br>
<p>Utilize this form to move software to other manufacturers.</p>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/UpdateSoftwareManufacturerSave.do">
	<display:table id="row" name="softwares" class="bravo" defaultsort="2"
		defaultorder="ascending">
		<display:setProperty name="basic.empty.showtable" value="true" />
		<display:caption><label for="id_selectedItems">Assigned Software</label></display:caption>
		<display:column
			title="<input id="id_selectedItems" type='checkbox' name='selectedItems' onclick='this.value=check(this.form.selectedItems);' onkeypress="return(this.onclick());" />"
			headerClass="blue-med">
			<html:multibox property="selectedItems" value="${row.softwareId}" />
		</display:column>
		<display:column title="Status" property="statusImage"
			headerClass="blue-med" />
		<display:column title="Software Name" property="softwareName"
			headerClass="blue-med" />
		<display:column title="Editor" property="remoteUser"
			headerClass="blue-med" />
	</display:table>
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td class="t1">*<label for="manufacturer">Software
			Manufacturer</label>: </td>
			<td>
			<div class="input-note">choose one</div>
			<html:select styleId="manufacturer" property="manufacturer" styleClass="input">
				<html:options collection="manufacturers" property="manufacturerId"
					labelProperty="manufacturerName" />
			</html:select></td>
		</tr>
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
	<div class="hrule-dots">&nbsp;</div>

	<div class="clear">&nbsp;</div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Move</html:submit></span>
	</div>
	</div>

</html:form>

</div>
<!-- stop main content -->

</div>
<!-- stop content -->
