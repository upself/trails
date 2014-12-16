<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h1>New Software Filters</h1>
<br>
<p>Utilize this form to search for new software filters to add to
your current software selection or to inactivate. Use the checkboxes to
alter multiple filters at a time. Click on move or remove when complete.</p>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>
<html:form action="/SoftwareFilterNewSave">
	<html:hidden property="action" />
	<table>
		<tr>
			<td>
			<table cellspacing="0" cellpadding="0" class="search-results">

				<tr class="summary-options">

					<th class="results-count">Results found <bean:write
						name="pagination" property="resultNumber" /></th>
				</tr>
				<tr class="summary-options">
					<logic:notEmpty name="report">
						<th nowrap class="results-sequence"><logic:equal
							name="pagination" property="previous" value="true">
							<html:link page="/SoftwareFilterNew.do" paramId="pagination"
								paramProperty="previousPageNumber">
								<b>Previous</b>
							</html:link> | 
<html:link page="/SoftwareFilterNew.do?pageNumber=1">1</html:link>...
</logic:equal> <logic:iterate id="pages" name="pagination" property="paginationItems">


							<logic:equal name="pages" property="active" value="true">
								<b><bean:write name="pages" property="pageNumber" /></b>
							</logic:equal>
							<logic:notEqual name="pages" property="active" value="true">
								<html:link page="/SoftwareFilterNew.do" paramId="pageNumber"
									paramName="pages" paramProperty="pageNumber">
									<bean:write name="pages" property="pageNumber" />
								</html:link>
							</logic:notEqual>
							<logic:equal name="pages" property="next" value="true">
				...
				<html:link page="/SoftwareFilterNew.do" paramId="pageNumber"
									paramName="pagination" paramProperty="totalPages">
									<bean:write name="pagination" property="totalPages" />
								</html:link> | 
				<html:link page="/SoftwareFilterNew.do" paramId="pageNumber"
									paramName="pagination" paramProperty="nextPageNumber">
									<b>Next</b>
								</html:link>
							</logic:equal>
						</logic:iterate></th>
					</logic:notEmpty>
				</tr>
			</table>


			<display:table id="row" name="report" class="bravo">
				<display:setProperty name="basic.empty.showtable" value="true" />
				<display:caption>New Filters</display:caption>
				<display:column
					title="<input type='checkbox' name='selectedItems' onclick='this.value=check(this.form.selectedItems);' />"
					headerClass="blue-med">
					<html:multibox property="selectedItems"
						value="${row.softwareFilterId}" />
				</display:column>
				<display:column title="Filter Name" property="softwareName"
					headerClass="blue-med"
					href="/SignatureBank/UpdateSoftwareFilter.do" paramId="id"
					paramProperty="softwareFilterId" />
				<display:column title="Filter version" property="softwareVersion"
					headerClass="blue-med" />
			</display:table></td>
			<td>
			<table cellspacing="0" cellpadding="0" class="search-results">
				<tr class="summary-options">
					<th class="results-count">&nbsp;</th>
				</tr>
				<tr class="summary-options">
					<th class="results-sequence">&nbsp;</th>
				</tr>
			</table>

			<table cellspacing="0" cellpadding="0" class="sign-in-table">
				<tr>
					<td class="t1"><label for="softwareCategory"> </label></td>
					<td>
					<div class="input-note">move filters to:</div>
					<html:select property="softwareId" styleClass="inputlong" size="40">
						<html:options collection="softwares" property="softwareId"
							labelProperty="softwareName" />
					</html:select></td>
				</tr>
			</table>
			</td>
		</tr>
	</table>

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
	<div class="buttons"><span class="button-blue"><html:submit
		onclick="this.form.action.value='add'">Add</html:submit></span> <span
		class="button-blue"><html:submit
		onclick="this.form.action.value='remove'">Remove</html:submit></span></div>
	</div>
</html:form>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
