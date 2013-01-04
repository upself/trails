<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<span style="font-weight:bold">Legend</span><hr />
<table border="0" cellpadding="2" cellspacing="0">
	<tr class="yes">
		<td class="catalogMatch" width="20"></td>
		<td>Catalog match</td>
	</tr>
	<tr class="no">
		<td class="catalogMatch"></td>
		<td>No catalog match</td>
	</tr>
</table>
<br />
<br />
<span style="font-weight:bold">Capacity types</span>
<table border="0" cellpadding="2" cellspacing="0">
	<s:iterator value="capacityTypeList">
	<tr>
		<td align="right" style="font-weight:bold"><s:property value="code" /></td>
		<td><s:property value="description" /></td>
	</tr>
	</s:iterator>
</table>
