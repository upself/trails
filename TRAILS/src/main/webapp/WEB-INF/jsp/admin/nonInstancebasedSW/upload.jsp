<%@ taglib prefix="s" uri="/struts-tags"%>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery.liveSearch.css" />
<script src="${pageContext.request.contextPath}/js/jquery.js"
	type="text/javascript"></script>
<div style="font-size: 22px; display: inline">Upload&nbsp;</div>
<p class="confidential">IBM Confidential</p>
<br />
<p>
	Use <a href="/TRAILS/template/nonInstanceUploadTemplate.xls">this
		form</a> to upload Non Instance Base Software Component. After you have
	selected a file on your local machine, click on Submit to begin the
	upload. After the file loads, you will receive a download dialog box.
	This download will contain the data that you have uploaded. Rows that
	have cells highlighted in red did not load because of problems with the
	data. Please correct the data in red and reload.
</p>
<p>Required fields are marked with an asterisk(*) and must be filled
	out to complete the upload.</p>
<br />
<div class="hrule-dots"></div>
<br />
<form id="myForm"
	action="${pageContext.request.contextPath}/ws/noninstance/upload"
	class="ibm-column-form" enctype="multipart/form-data" method="post">

	<p>
		* Select a file : <input id="uploadedFile_id" type="file"
			name="uploadedFile" size="50" class="ibm-btn-small"/>
	</p>

	<input  name="ibm-submit" type="submit" value="Upload It"  class="ibm-btn-pri" />
</form>
