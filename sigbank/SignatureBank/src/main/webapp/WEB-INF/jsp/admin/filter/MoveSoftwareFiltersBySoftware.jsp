<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h1>Manage By Software: <span class="orange-dark"><bean:write
	name="user.container" property="product.name" /></span></h1>

<div id="fourth-level">

<ul class="text-tabs">
	<li><html:link page="/SoftwareFilter.do" >Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareFilterSearchSetup.do">Search Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareFilterMove.do" styleClass="active">Manage Filters</html:link>
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

<h2>Move/Map Software Filters</h2>
<br>
<p>Utilize this form to move/map software filters to other software
in the software catalog. Use the checkboxes to make your selection and
then choose a piece of software. Click on move when complete. To alter
the map version, check which filters you would like to alter and click
on the Map Version button.</p>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/MoveSoftwareFilterSave">
	<html:hidden property="action" />
	<display:table id="row" name="report" class="bravo" defaultsort="2"
		defaultorder="descending">
		<display:setProperty name="basic.empty.showtable" value="true" />
		<display:caption>Assigned Software Filters</display:caption>
		<display:column
			title="<input type='checkbox' name='selectedItems' onclick='this.value=check(this.form.selectedItems);' />"
			headerClass="blue-med">
			<html:multibox property="selectedItems"
				value="${row.softwareFilterId}" />
		</display:column>
		<display:column title="Status" property="statusImage"
			headerClass="blue-med" />
		<display:column title="Filter Name" property="softwareName"
			headerClass="blue-med" href="/SignatureBank/UpdateSoftwareFilter.do"
			paramId="id" paramProperty="softwareFilterId" />
		<display:column title="Filter Version" property="softwareVersion"
			headerClass="blue-med" />
		<display:column title="Map Version" property="mapSoftwareVersion"
			headerClass="blue-med" />
		<display:column title="Last Editor" property="remoteUser"
			headerClass="blue-med" />
	</display:table>
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td class="t1"><label for="softwareCategory">*Software:
			</label></td>
			<td>
			<div class="input-note">choose one</div>
			<html:select property="softwareId" styleClass="input">
				<html:options collection="softwares" property="id"
					labelProperty="name" />
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="mapSoftwareVersion">New Map
			Version:</label></td>
			<td>
			<div class="input-note">maximum 64 characters</div>
			<html:text property="mapSoftwareVersion" /></td>
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
	<div class="buttons"><span class="button-blue"><html:submit onclick="this.form.action.value='move'">Move</html:submit></span>
	<span class="button-blue"><html:submit onclick="this.form.action.value='map'">Map Version</html:submit></span>
	</div>
	</div>
</html:form>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
