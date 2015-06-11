<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!-- Search form -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<form id="myForm" onsubmit="submitForm(); return false;" action="/" class="ibm-column-form" enctype="multipart/form-data" method="post">	
			<div class="ibm-columns">
				<div class="ibm-col-6-3">
					<p>
						<input value="Search" name="ibm-submit" class="ibm-btn-pri" type="submit">
					</p>
				</div>
			</div>
		</form>
		<!-- FORM_END -->
	</div>
</div>

<script>
function submitForm(){
	$.ajax({
        cache: true,
        type: "POST",
        url: '${pageContext.request.contextPath}/ws/noninstance/upload',
        data: $('#myForm').serialize(),
        dataType:'json',
        async: false,
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert(textStatus);
        },
        success: function(data) {
            alert(data.msg);
        }
    });
}

</script>






