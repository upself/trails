<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/trails_style.css">

<div class="ibm-columns">
    <p class="ibm-confidential">IBM Confidential</p>
	<div class="ibm-col-1-1">
	    <div class="ibm-alternate-rule"><hr/></div>
		<p>
			Use <a href="/TRAILS/template/priorityISVUploadTemplate.xls">this form</a> to upload Priority ISV SW. After you have
			selected a file on your local machine, click on Submit to begin the upload. After the file loads, you will receive a
			download dialog box. This download will contain the data that you have uploaded. Rows that have cells highlighted in
			red did not load because of problems with the data. Please correct the data in red and reload.
		</p>
		<p>Required fields are marked with an asterisk(*) and must be filled out to complete the upload.</p>

		<form id="myForm" action="${pageContext.request.contextPath}/ws/priorityISV/isv/upload" class="ibm-column-form"
			enctype="multipart/form-data" method="post">

			<p>
				* Select a file : <input id="uploadedFile_id" type="file" name="uploadedFile" size="50" class="ibm-btn-small" />
		       <input name="ibm-submit" type="submit" value="Submit" onclick="$('#myForm').submit()" class="ibm-btn-pri" />
			</p>
   		</form>
		<div class="ibm-alternate-rule"><hr/></div>
	</div>
</div>