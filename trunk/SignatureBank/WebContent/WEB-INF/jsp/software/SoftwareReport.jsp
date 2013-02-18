<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tmp"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.ibm.asset.swkbt.domain.Product"%><h1>Software
Catalog</h1>
<br>
<p>Use this form to search for software in the software catalog.
When you are finished, click the search button.</p>
<p>Required fields are marked with an asterisk(*) and must be filled
in to complete the form.
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent><html:form action="/SoftwareRefineSearch">
	<table cellspacing="0" cellpadding="0" class="sign-in-table">
		<tr class="blue-med">
			<td class="t1"><label for="softwareName">*Software Name:</label></td>
			<td>
			<div class="input-note">maximum 128 characters</div>
			<html:text styleId="softwareName" property="softwareName"
				styleClass="input" size="128" /></td>
		</tr>
		<tr>
			<td class="t1"><label for="manufacturerId">Manufacturer:</label></td>
			<td>
			<div class="input-note">select one</div>
			<html:select styleId="manufacturerId" property="manufacturerId"
				styleClass="input">
				<html:option value="">-ALL-</html:option>
				<html:options collection="manufacturers" property="manufacturerId"
					labelProperty="manufacturerName" />
			</html:select></td>
		</tr>
		<tr>
			<td class="t1"><label for="softwareCategoryId">SoftwareCategory:</label></td>
			<td>
			<div class="input-note">select one</div>
			<html:select styleId="softwareCategoryId"
				property="softwareCategoryId" styleClass="input">
				<html:option value="">-ALL-</html:option>
				<html:options collection="softwareCategories"
					property="softwareCategoryId" labelProperty="softwareCategoryName" />
			</html:select></td>
		</tr>
	</table>
	<div class="clear">&nbsp;</div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Search</html:submit></span>
	</div>
	</div>
	<div class="clear">&nbsp;</div>
	<div class="hrule-dots">&nbsp;</div>
</html:form>
<div class="clear">&nbsp;</div>

<display:table name="report" class="bravo" id="row">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:caption>Software Report</display:caption>
	<display:column title="Software Name" property="name"
		headerClass="blue-med" href="ViewSoftware.do" paramId="id"
		paramProperty="id" />
	<c:if test="${row.productInfo.licensable}">
		<display:column title="Level" value="LICENSABLE"
			headerClass="blue-med" />
	</c:if>
	<c:if test="${!row.productInfo.licensable}">
		<display:column title="Level" value="UN-LICENSABLE"
			headerClass="blue-med" />
	</c:if>
	<display:column title="Manufacturer"
		property="manufacturer.manufacturerName" headerClass="blue-med" />
	<display:column title="Filters" headerClass="blue-med"
		href="SoftwareFilter.do" paramId="id" paramProperty="id">
	View
	</display:column>
	<display:column title="Signatures" headerClass="blue-med"
		href="SoftwareSignature.do" paramId="id" paramProperty="id">
	View
	</display:column>
	<display:column title="Editor" property="productInfo.remoteUser"
		headerClass="blue-med" />
</display:table>