<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>

<div class="indent">
<h3>Software <img
	src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
	width="14" height="14" alt="contextual field help icon" /></h3>
</div>
<table class="bravo" id="small">
	<thead>
		<tr>
			<th class="blue-med" width="1%"></th>
			<th class="blue-med">Name</th>
			<th class="blue-med">Manufacturer</th>
			<th class="blue-med">License Level</th>
			<th class="blue-med">Discrepancy</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><c:choose>
				<c:when test="${software.status == 'ACTIVE'}">
					<img alt="ACTIVE" src="<c:out value="${software.statusIcon}"/>"
						width="12" height="10" />
				</c:when>
				<c:otherwise>
					<img alt="INACTIVE" src="<c:out value="${software.statusIcon}"/>"
						width="12" height="10" />
				</c:otherwise>
			</c:choose>
			<td><font class="orange-dark"> <html:link
				page="/software/update.do?id=${software.id}">
				<c:out value="${software.software.softwareName}" />
			</html:link><br />
			</font></td>
			<td><font class="orange-dark"><c:out
				value="${software.software.manufacturer.manufacturerName}" /></font></td>
			<td><font class="orange-dark"><c:out
				value="${software.licenseLevel}" /></font></td>
			<td><font class="orange-dark"><c:out
				value="${software.discrepancyType.name}" /></font></td>
			<%
				/*
			%>
			<td><img src="<c:out value="${account.customer.statusIcon}"/>"
				width="12" height="10" /></td>
			<%
				*/
			%>
		</tr>
	</tbody>
</table>
