<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<h1>Upload Cause Codes</h1>
<p class="confidential">IBM Confidential</p>
<br />
<p>Description to be done...</p>

<br />
<div class="hrule-dots"></div>
<br />

<s:actionerror />
<s:fielderror />
<s:form id="uploadForm" action="upload" namespace="/account/causecodes"
	enctype="multipart/form-data" theme="simple">
	<table>
		<tr>
			<td><label for="upload">*File:</label></td>
			<td><s:file id="upload" name="upload" label="File" /></td>
		</tr>
	</table>
	<div class="clear"></div>
	<div class="button-bar">
	<div class="buttons"><span class="button-blue"><s:submit alt="Submit"/></span></div>
	</div>
</s:form>