<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Connected Bank Accounts</h1>
<br>

<display:table id="row" name="report" class="bravo" defaultsort="2"
	defaultorder="ascending" requestURI="">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:caption>Bank Accounts</display:caption>
	<display:column title="Status" property="statusImage"
		headerClass="blue-med" sortable="true" />
	<display:column title="Name" property="name" headerClass="blue-med"
		sortable="true" />
	<display:column title="Type" property="type" headerClass="blue-med"
		sortable="true" />
	<display:column title="Version" property="version"
		headerClass="blue-med" sortable="true" />
	<display:column title="Authenicated Data" headerClass="blue-med"
		property="authenticatedData" sortable="true" />
	<display:column title="Editor" headerClass="blue-med"
		property="remoteUser" sortable="true" />
	<display:column title="Last Edited" headerClass="blue-med"
		property="recordTime" sortable="true" />
</display:table>

</div>
<!-- stop main content -->

</div>
<!-- stop content -->

