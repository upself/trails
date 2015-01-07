<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<div id="fourth-level">
<h1>Software History</h1>
</div>
<display:table id="row" name="report" class="bravo" defaultsort="10"
	defaultorder="descending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:column title="Software Name" property="softwareName"
		headerClass="blue-med" />
	<display:column title="Manufacturer Name" property="manufacturer"
		headerClass="blue-med" />
	<display:column title="Software Category"
		property="softwareCategory" headerClass="blue-med" />
	<display:column title="Priority" property="priority"
		headerClass="blue-med" />
	<display:column title="Level" property="level" headerClass="blue-med" />
	<display:column title="Type" property="type" headerClass="blue-med" />
	<display:column title="Vendor Managed" property="vendorManaged" headerClass="blue-med" />
	<display:column title="Change Justification"
		property="changeJustification" headerClass="blue-med" />
	<display:column title="Comments" property="comments"
		headerClass="blue-med" />
	<display:column title="Editor" property="remoteUser"
		headerClass="blue-med" />
	<display:column title="Record Time" property="recordTime"
		headerClass="blue-med" />
	<display:column title="Status" property="status" headerClass="blue-med" />
</display:table>



