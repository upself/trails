<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- Search form -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<form id="myForm" action="${pageContext.request.contextPath}/ws/noninstance/upload"  class="ibm-column-form" enctype="multipart/form-data" method="post">	
			<div class="ibm-columns">
				<div class="ibm-col-6-3">
<p>Use <a href="/TRAILS/template/scheduleFUploadTemplate.xls">this
form</a> to upload Non Instance Based Software . After you have selected
a file on your local machine, click on Upload to begin the upload. After
the file loads, you will receive a download dialog box. This download
will contain the data that you have uploaded. Rows that have cells
highlighted in red did not load because of problems with the data.
Please correct the data in red and reload.</p>
<p>Required fields are marked with an asterisk(*) and must be filled
out to complete the upload.</p>
<br />
<div class="hrule-dots"></div>
<br />
					<p>
				<label for="softwareName_id">
					Select File <span class="ibm-required">*</span>
					<span class="ibm-item-note">(xls)</span>
				</label> 
			
					<input name="softwareName" id="softwareName_id" size="40" value="" type="file">
		
			</p>
					<p>
						<input value="Upload" name="ibm-submit" class="ibm-btn-pri" type="submit">
					</p>
				</div>
			</div>
		</form>
		<!-- FORM_END -->
	</div>
</div>






