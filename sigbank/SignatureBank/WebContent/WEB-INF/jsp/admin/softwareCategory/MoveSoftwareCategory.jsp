<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Manage Software Category: <span class="orange-dark"><bean:write
	name="user.container" property="softwareCategory.softwareCategoryName" /></span></h1>
<br>
<p>Utilize this form to move software to other software categories.</p>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<html:form action="/UpdateSoftwareSoftwareCategorySave.do">
	<display:table id="row" name="products" class="bravo" defaultsort="5"
		defaultorder="ascending">
		<display:setProperty name="basic.empty.showtable" value="true" />
		<display:caption>Assigned Software</display:caption>
		<display:column
			title="<input type='checkbox' name='selectedItems' onclick='this.value=check(this.form.selectedItems);' />"
			headerClass="blue-med">
			<html:multibox property="selectedItems" value="${row.id}" />
		</display:column>
		<display:column title="Status" property="statusImage"
			headerClass="blue-med" />
		<display:column title="Software Name" property="name"
			headerClass="blue-med" />
		<display:column title="Editor" property="productInfo.remoteUser"
			headerClass="blue-med" />
		<display:column title="Order" property="productInfo.priority"
			headerClass="blue-med" href="ChangeSoftwarePriority.do" paramId="id"
			paramProperty="id"/>
	</display:table>
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr>
			<td class="t1"><label for="softwareCategory">*Software
			Category: </label></td>
			<td>
			<div class="input-note">choose one</div>
			<html:select property="softwareCategory" styleClass="input">
				<html:options collection="softwareCategories"
					property="softwareCategoryId" labelProperty="softwareCategoryName" />
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
	<div class="buttons"><span class="button-blue"><html:submit>Move</html:submit></span>
	</div>
	</div>

</html:form>