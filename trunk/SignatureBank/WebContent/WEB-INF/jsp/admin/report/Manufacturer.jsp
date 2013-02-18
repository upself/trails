<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1><bean:write name="month" />, <bean:write name="year" />
Manufacturer history</h1>
<br>

<display:table id="row" name="report" class="bravo" defaultsort="1"
	defaultorder="ascending" requestURI="">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:column title="Ref ID" property="manufacturer.manufacturerId"
		headerClass="blue-med" group="1" />
	<display:column title="Manufacturer Name" property="manufacturerName"
		headerClass="blue-med" />
	<display:column title="Justification" property="changeJustification"
		headerClass="blue-med" />
	<display:column title="Comments" property="comments"
		headerClass="blue-med" />
	<display:column title="Editor" property="remoteUser"
		headerClass="blue-med" />
	<display:column title="Edit Time" property="recordTime"
		headerClass="blue-med" />
	<display:column title="Status" property="status" headerClass="blue-med" />
</display:table>

</div>
<!-- stop main content -->

</div>
<!-- stop content -->

