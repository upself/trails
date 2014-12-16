<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>View By Manufacturer</h1>
<br>
<p>This page is intended to allow Signature Bank Admins to view
software by the manufacturer.</p>
<p class="hrule-dots"></p>
<br>
<display:table id="row" name="report" class="bravo" defaultsort="2"
	defaultorder="ascending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:caption>Manufacturers</display:caption>

	<display:column title="Manufacturer Name" property="manufacturerName"
		headerClass="blue-med" />
	<display:column title="Software" headerClass="blue-med"
		href="ManufacturerSoftware.do" paramId="id"
		paramProperty="manufacturerId">
	View
	</display:column>
</display:table>
<!-- stop main content -->
<!-- stop content -->
