<%@ taglib prefix="s" uri="/struts-tags"%>

<div style="font-size:22px; display:inline">Upload&nbsp;</div><h1 class="oneline">Schedule F</h1>
<p class="confidential">IBM Confidential</p>

<br />
<p>Use <a href="/TRAILS/template/scheduleFUploadTemplate.xls">this
form</a> to upload Schedule F contract information. After you have selected
a file on your local machine, click on Submit to begin the upload. After
the file loads, you will receive a download dialog box. This download
will contain the data that you have uploaded. Rows that have cells
highlighted in red did not load because of problems with the data.
Please correct the data in red and reload.</p>
<p>Required fields are marked with an asterisk(*) and must be filled
out to complete the upload.</p>
<br />
<div class="hrule-dots"></div>
<br />

<s:actionerror />
<s:fielderror />
<s:form id="uploadForm" action="upload" namespace="/admin/scheduleF"
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
