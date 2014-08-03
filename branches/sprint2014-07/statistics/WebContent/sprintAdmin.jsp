<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.ibm.trac.domain.Sprint"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sprint Administration</title>
</head>
<body>
	<%
		List<Sprint> sprints = (List<Sprint>) request
				.getAttribute("sprints");
		SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");

		if (sprints != null && sprints.size() > 0) {
	%>
	<table border="1" cellpadding="1" cellspacing="1">
		<tr>
			<td>ID</td>
			<td>Name</td>
			<td>Start Time</td>
			<td>End Time</td>
			<td>Total Effort</td>
			<td>W x H</td>
			<td>Action</td>
		</tr>

		<%
			for (Sprint s : sprints) {
		%>
		<tr>
			<td><%=s.getId()%></td>
			<td><%=s.getName()%></td>
			<td><%=fmt.format(s.getStart())%></td>
			<td><%=fmt.format(s.getEnd())%></td>
			<td><%=s.getEffort()%></td>
			<td><%=s.getWidth()%>x<%=s.getHeight()%></td>
			<td><a href="sprintEdit?id=<%=s.getId()%>">Eidt</a> | <a
				href="sprintDelete?id=<%=s.getId()%>">Delete</a> | <a
				href="sprintLoadEffort?id=<%=s.getId()%>">Load Effort</a> | <a
				href="effortProgress?sprintId=<%=s.getId()%>">Effort Progress</a> |
				<a href="displayProgressChart.jsp?id=<%=s.getId()%>">Show
					Progress</a></td>
		</tr>
		<%
			}
		%>
	</table>
	<%
		}
	%>
	<p>Add Sprint</p>
	<form action="sprintAdd" method="post">
		<table>
			<tr>
				<td colspan="2">Sprint name: <input type="text" name="name" />
				</td>

			</tr>
			<tr>
				<td>Start time:<input type="text" name="start" />
				</td>
				<td>End time:<input type="text" name="end" /></td>
			</tr>
			<tr>
				<td>Width:<input type="text" name="width" />
				</td>
				<td>Height:<input type="text" name="height" /></td>
			</tr>
		</table>

		<input type="submit" value="Add" />
	</form>
</body>
</html>