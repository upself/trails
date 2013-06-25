<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="indent">
<h3>Software LPAR <html:link page="/help/help.do#H8">
	<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h3>
</div>
<table class="bravo" id="small">
	<thead>
		<tr>
			<th class="blue-med" width="1%"></th>
			<th class="blue-med">Name</th>
			<th class="blue-med">Proc</th>
			<th class="blue-med">BIOS Serial</th>
			<th class="blue-med">Scan Time</th>
			<th class="blue-med">Acquisition Time</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<c:choose>
				<c:when test="${lpar.softwareLpar == null}">
					<td colspan="4" align="center"><font class="orange-dark">
					<html:link
						page="/software/selectInit.do?accountId=${account.customer.accountNumber}&lparName=${lpar.name}&lparId=${lpar.softwareLpar.id}">
							No Software Records
						</html:link> </font></td>
				</c:when>
				<c:otherwise>
					<td><c:choose>
						<c:when test="${lpar.softwareLpar.status == 'ACTIVE'}">
							<img alt="ACTIVE"
								src="<c:out value="${lpar.softwareLpar.statusIcon}"/>"
								width="12" height="10" />
						</c:when>
						<c:otherwise>
							<img alt="INACTIVE"
								src="<c:out value="${lpar.softwareLpar.statusIcon}"/>"
								width="12" height="10" />
						</c:otherwise>
					</c:choose></td>
					<td><font class="orange-dark"> <html:link
						page="/software/home.do?lparId=${lpar.softwareLpar.id}">
						<c:out value="${lpar.softwareLpar.name}" />
					</html:link> </font></td>
					<td><font class="orange-dark"><c:out
						value="${lpar.softwareLpar.processorCount}" /></font></td>
					<td><font class="orange-dark"><c:out
						value="${lpar.softwareLpar.biosSerial}" /></font></td>
					<td><font class="orange-dark"><c:out
						value="${lpar.softwareLpar.scantimeDate}" /></font></td>
					<td><font class="orange-dark"><c:out
						value="${lpar.softwareLpar.acquisitionDate}" /></font></td>
				</c:otherwise>
			</c:choose>
		</tr>
	</tbody>
</table>
