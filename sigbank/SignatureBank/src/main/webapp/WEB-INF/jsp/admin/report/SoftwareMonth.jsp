<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1><bean:write name="year"/> available software history months</h1>
<br>

<display:table id="row" name="report" class="bravo" defaultsort="2"
	defaultorder="ascending" requestURI="">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:column title="Year" headerClass="blue-med"><a href="/SignatureBank/SoftwareHistoryReport.do?year=<bean:write name="year"/>&month=${row.unit}">${row.unit}</a></display:column>
</display:table>

</div>
<!-- stop main content -->

</div>
<!-- stop content -->

