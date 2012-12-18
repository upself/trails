<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
	
	<table class="bravo" id="small">
		<thead>
		<tr>
			<th class="blue-med">ID</th>
			<th class="blue-med">Name</th>
			<th class="blue-med">Email</th>
			<th class="blue-med">Serial Number</th>
			<th class="blue-med">1st Line Serial</th>
			<th class="blue-med">2nd Line Serial</th>
			<th class="blue-med">3rd Line Serial</th>
			<th class="blue-med">Is Manager</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td><font class="orange-dark"><c:out value="${contact.contact.id}"/></font></td>			
			<td><font class="orange-dark"><c:out value="${contact.contact.name}"/></font></td>
			<td><font class="orange-dark"><c:out value="${contact.contact.email}"/></font></td>
			<td><font class="orange-dark"><c:out value="${contact.contact.serial}"/></font></td>
			<td><font class="orange-dark"><c:out value="${contact.contact.serialMgr1}"/></font></td>
			<td><font class="orange-dark"><c:out value="${contact.contact.serialMgr2}"/></font></td>
			<td><font class="orange-dark"><c:out value="${contact.contact.serialMgr3}"/></font></td>
			<td><font class="orange-dark"><c:out value="${contact.contact.isManager}"/></font></td>
		</tr>
		</tbody>
	</table>
	