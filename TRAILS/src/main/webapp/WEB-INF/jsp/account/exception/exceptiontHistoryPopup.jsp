<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<div id="fourth-level">
<h1>Data Exception History</h1>
<p class="confidential">IBM Confidential</p>
</div>
<h2>&nbsp;</h2>
<p class="lead-in">Data Exception History</p>
<h3>&nbsp;</h3>
<display:table name="data.list" class="basic-table" id="row"
    summary="Exception History"
	decorator="org.displaytag.decorator.TotalTableDecorator"
	cellspacing="1" cellpadding="0" excludedParams="*">
	<display:column property="comment" title="Comment"/>
	<display:column property="assignee" title="Assignee"/>
	<display:column property="creationTime" class="date"
		format="{0,date,MM-dd-yyyy}" title="Creation Time"/>
	<display:column property="recordTime" class="date"
		format="{0,date,MM-dd-yyyy}" title="Record Time"/>
</display:table>
<p class="note">&nbsp;</p>