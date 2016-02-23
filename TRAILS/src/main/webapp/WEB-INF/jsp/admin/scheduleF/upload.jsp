<script src="${pageContext.request.contextPath}/js/jquery.js" type="text/javascript"></script>
<p class="confidential">IBM Confidential</p>
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
<form id="uploadForm" action="${pageContext.request.contextPath}/ws/scheduleF/upload" method="POST" onSubmit="return doValidation()" enctype="multipart/form-data">
	<table>
		<tr>
			<td><label for="upload">*File:</label></td>
			<td><input id="uploadedFile" type="file" name="uploadedFile"/></td>
			<td style="padding-left:20px;">
				<input  name="ibm-submit" type="submit" value="Submit"  class="ibm-btn-pri" />
			</td>
		</tr>
	</table>
</form>

<script>
function doValidation(){
	var file =  $("#uploadedFile").val();
	if(file == ''){
		alert('Please select a file to upload');
		return false;
	}
	return true;
}
</script>