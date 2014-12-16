<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>

<h1>Software Signature Upload</h1>
<br>
<p>Utilize this loader to load software signatures. The template can
be downloaded by way of the templates link on the left navigation.</p>
<p class="hrule-dots"></p>
<br>

<logic:messagesPresent>
	<html:messages id="msg">
		<li class="red-dark"><bean:write name="msg" /></li>
	</html:messages>
</logic:messagesPresent>
<html:form action="/UploadSignatureSave" enctype="multipart/form-data">

	<table cellspacing="0" cellpadding="0" class="sign-in-table">

		<tr>
			<td class="t1"><label for="file">*File name:</label></td>
			<td>
			<div class="input-note">select a file</div>
			<html:file property="file" /></td>
		</tr>

	</table>

	<div class="clear">&nbsp;</div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><html:submit>Submit</html:submit></span>
	<span class="button-blue"><html:cancel>Cancel</html:cancel></span></div>
	</div>
</html:form>
<p>&nbsp;</p>
<div class="hrule-dots">&nbsp;</div>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
