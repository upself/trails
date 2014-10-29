<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
	
	<table class="bravo" id="small">
		<thead>
		<tr>
			<th class="blue-med" width="1%"></th>
			<th class="blue-med">ID</th>
			<th class="blue-med">Name</th>
			<th class="blue-med">Type</th>
			<th class="blue-med">Definition</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td><img src="<c:out value="${machineType.statusIcon}"/>" width="12" height="10"/></td>
			<td><font class="orange-dark"><c:out value="${machineType.id}"/></font></td>			
			<td><font class="orange-dark"><c:out value="${machineType.name}"/></font></td>
			<td><font class="orange-dark"><c:out value="${machineType.type}"/></font></td>
			<td><font class="orange-dark"><c:out value="${machineType.definition}"/></font></td>
		</tr>
		</tbody>
	</table>
	