<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Available software filter history years</h1>
<br>

<display:table id="row" name="report" class="bravo" defaultsort="2"
	defaultorder="ascending" requestURI="">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:column title="Year" property="unit" headerClass="blue-med"
		sortable="true" href="SoftwareFilterHistoryReport.do" paramId="year"
		paramProperty="unit" />
</display:table>

</div>
<!-- stop main content -->

</div>
<!-- stop content -->

