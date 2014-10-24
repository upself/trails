<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h1><bean:write name="month" />, <bean:write name="year" />
Software Filter history</h1>
<br>


<table cellspacing="0" cellpadding="0" class="search-results">

	<tr class="summary-options">

		<th class="results-count">Results found <bean:write
			name="pagination" property="resultNumber" /></th>
	</tr>
	<tr class="summary-options">
		<logic:notEmpty name="report">
			<th nowrap class="results-sequence"><logic:equal
				name="pagination" property="previous" value="true">
				<a
					href="/SignatureBank/SoftwareFilterHistoryReport.do?year=<bean:write name="year"/>&month=<bean:write name="month"/>&pageNumber=<bean:write name="pagination" property="previousPageNumber"/>">
				<b>Previous</b> </a> | 
<a
					href="/SignatureBank/SoftwareFilterHistoryReport.do?year=<bean:write name="year"/>&month=<bean:write name="month"/>&pageNumber=1">
				1</a>...
</logic:equal> <logic:iterate id="pages" name="pagination" property="paginationItems">


				<logic:equal name="pages" property="active" value="true">
					<b><bean:write name="pages" property="pageNumber" /> </b>
				</logic:equal>
				<logic:notEqual name="pages" property="active" value="true">
					<a
						href="/SignatureBank/SoftwareFilterHistoryReport.do?year=<bean:write name="year"/>&month=<bean:write name="month"/>&pageNumber=<bean:write name="pages" property="pageNumber"/>">
					<bean:write name="pages" property="pageNumber" />&nbsp;</a>
				</logic:notEqual>
				<logic:equal name="pages" property="next" value="true">
				...
				<a
						href="/SignatureBank/SoftwareFilterHistoryReport.do?year=<bean:write name="year"/>&month=<bean:write name="month"/>&pageNumber=<bean:write name="pagination" property="totalPages"/>">

					<bean:write name="pagination" property="totalPages" /> </a> | 
<a
						href="/SignatureBank/SoftwareFilterHistoryReport.do?year=<bean:write name="year"/>&month=<bean:write name="month"/>&pageNumber=<bean:write name="pagination" property="nextPageNumber"/>">

					<b>Next</b> </a>
				</logic:equal>
			</logic:iterate></th>
		</logic:notEmpty>
	</tr>
</table>

<display:table id="row" name="report" class="bravo" defaultsort="1"
	defaultorder="ascending" requestURI="">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:caption>Software Filters</display:caption>
	<display:column title="Ref ID"
		property="softwareFilter.softwareFilterId" headerClass="blue-med"
		group="1" />
	<display:column title="Filter Name" property="softwareName"
		headerClass="blue-med" />
	<display:column title="Filter Version" property="softwareVersion"
		headerClass="blue-med" />
	<display:column title="Product" property="product.name"
		headerClass="blue-med" />
	<display:column title="Map Version" property="mapSoftwareVersion"
		headerClass="blue-med" />
	<display:column title="End of Support" property="endOfSupport"
		headerClass="blue-med" />
	<display:column title="Operating System" property="osType"
		headerClass="blue-med" />
	<display:column title="Justification" property="changeJustification"
		headerClass="blue-med" />
	<display:column title="Comments" property="comments"
		headerClass="blue-med" />
	<display:column title="Editor" property="remoteUser"
		headerClass="blue-med" />
	<display:column title="Edit Time" property="recordTime"
		headerClass="blue-med" format="{0,date,MM-dd-yyyy}"/>
	<display:column title="Status" property="status" headerClass="blue-med" />
</display:table>

</div>
<!-- stop main content -->

</div>
<!-- stop content -->
