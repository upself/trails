<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp" %>

<tmp:useAttribute id="report" name="report"/>

<% boolean alternate = true; %>

<table class="basic-table" border="0" cellspacing="1" cellpadding="0" width="100%" style="margin-top:2em;">

		<tr class="tablefont"> 
		<th colspan="<bean:write name="report" property="size"/>" style="white-space:nowrap; background-color:#bd6;">
			<bean:write name="report" property="title"/>
		</th> 
		</tr> 

<tr style="background-color:#dfb;" class="tablefont">
<logic:iterate id="header" name="report" property="header">
    <th nowrap="nowrap">
    	<bean:write name="header" property="value"/>
    </th> 
</logic:iterate>
</tr>


<logic:iterate id="reportRow" name="report" property="reportRows">
	<%
		alternate = alternate ? false : true;
		
		if (alternate) {
			out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
		} else {
			out.println("<tr style=\"font-size:8pt\">");
		}
	%>
	
			<logic:iterate id="reportElement" name="reportRow" property="reportElements">
				<td>	
					<bean:write name="reportElement" property="value"/>						
				</td>
			</logic:iterate>
	</tr>
</logic:iterate>



</table>