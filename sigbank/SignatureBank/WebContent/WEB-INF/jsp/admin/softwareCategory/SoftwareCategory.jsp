<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Manage By Software Category</h1>
<br>
<p>This page is intended to allow Signature Bank Admins to manage
software by the software category.</p>
<p class="hrule-dots"></p>
<br>
<display:table id="row" name="report" class="bravo" defaultsort="2"
	defaultorder="ascending">
	<%
				String id = "";
				if (pageContext.getAttribute("row") != null) {
			id = ((com.ibm.tap.sigbank.softwarecategory.SoftwareCategory) pageContext
					.getAttribute("row")).getSoftwareCategoryId()
					.toString();
				}
	%>
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:caption>Software Categories</display:caption>

	<display:column title="Status" property="statusImage"
		headerClass="blue-med" />
	<display:column title="Software Category"
		property="softwareCategoryName" headerClass="blue-med"
		href="UpdateSoftwareCategory.do" paramId="id"
		paramProperty="softwareCategoryId" />
	<display:column title="Comments" property="comments"
		headerClass="blue-med" />
	<display:column title="Editor" property="remoteUser"
		headerClass="blue-med" />
	<display:column title="Software" headerClass="blue-med"
		href="SoftwareCategorySoftware.do" paramId="id"
		paramProperty="softwareCategoryId">
	View
	</display:column>
	<display:column title="" headerClass="blue-med"
		href="MoveSoftwareCategorySoftware.do" paramId="id"
		paramProperty="softwareCategoryId">
	Move
	</display:column>
	<display:column title="" headerClass="blue-med"
		href="AddSoftwareCategorySoftware.do" paramId="id"
		paramProperty="softwareCategoryId">
	Add
	</display:column>
	<display:column title="History" headerClass="blue-med">
		<a
			href="javascript:displayPopUp('SoftwareCategoryHistory.do?id=<%=id %>')">History</a>
	</display:column>
</display:table>

</div>
<!-- stop main content -->

</div>
<!-- stop content -->
