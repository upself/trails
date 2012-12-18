<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>

<div class="indent">
<h3>Account <html:link page="/help/help.do#H3">
	<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h3>
</div>
<table class="bravo" id="small">
	<thead>
		<tr>
			<th class="blue-med" width="1%"></th>
			<th class="blue-med">ID</th>
			<th class="blue-med">Name</th>
			<th class="blue-med">Type</th>
			<th class="blue-med">Dept</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><c:choose>
				<c:when test="${account.customer.status == 'ACTIVE'}">
					<img alt="ACTIVE"
						src="<c:out value="${account.customer.statusIcon}"/>" width="12"
						height="10" />
				</c:when>
				<c:otherwise>
					<img alt="INACTIVE"
						src="<c:out value="${account.customer.statusIcon}"/>" width="12"
						height="10" />
				</c:otherwise>
			</c:choose></td>
			<td><font class="orange-dark"><c:out
				value="${account.customer.accountNumber}" /></font></td>
			<td><font class="orange-dark"><c:out
				value="${account.customer.customerName}" /></font></td>
			<td><font class="orange-dark"><c:out
				value="${account.customer.customerType.customerTypeName}" /></font></td>
			<td><font class="orange-dark"><c:out
				value="${account.customer.pod.podName}" /></font></td>
		</tr>
	</tbody>
</table>
