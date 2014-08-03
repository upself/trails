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
	<p>Update Sprint</p>
	<%
		Sprint sprint = (Sprint) request.getAttribute("sprint");
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
	%>
	<form action="sprintUpdate" method="post">
		<input type="hidden" name="id" value="<%=sprint.getId()%>">
		<table>
			<tr>
				<td colspan="2">Sprint name: <input type="text" name="name"
					value="<%=sprint.getName()%>" />
				</td>

			</tr>
			<tr>
				<td>Start time:<input type="text" name="start"
					value="<%=f.format(sprint.getStart())%>" />
				</td>
				<td>End time:<input type="text" name="end"
					value="<%=f.format(sprint.getEnd())%>" /></td>
			</tr>
			<tr>
				<td>Height:<input type="text" name="height"
					value="<%=sprint.getHeight()%>" />
				</td>
				<td>Width:<input type="text" name="width"
					value="<%=sprint.getWidth()%>" /></td>
			</tr>
		</table>

		<input type="submit" value="Update" />
	</form>
</body>
</html>