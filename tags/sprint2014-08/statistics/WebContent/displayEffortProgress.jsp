<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.ibm.trac.domain.EffortProgress"%>
<%@page import="java.util.List"%>
<%@page import="com.ibm.trac.domain.Sprint"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sprint Progress</title>
</head>
<%
	Sprint sprint = (Sprint) request.getAttribute("sprint");
	SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	List<EffortProgress> progressList = (List<EffortProgress>) request
			.getAttribute("progress");
%>
<body>
	<h2><%=sprint.getName()%>
		Effort Records
	</h2>

	<%
		if (progressList.size() <= 0) {
	%>
	<p>None effort records found.</p>
	<%
		} else {
	%><table border="1" cellpadding="1" cellspacing="1">
		<tr>
			<td>Time</td>
			<td>Left Effort</td>
			<td>Action</td>
		</tr>
		<%
			for (EffortProgress ep : progressList) {
		%>
		<tr>
			<td><%=f.format(ep.getTime())%></td>
			<td><%=ep.getEffort()%></td>
			<td><a
				href="deleteProgress?id=<%=ep.getId()%>&sprintId=<%=sprint.getId()%>">Delete</a></td>
		</tr>
		<%
			}
		%>
	</table>
	<%
		}
	%>

	<a href="addProgress?sprintId=<%=sprint.getId()%>">Add Current
		Effort</a> |
	<a href="sprintAdmin">Back</a>
</body>
</html>