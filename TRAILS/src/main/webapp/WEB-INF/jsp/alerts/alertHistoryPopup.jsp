<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<div id="fourth-level">
<h1>Alert History</h1>
<p class="ibm-confidential">IBM Confidential</p>
</div>

<div class="ibm-columns" style="width: 95%">
	<div class="ibm-col-1-1">
		<h2>&nbsp;</h2>
		<p class="lead-in">Alert History</p>
		<h3>&nbsp;</h3>
		<display:table name="data.list" class="ibm-data-table ibm-sortable-table ibm-alternating tablesorter tablesorter-default" id="row" summary="Alert History" 
			decorator="org.displaytag.decorator.TotalTableDecorator" cellspacing="1" cellpadding="0" excludedParams="*">
			<display:column property="comments" />
			<display:column property="type" />
			<display:column property="remoteUser" />
			<display:column property="creationTime" class="date"
				format="{0,date,MM-dd-yyyy}" />
			<display:column property="recordTime" class="date"
				format="{0,date,MM-dd-yyyy}" />
			<display:column property="open" />
		</display:table>
	</div>
</div>
<p class="note">&nbsp;</p>

