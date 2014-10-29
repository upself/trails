<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<h1>Software mappings for <bean:write name="microsoftProduct"
	property="productDescription" /></h1>
<br>
<p>Utilize the Add/Remove links to map and unmap Microsoft products to
software products.</p>
<div id="fourth-level"><!-- forth level navigation -->
<ul class="text-tabs">
	<li><html:link page="/Administration.do">Reports</html:link> |</li>
	<li><html:link page="/AdminFunction.do">Functions</html:link> |</li>
	<li><html:link page="/PriceList.do">Price List</html:link>
	|</li>
</ul>
</div>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>

<%boolean alternate = true;
		%>

<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
	width="100%" style="margin-top:2em;">

	<tr class="tablefont">
		<th colspan="11" style="white-space:nowrap; background-color:#bd6;">Current
		Mappings</th>
	</tr>
	<tr style="background-color:#dfb;" class="tablefont">
		<th nowrap="nowrap">Software Name</th>
		<th nowrap="nowrap">Manufacturer</th>
		<th nowrap="nowrap">Category</th>
		<th nowrap="nowrap">Priority</th>
		<th nowrap="nowrap">Level</th>
		<th nowrap="nowrap">Type</th>
		<th nowrap="nowrap">Editor</th>
		<th nowrap="nowrap">Last edited</th>
		<th nowrap="nowrap">Status</th>
		<th nowrap="nowrap">Comments</th>
		<th nowrap="nowrap">Action</th>
	</tr>

	<logic:iterate id="product" name="productList">

		<%alternate = alternate ? false : true;

		if (alternate) {
			out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
		} else {
			out.println("<tr style=\"font-size:8pt\">");
		}
		%>
		<td><bean:write name="product" property="software.softwareName" /></td>
		<td><bean:write name="product"
			property="software.manufacturer.manufacturerName" /></td>
		<td><bean:write name="product"
			property="software.productInfo.softwareCategory.softwareCategoryName" /></td>
		<td><bean:write name="product" property="software.priority" /></td>
		<td><bean:write name="product" property="software.level" /></td>
		<td><bean:write name="product" property="software.licenseType" /></td>
		<td><bean:write name="product" property="software.productInfo.remoteUser" /></td>
		<td><bean:write name="product" property="software.productInfo.recordTime" /></td>
		<td><bean:write name="product" property="software.status" /></td>
		<td><bean:write name="product" property="software.comments" /></td>
		<bean:define id="microsoftProductMapId" name="product"
			property="microsoftProductMapId" />
		<bean:define id="microsoftProductId" name="microsoftProduct"
			property="microsoftProductId" />
		<%java.util.HashMap params = new java.util.HashMap();
		params.put("microsoftProductMapId", microsoftProductMapId);
		params.put("microsoftProductId", microsoftProductId);
		pageContext.setAttribute("paramsName", params);
%>
		<td><html:link action="/RemoveProductMap.do" name="paramsName">
			Remove
		</html:link></td>
		</tr>
	</logic:iterate>
</table>

<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
	width="100%" style="margin-top:2em;">

	<tr class="tablefont">
		<th colspan="11" style="white-space:nowrap; background-color:#bd6;">Unmapped
		Microsoft Software</th>
	</tr>
	<tr style="background-color:#dfb;" class="tablefont">
		<th nowrap="nowrap">Software Name</th>
		<th nowrap="nowrap">Manufacturer</th>
		<th nowrap="nowrap">Category</th>
		<th nowrap="nowrap">Priority</th>
		<th nowrap="nowrap">Level</th>
		<th nowrap="nowrap">Type</th>
		<th nowrap="nowrap">Editor</th>
		<th nowrap="nowrap">Last edited</th>
		<th nowrap="nowrap">Status</th>
		<th nowrap="nowrap">Comments</th>
		<th nowrap="nowrap">Action</th>
	</tr>

	<logic:iterate id="software" name="softwareList">

		<%alternate = alternate ? false : true;

		if (alternate) {
			out.println("<tr class=\"gray\" style=\"font-size:8pt\">");
		} else {
			out.println("<tr style=\"font-size:8pt\">");
		}

		%>
		<td><bean:write name="software" property="softwareName" /></td>
		<td><bean:write name="software"
			property="manufacturer.manufacturerName" /></td>
		<td><bean:write name="software"
			property="softwareCategory.softwareCategoryName" /></td>
		<td><bean:write name="software" property="priority" /></td>
		<td><bean:write name="software" property="level" /></td>
		<td><bean:write name="software" property="type" /></td>
		<td><bean:write name="software" property="remoteUser" /></td>
		<td><bean:write name="software" property="recordTime" /></td>
		<td><bean:write name="software" property="status" /></td>
		<td><bean:write name="software" property="comments" /></td>
		<bean:define id="softwareId" name="software" property="softwareId" />
		<bean:define id="microsoftProductId" name="microsoftProduct"
			property="microsoftProductId" />
		<%java.util.HashMap params = new java.util.HashMap();
		params.put("softwareId", softwareId);
		params.put("microsoftProductId", microsoftProductId);
		pageContext.setAttribute("paramsName", params);
%>
		<td><html:link action="/AddProductMap.do" name="paramsName">
			Add
		</html:link></td>
		</tr>
	</logic:iterate>
</table>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->
