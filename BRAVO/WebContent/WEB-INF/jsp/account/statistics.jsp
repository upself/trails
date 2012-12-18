<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>

<div class="indent">
<h3>Account Statistics <html:link page="/help/help.do#H4">
	<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h3>
</div>
<table class="bravo" id="small">
	<thead>
		<tr>
			<th class="blue-med">HW Lpars</th>
			<th class="blue-med">HW w/scan</th>
			<th class="blue-med">HW w/o scan</th>
			<th class="blue-med">HW % w/scan</th>
			<th class="blue-med">SW Discrepancies</th>
			<th class="blue-med">SW</th>
			<th class="blue-med">SW Lpars w/o HW</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><font class="orange-dark"><c:out
				value="${accountStatistics.hardwareLpars}" /></font></td>
			<td><font class="orange-dark"><c:out
				value="${accountStatistics.hardwareLparsWithScan}" /></font></td>
			<td><font class="orange-dark"><c:out
				value="${accountStatistics.hardwareLparsWithoutScan}" /></font></td>
			<td><font class="orange-dark"><c:out
				value="${accountStatistics.hardwareLparWithScanPercentage}" /></font></td>
			<td><font class="orange-dark"><c:out
				value="${accountStatistics.softwareDiscrepancies}" /></font></td>
			<td><font class="orange-dark"><c:out
				value="${accountStatistics.softwares}" /></font></td>
			<td><font class="orange-dark"><c:out
				value="${accountStatistics.softwareLparsWithoutHardwareLpar}" /></font></td>
		</tr>
	</tbody>
</table>
