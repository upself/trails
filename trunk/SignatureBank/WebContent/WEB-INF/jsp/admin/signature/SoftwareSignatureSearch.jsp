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
	<li><html:link page="/SoftwareFilterSearchSetup.do">Search Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareFilterMove.do">Manage Filters</html:link>
	|</li>
	<li><html:link page="/SoftwareSignature.do">Sigs</html:link>
	|</li>
	<li><html:link page="/SoftwareSignatureSearchSetup.do" styleClass="active">Search Sigs</html:link> 
	|</li>
	<li><html:link page="/SoftwareSignatureMove.do">Manage Sigs</html:link>
	|</li>
	<li><html:link page="/AddSoftwareSignature.do">Add Signature</html:link>
	</li>
</ul>
</div>

<h2>Search and add Software Signatures</h2>
<br>
<p>Utilize this form to search for software signatures to add to
your current software selection. Once you obtain the necessary results
from the search, use the checkboxes to add software signatures. Click on
add when complete.</p>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/SoftwareSignatureSearch">
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td class="t1"><label for="softwareCategory">*Signature
			name: </label></td>
			<td>
			<div class="input-note">max 128 characters</div>
			<html:text property="fileName" styleClass="input" /></td>
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

<html:form action="/AddSearchSoftwareSignatureSave">
	<display:table id="row" name="report" class="bravo" defaultsort="2"
		defaultorder="descending">
		<display:setProperty name="basic.empty.showtable" value="true" />
		<display:caption>Search Results</display:caption>
		<display:column
			title="<input type='checkbox' name='selectedItems' onclick='this.value=check(this.form.selectedItems);' />"
			headerClass="blue-med">
			<html:multibox property="selectedItems"
				value="${row.softwareSignatureId}" />
		</display:column>
		<display:column title="Status" property="statusImage"
			headerClass="blue-med" />
		<display:column title="File Name" property="fileName" style="white-space:pre;"
			headerClass="blue-med"
			href="/SignatureBank/UpdateSoftwareSignature.do" paramId="id"
			paramProperty="softwareSignatureId" />
		<display:column title="File Size" property="fileSize"
			headerClass="blue-med" />
		<display:column title="Version" property="softwareVersion"
			headerClass="blue-med" />
		<display:column title="Mapped Name" headerClass="blue-med"
			property="product.name">
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
		class="orange-dark">Add signatures to <bean:write
		name="user.container" property="product.name" /></span>]<html:submit>Add</html:submit></span>
	</div>
	</div>
</html:form>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
