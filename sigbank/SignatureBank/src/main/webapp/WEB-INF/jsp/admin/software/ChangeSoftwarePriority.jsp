<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Alter Priority: <span class="orange-dark"><bean:write
	name="softwareForm" property="softwareName" /></span></h1>
<br>
<p>Utilize this form to move the priority of a given piece of
software.</p>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/ChangeSoftwarePrioritySave.do">
	<html:hidden property="softwareId" />
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td class="t1"><label for="priority">*New Priority:</label></td>
			<td>
			<div class="input-note">must be an integer</div>
			<html:text property="priority" styleClass="input" /></td>
		</tr>
		<tr>
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

	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
	<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
	</div>
	<div class="clear">&nbsp;</div>
	<div class="hrule-dots">&nbsp;</div>
	<p>&nbsp;</p>
</html:form>

<display:table id="row" name="products" class="bravo" defaultsort="4"
	defaultorder="ascending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:caption>Assigned Software</display:caption>
	<display:column title="Status" property="statusImage"
		headerClass="blue-med" />
	<display:column title="Software Name" property="name"
		headerClass="blue-med" />
	<display:column title="Editor" property="productInfo.remoteUser"
		headerClass="blue-med" />
	<display:column title="Order" property="productInfo.priority"
		headerClass="blue-med" />
</display:table>
