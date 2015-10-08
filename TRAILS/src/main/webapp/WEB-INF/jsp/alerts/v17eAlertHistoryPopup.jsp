<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<div class="ibm-columns">
	<div class="ibm-col-5-4">
		<table cellspacing="0" cellpadding="0" border="0" class="ibm-data-table ibm-sortable-table" summary="Alert History">
			<thead>
				<tr>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Comments</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Remote User</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Creation Time</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Record Time</span><span class="ibm-icon"></span></a></th>
					<th scope="col" class="ibm-sort"><a href="#sort"><span>Open</span><span class="ibm-icon"></span></a></th>
				</tr>
			</thead>
			<tbody>
				<s:iterator value="historyList" id="history">
					<tr>
						<td><s:property value="#history.comments"/></td>
						<td><s:property value="#history.remoteUser"/></td>
						<td><s:property value="#history.creationTime"/></td>
						<td><s:property value="#history.recordTime"/></td>
						<td><s:property value="#history.open"/></td>
					</tr>
				</s:iterator>
			</tbody>
		</table>
	</div>
</div>

