<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h1>Manage By Software: <span class="orange-dark"><bean:write
	name="user.container" property="product.name" /></span></h1>

<div id="fourth-level">

<ul class="text-tabs">
	<li><html:link page="/SoftwareFilter.do">Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareFilterSearchSetup.do"	styleClass="active">Search Filters</html:link> 
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

<h2>Search and add Software Filters</h2>
<br>
<p>Utilize this form to search for software filters to add to your
current software selection. Once you obtain the necessary results from
the search, use the checkboxes to add software filters. Click on add
when complete.</p>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/SoftwareFilterSearch">
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td class="t1"><label for="softwareCategory">*Filter
			name: </label></td>
			<td>
			<div class="input-note">max 128 characters</div>
			<html:text property="softwareName" styleClass="input" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="status">*Status: </label></td>
			<td><html:radio property="status" value="ACTIVE">Active</html:radio>
			<html:radio property="status" value="INACTIVE">Inactive</html:radio>
			<html:radio property="status" value="NEW">New</html:radio> <html:radio
				property="status" value="ALL">All</html:radio></td>
		</tr>
	</table>
	<p>&nbsp;</p>
	<div class="hrule-dots">&nbsp;</div>

	<div class="clear">&nbsp;</div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Search</html:submit></span>
	</div>
	</div>
</html:form>

<html:form action="/AddSearchSoftwareFilterSave">
	<display:table id="row" name="report" class="bravo" defaultsort="2"
		defaultorder="descending">
		<display:setProperty name="basic.empty.showtable" value="true" />
		<display:caption>Search Results</display:caption>
		<display:column
			title="<input type='checkbox' name='selectedItems' onclick='this.value=check(this.form.selectedItems);' />"
			headerClass="blue-med">
			<html:multibox property="selectedItems"
				value="${row.softwareFilterId}" />
		</display:column>
		<display:column title="Status" property="statusImage"
			headerClass="blue-med" />
		<display:column title="Filter Name" property="softwareName" style="white-space:pre;"
			headerClass="blue-med" href="/SignatureBank/UpdateSoftwareFilter.do"
			paramId="id" paramProperty="softwareFilterId" />
		<display:column title="Filter version" property="softwareVersion"
			headerClass="blue-med" />
		<display:column title="Mapped Name" headerClass="blue-med"
			property="product.name" href="SoftwareFilter.do"
			paramId="id" paramProperty="product.id">
		</display:column>
		<display:column title="Last Editor" property="remoteUser"
			headerClass="blue-med" />
	</display:table>
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
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
	<div class="buttons"><span class="button-blue">[<span
		class="orange-dark">Add filters to <bean:write
		name="user.container" property="product.name" /></span>]<html:submit>Add</html:submit></span>
	</div>
	</div>
</html:form>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
