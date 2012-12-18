<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
	
	<div class="indent">
		<h3>
			Software Statistics
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
		</h3>
	</div>
	<table class="bravo" id="small">
		<thead>
		<tr>
			<th class="blue-med">Total Active Installed Software</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td><font class="orange-dark"><c:out value="${softwareStatistics.installedSoftwareCount}"/></font></td>
		</tr>
		</tbody>
	</table>
	