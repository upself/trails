<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<div id="fourth-level">
<h1>Administrative Uploads</h1>
<!-- forth level navigation -->
<ul class="text-tabs">
	<li><html:link page="/Administration.do">Reports</html:link> |</li>
	<li><html:link page="/AdminFunction.do">Functions</html:link> |</li>
	<li><html:link page="/PriceList.do">Price List</html:link> |</li>
</ul>
</div>
<br>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>
<html:form action="/PriceListSave" enctype="multipart/form-data">

	<table cellspacing="0" cellpadding="0" class="sign-in-table">

		<tr>
			<td class="t1"><label for="file">*Price List File name:</label></td>
			<td>
			<div class="input-note">select a file</div>
			<html:file property="file" /></td>
		</tr>

	</table>

	<div class="clear"></div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
	<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
	</div>
</html:form>
<br>
<br>
<p class="hrule-dots">&nbsp;</p>
<html:form action="/MappingSave" enctype="multipart/form-data">

	<table cellspacing="0" cellpadding="0" class="sign-in-table">

		<tr>
			<td class="t1"><label for="file">*Mapping File name:</label></td>
			<td>
			<div class="input-note">select a file</div>
			<html:file property="file" /></td>
		</tr>

	</table>

	<div class="clear"></div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
	<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
	</div>
</html:form>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
