<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
	
	<div class="indent">
		<h3>
			Software
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
		</h3>
	</div>
	<table class="bravo" id="small">
		<thead>
		<tr>
			<th class="blue-med" width="1%"></th>
			<th class="blue-med">Name</th>
			<th class="blue-med">Processors</th>
			<th class="blue-med">Effective Processors</th>
			<th class="blue-med">Scan Time</th>
			<th class="blue-med">Acquisition Time</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td><img src="<c:out value="${software.softwareLpar.statusIcon}"/>" width="12" height="10"/></td>
			<td><font class="orange-dark"><c:out value="${software.softwareLpar.name}"/></font></td>
			<td><font class="orange-dark"><c:out value="${software.softwareLpar.processorCount}"/></font></td>
			<td><font class="orange-dark">
			    <c:if test="${ (software.softwareLpar.softwareLparEff != null) && (software.softwareLpar.softwareLparEff.status == 'ACTIVE')}">
			        <c:out value="${software.softwareLpar.softwareLparEff.processorCount}"/>
			    </c:if>
			</td>
			<td><font class="orange-dark"><c:out value="${software.softwareLpar.scantimeDate}"/></font></td>
			<td><font class="orange-dark"><c:out value="${software.softwareLpar.acquisitionDate}"/></font></td>
		</tr>
		</tbody>
	</table>