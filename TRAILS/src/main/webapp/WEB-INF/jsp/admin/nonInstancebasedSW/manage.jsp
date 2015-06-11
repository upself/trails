<%@ taglib prefix="s" uri="/struts-tags"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery.liveSearch.css" />
<script src="${pageContext.request.contextPath}/js/jquery.js" type="text/javascript"></script>

<script type="text/javascript">
var lastValue = '';
$(document.body).click(
	function(event) {
		var liveSearch = $("#jquery-live-search");
		if (liveSearch.length) {
			var clicked = $(event.target);
			if (!(clicked.is("#jquery-live-search") || clicked.parents("#jquery-live-search").length || clicked.is(this))) {
				liveSearch.slideUp();
			}
		}
	}
);

function keyup(type) {
	var value = $.trim(type.value);
	
	if (value == $.trim('') || value == '' || value == lastValue) {
		return;
	}
	
	lastValue = value;

	var liveSearch = $("#jquery-live-search");

	if (!liveSearch.length) {
		liveSearch = $("<div id='jquery-live-search'></div>").appendTo(document.body).hide().slideUp(0);
	}
	
	var inputPos = $(type).position();
	var inputHeight = $(type).outerHeight();

	liveSearch.css({
		"position" : "absolute",
		"top" : inputPos.top + inputHeight + "px",
		"left" : inputPos.left + "px"
	});

	if (this.timer) {
		clearTimeout(this.timer);
	}
	
	this.timer = setTimeout(
			function() {
				$.ajax({
					url : "${pageContext.request.contextPath}/admin/liveSearch.htm",
					async : true,
					type : "POST",
					data : {
							key : value,
							label : type.name
					},
					beforeSend : function() {
						liveSearch.empty();
						liveSearch.append("searching...").fadeIn(400);
					},
					error : function() {
						liveSearch.empty();
						liveSearch.append("error").fadeIn(400);
					},
					success : function(data, status) {
						liveSearch.empty();
						if (!data.length) {
							liveSearch.append("no matched item found.")
						} else {
							liveSearch.append(data);
						}
						liveSearch.show("slow");
						var over = {
								"color" : "white",
								"background" : "blue"
								};

						var out = {
								"color" : "black",
								"background" : "white"
								};

						$("li.prompt").hover(
							function() {
								$(this).css(over);
							}, 
							function() {
								$(this).css(out);
							}
						);

						$("li.prompt").click(
							function() {
								if(type.name == 'softwareName') {
									type.value = $(this).text().slice(11,-10);	
								} else {
									type.value = $(this).text();	
								}
							}
						);
					}
				})
			}, 1000);
}
</script>
<!-- manage Non Instance based SW -->
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<form id="myForm" onsubmit="submitForm(); return false;" action="/" class="ibm-column-form" enctype="multipart/form-data" method="post">
			<s:if test="#request.nonInstanceDisplay != null">
				<input name="id" value="<s:property value='#request.nonInstanceDisplay.id'/>" type="hidden" />
			</s:if>
			<p>
				<label for="softwareName_id"> Software title:
					<span class="ibm-required">*</span> 
					<span class="ibm-item-note">(e.g., KANA IQ)</span>
				</label> 
				<span>
					<input name="softwareName" id="softwareName_id" value="<s:property value='#request.nonInstanceDisplay.softwareName'/>" size="40" type="text" onKeyUp="keyup(this)">
				</span>
			</p>
			<p>
				<label for="manufacturerName_id"> Manufacturer:
					<span class="ibm-required">*</span> 
					<span class="ibm-item-note">(e.g., KANA)</span>
				</label> 
				<span> 
					<input name="manufacturerName" id="manufacturerName_id" value="<s:property value='#request.nonInstanceDisplay.manufacturerName'/>" size="40" value="" type="text">
				</span>
			</p>
			<p>
				<label for="restriction_id"> Restriction:<span class="ibm-required">*</span>
				</label> <span> 
				<select name="restriction" id="restriction_id">
					<option value="">Please select one</option>
					<option value="account" <s:if test="#request.nonInstanceDisplay.restriction eq 'account'">selected="selected"</s:if> >account</option>
					<option value="machine" <s:if test="#request.nonInstanceDisplay.restriction eq 'machine'">selected="selected"</s:if>>machine</option>
					<option value="LPAR" <s:if test="#request.nonInstanceDisplay.restriction eq 'LPAR'">selected="selected"</s:if>>LPAR</option>
				</select>
				</span>
			</p>
			<p>
				<label for="baseOnly_id"> Non Instance based only :<span class="ibm-required">*</span>
				</label> <span> <select class="iform" name="baseOnly" id="baseOnly_id">
						<option value="">Please select one</option>
						<option value="1" <s:if test="#request.nonInstanceDisplay.baseOnly eq 1">selected="selected"</s:if> >Y</option>
						<option value="0" <s:if test="#request.nonInstanceDisplay.baseOnly eq 0">selected="selected"</s:if> >N</option>
				</select>
				</span>

			</p>
			<p>
				<label for="capacityDesc_id"> Capacity type:<span class="ibm-required">*</span> <span class="ibm-item-note">(e.g.,
						USERS)</span>
				</label> <span> <input name="capacityDesc" id="capacityDesc_id" value="<s:property value='#request.nonInstanceDisplay.capacityDesc'/>" size="40" type="text">
				</span>
			</p>
			<p>
				<label for="statusId_id"> Status:<span class="ibm-required">*</span>
				</label> <span> <select class="iform" name="statusId" id="statusId_id">
						<option value="">Please select one</option>
						<option value="2" <s:if test="#request.nonInstanceDisplay.statusId eq 2">selected="selected"</s:if> >ACTIVE</option>
						<option value="1" <s:if test="#request.nonInstanceDisplay.statusId eq 1">selected="selected"</s:if> >INACTIVE</option>
				</select>
				</span>
			</p>

			<div class="ibm-rule">
				<hr />
			</div>
			<div class="ibm-columns">
				<div class="ibm-col-6-3">
					<p>
						<input value="Save" name="ibm-submit" class="ibm-btn-pri" type="submit">
					</p>
				</div>
			</div>
		</form>
		<!-- FORM_END -->
	</div>
</div>
<script>
function submitForm(){
	if(validateForm()){
		$.ajax({
	        cache: true,
	        type: "POST",
	        url: '${pageContext.request.contextPath}/ws/noninstance/saveOrUpdate',
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
}

function validateForm(){
	var softwareName = $("#softwareName_id").val();
	var manufacturerName = $("#manufacturerName_id").val();
	var restriction = $("#restriction_id").val();
	var baseOnly = $("#baseOnly_id").val();
	var capacityDesc = $("#capacityDesc_id").val();
	var statusId = $("#statusId_id").val();

	if(softwareName.trim() == ''){
		alert('Software title is required');
		return false;
	}
	
	if(manufacturerName.trim() == ''){
		alert('Manufacturer is required');
		return false;
	}
	
	if(restriction.trim() == ''){
		alert('Restriction is required');
		return false;
	}
	
	if(baseOnly.trim() == ''){
		alert('Non Instance based only is required');
		return false;
	}
	
	if(capacityDesc.trim() == ''){
		alert('Capacity type is required');
		return false;
	}
	
	if(statusId.trim() == ''){
		alert('Status is required');
		return false;
	}
	
	return true;
}

</script>






